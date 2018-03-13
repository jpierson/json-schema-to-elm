module Parsers.RootParser exposing (..)

import Json.Decode exposing (..)
import Dict exposing (..)

import Parsers.Util exposing (..)

-- import Parsers.ArrayParser exposing (..)
import Parsers.DefinitionsParser exposing (..)
-- import Parsers.ObjectParser exposing (..)
-- import Parsers.TupleParser exposing (..)
-- import Parsers.TypeReferenceParser exposing (..)

import Parsers.ErrorUtil as ErrorUtil
import Parsers.ParserResult exposing (..)
import Parsers.ParserError exposing (..)
import Parsers.SchemaResult exposing (..)

import Types exposing (SchemaNode)
import TypePath exposing (..)

import URI exposing (URI, parse, to_string)

type ParseNode = 
    SchemaNode Types.SchemaNode 
    Dict String Value

type ParseOutput = 
    Ok String 
    | Error ParserError

isBinary : Value
isBinary value = 
    -- case value of
    --     String s -> s
    True

supported_versions = 
    [ "http://json-schema.org/draft-04/schema" ]

validUriSchemes = ["http", "https", "urn"]

parseSchemaVersion : Types.SchemaNode -> ParseOutput
parseSchemaVersion node =
    -- case Dict.get "$schema" |> Maybe.map (isBinary) of 
    case Dict.get "$schema" node of 
        Just schema_str -> 
            schema_str 
                |> URI.parse 
                |> URI.to_string 
                |> case (List.any (\ schema -> (==) schema) supported_versions) of -- original code parsed schema as URL here and then turned back to string, for normalization?
                    True -> Result.Ok schema_str
                    False -> Result.Err <| (ErrorUtil.unsupported_schema_version schema_str supported_versions)
            
        -- TODO: If we allow dynamic type checking then we can construct invalid_type error
        -- ErrorUtil.invalid_type("#", "$schema", "string", schema_type)

        Nothing ->
            let
                path = TypePath.fromString "#"
            in
                Result.Err <| ErrorUtil.missing_property path "$schema"


parseSchemaId : Types.SchemaNode -> Result URI ParserError
parseSchemaId schemaNode =
    case Dict.get "id" schemaNode of
        Just schemaId -> 
            schemaId |> URI.parse |> (\parsedId ->
            -- case URI.parse schemaId of
            --     Just parsedId -> 
                    case List.member parsedId.schema validUriSchemes of
                        True ->
                            Result.Ok parsedId
                        
                        False ->
                            -- URI not found in list
                            Result.Err ErrorUtil.invalidUri "#", "id", schemaId
                    )
            
                -- Nothing -> 

                --     Result.Err ErrorUtil.invalidUrl "#", "id", schemaId
        Nothing -> 
            ErrorUtil.missing_property "#" "id"

parseSchema : SchemaNode -> String -> SchemaResult
parseSchema root_node schema_file_path =
    case (parseSchemaVersion root_node, parse_schema_id root_node) of
        (Result.Ok _schema_version, Result.Ok schema_id) ->
            -- ... TODO: LEFT OFF HERE
        let 
            title = Dict.get "title" root_node |> Maybe.withDefault ""
            description = Dict.get "description" root_node
            definitions_parser_result = parse_definitions root_node schema_id
            root_parser_result = parse_root_object(root_node, schema_id, title)
        in a


{-

  @spec parse_schema(Types.schemaNode, String.t) :: SchemaResult.t
  def parse_schema(root_node, schema_file_path) do

    with {:ok, _schema_version} <- parse_schema_version(root_node),
         {:ok, schema_id} <- parse_schema_id(root_node)
    do

        title = Map.get(root_node, "title", "")
        description = Map.get(root_node, "description")

        definitions_parser_result = parse_definitions(root_node, schema_id)
        root_parser_result = parse_root_object(root_node, schema_id, title)

        %ParserResult{type_dict: type_dict,
                      errors: errors,
                      warnings: warnings} =
          ParserResult.merge(root_parser_result, definitions_parser_result)

        schema_dict =
          %{to_string(schema_id) => SchemaDefinition.new(
           schema_file_path, schema_id, title, description, type_dict)}

        schema_errors = (if length(errors) > 0 do
          [{schema_file_path, errors}] else []
        end)

        schema_warnings = (if length(warnings) > 0 do
          [{schema_file_path, warnings}] else []
        end)

        SchemaResult.new(schema_dict, schema_warnings, schema_errors)
    else

      {:error, error} ->
        schema_warnings = [{schema_file_path, []}]
        schema_errors = [{schema_file_path, [error]}]
        SchemaResult.new(%{}, schema_warnings, schema_errors)
    end
  end
-}

parse_definitions : SchemaNode -> URI.URI -> ParserResult
parse_definitions schema_root_node schema_id =
    if DefinitionsParser.isType schema_root_node
        DefinitionsParser.parse schema_root_node schema_id Nothing ["#"] "" 

    else
        ParserResult.new

{-
  @spec parse_definitions(Types.schemaNode, URI.t) :: ParserResult.t
  defp parse_definitions(schema_root_node, schema_id) do
    if DefinitionsParser.type?(schema_root_node) do
      DefinitionsParser.parse(schema_root_node, schema_id, nil, ["#"], "")
    else
      ParserResult.new(%{})
    end
  end

  @spec parse_root_object(map, URI.t, String.t) :: ParserResult.t
  defp parse_root_object(schema_root_node, schema_id, _title) do

    type_path = TypePath.from_string("#")
    name = "#"

    cond do
      ArrayParser.type?(schema_root_node) ->
        schema_root_node
        |> parse_type(schema_id, [], name)

      ObjectParser.type?(schema_root_node) ->
        schema_root_node
        |> parse_type(schema_id, [], name)

      TupleParser.type?(schema_root_node) ->
        schema_root_node
        |> parse_type(schema_id, [], name)

      TypeReferenceParser.type?(schema_root_node) ->
        schema_root_node
        |> TypeReferenceParser.parse(schema_id, schema_id, type_path, name)

      true ->
        ParserResult.new()
    end
  end

  @supported_versions [
    "http://json-schema.org/draft-04/schema"
  ]

  @doc ~S"""
  Returns `:ok` if the given JSON schema has a known supported version,
  and an error tuple otherwise.

  ## Examples

      iex> schema = %{"$schema" => "http://json-schema.org/draft-04/schema"}
      iex> parse_schema_version(schema)
      {:ok, "http://json-schema.org/draft-04/schema"}

      iex> schema = %{"$schema" => "http://example.org/my-own-schema"}
      iex> {:error, error} = parse_schema_version(schema)
      iex> error.error_type
      :unsupported_schema_version

      iex> {:error, error} = parse_schema_version(%{})
      iex> error.error_type
      :missing_property

  """
  @spec parse_schema_version(Types.schemaNode)
  :: {:ok, String.t} | {:error, ParserError.t}
  def parse_schema_version(%{"$schema" => schema_str})
  when is_binary(schema_str) do

    schema_version = schema_str |> URI.parse |> to_string
    if schema_version in @supported_versions do
      {:ok, schema_version}

    else
      {:error, ErrorUtil.unsupported_schema_version(
        schema_str, @supported_versions)}
    end
  end

  def parse_schema_version(%{"$schema" => schema}) do
    schema_type = ErrorUtil.get_type(schema)
    {:error, ErrorUtil.invalid_type("#", "$schema", "string", schema_type)}
  end

  def parse_schema_version(_schema) do
    path = TypePath.from_string("#")
    {:error, ErrorUtil.missing_property(path, "$schema")}
  end

  @valid_uri_schemes ["http", "https", "urn"]

  @doc ~S"""
  Parses the ID of a JSON schema.

  ## Examples

      iex> parse_schema_id(%{"id" => "http://www.example.com/my-schema"})
      {:ok, URI.parse("http://www.example.com/my-schema")}

      iex> {:error, error} = parse_schema_id(%{"id" => "foo bar baz"})
      iex> error.error_type
      :invalid_uri

      iex> {:error, error} = parse_schema_id(%{})
      iex> error.error_type
      :missing_property

  """
  @spec parse_schema_id(Types.schemaNode)
  :: {:ok, URI.t} | {:error, ParserError.t}
  def parse_schema_id(%{"id" => schema_id}) when is_binary(schema_id) do
    parsed_id = URI.parse(schema_id)

    if parsed_id.scheme in @valid_uri_schemes do
      {:ok, parsed_id}

    else
      {:error, ErrorUtil.invalid_uri("#", "id", schema_id)}
    end
  end

  def parse_schema_id(%{"id" => schema_id}) do
    {:error, ErrorUtil.invalid_type("#", "id", "string", schema_id)}
  end

  def parse_schema_id(_schema_node) do
    {:error, ErrorUtil.missing_property("#", "id")}
  end

end
-}

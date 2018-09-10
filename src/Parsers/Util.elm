module Parsers.Util exposing (..)

import Dict exposing (..)
import Types exposing (..)
import Types.TypeDefinition exposing (..)
import TypePath exposing (..)
import URI exposing (..)
import Parsers.ParserResult exposing (..)
import Parsers.ErrorUtil exposing (..)
import Parsers.ParserError exposing (..)

import Parsers.AllOfParser exposing (..)
import Parsers.AllOfParser exposing (..)
-- TODO: LEFT OFF HERE
-- import Parsers.AnyOfParser exposing (..)
-- import Parsers.ArrayParser exposing (..)
-- import Parsers.DefinitionsParser exposing (..)
-- import Parsers.EnumParser exposing (..)
-- import Parsers.ObjectParser exposing (..)
-- import Parsers.OneOfParser exposing (..)
-- import Parsers.PrimitiveParser exposing (..)
-- import Parsers.TupleParser exposing (..)
-- import Parsers.TypeReferenceParser exposing (..)
-- import Parsers.UnionParser exposing (..)

create_type_dict : TypeDefinition -> TypePath -> Maybe URI -> TypeDictionary
create_type_dict type_def path id =
    let
        string_path = path |> TypePath.toString
    in 
        case id of 
            Just id -> 
                let 
                    string_id = (if type_def.name == "#" then id ++ "#" else id)
                in
                    Dict.fromList 
                        [ (string_path, type_def)
                        , (string_id, type_def)
                        ]
            Nothing -> 
                    Dict.fromList 
                        [ (string_path, type_def)
                        ]
        

parse_type : SchemaNode -> URI.URI -> TypePath.TypePath -> ParserResult
parse_type schema_node parent_id path name =
    case determine_node_parser schema_node path name of
        Ok node_parser ->
            let
                id = determine_id schema_node parse_type
                parent_id = determine_parent_id id parse_type
                type_path = TypePath.addChild path name
            in
                node_parser schema_node parent_id id type_path name
        Result.Err reason -> 
            ParserResult.new Dict.empty []


-- @spec parse_type(Types.schemaNode, URI.t, TypePath.t, String.t)
-- :: ParserResult.t
-- def parse_type(schema_node, parent_id, path, name) do

-- case determine_node_parser(schema_node, path, name) do
--     {:ok, node_parser} ->
--     id = determine_id(schema_node, parent_id)
--     parent_id = determine_parent_id(id, parent_id)
--     type_path = TypePath.add_child(path, name)
--     node_parser.(schema_node, parent_id, id, type_path, name)

--     {:error, reason} ->
--     ParserResult.new(%{}, [], [reason])
-- end
-- end]

determine_node_parser : SchemaNode -> TypeIdentifier -> String -> Result nodeParser ParserError
determine_node_parser schema_node identifier name = 
    let
        predicate_node_type_pairs = 
        [ (AllOfParser.isType, AllOfParser.parse)
        , (AnyOfParser.isType, AnyOfParser.parse)
        , (ArrayParser.isType, ArrayParser.parse)
        , (DefinitionsParser.isType, DefinitionsParser.parse)
        , (EnumParser.isType, EnumParser.parse)
        , (ObjectParser.isType, ObjectParser.parse)
        , (OneOfParser.isType, OneOfParser.parse)
        , (PrimitiveParser.isType, PrimitiveParser.parse)
        , (TupleParser.isType, TupleParser.parse)
        , (TypeReferenceParser.isType, TypeReferenceParser.parse)
        , (UnionParser.isType, UnionParser.parse)
        ]    


        node_parser =
            predicate_node_type_pairs
                |> List.filter (\ pred _node_parser -> pred schema_node)
                |> List.head
                -- |> Maybe.withDefault Result.Error ErrorUtil.unknown_node_type(identifier, name, schema_node)
                |> \ firstMatch -> 
                    case firstMatch of 
                        Maybe.Nothing -> Result.Error (ErrorUtil.unknown_node_type identifier name schema_node)
                        Maybe.Just node_parser ->  Result.Ok node_parser
    in
        node_parser
-- TODO : left off here

--  @spec determine_node_parser(
--     Types.schemaNode,
--     Types.typeIdentifier,
--     String.t
--   ) :: {:ok, nodeParser} | {:error, ParserError.t}
--   defp determine_node_parser(schema_node, identifier, name) do

--     predicate_node_type_pairs = [
--       {&AllOfParser.type?/1, &AllOfParser.parse/5},
--       {&AnyOfParser.type?/1, &AnyOfParser.parse/5},
--       {&ArrayParser.type?/1, &ArrayParser.parse/5},
--       {&DefinitionsParser.type?/1, &DefinitionsParser.parse/5},
--       {&EnumParser.type?/1, &EnumParser.parse/5},
--       {&ObjectParser.type?/1, &ObjectParser.parse/5},
--       {&OneOfParser.type?/1, &OneOfParser.parse/5},
--       {&PrimitiveParser.type?/1, &PrimitiveParser.parse/5},
--       {&TupleParser.type?/1, &TupleParser.parse/5},
--       {&TypeReferenceParser.type?/1, &TypeReferenceParser.parse/5},
--       {&UnionParser.type?/1, &UnionParser.parse/5}
--     ]

--     node_parser =
--       predicate_node_type_pairs
--       |> Enum.find({nil, nil}, fn {pred?, _node_parser} ->
--       pred?.(schema_node)
--     end) |> elem(1)

--     if node_parser != nil do
--       {:ok, node_parser}
--     else
--       {:error, ErrorUtil.unknown_node_type(identifier, name, schema_node)}
--     end
--   end


parse_child_types : List SchemaNode -> URI -> TypePath -> ParserResult
parse_child_types child_nodes parent_id path =
    case child_nodes of
        List child_nodes ->
            child_nodes
            |> List.foldl (ParserResult.new, 0) (\ child_node (result, idx) -> 
                let
                    child_name = toString idx
                    child_result = parse_type child_node parent_id path child_name
                    
                in
                    (ParserResult.merge result child_result, idx + 1)
                    )
            |> Tuple.first
        _ -> ParserResult.new -- HACK: Not sure what Elixir does here

--   @doc ~S"""
--   Parse a list of JSON schema objects that have a child relation to another
--   schema object with the specified `parent_id`.
--   """
--   @spec parse_child_types([Types.schemaNode], URI.t, TypePath.t)
--   :: ParserResult.t
--   def parse_child_types(child_nodes, parent_id, path)
--   when is_list(child_nodes) do

--     child_nodes
--     |> Enum.reduce({ParserResult.new(), 0}, fn (child_node, {result, idx}) ->
--       child_name = to_string(idx)
--       child_result = parse_type(child_node, parent_id, path, child_name)
--       {ParserResult.merge(result, child_result), idx + 1}
--     end)
--     |> elem(0)
--   end


determine_id : Dict -> URI.URI -> Maybe URI.URI
determine_id schema_node parent_id =
    let 
        id = Dict.get "id" schema_node
    in
        case id of
            Just id -> 
                let id_uri = URI.parse id
                in
                    if id_uri.scheme == "urn" then
                        id_uri
                    else
                        URI.merge parent_id id_uri

            Nothing -> Nothing


determine_parent_id : Maybe URI.URI -> URI -> URI
determine_parent_id id parent_id =
    case id of
        Just id -> if id.scheme /= "urn" then id else parent_id
        Nothing -> parent_id

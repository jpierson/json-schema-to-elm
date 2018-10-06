module Parsers.Util exposing (..)

import Dict exposing (..)
import Types exposing (..)
import Types.TypeDefinition exposing (..)
import TypePath exposing (..)
import URI exposing (..)
import Parsers.ParserResult as ParserResult
import Parsers.ErrorUtil as ErrorUtil
import Parsers.ParserError exposing (..)

import Parsers.AcyclicUtil exposing (ParserUtil)

import Parsers.AllOfParser as AllOfParser
-- import Parsers.AnyOfParser exposing (..)
-- TODO: LEFT OFF HERE
-- import Parsers.ArrayParser exposing (..)
-- import Parsers.DefinitionsParser exposing (..)
-- import Parsers.EnumParser exposing (..)
-- import Parsers.ObjectParser exposing (..)
-- import Parsers.OneOfParser exposing (..)
-- import Parsers.PrimitiveParser exposing (..)
-- import Parsers.TupleParser exposing (..)
-- import Parsers.TypeReferenceParser exposing (..)
-- import Parsers.UnionParser exposing (..)

utils = Parsers.AcyclicUtil.ParserUtil parse_child_types create_types_list create_type_dict

type alias Node = Dict String SchemaNode

getTypeDefinitionName : TypeDefinition -> String
getTypeDefinitionName typeDefinition = 
    case typeDefinition of 
        AllOfType allOfType -> allOfType.name
        ObjectType objectType -> objectType.name 

create_type_dict : TypeDefinition -> TypePath -> Maybe URI -> TypeDictionary
create_type_dict type_def path id =
    let
        string_path = path |> TypePath.toString
    in 
        case id of 
            Just id -> 
                let 
                    string_id = (if (getTypeDefinitionName type_def) == "#" then (to_string id) ++ "#" else to_string id)
                in
                    Dict.fromList 
                        [ (string_path, type_def)
                        , (string_id, type_def)
                        ]
            Nothing -> 
                    Dict.fromList 
                        [ (string_path, type_def)
                        ]
        

-- @doc ~S"""
--   Returns a list of type paths when given a type dictionary.
--   """
create_types_list : TypeDictionary -> TypePath.TypePath -> List TypePath.TypePath
create_types_list type_dict path = 
    type_dict
    -- |> Dict.foldr (\key value previous -> Dict.empty) Dict.empty
    |> Dict.foldr (\key value previous -> 
        let
            child_abs_path = key
            child_type = value
            reference_dict = previous
            child_type_path = TypePath.addChild path child_type.name
        in
            if child_type_path == TypePath.fromString child_abs_path then
                Dict.merge reference_dict (Dict.singleton child_type.name child_type_path)
            else
                reference_dict) Dict.empty
    |> Dict.values
--   @spec create_types_list(Types.typeDictionary, TypePath.t) :: [TypePath.t]
--   def create_types_list(type_dict, path) do
--     type_dict
--     |> Enum.reduce(%{}, fn({child_abs_path, child_type}, reference_dict) ->

--       child_type_path = TypePath.add_child(path, child_type.name)

--       if child_type_path == TypePath.from_string(child_abs_path) do
--         Map.merge(reference_dict, %{child_type.name => child_type_path})
--       else
--         reference_dict
--       end

--     end)
--     |> Map.values()
--   end

parse_type : SchemaNode -> URI.URI -> TypePath.TypePath -> ParserResult.ParserResult
parse_type schema_node parent_id path name =
    case determine_node_parser schema_node (TypePath path) name of
        Ok node_parser ->
            let
                id = determine_id schema_node parent_id
                parent_id2 = determine_parent_id id parent_id
                type_path = TypePath.addChild path name
            in
                node_parser schema_node parent_id2 id type_path name
        Result.Err reason -> 
            \x -> ParserResult.newWithTypeDictionaryAndWarningsAndErrors Dict.empty [] [Result.Err reason]


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

-- nodeParser probably needs to be the below shape
-- parse : ParserUtil -> Node -> URI -> Maybe URI -> TypePath -> String -> ParserResult
type alias NodeParser = ParserUtil -> Node -> URI -> Maybe URI -> TypePath -> String -> ParserResult.ParserResult

determine_node_parser : SchemaNode -> TypeIdentifier -> String -> Result NodeParser ParserError
determine_node_parser schema_node identifier name = 
    let
        predicate_node_type_pairs : List (Node -> Bool, NodeParser)
        predicate_node_type_pairs = 
        [ (AllOfParser.isType, AllOfParser.parse)
        -- , (AnyOfParser.isType, AnyOfParser.parse)
        -- , (ArrayParser.isType, ArrayParser.parse)
        -- , (DefinitionsParser.isType, DefinitionsParser.parse)
        -- , (EnumParser.isType, EnumParser.parse)
        -- , (ObjectParser.isType, ObjectParser.parse)
        -- , (OneOfParser.isType, OneOfParser.parse)
        -- , (PrimitiveParser.isType, PrimitiveParser.parse)
        -- , (TupleParser.isType, TupleParser.parse)
        -- , (TypeReferenceParser.isType, TypeReferenceParser.parse)
        -- , (UnionParser.isType, UnionParser.parse)
        ]    

        node_parser : Result NodeParser ParserError
        node_parser =
            predicate_node_type_pairs
                |> List.filter (\ pred _node_parser -> pred schema_node)
                |> List.head
                -- |> Maybe.withDefault Result.Error ErrorUtil.unknown_node_type(identifier, name, schema_node)
                |> \ firstMatch -> 
                    case firstMatch of 
                        Maybe.Nothing -> Result.Err (ErrorUtil.unknown_node_type identifier name schema_node)
                        Maybe.Just parser ->  Result.Ok parser
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


parse_child_types : List SchemaNode -> URI -> TypePath -> ParserResult.ParserResult
parse_child_types child_nodes parent_id path =
    -- case child_nodes of
    --     List child_nodes ->
            child_nodes
            |> List.foldl (\ child_node (result, idx) -> 
                let
                    child_name = Basics.toString idx
                    child_result = parse_type child_node parent_id path child_name
                    
                in
                    (ParserResult.merge result child_result, idx + 1)
                    ) (ParserResult.new, 0)
            |> Tuple.first
        -- _ -> ParserResult.new -- HACK: Not sure what Elixir does here

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


determine_id : Dict String SchemaNode -> URI.URI -> Maybe URI.URI
determine_id schema_node parent_id =
    let 
        id = Dict.get "id" schema_node
    in
        case id of
            Just id -> 
                let id_uri = URI.parse id
                in
                    Just (
                        if id_uri.scheme == "urn" then
                            id_uri
                        else
                            URI.merge parent_id id_uri
                    )

            Nothing -> Nothing


determine_parent_id : Maybe URI.URI -> URI -> URI
determine_parent_id id parent_id =
    case id of
        Just justId -> if justId.scheme /= "urn" then justId else parent_id
        Nothing -> parent_id

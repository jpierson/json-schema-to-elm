module Parsers.Util exposing (..)

import Types exposing (..)
import Types.TypeDefinition exposing (..)
import TypePath exposing (..)
import URI exposing (..)
import Parsers.ParserResult exposing (..)


create_type_dict : TypeDefinition -> TypePath -> Maybe URI
create_type_dict a b =
    Nothing


parse_type : SchemaNode -> URI.URI -> TypePath.TypePath -> ParserResult
parse_type schema_node parent_id path name =
    case determine_node_parser schema_node path name of
        (Ok, node_parser) ->
            let
                id = determine_id schema_node parse_type
                parent_id = determine_parent_id id parse_type
                type_path = TypePath.addChild path name
            in
                node_parser schema_node parent_id id type_path name
        (Error, reason) -> 
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

determine_node_parser : SchemaNode -> TypeIdentifier -> String
determine_node_parser schema_node identifier name = 

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
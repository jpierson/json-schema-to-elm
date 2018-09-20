module Parsers.AllOfParser exposing (..)

import Dict exposing (..)
import TypePath exposing (..)
-- import Types exposing (..)
import URI exposing (..)
import Parsers.ParserResult exposing (..)
import Types.AllOfType exposing (..)
import Types exposing (..)
-- import Parsers.AcyclicUtil exposing (parse_child_types, create_types_list, create_type_dict)
import Parsers.AcyclicUtil exposing (ParserUtil)

-- type alias ListNode = List a

-- type NodeValue a
--     = ListNode (List a)
--     | DictNode (Dict String a)

type alias Node = Dict String SchemaNode

isType : Node -> Bool
isType node =
    -- case node of 
    --     Branch -> 
    case Dict.get "allOf" node of
        Just all_of ->
            case all_of of
                Branch list ->
                    not (Dict.isEmpty list)

                _ ->
                    False

        Nothing ->
            False


-- parse : ParserUtil -> Node -> URI -> Maybe URI -> TypePath -> String -> ParserResult
-- parse util nodeValue parent_id id path name =
--     case Dict.get "allOf" nodeValue of
--         Just all_of -> 
--             case all_of of
--                 ListNode list ->
--                     Parsers.ParserResult.new

--                 _ -> 
--                     Parsers.ParserResult.new

--         Nothing -> 
--             Parsers.ParserResult.new



-- parse : ParserUtil -> Node -> URI -> Maybe URI -> TypePath -> String -> ParserResult
-- parse util nodeValue parent_id id path name =
--     let 
--         handleNodeValue: NodeValue -> ParserResult
--         handleNodeValue nodeValue = 
--             case nodeValue of
--                 ListNode list -> Parsers.ParserResult.new
                      
--                 _ -> Parsers.ParserResult.new -- HACK: Not sure what Elixir does here
--     in
--         case Dict.get "allOf" nodeValue of
--             Just all_of -> 
--                 handleNodeValue all_of
--                 -- case all_of of
--                 --     -- NodeValue -> 
--                 --     -- case all_of of 
--                 --     ListNode (all_of) ->
--                 --         Parsers.ParserResult.new
--                 --         -- let 
--                 --         --     child_path = TypePath.addChild path "allOf"

--                 --         --     child_types_result = 
--                 --         --         all_of
--                 --         --         |> util.parse_child_types parent_id child_path
                            
--                 --         --     all_of_types =
--                 --         --         child_types_result.type_dict
--                 --         --         |> util.create_types_list child_path

--                 --         --     all_of_type = Types.AllOfType.new name path all_of_types

--                 --         -- in
--                 --         --     all_of_type 
--                 --         --     |> util.create_type_dict path id
--                 --         --     |> Parsers.ParserResult.new
--                 --         --     |> Parsers.ParserResult.merge child_types_result

--                 --     _ -> Parsers.ParserResult.new -- HACK: Not sure what Elixir does here
--             Nothing -> Parsers.ParserResult.new -- HACK: Not sure what Elixir does here


--   @impl JS2E.Parsers.ParserBehaviour
--   @spec parse(Types.node, URI.t, URI.t | nil, TypePath.t, String.t)
--   :: ParserResult.t
--   def parse(%{"allOf" => all_of}, parent_id, id, path, name)
--   when is_list(all_of) do

--     child_path = TypePath.add_child(path, "allOf")

--     child_types_result =
--       all_of
--       |> parse_child_types(parent_id, child_path)

--     all_of_types =
--       child_types_result.type_dict
--       |> create_types_list(child_path)

--     all_of_type = AllOfType.new(name, path, all_of_types)

--     all_of_type
--     |> create_type_dict(path, id)
--     |> ParserResult.new()
--     |> ParserResult.merge(child_types_result)
--   end

-- end
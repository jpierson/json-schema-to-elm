module Parsers.AllOfParser exposing (..)

import Dict exposing (..)
import TypePath exposing (..)
import Types exposing (..)
import URI exposing (..)
import Parsers.ParserResult exposing (..)
import Parsers.Util exposing (parse_child_types, create_types_list, create_type_dict)


type NodeValue a
    = ListNode (List a)
    | DictNode (Dict String a)

type alias Node = Dict String NodeValue 

isType : Dict String NodeValue -> Bool
isType node =
    case Dict.get "allOf" node of
        Just all_of ->
            case all_of of
                ListNode list ->
                    (List.length list) > 0

                _ ->
                    False

        Nothing ->
            False

parse : Node -> URI -> Maybe URI -> TypePath -> String -> ParserResult
parse nodeValue parent_id id path name =
    case Dict.get "allOf" nodeValue of
        Just all_of ->
            case all_of of
                ListNode all_of ->
                    let 
                        child_path = TypePath.addChild path "allOf"

                        child_types_result = 
                            all_of
                            |> parse_child_types parent_id child_path
                        
                        all_of_types =
                            child_types_result.type_dict
                            |> create_types_list child_path

                        all_of_type = AllOfType.new name path all_of_types

                    in
                        all_of_type 
                        |> create_type_dict path id
                        |> Parsers.ParserResult.new
                        |> Parsers.ParserResult.merge child_types_result

                _ -> Parsers.ParserResult.new -- HACK: Not sure what Elixir does here
        Nothing -> Parsers.ParserResultult.new -- HACK: Not sure what Elixir does here


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
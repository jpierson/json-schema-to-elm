module Parsers.DefinitionsParser exposing (..)

import Dict exposing (..)
import Parsers.Util exposing (parse_type)
import TypePath exposing (..)
import Parsers.ParserResult exposing (..)
import URI exposing (..)
import Types exposing (SchemaNode)

-- type DictOrString = 
--     Dict Dict
--     | String String

isType : Dict String (Maybe Dict) -> Bool
-- isType : Dict String DictOrString -> Bool
-- isType : DictOrString -> Bool
isType dict = 
    let 
        definitions = Dict.get "definitions" dict
    in
        case definitions of
            Just _ -> True
            _ -> False

parse : SchemaNode String TypePath -> URI -> Maybe URI -> TypePath -> String -> ParserResult
parse mapWithDefinitions parent_id _id path _name =
    let
        definitions = Dict.get "definitions" mapWithDefinitions
        child_path = path |> TypePath.addChild "definitions"
        init_result = Parsers.ParserResult.new
        definitions_types_result =
            definitions
            |> List.foldl (\ child_name child_node -> 
                let
                    child_types = parse_type child_node parent_id child_path child_name
                in
                    ParserResult.merge acc_result child_types
            )
    in 
        definitions_types_result
module Parsers.DefinitionsParser exposing (..)

import Parsers.Util exposing (..)
import TypePath exposing (..)
import Parsers.ParserResult exposing (..)
import URI exposing (..)
import Types exposing (SchemaNode)

isType : Dict String ((Dict a b) | String) -> Bool
isType dict = 
    case dict of
        Dict a b -> True
        _ -> False

parse : SchemaNode String String -> URI -> Maybe URI -> TypePath -> String -> Parsers.ParserResult
parse mapWithDefinitions parent_id _id path _name =
    let
        definitions = Dict.get "definitions" mapWithDefinitions
        child_path = path |> TypePath.addChild "definitions"
        init_result = Parsers.ParserResult.new
        definitions_types_result =
            definitions
            |> Enum.reduce (\ child_name child_node -> 
                let
                    child_types = parse_type child_node parent_id child_path child_name
                in
                    ParserResult.merge acc_result child_types
            )
    in 
        definitions_types_result
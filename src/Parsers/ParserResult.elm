module Parsers.ParserResult exposing (..)

import Dict exposing (..)
import Types.TypeDefinition exposing (..)
import Parsers.ParserWarning exposing (..)
import Parsers.ParserError exposing (..)
import Parsers.ErrorUtil exposing (nameCollision)

type alias ParserResult =
    { type_dict : TypeDictionary
    , warnings : List ParserWarning
    , errors : List ParserError
    }


empty : Maybe ParserResult
empty =
    Nothing



{-
   Creates a `ParserResult` from a type dictionary.

   A `ParserResult` consists of a type dictionary corresponding to the
   succesfully parsed part of a JSON schema object, and a list of warnings and
   errors encountered while parsing.
-}


new : ParserResult
new =
    { type_dict = Dict.empty
    , warnings = []
    , errors = []
    }


merge : ParserResult -> ParserResult -> ParserResult
merge result1 result2 =
    let
        keys1 = result1.type_dict |> Dict.keys |> Set.fromList
        keys2 = result2.type_dict |> Dict.keys |> Set.fromList
    
        collisions : ParserResult
        collisions =
            keys1
            |> Set.intersect(keys2)
            |> Set.map(ErrorUtil.nameCollision)
            |> 
            {  
                schema_dict = Map.merge(result1.type_dict, result2.type_dict)
                warnings = Enum.uniq(result1.warnings ++ result2.warnings)
                errors = Enum.uniq(collisions ++ result1.errors ++ result2.errors)
            }
    in
        collisions


-- TODO: Left off here implementing merge

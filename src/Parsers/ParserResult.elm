module Parsers.ParserResult exposing (..)

import Dict exposing (..)
import Set exposing (..)
import Types exposing (TypeIdentifier)
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

uniq : (a -> a -> bool) -> List a -> List a
uniq comparer list =
    list

merge : ParserResult -> ParserResult -> ParserResult
merge result1 result2 =
    let
        keys1 : Set String
        keys1 = result1.type_dict |> Dict.keys |> Set.fromList
        keys2 : Set String
        keys2 = result2.type_dict |> Dict.keys |> Set.fromList
    
        collisions : List ParserError
        collisions =
            let 
                intersection : List String
                intersection = 
                    keys1
                    |> Set.intersect keys2
                    |> Set.toList
            in
                intersection
                -- TODO: Get the following data constructor to work for Types.TypeIdentifier.String
                |> List.map (\ key -> (Types.String) key)
                -- |> List.map Types.TypeIdentifier.String
                |> List.map nameCollision

        warnings : List ParserWarning
        warnings = 
            (result1.warnings ++ result2.warnings)-- |> Set.fromList |> Set.toList
            |> uniq Parsers.ParserWarning.isEqual

        errors : List ParserError
        errors = 
            (collisions ++ result1.errors ++ result2.errors) 
            |> uniq Parsers.ParserError.isEqual
    in
        { type_dict = result1.type_dict
        -- TODO: Get the following merge to work
        -- { schema_dict = Dict.merge result1.type_dict result2.type_dict
        , warnings = warnings
        , errors = errors
        }
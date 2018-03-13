module Parsers.SchemaResult exposing (..)

import Dict exposing (..)
import Set exposing (..)
import Debug exposing (log)


-- import Parsers exposing (ErrorUtil, ParserError, ParserWarning)

import Parsers.ErrorUtil exposing (..)
import Parsers.ParserError exposing (..)
import Parsers.ParserWarning exposing (..)
import Types exposing (..)
import Types.SchemaDefinition exposing (SchemaDictionary)
import ListExtras exposing (uniq)


-- import Types.Path exposing (..)
-- @type t :: %__MODULE__{schema_dict: Types.schemaDictionary,
--                        warnings: [{Path.t, ParserWarning.t}],
--                        errors: [{Path.t, ParserError.t}]}
-- defstruct [:schema_dict, :warnings, :errors]
-- type alias PathWarning =
--     { Path,
--     , ParserWarning
--     }
-- type alias PathError =
--     { Path,
--     , ParserWarning
--     }


type alias SchemaResult =
    { schema_dict : SchemaDictionary
    , warnings : List ( Path, ParserWarning )
    , errors : List ( Path, ParserError )
    }



-- Renamed from new to empty because Elm doesn't support function overloading and this is more clear


empty : SchemaResult
empty =
    -- { schema_dict = (Dict String Types.SchemaDefinition.SchemaDefinition).empty
    { schema_dict = Dict.empty
    , warnings = []
    , errors = []
    }


new : SchemaDictionary -> List ( Path, ParserWarning ) -> List ( Path, ParserError ) -> SchemaResult
new schema_dict warnings errors =
    { schema_dict = schema_dict, warnings = warnings, errors = errors }



-- unique : (a -> comparable) -> (comparable -> a) -> List a -> List a
-- unique toComparable fromComparable source =
--     source
--     |> List.map toComparable
--     |> Set.fromList
--     |> Set.toList
--     |> List.map fromComparable
-- uniqueSchemaResult : List SchemaResult -> List SchemaResult
-- uniqueSchemaResult source =
--     let
--         toTuple schemaResult =
--             let
--                 path = Tuple.first schemaResult
--                 { identifier, warning_type, message } = Tuple.second schemaResult
--             in
--                 (path, identifier, warning_type, message)
--         fromTuple = Schemaresult.
--     unique (\schemaResult -> (Tuple.first schemaResult, Tuple.second schemaResult |> )
-- -- Workaround for lack of comparable records in Elm
-- uniqueParserWarning : List ParserWarning -> List ParserWarning
-- uniqueParserWarning source =
--     let
--         toTuple warning =
--             let
--                 { identifier, warning_type, message } = warning
--             in
--                 (path, identifier, warning_type, message)
--         fromTuple tuple = ParserWarning tuple
--     in
--         unique toTuple fromTuple
-- -- Workaround for lack of comparable records in Elm
-- uniqueParserError : List ParserError -> List ParserError
-- uniqueParserError source =
--     let
--         toTuple error =
--             let
--                 { identifier, error_type, message } = error
--             in
--                 (path, identifier, error_type, message)
--         fromTuple tuple = ParserError tuple
--     in
--         unique toTuple fromTuple
-- merge : SchemaResult -> SchemaResult -> SchemaResult
-- merge schema1 schema2 =
--     let
--         keys1 = schema1.schema_dict |> Dict.keys |> Set.fromList
--         keys2 = schema2.schema_dict |> Dict.keys |> Set.fromList
--     in
--         collisions =
--             keys1
--             |> Set.intersect(keys2)
--             |> Enum.map(ErrorUtil.Name_collision)
--             |>
--             {
--                 schema_dict = Map.merge(schema1.schema_dict, schema2.schema_dict)
--                 warnings = uniqueParserWarning (schema1.warnings ++ schema2.warnings)
--                 errors = uniqueParserError (collisions ++ schema1.errors ++ schema2.errors)
--             }


merge : SchemaResult -> SchemaResult -> SchemaResult
merge result1 result2 =
    let
        keys1 : Set String
        keys1 =
            result1.schema_dict |> Dict.keys |> Set.fromList

        keys2 : Set String
        keys2 =
            result2.schema_dict |> Dict.keys |> Set.fromList

        collisions : List (String, ParserError)
        collisions =
            let
                intersection : List String
                intersection =
                    keys1
                        |> Set.intersect keys2
                        |> Set.toList
                -- maybeString 
            in
                intersection
                    -- |> List.map Types.String
                    -- |> List.filterMap (\ s -> (case s of String x -> Some x
                    --     _ -> None, nameCollision s))
                    |> List.map (\ s -> (s, nameCollision (Types.String s)))

        warnings : List ( Path, ParserWarning )
        warnings =
            (result1.warnings ++ result2.warnings)
                |> uniq (\ tuple1 tuple2 -> (Tuple.first tuple1) == (Tuple.first tuple2) && (Parsers.ParserWarning.isEqual (Tuple.second tuple1) (Tuple.second tuple2)))

        errors : List ( Path, ParserError )
        errors =
            (collisions ++ result1.errors ++ result2.errors)
                |> uniq (\ tuple1 tuple2 -> (Tuple.first tuple1) == (Tuple.first tuple2) && (Parsers.ParserError.isEqual (Tuple.second tuple1) (Tuple.second tuple2)))
    in
        { schema_dict = result1.schema_dict

        -- TODO: Get the following merge to work
        -- { schema_dict = Dict.merge result1.schema_dict result2.schema_dict
        , warnings = warnings
        , errors = errors
        }

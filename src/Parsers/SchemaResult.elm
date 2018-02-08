module Parsers.SchemaResult exposing (..)

import Dict exposing (..)
import Set exposing (..)
import Debug exposing (log)
import Parsers exposing (ErrorUtil, ParserError, ParserWarning)
import Types exposing (..)
import Types.SchemaDefinition exposing (SchemaDictionary)
import Path

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
    { schema_dict : Types.SchemaDictionary
    , warnings : [{Path, ParserWarning}]
    , errors :  [{Path, ParserError}]
    }

-- Renamed from new to empty because Elm doesn't support function overloading and this is more clear
empty : SchemaResult
empty = {  }


new : Types.SchemaDictionary -> [{Path, ParserWarning}] -> [{Path, ParserError}] -> SchemaResult
new schema_dict warnings errors =
    { schema_dict warnings errors }


merge : SchemaResult -> SchemaResult -> SchemaResult
merge schema1 schema2 =
    let
        keys1 = schema1.schema_dict |> Dict.keys |> Set.fromList
        keys2 = schema2.schema_dict |> Dict.keys |> Set.fromList
    
    in
        collisions =
            keys1
            |> Set.intersect(keys2)
            |> Enum.map(ErrorUtil.Name_collision)
            |> 
            {  
                schema_dict = Map.merge(schema1.schema_dict, schema2.schema_dict)
                warnings = Enum.uniq(schema1.warnings ++ schema2.warnings)
                errors = Enum.uniq(collisions ++ schema1.errors ++ schema2.errors)
            }

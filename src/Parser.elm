module Parser exposing (parseSchemaFiles)
  -- @moduledoc ~S"""
  -- Parses JSON schema files into an intermediate representation to be used for
  -- e.g. printing elm decoders.
  -- """

import Debug exposing (log)
import Types exposing (..)
import Parsers exposing (RootParser, SchemaResult, ErrorUtil)
-- import Parsers.RootParser exposing (..)
-- import Parsers.SchemaResult exposing (..)
-- import Parsers.ErrorUtil exposing (..)
import Printers.Util
import File


parse_schema_files : [Path] -> SchemaResult
parse_schema_files schemaPaths =
    let init_schema_result = SchemaResult.new()

    in schemaPaths
        |> List.foldl (\ schema_path acc ->
            schema_path
            |> File.read
            |> Poison.decode
            |> RootParser.parse_schema(schema_path)
            |> SchemaResult.merge(acc)
            ) init_schema_result
        |> 
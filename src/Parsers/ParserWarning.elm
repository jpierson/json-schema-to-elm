module Parsers.ParserWarning exposing (..)

import Types exposing (..)


type WarningType
    = Unsupported_schema_version
    | Missing_property


type alias ParserWarning =
    { identifier : Types.TypeIdentifier
    , warning_type : WarningType
    , message : String
    }


new : Types.TypeIdentifier -> WarningType -> String -> ParserWarning
new identifier warning_type message =
    { identifier = identifier
    , warning_type = warning_type
    , message = message
    }

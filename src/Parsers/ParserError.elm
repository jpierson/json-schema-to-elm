module Parsers.ParserError exposing (..)

import Types exposing (..)


-- type alias ParserError a =
--     {
--         identifier: Types.TypeIdentifier,
--         error_type: a,
--         message: String
--     }
-- new : Types.TypeIdentifier -> a -> String -> ParserError a
-- new identifier error_type message =
--     { identifier = identifier
--     , error_type = error_type
--     , message = message
--     }
-- NOTE: Elixir implementation used atom: as the type for error_type


type ErrorTypes
    = Unsupported_schema_version
    | Missing_property


type alias ParserError =
    { identifier : Types.TypeIdentifier
    , error_type : ErrorTypes
    , message : String
    }


new : Types.TypeIdentifier -> ErrorTypes -> String -> ParserError
new identifier error_type message =
    { identifier = identifier
    , error_type = error_type
    , message = message
    }

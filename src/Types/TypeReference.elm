module Types.TypeReference exposing (..)

import Types exposing (TypeIdentifier)


type alias TypeReference =
    { name : String
    , path : Types.TypeIdentifier
    }

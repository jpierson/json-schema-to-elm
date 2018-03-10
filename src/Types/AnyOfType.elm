module Types.AnyOfType exposing (..)

import TypePath exposing (..)


type alias AnyOfType =
    { name : String
    , path : TypePath
    , types : List TypePath
    }

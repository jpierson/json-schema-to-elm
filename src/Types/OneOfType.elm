module Types.OneOfType exposing (..)

import TypePath exposing (..)


type alias OneOfType =
    { name : String
    , path : TypePath.T
    , types : List TypePath.T
    }
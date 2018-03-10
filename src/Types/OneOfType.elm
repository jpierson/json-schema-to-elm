module Types.OneOfType exposing (..)

import TypePath exposing (..)


type alias OneOfType =
    { name : String
    , path : TypePath.TypePath
    , types : List TypePath.TypePath
    }

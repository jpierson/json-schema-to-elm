module Types.UnionType exposing (..)

import TypePath exposing (..)


type alias UnionType =
    { name : String
    , path : TypePath.TypePath
    , types : List TypePath.TypePath
    }

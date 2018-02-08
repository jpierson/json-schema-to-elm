module Types.UnionType exposing (..)

import TypePath exposing (..)


type alias UnionType =
    { name : String
    , path : TypePath.T
    , types : List TypePath.T
    }
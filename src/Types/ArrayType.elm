module Types.ArrayType exposing (..)

import TypePath exposing (..)


type alias AnyOfType =
    { name : String
    , path : TypePath.T
    , items : TypePath.T
    }
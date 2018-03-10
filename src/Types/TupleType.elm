module Types.TupleType exposing (..)

import TypePath exposing (..)


type alias TupleType =
    { name : String
    , path : TypePath.TypePath
    , items : TypePath.TypePath
    }

module Types.PrimitiveType exposing (..)

import TypePath exposing (..)


type StringOrTypePath
    = String
    | TypePath


type alias PrimitiveType =
    { name : String
    , path : StringOrTypePath
    , primitiveType : String
    }

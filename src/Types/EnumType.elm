module Types.EnumType exposing (..)

import TypePath exposing (..)


type StringOrNumber
    = String
    | Number


type alias EnumType =
    { name : String
    , path : TypePath.T
    , valueType : TypePath.T
    , values : List StringOrNumber
    }

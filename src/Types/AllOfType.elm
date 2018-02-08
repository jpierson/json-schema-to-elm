module Types.AllOfType exposing (..)

import TypePath exposing (..)


type alias AllOfType =
    { name : String
    , path : TypePath
    , types : List TypePath
    }
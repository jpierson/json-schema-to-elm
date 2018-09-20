module Types.AllOfType exposing (..)

import TypePath exposing (..)


type alias AllOfType =
    { name : String
    , path : TypePath
    , types : List TypePath
    }

new : String -> TypePath -> List TypePath -> AllOfType
new name path types =
    AllOfType name path types
    -- { name = name, path = path, types = types }
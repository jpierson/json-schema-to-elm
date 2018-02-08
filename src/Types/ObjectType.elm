module Types.ObjectType exposing (..)

import Types exposing (PropertyDictionary)
import TypePath exposing (..)

type alias ObjectType =
  { name : String,
    path : TypePath,
    properties : PropertyDictionary,
    required : List String
  }
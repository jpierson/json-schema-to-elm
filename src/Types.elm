module Types exposing (..)

import TypePath exposing (..)

alias ObjectType {
  name : String,
  path : TypePath.T,
  properties : PropertyDictionary
  required : List String
}

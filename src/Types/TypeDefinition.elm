module Types.TypeDefinition exposing (..)

import Dict exposing (..)
import Types.AllOfType exposing (AllOfType)
import Types.AnyOfType exposing (AnyOfType)
import Types.ObjectType exposing (ObjectType)

type TypeDefinition   
  = AllOfType
  | ObjectType

-- import Types exposing (AllOfType, AnyOfType, ArrayType, EnumType, ObjectType, OneOfType, PrimitiveType, SchemaDefinition, TupleType, TypeReference, UnionType)

-- type TypeDefinition 
--   = AllOfType.t 
--   | AnyOfType.t
--   | ArrayType.t
--   | EnumType.t
--   | ObjectType.t
--   | OneOfType.t
--   | PrimitiveType.t
--   | TupleType.t
--   | TypeReference.t
--   | UnionType.t

-- type alias TypeDictionary = String -> TypeDefinition
type alias TypeDictionary = Dict String TypeDefinition
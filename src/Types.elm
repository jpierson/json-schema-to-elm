module Types exposing (..)

import TypePath exposing (..)
import Dict exposing (..)


-- Elixir appears to have URI as a built in type so we make our own here


type alias Uri =
    String



-- Elixir has a Path type in it's core so this is to simulate that type
-- https://hexdocs.pm/elixir/Path.html


type alias Path =
    String



-- TypeDefinition moved to it's own module to avoid cyclical dependency


-- type SchemaNode
--     = Dict

type SchemaNode
    = Branch (Dict String SchemaNode)
    | Leaf String

type SchemaNodeX a
    = SchemaNodeX (Dict a (SchemaNodeX a))

type SchemaNodeY
    = SchemaNodeY (Dict String SchemaNodeY)
    | Value String

myroot = SchemaNodeY (Dict.singleton "key1" (SchemaNodeY (Dict.singleton "innerKey" (Value "innerValue"))))

-- type RecursiveList
--     = RecursiveList (List RecursiveList)

-- mylist : RecursiveList
-- mylist = (RecursiveList [])

type TypeIdentifier
    = String String
    | TypePath TypePath
    | Uri Uri


type alias PropertyDictionary =
    String -> TypeIdentifier


type alias FileDictionary =
    String -> String

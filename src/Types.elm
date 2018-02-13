module Types exposing (..)

import TypePath exposing (..)


-- Elixir appears to have URI as a built in type so we make our own here


type alias Uri =
    String



-- Elixir has a Path type in it's core so this is to simulate that type
-- https://hexdocs.pm/elixir/Path.html


type alias Path =
    String



-- TypeDefinition moved to it's own module to avoid cyclical dependency


type SchemaNode = Dict

type TypeIdentifier
    = String String
    | TypePath TypePath
    | Uri Uri


type alias PropertyDictionary =
    String -> TypeIdentifier


type alias FileDictionary =
    String -> String

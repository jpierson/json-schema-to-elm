module PredicatesTests exposing (..)

import Dict
import Expect
import Test exposing (..)
import Predicates exposing (..)


suite : Test
suite =
    describe "Predicates" 
        [ describe "Predicates.definitions"
            [ test """Predicates.definitions?(%{"title" => "A fancy title"})""" <|
                \_ -> (Predicates.definitions <| Dict.fromList [ ("title", Dict.fromList [ ("A fancy title", "") ] ) ])
                    |> Expect.equal False
            , test """Predicates.definitions?(%{"definitions" => %{}})""" <|
                \_ -> (Predicates.definitions <| Dict.fromList [ ("definitions", Dict.fromList [ ("", "") ] ) ])
                    |> Expect.equal True
            ]
        , describe "Predicates.primitiveType"
            [ test """Predicates.primitive_type?(%{})""" <|
                \_ -> (Predicates.primitiveType <| Dict.fromList [ ])
                    |> Expect.equal False
            , test """Predicates.primitive_type?(%{"type" => "object"})""" <|
                \_ -> (Predicates.primitiveType <| Dict.fromList [ ("type", "object") ])
                    |> Expect.equal False
            , test """Predicates.primitive_type?(%{"type" => "boolean"})""" <|
                \_ -> (Predicates.primitiveType <| Dict.fromList [ ("type", "boolean") ])
                    |> Expect.equal True
            , test """Predicates.primitive_type?(%{"type" => "integer"})""" <|
                \_ -> (Predicates.primitiveType <| Dict.fromList [ ("type", "integer") ])
                    |> Expect.equal True
            ]
        ]
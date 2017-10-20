module Example exposing (..)

import Expect
import Test exposing (..)
import TypePath exposing (..)


suite : Test
suite =
    describe "parse primitive all_of type"
        [ describe "TypePath"
            [ test """TypePath.fromString("")""" <|
                \() ->
                    Expect.equal (fromString "") []
            , test """TypePath.fromString("#")""" <|
                \() ->
                    Expect.equal (fromString "#") [ "#" ]
            , test """TypePath.fromString("#/definitions/foo")""" <|
                \() ->
                    Expect.equal 
                        (fromString "#/definitions/foo") 
                        [ "#", "definitions", "foo" ]
            , test """TypePath.toString([])""" <|
                \() ->
                    Expect.equal (TypePath.toString []) ""
            , test """TypePath.toString(["#"])""" <|
                \() ->
                    Expect.equal (TypePath.toString [ "#" ]) "#"
            , test """TypePath.toString(["#", "definitions", "foo"])""" <|
                \() ->
                    Expect.equal 
                        (TypePath.toString [ "#", "definitions", "foo" ]) 
                        "#/definitions/foo"
            , test """TypePath.addChild(["#", "definitions", "foo"], "")""" <|
                \() ->
                    Expect.equal
                        (TypePath.addChild [ "#", "definitions", "foo" ] "")
                        [ "#", "definitions", "foo" ]
            , test """TypePath.addChild(["#", "definitions"], "bar")""" <|
                \() ->
                    Expect.equal
                        (TypePath.addChild [ "#", "definitions" ] "bar")
                        [ "#", "definitions", "bar" ]
            ]
        ]

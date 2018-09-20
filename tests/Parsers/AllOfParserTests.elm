module AllOfParserTests exposing (..)

import Expect
import Test exposing (..)
import Dict exposing (..)
import Parsers.AllOfParser exposing (..)
import Types exposing (..)


suite : Test
suite =
    describe "AllOfParser"
        [ describe "isType"
            [ describe "Returns true if the JSON subschema represents an allOf type."
                [ test """empty branch""" <|
                    \() ->
                        Expect.equal (isType Dict.empty) False
                , test """allOf branch that's empty""" <|
                    \() ->
                        Expect.equal (isType (Dict.singleton "allOf" (Branch Dict.empty))) False
                , test """allOf branch with $ref key and #foo value""" <|
                    \() ->
                        Expect.equal (isType (Dict.singleton "allOf" (Branch (Dict.singleton "$ref" (Leaf "#foo"))))) True
                ]
            ]
        ]

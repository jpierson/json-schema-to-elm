module AllOfParserTests exposing (..)

import Expect
import Test exposing (..)
import Dict exposing (..)
import Parsers.AllOfParser exposing (..)
import Parsers.Util exposing (utils)
import Types exposing (..)
import Types.ObjectType exposing (..)
import External.Poison exposing (..)


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
        , test "parse primitive all_of type" <|
            \() -> 
                let 
                    parser_result =
                        """
                        {
                            "allOf": [
                            {
                                "type": "object",
                                "properties": {
                                "color": {
                                    "$ref": "#/color"
                                },
                                "title": {
                                    "type": "string"
                                },
                                "radius": {
                                    "type": "number"
                                }
                                },
                                "required": [ "color", "radius" ]
                            },
                            {
                                "type": "string"
                            }
                            ]
                        }
                        """
                        |> Poison.decode
                        |> AllOfParser.parse utils (nil, nil, ["#", "schema"], "schema") 
                    
                    expected_object_type : Types.ObjectType
                    expected_object_type = {
                        name= "0",
                        path= ["#", "schema", "allOf", "0"],
                        required= ["color", "radius"],
                        properties= Dict.fromList [
                            ("color", ["#", "schema", "allOf", "0", "properties", "color"]),
                            ("title" => ["#", "schema", "allOf", "0", "properties", "title"]),
                            ("radius" => ["#", "schema", "allOf", "0", "properties", "radius"])
                        ]
                    }
                in

        ]

module AnyOfParserTests exposing (..)

import Expect
import Test exposing (..)
import Dict exposing (..)
import Parsers.AnyOfParser exposing (..)

todo : ()
todo = ()

-- suite : Test
-- suite =
--     describe "AnyOfParser"
--         [ describe "isType"
--             [ describe "Returns true if the JSON subschema represents an allOf type."
--                 [ test """AnyOfParser.isType(Dict.empty)""" <|
--                     \() ->
--                         Expect.equal (AnyOfParser.isType Dict.empty) []
--                 , test """TypePath.fromString("#")""" <|
--                     \() ->
--                         Expect.equal (true) [ "#" ]
--                 ]
--             ]
--         ]

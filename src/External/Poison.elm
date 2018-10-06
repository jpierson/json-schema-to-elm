module External.Poison exposing (..)

import Dict exposing (..)
import Json.Decode exposing (..)


type PoisonNode
    = NameValuePair ( String, String )


decode : String -> Dict String Value
decode json =
    decodeString (dict value) json
        |> \result ->
            case result of
                Ok value ->
                    value

                Err error ->
                    Dict.empty

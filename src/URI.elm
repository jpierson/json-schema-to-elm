module URI exposing (URI, parse, to_string, merge)

import Regex exposing (..)
import Array exposing (..)


type UriValue
    = JustUri String


type alias URI =
    { scheme : Maybe String
    , path : Maybe String
    , query : Maybe String
    , fragment : Maybe String
    , authority : Maybe String
    , userInfo : Maybe String
    , host : Maybe String
    , uriPort : Maybe Int
    }


empty : URI
empty =
    { scheme = Nothing
    , path = Nothing
    , query = Nothing
    , fragment = Nothing
    , authority = Nothing
    , userInfo = Nothing
    , host = Nothing
    , uriPort = Nothing
    }


parseUriRegex : Regex
parseUriRegex =
    regex "^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\\?([^#]*))?(#(.*))?"


toUri : Array (Maybe String) -> URI
toUri submatches =
    let
        getMatch index =
            Array.get index submatches |> Maybe.withDefault Nothing
    in
        { scheme = getMatch 2
        , path = getMatch 5
        , query = getMatch 7
        , fragment = getMatch 9
        , authority = getMatch 4
        , userInfo = Nothing
        , host = getMatch 3
        , uriPort = Nothing -- TODO: parse out port for compatibility
        }



-- simulates URI.parse from Elixir


parse : String -> URI
parse uri =
    Regex.find Regex.All parseUriRegex uri
        |> List.head
        |> Maybe.map (.submatches >> Array.fromList)
        |> Maybe.map toUri
        |> Maybe.withDefault empty



--  { Maybe.Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing }
-- Nothing


to_string : URI -> String
to_string value =
    -- case value of
    -- HACK: Impelement better or use a library
    -- URI ->
    case
        ( value.scheme, value.authority, value.uriPort, value.path, value.query )
    of
        ( Just scheme, Just authority, Just uriPort, Just path, Just query ) ->
            scheme ++ ":\\" ++ authority ++ (toString uriPort) ++ "\\" ++ path ++ query

        _ ->
            ""

{--
Merges two URIs.

This function merges two URIs as per [RFC 3986, section 5.2.](https://hexdocs.pm/elixir/URI.html#merge/2)
--}
merge : URI -> URI -> URI
merge uri rel =
    -- TODO: This looks quite involved, perhaps we should use a library implementation instead of reimplementing URI merge
    Debug.crash ""
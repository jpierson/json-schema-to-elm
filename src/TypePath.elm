module TypePath exposing (..)


type alias T =
    List String


forwardSlash : String
forwardSlash =
    "/"


fromString : String -> T
fromString s =
    String.split forwardSlash s
        |> List.filter (\segment -> segment /= "")


toString : T -> String
toString segments =
    segments |> String.join forwardSlash


addChild : T -> String -> T
addChild segments segment =
    case segment of
        "" ->
            segments

        _ ->
            List.append segments [ segment ]

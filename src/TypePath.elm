module TypePath exposing (..)


type alias TypePath =
    List String


forwardSlash : String
forwardSlash =
    "/"


fromString : String -> TypePath
fromString s =
    String.split forwardSlash s
        |> List.filter (\segment -> segment /= "")


toString : TypePath -> String
toString segments =
    segments |> String.join forwardSlash


addChild : TypePath -> String -> TypePath
addChild segments segment =
    case segment of
        "" ->
            segments

        _ ->
            List.append segments [ segment ]


type_path : List String -> Bool
type_path path =
    -- path |> List.length |> (>) 0 && (List.head path) |> Maybe.map (\segment -> segment == "#") |> Maybe.withDefault (False)
    List.head path
        |> Maybe.map (\segment -> segment == "#")
        |> Maybe.withDefault (False)



--   @spec type_path?(any) :: boolean
--   def type_path?(path) do
--     is_list(path) &&
--       length(path) > 0 &&
--       Enum.fetch!(path, 0) == "#"
--   end

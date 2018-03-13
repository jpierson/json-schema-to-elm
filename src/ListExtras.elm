module ListExtras exposing (..)

import Set exposing (..)

-- groupBy : (a -> a -> bool) -> List a -> List List a
-- groupBy comparer list =
--     list
--     |> List.filter / item -> List.fol comparer

-- countGreaterThan : (a -> a -> bool) -> a -> List a -> Bool

appendIfNotFound : (a -> a -> Bool) -> List a -> a -> List a
appendIfNotFound comparer list value =
    case List.filter (comparer value) list |> List.length of 
    0 -> value :: list
    _ -> list


uniq : (a -> a -> Bool) -> List a -> List a
uniq comparer list =
    list
    |> List.foldl (\ current accumulate -> appendIfNotFound comparer accumulate current) []

unique : (a -> comparable) -> (comparable -> a) -> List a -> List a
unique toComparable fromComparable source =
    source
    |> List.map toComparable
    |> Set.fromList
    |> Set.toList
    |> List.map fromComparable
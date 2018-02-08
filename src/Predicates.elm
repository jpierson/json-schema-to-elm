-- module Predicates exposing (..)

-- import Dict exposing (..)


-- definitions : Dict String (Dict String String) -> Bool
-- definitions schemaNode =
--     case Dict.get "definitions" schemaNode of
--         Nothing ->
--             False

--         Just this ->
--             True


-- primitiveType : Dict String String -> Bool
-- primitiveType schemaNode =
--     case Dict.get "type" schemaNode of
--         Nothing ->
--             False

--         Just this ->
--             [ "null", "boolean", "string", "number", "integer" ]
--                 -- |> List.any (\ t -> t == this)
--                 |> List.member this

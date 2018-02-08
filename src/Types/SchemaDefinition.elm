module Types.SchemaDefinition exposing (..)

import Types exposing (..)
import Types.TypeDefinition exposing (TypeDictionary)
import Dict exposing (..)


type alias SchemaDefinition =
    { filePath : Path
    , id : Uri
    , title : String
    , description : String
    , types : TypeDictionary
    }



-- type alias SchemaDictionary = String -> SchemaDefinition


type alias SchemaDictionary =
    Dict String SchemaDefinition

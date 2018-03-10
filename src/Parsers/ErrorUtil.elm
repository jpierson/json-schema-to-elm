module Parsers.ErrorUtil exposing (..)

import Logger
import Types exposing (TypeIdentifier)
import TypePath exposing (..)
import Parsers.ParserError exposing (..)


-- HACK: The original Elixir implementation did some dynamc type checking here, probably not applicable in elm


sanitize_value : a -> String
sanitize_value =
    Basics.toString


error_markings : String -> String
error_markings value =
    String.repeat (String.length value) "^"
        |> red


red : a -> a
red value =
    let
        loggerConfig : Logger.Config a
        loggerConfig =
            Logger.defaultConfig Logger.Error

        log : String -> a -> a
        log =
            Logger.log loggerConfig Logger.Error
    in
        Logger.log loggerConfig Logger.Error "error" value


inspect : a -> String
inspect =
    Basics.toString


print_identifier : Types.TypeIdentifier -> String
print_identifier identifier =
    case identifier of
        Types.TypePath identifier ->
            TypePath.toString identifier

        Types.String string ->
            string

        Types.Uri uri ->
            Basics.toString uri


unsupported_schema_version : String -> List String -> ParserError
unsupported_schema_version supplied_value supported_versions =
    let
        root_path =
            TypePath.fromString "#"

        stringified_value =
            sanitize_value supplied_value

        error_msg =
            """
            Unsupported JSON schema version found at '#'.

                "$schema": """ ++ stringified_value ++ """
                        """ ++ (error_markings stringified_value) ++ """

            Was expecting one of the following types:

            """ ++ (inspect supported_versions) ++ """

        Hint: See the specification section 7. "The '$schema' keyword"
        <http://json-schema.org/latest/json-schema-core.html#rfc.section.7>
        """
    in
        Parsers.ParserError.new (Types.TypePath root_path) Unsupported_schema_version error_msg


missing_property : Types.TypeIdentifier -> String -> ParserError
missing_property identifier property =
    let
        full_identifier =
            print_identifier identifier

        error_msg =
            """
            Could not find property '""" ++ property ++ """' at '""" ++ full_identifier ++ """'
            """
    in
        Parsers.ParserError.new identifier Missing_property error_msg


printIdentifier : TypeIdentifier -> String
printIdentifier identifier =
    case identifier of
        Types.TypePath typePath ->
            TypePath.toString typePath

        Types.String string ->
            string

        Types.Uri uri ->
            uri


nameCollision : TypeIdentifier -> ParserError
nameCollision identifier =
    let
        full_identifier =
            print_identifier identifier

        error_msg =
            """
            Found more than one property with identifier '#{""" ++ full_identifier ++ """}'
            """
    in
        Parsers.ParserError.new identifier Name_collision error_msg


invalidUri : Types.TypeIdentifier -> String -> String -> ParserError
invalidUri identifier property actual =
    let
        fullIdentifier =
            print_identifier identifier

        stringifiedValue =
            sanitize_value actual

        error_msg =
            """
            Could not parse property '""" ++ property ++ """' at '""" ++ fullIdentifier ++ """' into a valid URI.

                "id": """ ++ stringifiedValue ++ """
                    """ ++ error_markings (stringifiedValue) ++ """

            Hint: See URI specification section 3. "Syntax Components"
            <https://tools.ietf.org/html/rfc3986#section-3>
            """
    in
        Parsers.ParserError.new identifier Invalid_uri error_msg

module Writings where

import Data.Aeson (toJSON)
import Data.HashMap.Strict as HashMap (singleton)
import Data.Text (Text)
import Flow
import Shikensu
import Shikensu.Contrib
import Text.HTML.TagSoup

import qualified Data.ByteString as ByteString (empty)
import qualified Data.List as List
import qualified Data.Maybe as Maybe
import qualified Data.Text as Text
import qualified Data.Text.Encoding as Text
import qualified Debug.Trace


-- Summary


insertSummary :: Dictionary -> Dictionary
insertSummary =
    fmap insertSummaryDef


insertSummaryDef :: Definition -> Definition
insertSummaryDef def =
    let
        summary = def
            |> content
            |> Maybe.fromMaybe ByteString.empty
            |> Text.decodeUtf8
            |> Text.unpack
            |> parseTags
            |> extractSummary
            |> toJSON
            |> HashMap.singleton "summary"
    in
    insertMetadataDef summary def


extractSummary :: [Tag String] -> String
extractSummary tags =
    tags
        |> List.filter isTagText
        |> List.map (Maybe.fromMaybe "" . maybeTagText)
        |> List.intercalate ""
        |> truncateString


truncateString :: String -> String
truncateString str =
    let
        spaceIdx =
            str
                |> List.drop 140
                |> List.elemIndex ' '
                |> Maybe.fromMaybe 0
    in
        str
            |> List.take (140 + spaceIdx)
            |> List.foldr (\char acc -> if char == '\n' then ' ' : acc else char : acc) []

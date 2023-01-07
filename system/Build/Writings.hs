module Writings where

import Data.Aeson (toJSON)
import qualified Data.Aeson.KeyMap as KeyMap (singleton)
import Data.Text (Text)
import Flow
import Protolude
import Shikensu
import Shikensu.Contrib
import Text.HTML.TagSoup

import qualified Data.ByteString as ByteString (empty)
import qualified Data.List as List
import qualified Data.Maybe as Maybe
import qualified Data.Text as Text
import qualified Data.Text.Encoding as Text


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
            |> KeyMap.singleton "summary"
    in
    insertMetadataDef summary def


extractSummary :: [Tag [Char]] -> [Char]
extractSummary tags =
    tags
        |> List.filter isTagText
        |> List.map (Maybe.fromMaybe "" . maybeTagText)
        |> List.intercalate ""
        |> truncateString


truncateString :: [Char] -> [Char]
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

module Shikensu.Extra where

import Common
import Data.Text (Text)
import Flow
import Protolude
import Shikensu
import Shikensu.Contrib
import Shikensu.Utilities

import qualified Data.Aeson as Aeson (Value)
import qualified Data.Aeson.KeyMap as KeyMap (empty, fromList, singleton)
import qualified Data.Maybe as Maybe (fromMaybe)
import qualified Data.Text as Text (pack)


-- Flows


insertTitleIntoMetadata :: (Text -> Maybe Aeson.Value) -> Dictionary -> Dictionary
insertTitleIntoMetadata finder = map $
    \def ->
        def
            |> basename
            |> Text.pack
            |> finder
            |> map (KeyMap.singleton "title")
            |> map (`insertMetadataDef` def)
            |> Maybe.fromMaybe def



-- Data utilities


titleFinder :: Metadata -> Text -> Text -> Maybe Aeson.Value
titleFinder deps cat name =
    deps ~> "info" ?~> "titles" ?~> cat ?~> name

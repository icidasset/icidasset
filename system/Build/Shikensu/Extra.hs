module Shikensu.Extra where

import Data.Text (Text)
import Flow
import Shikensu
import Shikensu.Contrib
import Shikensu.Utilities
import Utilities

import qualified Data.Aeson as Aeson (Value)
import qualified Data.HashMap.Strict as HashMap (empty, fromList, singleton)
import qualified Data.Maybe as Maybe (fromMaybe)
import qualified Data.Text as Text (pack)


-- Flows


insertTitleIntoMetadata :: (Text -> Maybe Aeson.Value) -> Dictionary -> Dictionary
insertTitleIntoMetadata finder = fmap $
    \def ->
        def
            |> basename
            |> Text.pack
            |> finder
            |> fmap (HashMap.singleton "title")
            |> fmap (`insertMetadataDef` def)
            |> Maybe.fromMaybe def



-- Data utilities


titleFinder :: Metadata -> Text -> Text -> Maybe Aeson.Value
titleFinder deps cat name =
    deps ~> "info" ?~> "titles" ?~> cat ?~> name

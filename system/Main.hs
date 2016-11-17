module Main where

import Data.Maybe (fromJust, fromMaybe)
import Data.Text (Text)
import Data.Time.Format (defaultTimeLocale, formatTime)
import Data.Yaml (decodeFile)
import Catalogs
import Flow
import Layouts.Application
import Layouts.Writing
import Renderers.Lucid
import Renderers.Markdown
import Shikensu
import Shikensu.Functions
import Shikensu.Metadata
import Shikensu.Types
import Shikensu.Contrib
import Shikensu.Contrib.IO as Shikensu
import System.Directory (getModificationTime)
import Utilities

import qualified Data.Aeson as Aeson (Object, Value, toJSON)
import qualified Data.HashMap.Strict as HashMap (fromList, singleton)
import qualified Data.Text as Text (pack)
import qualified Data.Text.IO as Text (readFile)
import qualified Data.List as List (concatMap)


-- | (• ◡•)| (❍ᴥ❍ʋ)


type Dependencies = Aeson.Object


main :: IO Dictionary
main =
  let
    sequencer = dependencies
      |> fmap flow
      |> fmap List.concatMap
  in
    sequencer
      >>= (<&>) sequences
      >>= write "./build"


non_permalinked_pages :: [String]
non_permalinked_pages = ["200", "404"]



-- Sequences


sequences :: IO [(String, Dictionary)]
sequences = lsequence
  [ ( "pages",      process ["src/Pages/**/*.hs"]                                   )
  , ( "writings",   process ["src/Writings/**/*.md"]              >>= Shikensu.read )
  , ( "images",     process ["icidasset-template/images/**/*.*"]  >>= Shikensu.read )
  ]


flow :: Dependencies -> (String, Dictionary) -> Dictionary
flow deps ("pages", dict) =
  let
    titleFinder_ = titleFinder deps "pages"
  in
    dict
      |> renameExt ".hs" ".html"
      |> rename "NotFound.html" "404.html"
      |> insertTitleIntoMetadata titleFinder_
      |> lowerCaseBasename
      |> permalinkPages
      |> copyPropsToMetadata
      |> insertMetadata deps
      |> renderContent (Renderers.Lucid.catalogRenderer Catalogs.pages)
      |> renderContent (Renderers.Lucid.renderer Layouts.Application.template)


flow deps ("writings", dict) =
  dict
    |> renameExt ".md" ".html"
    |> permalink "index"
    |> frontmatter
    |> prefixDirname "writings/"
    |> copyPropsToMetadata
    |> insertMetadata deps
    |> renderContent (Renderers.Markdown.renderer)
    |> renderContent (Renderers.Lucid.renderer Layouts.Writing.template)
    |> renderContent (Renderers.Lucid.renderer Layouts.Application.template)


flow _ ("images", dict) = prefixDirname "images/" dict



-- Additional IO
--   (Next to the sequences)


dependencies :: IO Dependencies
dependencies =
  lsequence
    [ ("info", parseYamlFile "src/Information.yaml")
    , ("intro", getFileContents "src/Intro.md")
    , ("now", getFileContents "src/Now.md")
    , ("nowDate", getFileLastModDate "src/Now.md")
    , ("social", getFileContents "src/Social.md")
    , ("writings", gatherWritings)
    ]

  |> fmap (fmap $ \(a, b) -> (Text.pack a, b))
  |> fmap (HashMap.fromList)


gatherWritings :: IO Aeson.Value
gatherWritings =
  process ["src/Writings/**/*.md"]
    >>= Shikensu.read
    |> fmap (copyPropsToMetadata)
    |> fmap (frontmatter)
    |> fmap (fmap metadata)
    |> fmap (Aeson.toJSON)


getFileContents :: String -> IO Aeson.Value
getFileContents relativePath =
  relativePath
    |> Text.readFile
    |> fmap Aeson.toJSON


getFileLastModDate :: String -> IO Aeson.Value
getFileLastModDate relativePath =
  relativePath
    |> getModificationTime
    |> fmap (formatTime defaultTimeLocale "%B %Y")
    |> fmap (Aeson.toJSON)


parseYamlFile :: String -> IO Aeson.Value
parseYamlFile relativePath =
  relativePath
    |> decodeFile
    |> fmap fromJust



-- Helpers


insertTitleIntoMetadata :: (Text -> Maybe Aeson.Value) -> Dictionary -> Dictionary
insertTitleIntoMetadata finder =
  let
    insertMeta_ = flip insertMetadataDef
  in
    fmap $ \def ->
      basename def
        |> Text.pack
        |> finder
        |> fmap (HashMap.singleton "title")
        |> fmap (insertMeta_ def)
        |> fromMaybe def


permalinkPages :: Dictionary -> Dictionary
permalinkPages =
  fmap $ \def ->
    if elem (basename def) non_permalinked_pages then def
    else permalinkDef "index" def


titleFinder :: Metadata -> Text -> Text -> Maybe Aeson.Value
titleFinder deps cat name = deps ⚡⚡ "info" ⚡⚡ "titles" ⚡⚡ cat ⚡ name

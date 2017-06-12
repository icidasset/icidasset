module Main where

import Catalogs
import Data.Maybe (fromJust, fromMaybe)
import Data.Text (Text)
import Data.Time.Format (defaultTimeLocale, formatTime)
import Data.Yaml (decodeFile)
import Flow
import Layouts.Application
import Layouts.Writing
import Renderers.Lucid
import Renderers.Markdown
import Shikensu
import Shikensu.Contrib
import Shikensu.Contrib.IO as Shikensu
import Shikensu.Functions
import Shikensu.Metadata
import Shikensu.Types
import Shikensu.Utilities
import System.Directory (getModificationTime)
import Utilities

import qualified Data.Aeson as Aeson (Object, Value, toJSON)
import qualified Data.HashMap.Strict as HashMap (fromList, singleton)
import qualified Data.List as List (concatMap)
import qualified Data.Text as Text (pack)
import qualified Data.Text.IO as Text (readFile)


-- | (• ◡•)| (❍ᴥ❍ʋ)


type Dependencies = Aeson.Object


main :: IO Dictionary
main =
    do
        de <- dependencies
        se <- sequences

        -- Execute flows
        -- & reduce to a single dictionary
        let dictionary = List.concatMap (flow de) se

        -- Write to disk
        write "./build" dictionary


non_permalinked_pages :: [String]
non_permalinked_pages =
    ["200", "404"]


enshrine :: String -> (Dictionary -> IO Dictionary) -> IO Dictionary
enshrine pattern operator =
    Shikensu.listRelativeF "." [pattern] >>= operator



-- Sequences


sequences :: IO [(String, Dictionary)]
sequences = lsequence
    [ ( "pages",     enshrine   "src/Pages/**/*.hs"                 return          )
    , ( "writings",  enshrine   "src/Writings/**/*.md"              Shikensu.read   )
    , ( "images",    enshrine   "icidasset-template/images/**/*.*"  Shikensu.read   )
    ]


flow :: Dependencies -> (String, Dictionary) -> Dictionary
flow deps ("pages", dict) =
    dict
        |> renameExt ".hs" ".html"
        |> rename "NotFound.html" "404.html"
        |> insertTitleIntoMetadata (titleFinder deps "pages")
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


flow _ ("images", dict) =
    dict
        |> prefixDirname "images/"



-- Additional IO
-- (Next to the sequences)


dependencies :: IO Dependencies
dependencies =
    lsequence
        [ ( "info",         parseYamlFile "src/Information.yaml"    )
        , ( "intro",        getFileContents "src/Intro.md"          )
        , ( "now",          getFileContents "src/Now.md"            )
        , ( "nowDate",      getFileLastModDate "src/Now.md"         )
        , ( "social",       getFileContents "src/Social.md"         )
        , ( "writings",     gatherWritings                          )
        ]

    |> fmap (fmap $ \(a, b) -> (Text.pack a, b))
    |> fmap (HashMap.fromList)


gatherWritings :: IO Aeson.Value
gatherWritings =
    Shikensu.read
        |> enshrine "src/Writings/**/*.md"
        |> fmap (copyPropsToMetadata .> frontmatter .> fmap metadata .> Aeson.toJSON)


getFileContents :: String -> IO Aeson.Value
getFileContents relativePath =
    relativePath
        |> Text.readFile
        |> fmap (Aeson.toJSON)


getFileLastModDate :: String -> IO Aeson.Value
getFileLastModDate relativePath =
    relativePath
        |> getModificationTime
        |> fmap (formatTime defaultTimeLocale "%B %Y" .> Aeson.toJSON)


parseYamlFile :: String -> IO Aeson.Value
parseYamlFile relativePath =
    relativePath
        |> decodeFile
        |> fmap (fromJust)



-- Helpers


permalinkPages :: Dictionary -> Dictionary
permalinkPages =
    fmap $ \def ->
        if elem (basename def) non_permalinked_pages
            then def { pathToRoot = "/" }
            else permalinkDef "index" def


insertTitleIntoMetadata :: (Text -> Maybe Aeson.Value) -> Dictionary -> Dictionary
insertTitleIntoMetadata finder =
    let
        insertMeta_ = flip insertMetadataDef
    in
        fmap $ \def ->
            def
                |> basename
                |> Text.pack
                |> finder
                |> fmap (HashMap.singleton "title")
                |> fmap (insertMeta_ def)
                |> fromMaybe def


titleFinder :: Metadata -> Text -> Text -> Maybe Aeson.Value
titleFinder deps cat name =
    deps ~> "info" ?~> "titles" ?~> cat ?~> name

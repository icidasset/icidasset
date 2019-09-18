module Main where

import Catalogs
import Data.ByteString (ByteString)
import Data.Text (Text)
import Data.Time.Format (defaultTimeLocale, formatTime)
import Feed (createFeed)
import Flow
import Protolude
import Renderers.Lucid
import Renderers.Markdown
import Shikensu
import Shikensu.Contrib
import Shikensu.Contrib.IO as Shikensu
import Shikensu.Extra
import Shikensu.Functions
import Shikensu.Utilities
import System.Directory (getCurrentDirectory)
import Writings

import qualified Data.Aeson as Aeson (Object, Value, toJSON)
import qualified Data.HashMap.Strict as HashMap (empty, fromList)
import qualified Data.List as List (concatMap, filter, find, head, map)
import qualified Data.Maybe as Maybe (fromJust, fromMaybe)
import qualified Data.Text.IO as Text (readFile)
import qualified Data.Yaml as Yaml (decodeFile)
import qualified Layouts.Application.Ext
import qualified Layouts.Writing
import qualified System.Directory as Dir (getModificationTime)


-- | (• ◡•)| (❍ᴥ❍ʋ)


main :: IO Dictionary
main =
    do
        de <- dependencies
        se <- sequences
        fe <- rssFeed

        -- Execute flows
        -- & reduce to a single dictionary
        let dictionary = List.concatMap (flow de) se ++ [ fe ]

        -- Write to disk
        write "./build" dictionary


nonPermalinkedPages :: [[Char]]
nonPermalinkedPages =
    [ "200", "404" ]



-- SEQUENCES


data Sequence
    = Images
    | Pages
    | Static
    | Writings
    | WritingsWithLayout
    deriving (Eq)


sequences :: IO [(Sequence, Dictionary)]
sequences =
    do
        pages           <- encapsulate "src/Pages/**/*.hs"
        images          <- encapsulate "icidasset-template/images/**/*.*"   >>= Shikensu.read
        static          <- encapsulate "src/Static/**/*.*"                  >>= Shikensu.read
        writings        <- writingsIO

        return
            [ (Images, images)
            , (Static, static)
            , (Pages, pages)
            , (WritingsWithLayout, writings)
            ]


writingsIO :: IO Dictionary
writingsIO =
    encapsulate "src/Writings/**/*.md" >>= Shikensu.read


encapsulate :: [Char] -> IO Dictionary
encapsulate thePattern =
    Shikensu.listRelativeF "." [ thePattern ]



-- FLOWS


flow :: Dependencies -> (Sequence, Dictionary) -> Dictionary
flow _ (Images, dict) =
    dict
        |> prefixDirname "images/"


flow deps (Pages, dict) =
    dict
        |> renameExt ".hs" ".html"
        |> rename "NotFound.html" "404.html"
        |> insertTitleIntoMetadata (titleFinder deps "pages")
        |> lowerCaseBasename
        |> permalinkPages nonPermalinkedPages
        |> copyPropsToMetadata
        |> insertMetadata deps
        |> renderContent (Renderers.Lucid.catalogRenderer Catalogs.pages)
        |> renderContent (Renderers.Lucid.renderer Layouts.Application.Ext.template)


flow _ (Static, dict) =
    dict


flow deps (Writings, dict) =
    dict
        |> renameExt ".md" ".html"
        |> permalink "index"
        |> frontmatter
        |> prefixDirname "writings/"
        |> copyPropsToMetadata
        |> insertMetadata deps
        |> renderContent Renderers.Markdown.renderer
        |> insertSummary


flow deps (WritingsWithLayout, dict) =
    (Writings, dict)
        |> flow deps
        |> renderContent (Renderers.Lucid.renderer Layouts.Writing.template)
        |> renderContent (Renderers.Lucid.renderer Layouts.Application.Ext.template)



-- ADDITIONAL IO, Pt. 1
-- Flow dependencies


type Dependencies = Aeson.Object


dependencies :: IO Dependencies
dependencies = do
    info            <- decodeYaml "src/Information.yaml"
    intro           <- fileContents "src/Intro.md"
    now             <- fileContents "src/Now.md"
    nowDate         <- fileModificationDate "src/Now.md"
    social          <- fileContents "src/Social.md"
    writings        <- gatherWritings

    return $ HashMap.fromList
        [ ("info", info)
        , ("intro", intro)
        , ("now", now)
        , ("nowDate", nowDate)
        , ("social", social)
        , ("writings", writings)
        ]


gatherWritings :: IO Aeson.Value
gatherWritings = do
    writings        <- writingsIO

    (Writings, writings)
        |> flow HashMap.empty
        |> List.map metadata
        |> Aeson.toJSON
        |> return


fileContents :: [Char] -> IO Aeson.Value
fileContents =
    Text.readFile
    .> fmap Aeson.toJSON


fileModificationDate :: [Char] -> IO Aeson.Value
fileModificationDate =
    Dir.getModificationTime
    .> fmap (formatTime defaultTimeLocale "%B %Y")
    .> fmap Aeson.toJSON


decodeYaml :: [Char] -> IO Aeson.Value
decodeYaml =
    Yaml.decodeFile
    .> fmap Maybe.fromJust



-- ADDITIONAL IO, Pt. 2
-- RSS Feed


rssFeed :: IO Definition
rssFeed = do
    writings        <- writingsIO
    rootDir         <- getCurrentDirectory

    (Writings, writings)
        |> flow HashMap.empty
        |> createFeed
        |> fromMaybe ""
        |> feedDefinition rootDir
        |> return


feedDefinition :: [Char] -> ByteString -> Definition
feedDefinition rootDir feed =
    Definition
        { basename = "feed"
        , dirname = ""
        , extname = ".xml"
        , pattern = "example/**/*.md"
        , rootDirname = rootDir
        , workingDirname = ""

        , content = Just feed
        , metadata = HashMap.empty
        , parentPath = Nothing
        , pathToRoot = "../"
        }

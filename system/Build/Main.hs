module Main where

import Catalogs
import Data.Text (Text)
import Data.Time.Format (defaultTimeLocale, formatTime)
import Flow
import Html hiding (title)
import Html.Attributes
import Layouts.Application
import Layouts.Writing
import Renderers.Lucid
import Renderers.Markdown
import Shikensu
import Shikensu.Contrib
import Shikensu.Contrib.IO as Shikensu
import Shikensu.Functions
import Shikensu.Metadata
import Shikensu.Utilities
import Utilities
import Writings

import qualified Data.Aeson as Aeson (Object, Value, toJSON)
import qualified Data.HashMap.Strict as HashMap (empty, fromList, singleton)
import qualified Data.List as List (concatMap, find, map)
import qualified Data.Maybe as Maybe (fromJust, fromMaybe)
import qualified Data.Text as Text (append, pack)
import qualified Data.Text.IO as Text (readFile)
import qualified Data.Tuple as Tuple (fst, snd)
import qualified Data.Yaml as Yaml (decodeFile)
import qualified Feed
import qualified System.Directory as Dir (getModificationTime)


-- | (• ◡•)| (❍ᴥ❍ʋ)


main :: IO ()
main =
    do
        de <- dependencies
        se <- sequences

        -- Execute flows
        -- & reduce to a single dictionary
        let dictionary = List.concatMap (flow de) se

        -- Write to disk
        write "./build" dictionary

        -- RSS Feed
        createFeed




nonPermalinkedPages :: [String]
nonPermalinkedPages =
    ["200", "404"]



-- Sequences


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


encapsulate :: String -> IO Dictionary
encapsulate thePattern =
    Shikensu.listRelativeF "." [thePattern]



-- Flows


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
        |> permalinkPages
        |> copyPropsToMetadata
        |> insertMetadata deps
        |> renderContent (Renderers.Lucid.catalogRenderer Catalogs.pages)
        |> renderContent (Renderers.Lucid.renderer appLayout)


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
        |> renderContent (Renderers.Lucid.renderer appLayout)



-- Additional IO
-- (Next to the sequences)


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


fileContents :: String -> IO Aeson.Value
fileContents =
    Text.readFile
    .> fmap Aeson.toJSON


fileModificationDate :: String -> IO Aeson.Value
fileModificationDate =
    Dir.getModificationTime
    .> fmap (formatTime defaultTimeLocale "%B %Y")
    .> fmap Aeson.toJSON


decodeYaml :: String -> IO Aeson.Value
decodeYaml =
    Yaml.decodeFile
    .> fmap Maybe.fromJust



-- Feed


createFeed :: IO ()
createFeed = do
    writings        <- writingsIO

    (Writings, writings)
        |> flow HashMap.empty
        |> Feed.create
        |> writeFile "./build/feed.xml"



-- Application layout


appLayout :: Metadata -> Html -> Html
appLayout obj children =
    let
        docTitle =
            Text.append
                ( case obj ~> "title" of
                    Just x -> Text.append x " – "
                    Nothing -> ""
                )
                "I.A."

        docDescription =
            case obj !~> "workingDirname" of
                "src/Writings"  -> obj !~> "summary" :: Text
                _               -> ""

        headNodes = mconcat
            [ link
                [ href "http://icidasset.com/feed.xml"
                , rel "alternate"
                , title "I.A."
                , typ "application/rss+xml"
                ]
                []

            , meta [ name "twitter:card", Html.Attributes.content "summary" ] []
            , meta [ name "twitter:site", Html.Attributes.content "@icidasset" ] []
            , meta [ name "twitter:title", Html.Attributes.content docTitle ] []
            , meta [ name "twitter:description", Html.Attributes.content docDescription ] []
            ]
    in
    Layouts.Application.template
        headNodes
        obj
        children



-- Helpers


permalinkPages :: Dictionary -> Dictionary
permalinkPages = fmap $
    \def ->
        if basename def `elem` nonPermalinkedPages
            then def { pathToRoot = "/" }
            else permalinkDef "index" def


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


titleFinder :: Metadata -> Text -> Text -> Maybe Aeson.Value
titleFinder deps cat name =
    deps ~> "info" ?~> "titles" ?~> cat ?~> name

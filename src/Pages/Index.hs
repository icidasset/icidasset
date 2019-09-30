module Pages.Index where

import Chunky
import Common
import Components.Block (Filler(..))
import Data.Text (Text)
import Flow
import Html
import Html.Attributes
import Html.Custom
import Protolude hiding (Left, Right)
import Shikensu.Utilities

import qualified Components.Block as Block
import qualified Data.List as List
import qualified Data.Maybe as Maybe
import qualified Data.Text as Text
import qualified Shikensu (Metadata)


-- 🍯


template :: Shikensu.Metadata -> Html -> Html
template obj _ =
    container
        [ slab
            Html.p
            []
            [ "font-serif", "leading-relaxed", "mt-12", "text-2xl", "md:text-3xl" ]
            [ markdownWithoutBlocks $ obj !~> "intro" ]

        , Block.row
            [ "md:h-48" ]
            [ Block.filler <| Filler
                { hideOnSmallScreen = False
                , href = Just "projects/"
                , icon = "i-tools"
                , label = "Projects"
                , metadata = obj
                }

            , Block.filler <| Filler
                { hideOnSmallScreen = False
                , href = Just "writings/"
                , icon = "i-text-document"
                , label = "Writings"
                , metadata = obj
                }
            ]

        , Block.row
            []
            [ latestProjectsBlock obj
            , latestWritingsBlock obj
            ]

        , Block.row
            []
            [ nowBlock obj
            , socialBlock obj
            ]
    ]



-- 🚜


nowBlock :: Shikensu.Metadata -> Html
nowBlock obj =
    let
        modifiedData = (obj !~> "nowDate")
            |> Text.toLower
            |> Text.append (Text.pack "Last update, ")
    in
    Block.node
        []
        [ Block.title
            [ Block.titleColorClass ]
            [ "What I’m doing now" ]

        , chunk
            [ "text-justify", "md:w-9/12" ]
            [ markdown $ obj !~> "now" ]

        , Block.note
            (modifiedData <> ".")
        ]


socialBlock :: Shikensu.Metadata -> Html
socialBlock obj =
    Block.node
        []
        [ Block.title
            [ Block.titleColorClass ]
            [ text "Social links" ]

        , blockText
            []
            [ markdown $ obj !~> "social" ]
        ]


latestProjectsBlock :: Shikensu.Metadata -> Html
latestProjectsBlock obj =
    let
        reducer acc p =
            case p ~> "promote" of
                Just True -> acc ++ [ project p ]
                _         -> acc

        projectValues =
            (obj !~> "info" !~> "projects" :: [ Shikensu.Metadata ])

        projects =
            projectValues
                |> List.sortOn (\p -> p !~> "name" :: Text)
                |> List.foldl reducer []
    in
    Block.node
        []
        [ Block.title
            [ Block.titleColorClass ]
            [ text "Latest projects" ]

        , blockList
            []
            [ ul [] projects ]

        , Block.note
            "Ordered by name."
        ]


latestWritingsBlock :: Shikensu.Metadata -> Html
latestWritingsBlock obj =
    let
        reducer acc w =
            case w ~> "promote" of
                Just True ->
                    if w !~> "published" then
                        acc ++ [ writing obj w ]
                    else
                        acc
                _ ->
                    acc

        writingValues =
            obj !~> "writings" :: [ Shikensu.Metadata ]

        writings =
            writingValues
                |> List.sortOn (\w -> w !~> "title" :: Text)
                |> List.foldl reducer []
    in
    Block.node
        []
        [ Block.title
            [ Block.titleColorClass ]
            [ text "Latest writings" ]

        , blockList
            []
            [ ul [] writings ]

        , Block.note
            "Ordered by name."
        ]



-- 🎒


project :: Shikensu.Metadata -> Html
project obj =
    li
        []
        [ a
            [ Html.Attributes.href $ obj !~> "url" ]
            [ text $ obj !~> "name" ]
        ]


writing :: Shikensu.Metadata -> Shikensu.Metadata -> Html
writing parent obj =
    li
        []
        [ a
            [ hrefRelativeDir parent obj ]
            [ text $ Maybe.fromMaybe (obj !~> "title") (obj ~> "short_title") ]
        ]

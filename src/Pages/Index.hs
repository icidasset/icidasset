module Pages.Index where

import Components.Blocks.Filler
import Data.Text (Text)
import Flow
import Html
import Html.Attributes
import Html.Custom
import Shikensu.Utilities

import qualified Data.Text as Text
import qualified Shikensu (Metadata)


-- 🍯


template :: Shikensu.Metadata -> Html -> Html
template obj _ =
    container
        []
        [ p
            [ cls "intro" ]
            [ markdownWithoutBlocks $ obj !~> "intro" ]

        , blocks
            []
            [ blocksRow
                []
                [ nowBlock obj
                , socialBlock obj
                ]

            , blocksRow
                []
                [ latestProjectsBlock obj
                , latestWritingsBlock obj
                ]

            , blocksRow
                []
                [ Components.Blocks.Filler.template
                    [ class_ "has-content has-fixed-height", href "projects/" ]

                    Filler
                    { icon = "i-tools"
                    , label = "See all projects"
                    , metadata = obj
                    }

                , Components.Blocks.Filler.template
                    [ class_ "has-content has-fixed-height", href "writings/" ]

                    Filler
                    { icon = "i-text-document"
                    , label = "See all writings"
                    , metadata = obj
                    }
                ]
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
        block
            []
            [ blockTitleLvl2
                [ cls "is-colored" ]
                [ "What I’m doing now" ]

            , blockText
                []
                [ markdown $ obj !~> "now" ]

            , blockText
                [ cls "block__text--subtle" ]
                [ p [] [ em [] [ text modifiedData, text "." ] ] ]
            ]


socialBlock :: Shikensu.Metadata -> Html
socialBlock obj =
    block
        []
        [ blockTitleLvl2
            [ cls "is-colored" ]
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

        projectValues = (obj !~> "info" !~> "projects" :: [Shikensu.Metadata])
        projects = foldl reducer [] projectValues
  in
        block
            []
            [ blockTitleLvl2
                [ cls "is-colored" ]
                [ text "Latest projects" ]

            , blockList
                []
                [ ul [] projects ]

            , blockText
                [ cls "block__text--subtle" ]
                [ p [] [ em [] [ text "Ordered by name." ] ] ]
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

        writingValues = obj !~> "writings" :: [Shikensu.Metadata]
        writings = foldl reducer [] writingValues
    in
        block
            []
            [ blockTitleLvl2
                [ cls "block__title is-colored" ]
                [ text "Latest writings" ]

            , blockList
                []
                [ ul [] writings ]

            , blockText
                [ cls "block__text--subtle" ]
                [ p [] [ em [] [ text "Ordered by name." ] ] ]
      ]



-- 🎒


project :: Shikensu.Metadata -> Html
project obj =
    li
        []
        [ a
            [ href (obj !~> "url" :: Text) ]
            [ text (obj !~> "name" :: Text) ]
        ]


writing :: Shikensu.Metadata -> Shikensu.Metadata -> Html
writing parent obj =
    li
        []
        [ a
            [ hrefRelativeDir obj ]
            [ text (obj !~> "title" :: Text) ]
        ]

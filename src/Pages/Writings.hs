module Pages.Writings where

import Components.Blocks.Filler
import Data.Text (Text)
import Flow
import Html
import Html.Attributes
import Html.Custom
import Shikensu.Utilities

import qualified Data.List as List
import qualified Data.Maybe as Maybe
import qualified Data.Text as Text
import qualified Shikensu (Metadata)


-- 🍯


template :: Shikensu.Metadata -> Html -> Html
template obj _ =
    container
        []
        [ blocks
            []
            [ blocksRow
                [ cls "has-no-margin-top" ]
                [ left obj
                , right obj
                ]
            ]
        ]



-- 👈


left :: Shikensu.Metadata -> Html
left obj =
    let
        reducer acc w =
            if w !~> "published" then
                acc ++ [ writing obj w ]
            else
                acc

        writingValues =
            obj !~> "writings" :: [Shikensu.Metadata]

        writings =
            writingValues
                |> List.sortOn (\p -> p !~> "title" :: String)
                |> List.foldl reducer []
    in
        block
            []
            [ blockTitleLvl1
                []
                [ text $ obj !~> "title" ]

            , blockList
                []
                [ ul [] writings ]

            , blockText
                [ cls "block__text--subtle" ]
                [ p [] [ em [] [ text "Ordered by name." ] ] ]
            ]



-- 👉


right :: Shikensu.Metadata -> Html
right obj =
    Components.Blocks.Filler.template
        [ attr "hide-lt" "small" ]

        Filler
        { icon = "i-text-document"
        , label = obj !~> "title"
        , metadata = obj
        }



-- 🎒


writing :: Shikensu.Metadata -> Shikensu.Metadata -> Html
writing parent obj =
    li
        []
        [ a
            [ hrefRelativeDir obj ]
            [ text $ Maybe.fromMaybe (obj !~> "title") (obj ~> "short_title") ]
        ]

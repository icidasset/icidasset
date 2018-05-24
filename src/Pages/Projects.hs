module Pages.Projects where

import Components.Blocks.Filler
import Data.Text (Text)
import Flow
import Html
import Html.Attributes
import Html.Custom
import Shikensu.Utilities

import qualified Data.List as List
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
        projectValues =
            obj !~> "info" !~> "projects"

        projects =
            projectValues
                |> List.sortOn (\p -> p !~> "name" :: String)
                |> List.map project
    in
        block
            []
            [ blockTitleLvl1
                []
                [ text $ obj !~> "title" ]

            , blockList
                [ cls "has-extra-space" ]
                [ ul [] projects ]

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
        { icon = "i-tools"
        , label = obj !~> "title"
        , metadata = obj
        }



-- 🎒


project :: Shikensu.Metadata -> Html
project obj =
    li
        []
        [ a
            [ href $ obj !~> "url" ]
            [ text $ obj !~> "name" ]

        , br
            []
            []

        , small
            [ cls "small--block" ]
            [ text $ obj !~> "description" ]
        ]

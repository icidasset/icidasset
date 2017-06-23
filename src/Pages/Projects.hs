module Pages.Projects where

import Data.Text (Text)
import Html
import Html.Attributes
import Html.Custom
import Shikensu.Utilities

import qualified Components.Blocks.Filler
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
        projectValues = obj !~> "info" !~> "projects"
        projects = fmap project projectValues
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
        "i-tools"
        (obj !~> "title")
        obj



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

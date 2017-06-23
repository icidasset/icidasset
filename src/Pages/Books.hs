module Pages.Books where

import Components.Blocks.Filler
import Data.Text (Text)
import Html
import Html.Attributes
import Html.Custom
import Prelude hiding (span)
import Shikensu.Utilities

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
        bookValues = obj !~> "info" !~> "books"
        books = fmap book bookValues
    in
        block
            []
            [ blockTitleLvl1
                []
                [ text (obj !~> "title") ]

            , blockList
                []
                [ ul [] books ]

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
        { icon = "i-book"
        , label = obj !~> "title"
        , metadata = obj
        }



-- 🎒


book :: Shikensu.Metadata -> Html
book obj =
    li
        []
        [ -- Title
          text $ obj !~> "title"

          -- Status
        , case obj ~> "reading" of
            Just True ->
                span
                    [ cls "block__list__affix" ]
                    [ text "Currently reading" ]
            _ ->
                nothing

        , br
            []
            []

          -- Additional info
        , small
            []
            [ text "by "
            , text $ obj !~> "author"
            ]
        ]

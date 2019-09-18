module Pages.Books where

import Chunky
import Common (container)
import Components.Block (Filler(..))
import Data.Text (Text)
import Flow
import Html
import Html.Attributes
import Html.Custom
import Protolude hiding (span)
import Shikensu.Utilities

import qualified Components.Block as Block
import qualified Data.Text as Text
import qualified Shikensu (Metadata)


-- 🍯


template :: Shikensu.Metadata -> Html -> Html
template obj _ =
    container
        [ Block.row
            []
            [ left obj
            , right obj
            ]
        ]



-- 👈


left :: Shikensu.Metadata -> Html
left obj =
    let
        bookValues =
            obj !~> "info" !~> "books"

        books =
            map book bookValues
    in
        Block.node
            []
            [ Block.title
                []
                [ text (obj !~> "title") ]

            , ul
                []
                books

            , Block.note "Ordered by name."
            ]



-- 👉


right :: Shikensu.Metadata -> Html
right obj =
    Block.filler <| Filler
        { hideOnSmallScreen = True
        , href = Nothing
        , icon = "i-book"
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
                -- TODO: Styling
                text "Currently reading"

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

module Pages.NotFound where

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
    Components.Blocks.Filler.template
        []
        "i-megaphone"
        (obj !~> "title")
        obj



-- 👉


right :: Shikensu.Metadata -> Html
right =
    Components.Blocks.Filler.template
        [ cls "has-content", href "../" ]
        "i-home"
        "Go to the homepage"

module Pages.NotFound where

import Components.Blocks.Filler
import Data.Text (Text)
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

        Filler
        { icon = "i-megaphone"
        , label = obj !~> "title"
        , metadata = obj
        }



-- 👉


right :: Shikensu.Metadata -> Html
right obj =
    Components.Blocks.Filler.template
        [ cls "has-content", href "../" ]

        Filler
        { icon = "i-home"
        , label = "Go to the homepage"
        , metadata = obj
        }

module Pages.NotFound where

import Common (container)
import Components.Block (Filler(..))
import Data.Text (Text)
import Flow
import Html
import Html.Attributes
import Html.Custom
import Protolude
import Shikensu.Utilities

import qualified Components.Block as Block
import qualified Data.Text as Text
import qualified Shikensu (Metadata)


-- 🍯


template :: Shikensu.Metadata -> Html -> Html
template obj _ =
    container
        [ Block.row
            [ "md:h-48" ]
            [ left obj
            , right obj
            ]
        ]



-- 👈


left :: Shikensu.Metadata -> Html
left obj =
    Block.filler <| Filler
        { hideOnSmallScreen = True
        , href = Nothing
        , icon = "i-megaphone"
        , label = obj !~> "title"
        , metadata = obj
        }



-- 👉


right :: Shikensu.Metadata -> Html
right obj =
    Block.filler <| Filler
        { hideOnSmallScreen = False
        , href = Just "/"
        , icon = "i-home"
        , label = "Go to the homepage"
        , metadata = obj
        }

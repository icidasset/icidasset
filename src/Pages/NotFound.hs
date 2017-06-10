module Pages.NotFound where

import Data.Text (Text)
import Elements
import Flow
import Lucid.Base (Html, makeAttribute, toHtml)
import Lucid.Html5
import Shikensu.Utilities ((!~>), (~>))
import Types
import Utilities ((↩))

import qualified Components.Blocks.Filler
import qualified Data.Aeson as Aeson (Object, Value)
import qualified Data.Text as Text (append, concat, pack, toLower)


template :: Template
template obj _ =
  container_
    [] ↩
    [ blocks_
        [] ↩
        [ blocksRow_
            [ class_ "has-no-margin-top" ] ↩
            [ leftSide obj
            , rightSide obj
            ]
        ]
    ]



-- Blocks


leftSide :: Partial
leftSide obj =
  Components.Blocks.Filler.template
    []
    "i-megaphone"
    (obj !~> "title")
    (obj)


rightSide :: Partial
rightSide obj =
  Components.Blocks.Filler.template
    [ class_ "has-content", href_ "../" ]
    "i-home"
    "Go to the homepage"
    obj

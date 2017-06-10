module Pages.Projects where

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
  let
    projectValues = (obj !~> "info" !~> "projects" :: [Aeson.Object])
    projects = fmap project projectValues
  in
    block_
      [] ↩
      [ blockTitleLvl1_
          [] ↩
          [ toHtml (obj !~> "title" :: String) ]

      , blockList_
          [ class_ "has-extra-space" ] ↩
          [ ul_ ↩ projects ]

      , blockText_
          [ class_ "block__text--subtle" ] ↩
          [ p_ (em_ "Ordered by name.") ]
      ]


rightSide :: Partial
rightSide obj =
  Components.Blocks.Filler.template
    [ makeAttribute "hide-lt" "small" ]
    "i-tools"
    (obj !~> "title")
    (obj)



-- Helpers


project :: Aeson.Object -> Html ()
project obj =
  let
    name  = toHtml (obj !~> "name" :: String)
    desc  = toHtml (obj !~> "description" :: String)
    url   = obj !~> "url" :: Text
  in
    li_
      [] ↩
      [ a_
          [ href_ url ] ↩
          [ name ]

      , br_
          []

      , small_
          [ class_ "small--block" ] ↩
          [ desc ]
      ]

module Pages.Books where

import Data.Text (Text)
import Elements
import Flow
import Lucid.Base (Html, makeAttribute, toHtml)
import Lucid.Html5
import Shikensu.Utilities ((~>), (!~>))
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
    bookValues = (obj !~> "info" !~> "books" :: [Aeson.Object])
    books = fmap book bookValues
  in
    block_
      [] ↩
      [ blockTitleLvl1_
          [] ↩
          [ toHtml (obj !~> "title" :: String) ]

      , blockList_
          [] ↩
          [ ul_ ↩ books ]

      , blockText_
          [ class_ "block__text--subtle" ] ↩
          [ p_ (em_ "Ordered by name.") ]
      ]


rightSide :: Partial
rightSide obj =
  Components.Blocks.Filler.template
    [ makeAttribute "hide-lt" "small" ]
    "i-book"
    (obj !~> "title")
    (obj)



-- Helpers


book :: Aeson.Object -> Html ()
book obj =
  let
    title  = toHtml (obj !~> "title" :: String)
    author = toHtml (obj !~> "author" :: String)
  in
    li_
      [] ↩
      [ title

      , case obj ~> "reading" of
          Just True -> span_ [ class_ "block__list__affix" ] ( "Currently reading" )
          _         -> ""

      , br_
          []

      , small_
          [] ↩
          [ "by ", author ]
      ]

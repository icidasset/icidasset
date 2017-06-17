module Pages.Writings where

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
    reducer = \acc w ->
      let
        isPublished = w !~> "published" :: Bool
      in
        case isPublished of
          True -> acc ++ [writing obj w]
          _    -> acc

    writingValues = (obj !~> "writings" :: [Aeson.Object])
    writings = foldl reducer [] writingValues
  in
    block_
      [] ↩
      [ blockTitleLvl1_
          [] ↩
          [ toHtml (obj !~> "title" :: String) ]

      , blockList_
          [] ↩
          [ ul_ ↩ writings ]

      , blockText_
          [ class_ "block__text--subtle" ] ↩
          [ p_ (em_ "Ordered by name.") ]
      ]


rightSide :: Partial
rightSide obj =
  Components.Blocks.Filler.template
    [ makeAttribute "hide-lt" "small" ]
    "i-text-document"
    (obj !~> "title")
    obj



-- Helpers


writing :: Aeson.Object -> Aeson.Object -> Html ()
writing parent obj =
  let
    title = toHtml (obj !~> "title" :: String)
    href  = Text.concat
      [ parent !~> "pathToRoot" :: Text
      , obj !~> "dirname" :: Text
      , "/"
      ]
  in
    li_
      [] ↩
      [ a_
          [ href_ href ] ↩
          [ title ]
      ]

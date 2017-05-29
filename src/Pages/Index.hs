module Pages.Index where

import Data.Text (Text)
import Elements
import Flow
import Lucid.Base (Html, toHtml)
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
    [ p_
        [ class_ "intro" ] ↩
        [ markdownWithoutBlocks_ $ obj !~> "intro" ]

    , blocks_
        [] ↩
        [ blocksRow_
            [] ↩
            [ nowBlock obj
            , socialBlock obj
            ]

        , blocksRow_
            [] ↩
            [ latestProjectsBlock obj
            , latestWritingsBlock obj
            ]

        , blocksRow_
            [] ↩
            [ Components.Blocks.Filler.template
                [ class_ "has-content has-fixed-height", href_ "projects/" ]
                "i-tools"
                "See all projects"
                obj

            , Components.Blocks.Filler.template
                [ class_ "has-content has-fixed-height", href_ "writings/" ]
                "i-text-document"
                "See all writings"
                obj
            ]
        ]
    ]



-- Blocks


nowBlock :: Partial
nowBlock obj =
  let
    modifiedData = (obj !~> "nowDate")
      |> Text.toLower
      |> Text.append (Text.pack "Last update, ")
      |> toHtml
  in
    block_
      [] ↩
      [ blockTitleLvl2_
          [ class_ "is-colored" ] ↩
          [ "What I’m doing now" ]

      , blockText_
          [] ↩
          [ markdown_ $ obj !~> "now" ]

      , blockText_
          [ class_ "block__text--subtle" ] ↩
          [ p_ (em_ [] ↩ [ modifiedData, "." ]) ]
      ]


socialBlock :: Partial
socialBlock obj =
  block_
    [] ↩
    [ blockTitleLvl2_
        [ class_ "is-colored" ]
        ("Social links")

    , blockText_
        []
        (markdown_ $ obj !~> "social")
    ]


latestProjectsBlock :: Partial
latestProjectsBlock obj =
  let
    reducer = \acc p ->
      case p ~> "promote" of
        Just True -> acc ++ [project p]
        _         -> acc

    projectValues = (obj !~> "info" !~> "projects" :: [Aeson.Object])
    projects = foldl reducer [] projectValues
  in
    block_
      [] ↩
      [ blockTitleLvl2_
          [ class_ "is-colored" ]
          ("Latest projects")

      , blockList_
          []
          (ul_ ↩ projects)

      , blockText_
          [ class_ "block__text--subtle" ]
          ( p_ (em_ "Ordered by name.") )
      ]


latestWritingsBlock :: Partial
latestWritingsBlock obj =
  let
    reducer = \acc w ->
      let
        isPublished = w !~> "published" :: Bool
        isPromoted  = w ~> "promote" :: Maybe Bool
      in
        case isPromoted of
          Just True -> if isPublished == True then acc ++ [writing obj w] else acc
          _         -> acc

    writingValues = (obj !~> "writings" :: [Aeson.Object])
    writings = foldl reducer [] writingValues
  in
    block_
      [] ↩
      [ blockTitleLvl2_
          [ class_ "is-colored" ]
          ("Latest writings")

      , blockList_
          []
          (ul_ ↩ writings)

      , blockText_
          [ class_ "block__text--subtle" ]
          ( p_ (em_ "Ordered by name.") )
      ]



-- Helpers


project :: Aeson.Object -> Html ()
project obj =
  let
    name = toHtml (obj !~> "name" :: String)
    url = obj !~> "url" :: Text
  in
    li_
      [] ↩
      [ a_
        [ href_ url ] ↩
        [ name ]
      ]


writing :: Aeson.Object -> Aeson.Object -> Html ()
writing parent obj =
  let
    title = toHtml (obj !~> "title" :: String)
    href = Text.concat
      [ parent !~> "pathToRoot" :: Text
      , "writings/"
      , obj !~> "basename" :: Text
      , "/"
      ]
  in
    li_
      [] ↩
      [ a_
        [ href_ href ] ↩
        [ title ]
      ]

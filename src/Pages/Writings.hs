module Pages.Writings where

import Chunky
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
import qualified Data.List as List
import qualified Data.Maybe as Maybe
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
        reducer acc w =
            if w !~> "published" then
                acc ++ [ writing obj w ]
            else
                acc

        writingValues =
            obj !~> "writings" :: [ Shikensu.Metadata ]

        writings =
            writingValues
                |> List.sortOn (\p -> p !~> "title" :: Text)
                |> List.foldl reducer []
    in
        Block.node
            []
            [ Block.title
                []
                [ text $ obj !~> "title" ]

            , ul
                []
                writings

            , Block.note "Ordered by name."
            ]



-- 👉


right :: Shikensu.Metadata -> Html
right obj =
    Block.filler <| Filler
        { hideOnSmallScreen = True
        , href = Nothing
        , icon = "i-text-document"
        , label = obj !~> "title"
        , metadata = obj
        }



-- 🎒


writing :: Shikensu.Metadata -> Shikensu.Metadata -> Html
writing parent obj =
    Html.li
        []
        [ a
            [ hrefRelativeDir parent obj ]
            [ text $ Maybe.fromMaybe (obj !~> "title") (obj ~> "short_title") ]
        ]

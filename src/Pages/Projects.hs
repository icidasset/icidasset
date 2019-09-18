module Pages.Projects where

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
        projectValues =
            obj !~> "info" !~> "projects"

        projects =
            projectValues
                |> List.sortOn (\p -> p !~> "name" :: Text)
                |> List.map project
    in
        Block.node
            []
            [ Block.title
                []
                [ text (obj !~> "title") ]

            , ul
                []
                projects

            , Block.note "Ordered by name."
            ]



-- 👉


right :: Shikensu.Metadata -> Html
right obj =
    Block.filler <| Filler
        { hideOnSmallScreen = True
        , href = Nothing
        , icon = "i-tools"
        , label = obj !~> "title"
        , metadata = obj
        }



-- 🎒


project :: Shikensu.Metadata -> Html
project obj =
    slab
        Html.li
        []
        [ "mt-5" ]
        [ a
            [ Html.Attributes.href $ obj !~> "url" ]
            [ text $ obj !~> "name" ]

        , slab
            Html.small
            []
            [ "block", "leading-normal", "mt-2" ]
            [ text $ obj !~> "description" ]
        ]

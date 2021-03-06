module Layouts.Application.Ext where

import Data.Text (Text)
import Html hiding (title)
import Html.Attributes
import Layouts.Application
import Protolude hiding (link)
import Shikensu (Metadata)
import Shikensu.Utilities

import qualified Data.Text as Text (append, pack)


-- 🔱


template :: Metadata -> Html -> Html
template obj children =
    let
        docTitle =
            Text.append
                ( case obj ~> "title" of
                    Just x -> Text.append x " – "
                    Nothing -> ""
                )
                "I.A."

        docDescription =
            case obj !~> "workingDirname" of
                "src/Writings"  -> obj !~> "summary" :: Text
                _               -> "Steven Vandevelde, aka. icidasset"

        headNodes = mconcat
            [ link
                [ href "https://citric.id/feed.xml"
                , rel "alternate"
                , title "I.A."
                , typ "application/rss+xml"
                ]
                []

            --
            , meta [ name "twitter:card", Html.Attributes.content "summary" ] []
            , meta [ name "twitter:site", Html.Attributes.content "@icidasset" ] []
            , meta [ name "twitter:title", Html.Attributes.content docTitle ] []
            , meta [ name "twitter:description", Html.Attributes.content docDescription ] []

            --
            , meta [ name "description", Html.Attributes.content docDescription ] []
            ]
    in
    Layouts.Application.template
        headNodes
        obj
        children

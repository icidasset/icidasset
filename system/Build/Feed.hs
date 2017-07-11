module Feed where

import Data.Monoid ((<>))
import Data.Time.Clock
import Data.Time.Format
import Debug.Trace
import Flow
import Shikensu
import Shikensu.Utilities

import qualified Data.List as List
import qualified Data.Maybe as Maybe
import qualified Data.Text as Text
import qualified Data.Text.Encoding as Text
import qualified Text.Atom.Feed as Atom
import qualified Text.Atom.Feed.Export as Export
import qualified Text.XML.Light.Output as XML


create :: Dictionary -> String
create unfilteredWritings =
    let
        writings =
            unfilteredWritings
                |> List.filter isPublished
                |> List.sortOn publishedOn
                |> List.reverse

        feed =
            Atom.nullFeed
                (baseUrl <> "feed.xml")
                (Atom.TextString "I.A.")
                (writings |> List.head |> publishedOn)
    in
        feed
            { Atom.feedEntries = fmap toEntry writings
            , Atom.feedLinks = [Atom.nullLink baseUrl]
            }
            |> Export.xmlFeed
            |> XML.ppElement



isPublished :: Definition -> Bool
isPublished definition =
    definition
        |> metadata
        |> (~> "published")
        |> Maybe.fromMaybe False



-- Entries


baseUrl :: String
baseUrl =
    "http://icidasset.com/"


toEntry :: Definition -> Atom.Entry
toEntry def =
    let
        url =
            baseUrl <> localPath def

        entry =
            Atom.nullEntry
                url
                (Atom.TextString $ metadata def !~> "title")
                (publishedOn def)
    in
        entry
            { Atom.entryAuthors = [ Atom.nullPerson { Atom.personName = "Steven Vandevelde" } ]
            , Atom.entryLinks = [ Atom.nullLink url ]
            , Atom.entryContent =
                def
                    |> content
                    |> fmap Text.decodeUtf8
                    |> fmap Text.unpack
                    |> fmap Atom.HTMLContent
            }



-- Time


parseDate :: String -> Maybe UTCTime
parseDate =
    parseTimeM True defaultTimeLocale "%e-%m-%Y"


publishedOn :: Definition -> String
publishedOn definition =
    definition
        |> metadata
        |> (!~> "published_on")
        |> reformatDate


reformatDate :: String -> String
reformatDate input =
    input
        |> parseDate
        |> Maybe.fromJust
        |> formatTime defaultTimeLocale (iso8601DateFormat $ Just "%H:%M:%SZ")

module Feed
    ( createFeed
    ) where

import Common
import Data.ByteString (ByteString)
import Data.Monoid ((<>))
import Data.Time.Clock
import Data.Time.Format
import Flow
import Protolude
import Shikensu
import Shikensu.Utilities

import qualified Data.List as List
import qualified Data.Maybe as Maybe
import qualified Data.Text as Text
import qualified Data.Text.Encoding as Text
import qualified Data.Text.Lazy as Text.Lazy
import qualified Text.Atom.Feed as Atom
import qualified Text.Atom.Feed.Export as Export
import qualified Text.XML.Light.Output as XML


-- 🔱


createFeed :: Dictionary -> Maybe ByteString
createFeed unfilteredWritings =
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
        , Atom.feedLinks = [ Atom.nullLink baseUrl ]
        }
        |> Export.textFeed
        |> map Text.Lazy.toStrict
        |> map Text.encodeUtf8


isPublished :: Definition -> Bool
isPublished definition =
    definition
        |> metadata
        |> (~> "published")
        |> Maybe.fromMaybe False



-- Entries


baseUrl :: Text
baseUrl =
    "https://icidasset.com/"


toEntry :: Definition -> Atom.Entry
toEntry def =
    let
        url =
            baseUrl <> Text.pack (localPath def)

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
                    |> fmap Export.xmlId
                    |> fmap Atom.HTMLContent
            }



-- Time


parseDate :: Text -> Maybe UTCTime
parseDate =
    Text.unpack .> parseTimeM True defaultTimeLocale "%e-%m-%Y"


publishedOn :: Definition -> Text
publishedOn definition =
    "published_on"
        |> (~>) (metadata definition)
        |> (<<=) reformatDate
        |> fromMaybe Text.empty


reformatDate :: Text -> Maybe Text
reformatDate input =
    input
        |> parseDate
        |> map (formatTime defaultTimeLocale $ iso8601DateFormat $ Just "%H:%M:%SZ")
        |> map Text.pack

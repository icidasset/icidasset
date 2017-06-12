module Catalogs where

import Types

import qualified Data.HashMap.Strict as HashMap (fromList)
import qualified Pages.Books
import qualified Pages.Index
import qualified Pages.NotFound
import qualified Pages.Projects
import qualified Pages.Writings


pages :: TemplateCatalog
pages =
    HashMap.fromList
        [ ( "404", Pages.NotFound.template )
        , ( "books", Pages.Books.template )
        , ( "index", Pages.Index.template )
        , ( "projects", Pages.Projects.template )
        , ( "writings", Pages.Writings.template )
        ]

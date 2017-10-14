module Main where

import Network.Wai.Handler.Warp (run)
import qualified Server


main :: IO ()
main = run 8000 Server.app

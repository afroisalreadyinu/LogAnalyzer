module Main where

import System.Environment (getArgs)
import Text.Regex.PCRE
import Data.List
import qualified Data.PSQueue as PSQ
import qualified Data.Set as Set

import Util
import Regular
import Search
import Generation
import SearchTypes
import TestData

doHeuristicSearch :: String -> IO [REChain]
doHeuristicSearch filePath = do
  ll <- readFile filePath
  let logLines = filter (not . (=~ "^\\s*$")) $ lines ll
      startNode = RENode [[LineStart]] 0
      startState = RESearchState logLines (makeNewREs logLines) startNode PSQ.empty
  aStarSearch startState simpleHeuristic

doTest :: IO [REChain]
doTest = do
  let startNode = RENode [[LineStart]] 0
      startState = RESearchState moreComplicatedTestData (makeNewREs moreComplicatedTestData) startNode PSQ.empty
  aStarSearch startState simpleHeuristic

main :: IO ()
main = do
  args <- getArgs
  if (length args) < 1 then do
                         reChain <- doTest
                         putStrLn . show $ reChain
  else do
    reChain <- doHeuristicSearch (args !! 0)
    putStrLn . show $ reChain

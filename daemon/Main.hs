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

doHeuristicSearch :: IO [REChain]
doHeuristicSearch = do
  -- ll <- readFile filePath
  -- let logLines = filter (not . (=~ "^\\s*$")) $ lines ll
  let logLines = testData
      startNode = RENode [[LineStart]] 0
      startState = RESearchState logLines (makeNewREs logLines) startNode PSQ.empty
  aStarSearch startState simpleHeuristic

main :: IO ()
main = do
  -- ll <- readFile "test-data.txt"
  -- let logLines = lines ll
  --     reChain = [LineStart, Word, Word, Word, Word, Word, Word, Word, Word, Word, Word, Word, Word, Word]

  -- putStrLn . show $ improveRE reChain logLines
  -- args <- getArgs
  -- if (length args) < 1 then error "Usage: LogAnalyzer filename"
  -- else do
  reChain <- doHeuristicSearch
  putStrLn . show $ reChain

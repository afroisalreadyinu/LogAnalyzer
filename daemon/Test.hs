module Test where

import qualified Data.PSQueue as PSQ
import Generation
import SearchTypes
import Search
import Util
import Regular
import TestData

newREs = makeNewREs testData
startState = RESearchState testData newREs (RENode [[LineStart]] 0) PSQ.empty

otherNode = RENode [[LineStart, ConstWord "Hologram"], [LineStart, ConstWord "Program"]] 1

weirdNode = RENode [[LineStart, ConstWord "Hologram", ConstWord "blah", ConstWord "yada"], [LineStart, ConstWord "Program", ConstWord "pid", Number]] 2

showNode :: RENode -> String
showNode node = show node ++ "   Heuristic: " ++ (show $ valFunc testData simpleHeuristic node)

runTest :: IO ()
runTest = do
  -- findComplements [LineStart, ConstWord "Program"]
  putStrLn . unlines . (map showNode) $ nextStates startState

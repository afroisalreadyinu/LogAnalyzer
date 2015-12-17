module Test where

import qualified Data.PSQueue as PSQ
import Text.Regex.PCRE.String
import Generation
import SearchTypes
import Search
import Util
import Regular
import TestData

newREs = makeNewREs testData
startState = RESearchState testData newREs (RENode [[LineStart]] 0) PSQ.empty

otherNode = RENode [[LineStart, ConstWord "Oct"]] 1

showNode :: RENode -> String
showNode node = show node ++ "   Heuristic: " ++ (show $ valFunc testData simpleHeuristic node)

getError :: Either (MatchOffset, String) Regex -> String
getError (Right _) = ""
getError (Left (_, error)) = error

showError :: (RE, String) -> String
showError (re, []) = "NO ERROR"
showError (re, error) = reToRegExp re ++ "  :  " ++ error

runTest :: IO ()
runTest = do
  -- findComplements [LineStart, ConstWord "Program"]
  let res = makeNewREs moreComplicatedTestData
      statate = RESearchState moreComplicatedTestData (makeNewREs moreComplicatedTestData) (RENode [[LineStart]] 1) PSQ.empty
  putStrLn . unlines . (map showNode) $ nextStates statate

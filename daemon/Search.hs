module Search where

import qualified Data.PSQueue as PSQ

import Util
import Regular
import Generation
import SearchTypes

type Heuristic = [String] -> [REChain] -> Integer

-- A simple heuristic to evaluate a set of REChains. Returns the
-- percent of text that is not covered in the lines
simpleHeuristic :: Heuristic
simpleHeuristic logLines reChains =
    let linesSizeSum = sum . (map length) $ logLines
        totalMatched = sum . (map (lineCoverage reChains)) $ logLines
        coveragePerc = floor $ 100 * (fromIntegral totalMatched) / (fromIntegral linesSizeSum)
    in (fromIntegral 100) - coveragePerc


heuristicRESearch :: RESearchState -> Heuristic -> IO [REChain]
heuristicRESearch reState heuristic =
    if heuristic (reLogLines reState) (reNodeChains . currentRENode $ reState) == 0
    then return (reNodeChains . currentRENode $ reState)
    else
        let children = nextStates reState
            childrenVals = map (\x -> (x, heuristic (reLogLines reState) (reNodeChains x))) children
            newPrioQueue = insertList (priorityQueue reState) childrenVals
            maybeNextNode = PSQ.minView newPrioQueue
        in case maybeNextNode of
             Nothing -> error "Empty priority queue in heuristicRESearch"
             Just (binding, restPsq) -> do
                                putStrLn $ "Current heuristic: " ++ (show (PSQ.prio binding)) ++ "  Chains: " ++ (show (reNodeChains . currentRENode $ reState))
                                heuristicRESearch (reState { priorityQueue=restPsq, currentRENode=(PSQ.key binding) }) heuristic


valFunc :: [String] -> Heuristic -> RENode -> Integer
valFunc logLines heuristic node = (heuristic logLines (reNodeChains node)) + (costFuncNode node)


aStarSearch :: RESearchState -> Heuristic -> IO [REChain]
aStarSearch reState heuristic =
    if heuristic (reLogLines reState) (reNodeChains . currentRENode $ reState) == 0
    then return (reNodeChains . currentRENode $ reState)
    else
        let children = nextStates reState
            childrenVals = zipWith (,) children $ map (valFunc (reLogLines reState) heuristic) children
            newPrioQueue = insertList (priorityQueue reState) childrenVals
            maybeNextNode = PSQ.minView newPrioQueue
        in case maybeNextNode of
             Nothing -> error "Empty priority queue in heuristicRESearch"
             Just (binding, restPsq) -> do
                                putStrLn $ "Chains: " ++ (show . reNodeChains . currentRENode $ reState)
                                --putStrLn $ "Children: " ++ (show childrenVals)
                                aStarSearch (reState { priorityQueue=restPsq, currentRENode=(PSQ.key binding) }) heuristic

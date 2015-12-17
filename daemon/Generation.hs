module Generation where

import SearchTypes
import Util
import Regular
import qualified Data.IntMap.Strict as IntMap

allSubsets :: [a] -> [[a]]
allSubsets []  = [[]]
allSubsets (x:xs) = allSubsets xs ++ map (x:) (allSubsets xs)


chainSetCovers :: [REChain] -> [String] -> Bool
chainSetCovers = curry $ null . snd . (uncurry splitCoverage)

chainSetIndependent :: [REChain] -> [String] -> Bool
chainSetIndependent chains logLines =
    let allDoubles = filter ((==2) . length) $ allSubsets chains
    in null $ filter (\(x:y:_) -> (isOverlapping x y logLines)) allDoubles

nonOverlappingCover :: [String] -> [REChain] -> Bool
nonOverlappingCover logLines chains = (chainSetCovers chains logLines) && (chainSetIndependent chains logLines)

cachedChainSetCovers :: [REMatchCache] -> Bool
cachedChainSetCovers matchCaches =
    let composite = foldl1 (IntMap.unionWith (+)) $ map matchData matchCaches
    in IntMap.foldl (\a b -> a && (b>0)) True composite

cachedChainSetIndependent :: [REMatchCache] -> Bool
cachedChainSetIndependent matchCaches =
    let composite = foldl1 (IntMap.unionWith ??) $ map matchData matchCaches
    in

nextStates :: RESearchState -> [RENode]
nextStates searchState =
    let node = currentRENode searchState
        chains = reNodeChains node
        logLines = reLogLines searchState
        res = possibleREs searchState
        newChains = [chain ++ [re] | chain <- chains, re <- res] ++ chains
        goodChains = filter (\x -> anyLineMatches x logLines) newChains
        chainCaches = map (flip buildCache $ logLines) goodChains
        goodSets = filter (nonOverlappingCover logLines) $ allSubsets goodChains
    in map (\x -> RENode x (1 + (reNodeDepth node))) goodSets

isOverlapping :: REChain -> REChain -> [String] -> Bool
isOverlapping re other logLines =
    let (reCovering, _) = splitCoverage [re] logLines
        (otherCovering, _) = splitCoverage [other] logLines
    in or [l1 == l2 | l1 <- reCovering, l2 <- otherCovering]

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


data CoverageStatus = NotCovered | Covered Int | DoubleCovered
covStat :: Int -> CoverageStatus
covStat x | x > 0 = Covered x
          | otherwise = NotCovered

getCoverageStat :: CoverageStatus -> CoverageStatus -> CoverageStatus
getCoverageStat NotCovered c@(Covered _) = c
getCoverageStat c@(Covered _) NotCovered = c
getCoverageStat (Covered _) (Covered _) = DoubleCovered
getCoverageStat DoubleCovered _ = DoubleCovered
getCoverageStat _ DoubleCovered = DoubleCovered
getCoverageStat NotCovered NotCovered = NotCovered


isRighteous :: CoverageStatus -> Bool
isRighteous (Covered a) = True
isRighteous _ = False

uniquelyCovered :: [REMatchCache] -> Bool
uniquelyCovered matchCaches =
    if null matchCaches then False else
    let caches = map matchData matchCaches
        covStats = map (IntMap.map covStat) caches
        composite = foldl1 (IntMap.unionWith getCoverageStat) covStats
    in IntMap.foldl (&&) True $ IntMap.map isRighteous composite

nextStates :: RESearchState -> [RENode]
nextStates searchState =
    let node = currentRENode searchState
        chains = reNodeChains node
        logLines = reLogLines searchState
        res = possibleREs searchState
        newChains = [chain ++ [re] | chain <- chains, re <- res] ++ chains
        goodChains = filter (\x -> anyLineMatches x logLines) newChains
        chainCaches = map (flip buildCache $ logLines) goodChains
        goodCaches = filter uniquelyCovered  $ allSubsets chainCaches
        --goodSets = filter (nonOverlappingCover logLines) $ allSubsets goodChains
    in map (\x -> RENode (map rmcChain x) (1 + (reNodeDepth node))) goodCaches


isOverlapping :: REChain -> REChain -> [String] -> Bool
isOverlapping re other logLines =
    let (reCovering, _) = splitCoverage [re] logLines
        (otherCovering, _) = splitCoverage [other] logLines
    in or [l1 == l2 | l1 <- reCovering, l2 <- otherCovering]

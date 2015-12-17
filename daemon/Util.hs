module Util where

import Data.List
import qualified Data.PSQueue as PSQ
import qualified Data.Sequence as Seq
import qualified Data.Set as Set
import qualified Data.Foldable as Fold

import Regular

appendTo :: [a] -> a -> [a]
appendTo as a = as ++ [a]

-- Insert a list of (key, prio) values into a PSQ.PSQ
insertList :: (Ord k, Ord p) => (PSQ.PSQ k p) -> [(k, p)] -> (PSQ.PSQ k p)
insertList psq items = foldl (\psq' (k, p) -> PSQ.insert k p psq') psq items

updateOne :: (a -> a) -> [a] -> Int -> [a]
updateOne f as ix =
    let seq = Seq.fromList as
        modified = f $ Seq.index seq ix
    in Fold.toList $ Seq.update ix modified seq

mapOnce :: (a -> a) -> [a] -> [[a]]
mapOnce f as = map (updateOne f as) [0..(length as) - 1]


dieKeule :: Maybe a -> a
dieKeule Nothing = error "Die Keule!"
dieKeule (Just x) = x


-- RE Stuff

matchedByAll :: [REChain] -> String -> Bool
matchedByAll reChains logLine = and (map (\x -> chainMatches x logLine) reChains)


-- The lines that are matched and not matched by an re
splitCoverage :: [REChain] -> [String] -> ([String], [String])
splitCoverage reChains logLines =
    foldl' yada ([], []) logLines
    where yada (matching, nonMatching) logLine =
              if anyREMatches reChains logLine
              then ((logLine:matching), nonMatching)
              else (matching, (logLine:nonMatching))

getFirstIncomplete :: REChain -> [String] -> String
getFirstIncomplete reChain logLines = head $ filter (\l -> chainMatchesS reChain l /= l) logLines

generateREs :: REChain -> [String] -> [RE] -> [RE]
generateREs reChain logLines alreadyThere =
    if null logLines then [] else
        let firstIncomplete = getFirstIncomplete reChain logLines
            matchedPart = chainMatchesS reChain firstIncomplete
            unmatchedPart = dieKeule $ stripPrefix matchedPart firstIncomplete
            firstWord = head $ words unmatchedPart
            furtherREs = filter (not . (\x -> x `elem` alreadyThere)) $ findMatchingREs firstWord
            chains = map (appendTo reChain) furtherREs
            unmatched = filter (not . (matchedByAll chains)) logLines
        in furtherREs ++ (generateREs reChain unmatched (alreadyThere ++ furtherREs))

-- How many of a given list of lines a list of REChain's matches incompletely
coverageOf :: [REChain] -> [String] -> Int
coverageOf reChains logLines =
    sum $ map blah reChains
    where blah reChain = sum . (map length) . (filter (chainMatches reChain)) $ logLines

-- How many characters of a line is covered
lineCoverage :: [REChain] -> String -> Int
lineCoverage reChains line =
    let firstMatching = find (\x -> chainMatches x line) reChains
    in case firstMatching of
         Nothing -> 0
         Just re -> length $ chainMatchesS re line


makeNewREs :: [String] -> [RE]
makeNewREs logLines =
    let allWords = Set.fromList . words . unlines $ logLines
    in [Word, Number] ++ (map ConstWord $ Set.toList allWords)


filterFunc :: REChain -> [String] -> RE -> Bool
filterFunc reChain logLines re = anyLineMatches (reChain ++ [re]) logLines

-- starts from a reg exp and a set of lines that it matches (not completely),
-- and produces list of sets that each match the set again, in different ways
improveRE :: REChain -> [String] -> [RE] -> [[REChain]]
improveRE reChain logLines possibleREs =
    let usefulREs = filter (filterFunc reChain logLines) possibleREs
        maybeRes = map (\x -> coveringChains reChain [reChain ++ [x]] logLines usefulREs) usefulREs
        justRes = filter (/= Nothing) maybeRes
    in map dieKeule justRes

coveringChains :: REChain   -- the initial chain
               -> [REChain] -- the collected chains; covers part of the lines
                            -- the aim is to find a list of chains that covers all
               -> [String] -- the lines that have to be covered
               -> [RE] -- the available REs that can be tried
               -> Maybe [REChain] -- happens if there is no covering list from here
coveringChains currentChain collectedChains logLines res
    | null logLines = Just collectedChains
    | null res = Just collectedChains
    | otherwise = let newChainSet = (currentChain ++ [head res]) : collectedChains
                      (currentCovered,currentMissed) = collectedChains `splitCoverage` logLines
                      (newCovered,newMissed) = newChainSet `splitCoverage` logLines

                  in if (length newCovered) > (length currentCovered)
                     then coveringChains currentChain newChainSet newMissed (tail res)
                     else coveringChains currentChain collectedChains logLines (tail res)

reNextStates :: RENode -> [String] -> [RE] -> [RENode]
reNextStates reNode logLines possibleREs =
    let chains = reNodeChains reNode
        extensions = map (\chain -> improveRE chain (linesMatched chain) possibleREs) chains
        nodeDatas = map concat $ sequence extensions
    in map (\x -> RENode x ((reNodeDepth reNode) + 1)) nodeDatas
    where linesMatched chain = filter (chainMatches chain) logLines

findComplements :: REChain -> [REChain] -> [String] -> [[REChain]]
findComplements chain reChains logLines =
    let compChains = filter (\x -> not $ isOverlapping chain x logLines) reChains
    in map (\x -> [chain, x]) compChains

module SearchTypes where

import qualified Data.PSQueue as PSQ

import Util
import Regular

data RENode = RENode { reNodeChains :: [REChain], reNodeDepth :: Integer } deriving Show

pathCost :: RENode -> Integer
pathCost = fromIntegral . sum . (map length) . reNodeChains

instance Ord RENode where
    compare s1 s2 = compare ((map toRegExp) . reNodeChains $ s1) ((map toRegExp) . reNodeChains $ s2)

instance Eq RENode where
    s1 == s2 = ((map toRegExp) . reNodeChains $ s1) == ((map toRegExp) . reNodeChains $ s2)


costFuncNode :: RENode -> Integer
costFuncNode = fromIntegral . sum . (map costFuncREChain) . reNodeChains

data RESearchState = RESearchState {
      reLogLines :: [String],
      possibleREs :: [RE],
      currentRENode :: RENode,
      priorityQueue :: PSQ.PSQ RENode Integer
}

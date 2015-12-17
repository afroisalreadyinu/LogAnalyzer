module Regular where

import Text.Regex.PCRE
import qualified Data.IntMap.Strict as IntMap
import qualified Data.String.Utils as SU
import Data.List

toBeEscaped = "\\/[]().{}?*+|"

escape :: String -> String
escape s = foldl (\b a -> SU.replace [a] ("\\" ++ [a]) b) s toBeEscaped

data RE = LineStart |
          Word |
          ConstWord String |
          Number |
          ConstChar Char |
          Parenthesis |
          Brackets |
          HostName deriving (Eq, Ord)
reToRegExp :: RE -> String
reToRegExp LineStart = "^"
reToRegExp Number = "\\d+"
reToRegExp Word = "[a-zA-Z]+"
reToRegExp (ConstWord word) = escape word
reToRegExp (ConstChar c) = escape [c]
reToRegExp Parenthesis = "\\([^)]*\\)"
reToRegExp Brackets = "\\[[^)]*\\]"
reToRegExp HostName = "([\\w-_]+\\.)+([\\w-_]+)"

costFuncRE :: RE -> Int
costFuncRE LineStart = 0
costFuncRE Number = 5
costFuncRE Word = 5
costFuncRE (ConstWord _) = 1
costFuncRE (ConstChar _) = 1
costFuncRE Parenthesis = 1
costFuncRE Brackets = 1
costFuncRE HostName = 1

instance Show RE where
    show = show . reToRegExp

reMatches :: RE -> String -> Bool
reMatches re s = s =~ (reToRegExp re)

reMatchesS :: RE -> String -> String
reMatchesS re s = s =~ (reToRegExp re)

findMatchingREs :: String -> [RE]
findMatchingREs s =
    let constWord = [(ConstWord s)]
        withWord = if (reMatches Word s) then (Word:constWord) else constWord
        withNum = if (reMatches Number s) then (Number:withWord) else withWord
    in withNum

type REChain = [RE]
toRegExp :: REChain -> String
--toRegExp = concat . (intersperse "(\\s*)") . (map reToRegExp)
toRegExp (LineStart:rest) = (reToRegExp LineStart) ++ (toRegExp rest)
toRegExp rest = unwords . (map reToRegExp) $ rest

costFuncREChain :: REChain -> Int
costFuncREChain = sum . (map costFuncRE)

chainMatches :: REChain -> String -> Bool
chainMatches reChain line = line =~ (toRegExp reChain)

chainMatchesS :: REChain -> String -> String
chainMatchesS reChain line = line =~ (toRegExp reChain)

-- Does one of these REChain's match this line?
anyREMatches :: [REChain] -> String -> Bool
anyREMatches reChains line = any (\x -> chainMatches x line) reChains

-- Does this REChain match any of these lines?
anyLineMatches :: REChain -> [String] -> Bool
anyLineMatches reChain logLines = any (chainMatches reChain) logLines


data REMatchCache = REMatchCache { rmcChain :: REChain,
                                   matchData :: IntMap.IntMap Int }

buildCache :: REChain -> [String] -> REMatchCache
buildCache re logLines =
    REMatchCache re $ IntMap.fromList $ foldl collector [] $ zip [0..] logLines
    where collector collected (index, line) = (index, if re == [LineStart] then 1 else (length (chainMatchesS re line))):collected

isWord :: String -> Bool
isWord x = x =~ "\\w*"

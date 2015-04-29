module LtsHs.Version where

import System.Directory (
  getHomeDirectory,
  getDirectoryContents,
  doesDirectoryExist,
  makeAbsolute
  )
import System.FilePath (
  pathSeparator
  )
import Data.List.Split (splitOn)
import Data.List (find)
import Text.Read (readMaybe)

-- LTS Haskell version (major, minor)
data Version = Version Int Int deriving (Show, Eq, Ord)

versionString :: Version -> String
versionString (Version major minor) = show major ++ "." ++ show minor

-- Are two versions exepected to be compatible?
isCompatible :: Version -> Version -> Bool
isCompatible (Version major1 _) (Version major2 _) = major1 == major2

-- Extract version at a given file path.
extractVersion :: FilePath -> IO (Maybe Version)
extractVersion path = do
  absolute <- makeAbsolute path
  let dirs = splitOn [pathSeparator] absolute
      version = do
        lastDirName <- find (not . null) $ reverse dirs
        let majorMinor = splitOn "." lastDirName
        case fmap (readMaybe :: String -> Maybe Int) majorMinor of
         [Just major, Just minor] -> Just (Version major minor)
         _ -> Nothing
  return version

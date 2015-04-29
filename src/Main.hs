module Main where

import System.Environment (getArgs)
import System.Directory (
  getHomeDirectory,
  getDirectoryContents,
  doesDirectoryExist,
  makeAbsolute
  )
import System.IO.Error (catchIOError)
import System.FilePath ((</>))

import LtsHs.Version

-- print help
printHelp :: IO ()
printHelp = putStrLn $ unlines [
  "Usage: ltshs <command>"
  , ""
  , "Commands:"
  , "  ls                Show currently installed versions"
  , "  ls-known          Show all known versions (include not installed ones)"
  , "  install version   Install a specified version"
  , "  setup version     Setup a specified version for the current project"
  ]

getDefaultDirectory :: IO FilePath
getDefaultDirectory = do
  home <- getHomeDirectory
  return $ home </> ".ltshs"


-- list currently install versions
ls :: FilePath -> IO ()
ls path = do
  contents <- listPaths
  maybeVersions <- mapM extractVersion contents
  mapM_ printMaybeVersion maybeVersions
  where
    listPaths :: IO [FilePath]
    listPaths = catchIOError (getDirectoryContents path) (\_ -> return [])
    printMaybeVersion :: Maybe Version -> IO ()
    printMaybeVersion Nothing = return ()
    printMaybeVersion (Just v) = putStrLn $ versionString v

printAvailable :: IO ()
printAvailable = undefined

install :: String -> IO ()
install version = undefined

setup :: String -> IO ()
setup version = undefined

main :: IO ()
main = do
  args <- getArgs
  case args of
   ["ls"] -> getDefaultDirectory >>= ls
   ["ls-known"] -> printAvailable
   ["install", version] -> install version
   ["setup", version] -> setup version
   _ -> printHelp

import System.Environment (getArgs)
import System.IO (openBinaryFile, IOMode (..))
import Control.Monad (forM_)
import qualified Data.ByteString.Lazy as L
import Data.Digest.CRC32 (crc32)
import Data.Word (Word32)
import Text.Printf (printf)
import Text.Regex.Posix ((=~))

-- Text coloring
green :: String -> String
green str = "\x1b[01;32m" ++ str ++ "\x1b[m"
red :: String -> String
red str = "\x1b[01;31m" ++ str ++ "\x1b[m"

-- Integer to hexadecimal
wtox :: Word32 -> String
wtox x = printf "%.8X" x

-- Calculate CRC from file contents
-- (may throw IOException)
contentscrc :: String -> IO Word32
contentscrc fname = do
  file <- openBinaryFile fname ReadMode
  dat <- L.hGetContents file
  -- The file will be once the CRC is calculated
  -- causing hGetContents to encounter EOF
  return (crc32 dat)

-- Try to extract the required CRC from the filename
extractcrc :: String -> Maybe (String, String, String)
extractcrc fname = if not (null matchlist) then
                       Just (prefix, suffix, head matchlist)
                   else
                       Nothing
    where (prefix, _, suffix, matchlist) = (fname =~ "\\[([0-9A-F]{8})\\]")
                               :: (String, String, String, [String])

-- Check CRC given in filename against file contents
-- Ignores filenames that don't have a checksum in [SQUARE BRACKETS]
checkcrc :: String -> IO ()
checkcrc fname = do
  case extractcrc fname of
    Just (prefix, suffix, goal) -> do
      checksum <- fmap wtox (contentscrc fname)
      if checksum == goal then
        putStrLn (green checksum ++ "   " ++ prefix ++ "[" ++ green goal ++ "]" ++ suffix)
      else
        putStrLn (red checksum ++ "   " ++ prefix ++ "[" ++ red goal ++ "]" ++ suffix)
    Nothing -> return ()

main :: IO ()
main = getArgs >>= (mapM_ checkcrc)

import System.Environment (getArgs)
import System.IO (openBinaryFile, IOMode (..))
import Control.Monad (forM_)
import qualified Data.ByteString.Lazy as L
import Data.Digest.CRC32 (crc32)
import Data.Word (Word32)
import Text.Printf (printf)
import Text.Regex.Posix ((=~))


main :: IO ()
main = getArgs >>= (mapM_ checkcrc)

-- re_crc = mkRegex "^.*\\[([0-9A-F]{8})\\].*$"

checkcrc :: String -> IO ()
checkcrc fname = do
  case extractcrc fname of
    Just (prefix, suffix, goal) -> do
      crc <- fmap wtox (getcrc fname)
      if crc == goal then
          putStrLn (green crc ++ "   " ++ prefix ++ "[" ++ green goal ++ "]" ++ suffix)
      else
          putStrLn (red crc ++ "   " ++ prefix ++ "[" ++ red goal ++ "]" ++ suffix)
    Nothing -> return ()

green :: String -> String
green str = "\x1b[01;32m" ++ str ++ "\x1b[m"
red :: String -> String
red str = "\x1b[01;31m" ++ str ++ "\x1b[m"

-- printcheck :: String -> String -> IO ()
-- printcheck goal crc = do

extractcrc :: String -> Maybe (String, String, String)
extractcrc fname = if not (null matchlist) then
                       Just (prefix, suffix, head matchlist)
                   else
                       Nothing
    where (prefix, _, suffix, matchlist) = fname =~ "\\[([0-9A-F]{8})\\]"
                               :: (String, String, String, [String])

getcrc :: String -> IO Word32
getcrc fname = do
  handle <- openBinaryFile fname ReadMode
  dat <- L.hGetContents handle
  return (crc32 dat)

wtox :: Word32 -> String
wtox x = printf "%.8X" x
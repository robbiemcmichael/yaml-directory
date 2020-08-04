module Main where

import qualified Data.Aeson as A
import qualified Data.Aeson.Encode.Pretty as A
import qualified Data.ByteString.Char8 as BSS
import qualified Data.ByteString.Lazy.Char8 as BSL
import qualified Data.Yaml as Y
import Options.Applicative
import System.Exit (die)

import Data.Yaml.Directory

data Options = Options
    { directory :: FilePath
    , json      :: Bool
    }

parser :: Parser Options
parser = Options
    <$> argument str
        (  metavar "DIR"
        <> help "Directory to decode"
        )
    <*> switch
        (  long "json"
        <> short 'j'
        <> help "Set output format to JSON"
        )

main :: IO ()
main = do
    opts   <- execParser $ info (parser <**> helper) fullDesc
    result <- decodeDirectory $ directory opts :: IO (Either String A.Value)
    case result of
        Left e ->
            die e
        Right x ->
            if (json opts)
            then putStr . BSL.unpack $ A.encodePretty x
            else putStr . BSS.unpack $ Y.encode x

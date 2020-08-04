{-# LANGUAGE LambdaCase #-}

module Data.Yaml.Directory
    ( decodeDirectory
    , decodeYaml
    , yamlRule
    ) where

import Data.Aeson (FromJSON, Value(..))
import Data.JSON.Directory hiding (decodeDirectory)
import Data.List (isSuffixOf)
import qualified Data.Text as T
import Data.Yaml (decodeFileEither, prettyPrintParseException)
import System.FilePath (takeBaseName)

decodeDirectory :: FromJSON a => FilePath -> IO (Either String a)
decodeDirectory dir = decodeDirectory' [yamlRule, fallbackRule] dir

yamlRule :: Rule
yamlRule = Rule
    { predicate = \x -> isSuffixOf ".yaml" x || isSuffixOf ".yml" x
    , jsonKey   = T.pack . takeBaseName
    , parser    = decodeYaml
    }

fallbackRule :: Rule
fallbackRule = Rule
    { predicate = const True
    , jsonKey   = T.pack . takeBaseName
    , parser    = const . return $ ISuccess Null
    }

decodeYaml :: FilePath -> IO (IResult Value)
decodeYaml file =
    decodeFileEither file >>= \case
        Left e  -> return . IError [] $ prettyPrintParseException e
        Right x -> return $ ISuccess x

{-# LANGUAGE TemplateHaskell #-}
module Templates where

import Data.Text.Template 
import qualified Data.Text as T
import Data.Text.Encoding           (decodeUtf8, encodeUtf8)
import Data.FileEmbed
import System.FilePath.Posix        (takeBaseName)
import Data.Either.Combinators      (isRight)
import Data.Either.Utils            (fromRight)
import qualified Data.Map as M
import qualified Data.ByteString as BS

-- | Reads all templates from 
rawTemplates :: [(String,T.Text)]
rawTemplates = map (\(path,content) -> (takeBaseName path,decodeUtf8 content)) $(embedDir "templates")

-- | Converts all rawTemplates to template. 
--   Corrupt templates are ignored
templates :: M.Map String Template
templates = M.fromList 
    $ map (\(x,y) -> (x,fromRight y)) 
    $ filter (isRight . snd) 
    $ map (\(name,content) -> (name, templateSafe content)) rawTemplates

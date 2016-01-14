{-# LANGUAGE OverloadedStrings #-}

module Config where

import Network.Wai.Middleware.RequestLogger (logStdoutDev, logStdout)
import Network.Wai                          (Middleware)
import Control.Monad.Logger                 (runNoLoggingT, runStdoutLoggingT)

data Config = Config 
    { getEnv  :: Environment
    }

data Environment = 
    Development
  | Test
  | Production
  | Heroku
  deriving (Eq, Show, Read)

defaultConfig :: Config
defaultConfig = Config
    { getEnv  = Development
    }

setLogger :: Environment -> Middleware
setLogger Test = id
setLogger Development = logStdoutDev
setLogger _ = logStdout

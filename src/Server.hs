{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies, FlexibleContexts #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Server where

import Control.Applicative          ((<$>))
--import Control.Monad                (mapM,mapM_,(>=>))
import Control.Monad.IO.Class       (MonadIO, liftIO)
import Control.Monad.Trans.Either   (EitherT, left, right, runEitherT, hoistEither)
import Network.Wai                  (Application)
--import Data.Either.Combinators      (rightToMaybe)
--import Data.Maybe                   (fromJust, maybe)

--import Config    (Config(..))
--

import Network.Mail.Client.Gmail
import Network.Mail.Mime            (Address(..))
import qualified Data.Text.Lazy as LT
import qualified Data.Text as T
import Data.Text.Template
import Data.Either.Utils            (maybeToEither)
import qualified Data.Map as M
import Servant
import API
import Templates
import Models

app :: Application
app = serve mailAPI server

server :: Server MailAPI
server = (return $ M.keys templates)
    :<|> (\key -> maybeToEither err404 $ fmap showTemplate $ M.lookup key templates)
    :<|> sendEmail


sendEmail (Mail {..}) = do
    -- get template
    case M.lookup mailTemplate templates of 
        Nothing -> left $ err404
        (Just t) -> do
            case renderA t (context mailTransactionalData) of
                Nothing -> undefined
                (Just body) -> do
                    liftIO $ sendWakuGmail mailTo mailSubject body
                    return ()

            --maybeToEither err404 x

context :: M.Map T.Text T.Text -> ContextA Maybe
context m = (\key -> M.lookup key m)

sendWakuGmail to subject body = sendGmail 
    "wakunet.dev@gmail.com" 
    "wakunet!" 
    (Address (Just "Wakunet") "wakunet.dev@gmail.com") 
    (map ((Address Nothing) . T.pack) to)
    [] 
    [] 
    (T.pack subject)
    body
    [] 
    1000000

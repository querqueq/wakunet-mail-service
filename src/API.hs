{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies, FlexibleContexts #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}

module API where

import Servant.Docs
import Servant
import Models
import Templates
import Data.Text                        (Text)
import qualified Data.ByteString as BS
import qualified Data.Map as M
import Data.Text.Template               (showTemplate)

type SmtpStatusCode = Int
type MailAPI =
        -- | Retrieves all templates names
        "templates" :> Get '[JSON] [TemplateName]
        -- | Returns template body
   :<|> "templates" :> Capture "name" String :> Get '[PlainText] Text
        -- | Sends email
   :<|> "mails" :> ReqBody '[JSON] Mail :> Post '[JSON] ()

mailAPI :: Proxy MailAPI
mailAPI = Proxy

instance ToSample () () where
    toSample _ = Nothing

instance ToCapture (Capture "name" String) where
    toCapture _ = DocCapture "name" "name of template"

instance ToSample Text Text where
    toSample _ = fmap showTemplate $ M.lookup "example" templates

instance ToSample [TemplateName] [TemplateName] where
    toSample _ = Just $ ["invitation","reminder","notification"]

instance ToSample SmtpStatusCode SmtpStatusCode where
    toSamples _ = 
        [ ("Success", 200)
        , ("Service not available", 421)
        ]

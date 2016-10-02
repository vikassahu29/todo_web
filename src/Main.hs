{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty
import Data.Text.Lazy (Text, pack)
import Data.Text.Lazy.Encoding (decodeUtf8)
import DB
import Model
import Data.Aeson ((.=), object)

main :: IO ()
main = scotty 3000 $ do
  get "/hello" $
    json $
      object [ "ok" .= ("hello world" :: String)]

  get "/collections" $ do
    a <- liftAndCatchIO hello
    text $ pack a

  get "/todos" $ json first

  post "/user/register" $ do
    b <- decodeUtf8 <$> body
    text $ b


  post "/todos" $ do
    b <- jsonData
    json (b :: Todo)

  put "/todos/:id" $ do
    text "edit todo"

  delete "/todos/:id" $ do
    text "delete todo"

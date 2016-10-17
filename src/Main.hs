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

  get "/todos" $ do
    a <- liftAndCatchIO $ getC "todos"
    text $ pack a

  post "/user/register" $ do
    b <- decodeUtf8 <$> body
    text $ b

  post "/todos" $ do
    b <- jsonData
    a <- liftAndCatchIO $ insertC (b :: Todo) "todos"
    text "asd"

  delete "/todos/:id" $ do
    a <- param "id"
    c <- liftAndCatchIO $ deleteById a "todos"
    text $ pack a

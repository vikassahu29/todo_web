{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty
import Data.Text.Lazy (Text, pack)
import Data.Text.Lazy.Encoding (decodeUtf8)
import Data.Aeson (ToJSON, FromJSON, toJSON)
import DB
import Model
import Data.Aeson ((.=), object)
import Database.MongoDB (ObjectId)

addCors = do
  addHeader "Access-Control-Allow-Origin" "*"
  addHeader "Access-Control-Allow-Methods" "POST, GET, OPTIONS, DELETE, PUT"
  addHeader "Access-Control-Allow-Headers" "Content-Type"

main :: IO ()
main = scotty 3000 $ do
  get "/hello" $
    json $
      object [ "ok" .= ("hello world" :: String)]

  get "/collections" $ do
    a <- liftAndCatchIO hello
    text $ pack a

  get "/todos" $ do
    addCors
    a <- liftAndCatchIO $ getC "todos"
    json ((map fromDocument a) :: [Todo])

  post "/todos" $ do
    addCors
    b <- jsonData
    a <- liftAndCatchIO $ insertC (b :: Todo) "todos"
    json $ ((fromDocument (updateId a b)) :: Todo)

  options "/todos" $ do
    addCors
    text "[GET, POST, DELETE]"

  options "/todos/:id" $ do
    addCors
    text "[GET, POST, DELETE]"

  put "/todos/:id" $ do
    addCors
    todoId <- param "id"
    b <- jsonData
    a <- liftAndCatchIO $ updateTodo ((read todoId) :: ObjectId) (b :: Todo)
    json $
      object [ "message" .= ("done" :: String)]

  delete "/todos/:id" $ do
    addCors
    a <- param "id"
    c <- liftAndCatchIO $ deleteById ((read a) :: ObjectId) "todos"
    json $
      object [ "message" .= ("done" :: String)]

  post "/users" $ do
    b <- jsonData
    a <- liftAndCatchIO $ insertUser (b :: User)
    json $
      object [ "success" .= fst a, "message" .= snd a]

  post "/users/login" $ do
    b <- jsonData
    a <- liftAndCatchIO $ loginUser (b :: User)
    json $
      object [ "success" .= fst a, "message" .= snd a]

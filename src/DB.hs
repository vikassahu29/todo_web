{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}

module DB where

import Model
import Database.MongoDB
import Control.Monad

hello = do
  pipe <- connect (host "127.0.0.1")
  a <- access pipe master "test" $ insert "todos" ["as" =: "asdasd"]
  return $ show a

insertC :: BSONObj a => a -> Collection -> IO String
insertC obj collection = do
  pipe <- connect (host "127.0.0.1")
  a <- access pipe master "test" $ insert collection $ toDocument obj
  return $ show a

getC :: Collection -> IO String
getC collection = do
  pipe <- connect (host "127.0.0.1")
  b <- access pipe master "test" $ rest =<< find (select [] collection)
  return $ show b

deleteC :: BSONObj a => a -> Collection -> IO String
deleteC obj collection = do
  pipe <- connect (host "127.0.0.1")
  b <- access pipe master "test" $ delete $ select (toDocument obj) collection
  return $ show b

deleteById idVal collection = do
  pipe <- connect (host "127.0.0.1")
  b <- access pipe master "test" $ delete $ select ["_id" =: idVal] collection
  return $ show b

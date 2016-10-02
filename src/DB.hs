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

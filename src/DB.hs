{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}

module DB where

import Model
import Database.MongoDB
import Control.Monad
import Crypto.BCrypt
import Data.Maybe
import Data.ByteString.Char8 (ByteString, pack, unpack)

hello = do
  pipe <- connect (host "127.0.0.1")
  a <- access pipe master "test" $ insert "todos" ["as" =: "asdasd"]
  return $ show a

insertC :: BSONObj a => a -> Collection -> IO String
insertC obj collection = do
  pipe <- connect (host "127.0.0.1")
  a <- access pipe master "test" $ insert collection $ removeId (toDocument obj)
  return $ show a

getC :: Collection -> IO [Document]
getC collection = do
  pipe <- connect (host "127.0.0.1")
  b <- access pipe master "test" $ rest =<< find (select [] collection)
  return b

deleteC :: BSONObj a => a -> Collection -> IO String
deleteC obj collection = do
  pipe <- connect (host "127.0.0.1")
  b <- access pipe master "test" $ delete $ select (toDocument obj) collection
  return $ show b

deleteById :: ObjectId -> Collection -> IO String
deleteById idVal collection = do
  pipe <- connect (host "127.0.0.1")
  b <- access pipe master "test" $ delete $ select ["_id" =: idVal] collection
  return $ show b

updateTodo :: ObjectId -> Todo -> IO String
updateTodo todoId todo = do
  pipe <- connect (host "127.0.0.1")
  b <- access pipe master "test" $ updateAll "todos" [(["_id" =: todoId], removeId $ toDocument todo, [])]
  return $ show todoId

loginUser :: User -> IO (Bool, String)
loginUser user = do
  pipe <- connect (host "127.0.0.1")
  b <- access pipe master "test" $ findOne $ select ["userName" =: (userName user)] "users"
  case b of Nothing -> return (False, "Invalid Username")
            Just userDB -> if passwordCheck (fromDocument userDB) user
                              then return (True, "You are logged in")
                              else return (False, "Invalid Password")

passwordCheck :: User -> User -> Bool
passwordCheck a b = password a == password b

insertUser :: User -> IO (Bool, String)
insertUser user = do
  hUser <- hashPass user
  if isNothing hUser
    then return (False, "Hash Failed")
    else do
      a <- insertC (fromJust hUser) "users"
      return (True, a)

hashPass :: User -> IO (Maybe User)
hashPass User {userId = uId, userName = u, password = p } = do
  hPass <- hashPasswordUsingPolicy fastBcryptHashingPolicy $ pack p
  if isNothing hPass
    then return Nothing
    else return $ Just User { userId = uId, userName = u, password = unpack (fromJust hPass)}


findBySelection selection = do
  pipe <- connect (host "127.0.0.1")
  b <- access pipe master "test" $ rest =<< find selection
  return $ show b

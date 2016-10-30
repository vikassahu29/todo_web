{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Model where

import Data.Aeson (ToJSON, FromJSON, toJSON)
import GHC.Generics (Generic)
import Database.MongoDB
import Data.Text (pack)

class BSONObj a where
  getCollection :: a -> String
  toDocument :: a -> Document
  fromDocument :: Document -> a

getString :: Label -> Document -> String
getString label = typed . (valueAt label)

getInteger :: Label -> Document -> Integer
getInteger label = typed . (valueAt label)

getObjId :: Document -> ObjectId
getObjId = typed . (valueAt "_id")

getBoolean :: Label -> Document -> Bool
getBoolean label = typed . (valueAt label)

data User = User { userId :: Maybe String, userName :: String, password :: String }
  deriving (Show, Generic)

instance ToJSON User
instance FromJSON User
instance BSONObj User where
  getCollection User {userId = _, userName = _, password = _} = "users"
  toDocument User {userId = Nothing, userName = uN, password = pw} =
                                                            ["userName" =: (pack uN), "password" =: (pack pw)]
  toDocument User {userId = Just a, userName = uN, password = pw} =
                                                            ["_id" =: (pack a), "userName" =: (pack uN), "password" =: (pack pw)]
  fromDocument a = User { userId = Just $ show $ getObjId a,
                          userName = getString "userName" a,
                          password = getString "password" a}


data Todo = Todo { todoId :: Maybe String, content :: String, done :: Bool }
                    deriving (Show, Generic)

instance ToJSON Todo
instance FromJSON Todo
instance BSONObj Todo where
  getCollection Todo {todoId = _, content = _, done = _} = "users"
  toDocument Todo {todoId = Nothing, content = content, done = dn} =
    ["content" =: (pack content), "done" =: dn]
  toDocument Todo {todoId = Just a, content = content, done = dn} =
    ["_id" =: (pack a), "content" =: (pack content), "done" =: dn]
  fromDocument a = Todo { todoId = Just $ show $ getObjId a,
                          content = getString "content" a,
                          done = getBoolean "done" a}

removeId document = exclude ["_id"] document

updateId a document = merge ["_id" =: ((read a) :: ObjectId)] $ toDocument document

first :: Todo
first = Todo { todoId = Nothing, content = "asd", done = False }

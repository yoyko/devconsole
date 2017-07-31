module Message.Edit.Model exposing (Model, Msg(..), Id(..), Context, model, context)
import Material

type Id
  = AutoInc
  | None
  | Custom

type alias Model =
  { activeTab : Int
  , id : Id
  , nextAutoId : Int
  , customId : String
  , expandedId : Bool
  , rawMessage : String
  , url : String
  }

model : Model
model =
  { activeTab = 0
  , id = AutoInc
  , nextAutoId = 0
  , customId = ""
  , expandedId = False
  , rawMessage = """{"method":"ping"}"""
  , url = "/stable/av/volume"
  }

type Msg
  = SelectEditTab Int
  | Id Id
  | NextId
  | CustomId String
  | ToggleExpandedId
  | RawMessage String
  | Url String

type alias Context  msg =
  { msgLift : Msg -> msg
  , sendRequest : String -> msg
  , mdlLift : Material.Msg msg -> msg
  , mdl : Material.Model
  }

context
  : (Msg -> msg)
    -> (String -> msg)
    -> (Material.Msg msg -> msg)
    -> Material.Model
    -> Context msg
context msgLift sendRequest mdlLift mdl =
  { msgLift = msgLift, sendRequest = sendRequest, mdlLift =  mdlLift, mdl = mdl }

{- vim: set sw=2 ts=2 sts=2 et : -}

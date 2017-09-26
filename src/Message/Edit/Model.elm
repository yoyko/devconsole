module Message.Edit.Model exposing
  ( Model
  , Msg(..)
  , Id(..)
  , Ctx
  , BrowseType(..)
  , UpdateValueOperation(..)
  , model
  , context
  )
import Material

type Id
  = AutoInc
  | None
  | Custom

type BrowseType
  = Normal
  | Menu
  | Incremental

type UpdateValueOperation
  = Set
  | Adjust
  | Toggle

type alias Model =
  { activeTab : Int
  , id : Id
  , nextAutoId : Int
  , customId : String
  , expandedId : Bool
  , rawMessage : String
  , url : String
  , context : String
  , browseFrom : String
  , browseCount : String
  , browseType : BrowseType
  , updateValueOperation : UpdateValueOperation
  , updateValueValue : String
  , updateValueSteps : String
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
  , context = ""
  , browseFrom = ""
  , browseCount = ""
  , browseType = Normal
  , updateValueOperation = Set
  , updateValueValue = ""
  , updateValueSteps = ""
  }

type Msg
  = SelectEditTab Int
  | Id Id
  | NextId
  | CustomId String
  | ToggleExpandedId
  | RawMessage String
  | Url String
  | Context String
  | BrowseFrom String
  | BrowseCount String
  | BrowseType BrowseType
  | UpdateValueOperation UpdateValueOperation
  | UpdateValueValue String
  | UpdateValueSteps String

type alias Ctx  msg =
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
    -> Ctx msg
context msgLift sendRequest mdlLift mdl =
  { msgLift = msgLift, sendRequest = sendRequest, mdlLift =  mdlLift, mdl = mdl }

{- vim: set sw=2 ts=2 sts=2 et : -}

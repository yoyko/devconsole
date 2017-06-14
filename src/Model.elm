module Model exposing (Model, Message(..), Msg(..), initialModel)

type alias Model =
  { url : String
  , input : String
  , messages : List Message
  }

type Message
  = Sent String
  | Received String

initialModel : Model
initialModel =
  { url = "ws://nuvo.local:8000/apiWs"
  , input = ""
  , messages = []
  }


type Msg
  = Input String
  | SendRequest
  | Response String

{- vim: set sw=2 ts=2 sts=2 et : -}

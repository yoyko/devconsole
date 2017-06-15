module Model exposing (Model, Message(..), Msg(..), initialModel)
import Time

type alias Model =
  { url : String
  , input : String
  , messages : List Message
  , lastTs : Time.Time
  }

type Message
  = Sent Time.Time String
  | Received Time.Time String
  | Opened Time.Time String
  | Closed Time.Time String

initialModel : Model
initialModel =
  { url = "ws://nuvo.local:8000/apiWs"
  , input = ""
  , messages = []
  , lastTs = 0
  }


type Msg
  = Input String
  | SendRequest
  | Response String
  | WsClosed String
  | WsOpened String
  | Timestamp Msg
  | Timestamped Msg Time.Time

{- vim: set sw=2 ts=2 sts=2 et : -}

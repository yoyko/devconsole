module Connection exposing (Model, model, Message(..), Msg(..), send, update, subscriptions)
import WebSocket
import Time
import Task

type alias Model =
  { id : String
  , url : String
  , messages : List Message
  , lastTs : Time.Time
  }

model : String -> Model
model id =
  { id = id
  , url = "ws://nuvo.local:8000/apiWs" ++ "?" ++ id
  , messages = []
  , lastTs = 0
  }

type Message
  = Sent Time.Time String
  | Received Time.Time String
  | Opened Time.Time String
  | Closed Time.Time String

type Msg
  = Send String
  | Response String
  | WsClosed String
  | WsOpened String
  | Timestamp Msg
  | Timestamped Msg Time.Time

send : (Msg -> m) -> Model -> String -> (Model, Cmd m)
send lift model msg =
  (model, Task.perform (lift << Timestamped (Send msg)) Time.now)

update : (Msg -> m) -> Msg -> Model -> (Model, Cmd m)
update lift msg model =
  let
    addMessage msg = { model | messages = model.messages ++ [ msg ] }
    onlyAddMessage msg = ( addMessage msg, Cmd.none )
  in
    case msg of
      Send msg_ ->
        ( addMessage <| Sent model.lastTs msg_
        , WebSocket.send model.url msg_
        )
      Response msg_ -> onlyAddMessage <| Received model.lastTs msg_
      WsOpened ws   -> onlyAddMessage <| Opened   model.lastTs ws
      WsClosed ws   -> onlyAddMessage <| Closed   model.lastTs ws
      Timestamp msg_ -> (model, Task.perform (lift << Timestamped msg_) Time.now)
      Timestamped msg_ ts -> update lift msg_ { model  | lastTs = ts }

subscriptions : (Msg -> m) -> Model -> Sub m
subscriptions lift model =
  Sub.batch
    [ WebSocket.listen model.url  (lift << Timestamp << Response)
    , WebSocket.onOpen  (lift << Timestamp << WsOpened)
    , WebSocket.onClose (lift << Timestamp << WsClosed)
    ]

{- vim: set sw=2 ts=2 sts=2 et : -}

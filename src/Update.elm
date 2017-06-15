module Update exposing (update)
import Model exposing (Model, Msg(..), Message(..))
import WebSocket
import Time
import Task

addMessage : Model -> Message -> Model
addMessage model msg =
  { model | messages = model.messages ++ [ msg ] }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let
    onlyAddMessage msg = ( addMessage model msg, Cmd.none )
  in
    case msg of
      Input newInput -> ( { model | input = newInput }, Cmd.none )
      SendRequest ->
        ( addMessage model <| Sent model.lastTs model.input
        , WebSocket.send model.url model.input
        )
      Response message -> onlyAddMessage <| Received model.lastTs message
      Timestamp msg_ -> (model, Task.perform (Timestamped msg_) Time.now)
      Timestamped msg_ ts -> update msg_ { model | lastTs = ts }

{- vim: set sw=2 ts=2 sts=2 et : -}

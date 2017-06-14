module Update exposing (update)
import Model exposing (Model, Msg(..), Message(..))
import WebSocket

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Input newInput -> ( { model | input = newInput }, Cmd.none )
    SendRequest ->
      ( { model | input = "", messages = model.messages ++ [ Sent model.input ] }
      , WebSocket.send model.url model.input
      )
    Response message -> ( { model | messages = model.messages ++ [ Received message ] }, Cmd.none )

{- vim: set sw=2 ts=2 sts=2 et : -}

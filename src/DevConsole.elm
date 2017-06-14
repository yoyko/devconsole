module DevConsole exposing (..)
import Html exposing (h1, text)
import Model exposing (Model, Msg(..))
import Update
import View
import WebSocket

main =
  Html.program
    { init = init
    , update = Update.update
    , view = View.view
    , subscriptions = subscriptions
    }

init : ( Model, Cmd Msg )
init =
  ( Model.initialModel, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen model.url Response



{- vim: set sw=2 ts=2 sts=2 et : -}

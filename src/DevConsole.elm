module DevConsole exposing (..)
import Html exposing (h1, text)
import Model exposing (Model, Msg(..))
import Connection
import Update
import View

main : Program Never Model Msg
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
  Connection.subscriptions Conn model.connection

{- vim: set sw=2 ts=2 sts=2 et : -}

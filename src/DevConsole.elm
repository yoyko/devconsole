module DevConsole exposing (..)
import Html exposing (h1, text)
import Model exposing (Model, Msg(..))
import Connection
import Update
import View
import Material

main : Program Never Model Msg
main =
  Html.program
    { init = Model.init
    , update = Update.update
    , view = View.view
    , subscriptions = subscriptions
    }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Connection.subscriptions Conn model.connection
    , Material.subscriptions Mdl model
    ]

{- vim: set sw=2 ts=2 sts=2 et : -}

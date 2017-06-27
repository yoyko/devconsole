module Update exposing (update)
import Model exposing (Model, Msg(..))
import Connection
import Material


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Input newInput -> ( { model | input = newInput }, Cmd.none )
    SendRequest ->
      Model.applyConnection model <| Connection.send Conn model.connection model.input
    Conn msg_ ->
      Model.applyConnection model <| Connection.update Conn msg_ model.connection
    Mdl msg_ ->
      Material.update Mdl msg_ model

{- vim: set sw=2 ts=2 sts=2 et : -}

module Update exposing (update)
import Model exposing (Model, Msg(..))
import Connection
import Material
import Message.Edit as Edit
import Platform.Cmd
import Delegate exposing (delegate)

connection = Delegate.create .connection (\c r -> { r | connection = c })
edit = Delegate.create .edit (\e r -> { r | edit = e })

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Mdl msg_ ->
      Material.update Mdl msg_ model
    Conn msg_ ->
      Connection.update Conn msg_
      |> delegate connection model
    SendRequest message ->
      let
        (cm, cc) = Connection.send Conn model.connection message
        (em, ec) = Edit.update Edit.NextId model.edit
      in
        ({ model | connection = cm, edit = em }, Cmd.batch [cc, ec])
    Edit msg_ ->
      Edit.update msg_
      |> delegate edit model

{- vim: set sw=2 ts=2 sts=2 et : -}

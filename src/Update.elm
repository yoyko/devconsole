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
      (flip (Connection.send Conn)) message
      |> delegate connection model
    Edit msg_ ->
      Edit.update Edit msg_ (Model.context model)
      |> delegate edit model

{- vim: set sw=2 ts=2 sts=2 et : -}

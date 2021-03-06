module Update exposing (update)
import Model exposing (Model, Msg(..))
import Connection
import Material
import Message.Edit as Edit
import Message.Edit.Model as EditModel
import Platform.Cmd
import Dom.Scroll
import Task
import Delegate exposing (delegate)

connection = Delegate.create .connection (\c r -> { r | connection = c })
edit = Delegate.create .edit (\e r -> { r | edit = e })

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Mdl msg_ ->
      Material.update Mdl msg_ model
    Conn msg_ ->
      let
        (cm, ccmd) = Connection.update Conn msg_ model.connection
      in
        ({ model | connection = cm }
        , Cmd.batch
            [ccmd
            , Dom.Scroll.toBottom "messages"
                |> Task.attempt (\r -> NoOp)
            ]
        )
    SendRequest message ->
      let
        (cm, cc) = Connection.send Conn model.connection message
        (em, ec) = Edit.update EditModel.NextId model.edit
      in
        ({ model | connection = cm, edit = em }, Cmd.batch [cc, ec])
    Edit msg_ ->
      Edit.update msg_
      |> delegate edit model
    NoOp -> (model, Cmd.none)

{- vim: set sw=2 ts=2 sts=2 et : -}

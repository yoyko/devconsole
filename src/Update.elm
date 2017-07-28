module Update exposing (update)
import Model exposing (Model, Msg(..))
import Connection
import Material
import Message.Edit as Edit
import Platform.Cmd


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Mdl msg_ ->
      Material.update Mdl msg_ model
    Conn msg_ ->
      Connection.update Conn msg_ model.connection
      |> Model.applyConnection model
    SendRequest message ->
      Connection.send Conn model.connection message
      |> Model.applyConnection model
    Edit msg_ ->
      Edit.update Edit msg_ model.edit (Model.context model)
      |> Tuple.mapFirst (\m -> { model | edit =  m })


{- vim: set sw=2 ts=2 sts=2 et : -}

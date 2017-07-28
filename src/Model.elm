module Model exposing (Model, Msg(..), init, initialModel, initialCmd, applyConnection, context)
import Context
import Connection
import Material
import Message.Edit as Edit


type alias Model =
  { connection : Connection.Model
  , mdl : Material.Model
  , edit : Edit.Model
  }

apply : (m -> Model) -> (m, Cmd msg) -> (Model, Cmd msg)
apply setter =
  Tuple.mapFirst setter

applyConnection : Model -> (Connection.Model, Cmd msg) -> (Model, Cmd msg)
applyConnection model =
  apply (\m -> { model | connection = m})

initialModel : Model
initialModel =
  { connection = Connection.model "main"
  , mdl = Material.model
  , edit = Edit.model
  }

initialCmd : Cmd Msg
initialCmd =
  Material.init Mdl

init : ( Model, Cmd Msg )
init =
  ( initialModel, initialCmd )

context : Model -> Context.Context Msg
context model =
  { mdl = model.mdl, mdlLift = Mdl }


type Msg
  = Conn Connection.Msg
  | Mdl (Material.Msg Msg)
  | SendRequest String
  | Edit Edit.Msg

{- vim: set sw=2 ts=2 sts=2 et : -}

module Model exposing (Model,  Msg(..), init, initialModel, initialCmd, applyConnection)
import Connection
import Material

type alias Model =
  { connection : Connection.Model
  , input : String
  , mdl : Material.Model
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
  , input = """{"method":"ping"}"""
  , mdl = Material.model
  }

initialCmd : Cmd Msg
initialCmd =
  Material.init Mdl

init : ( Model, Cmd Msg )
init =
  ( initialModel, initialCmd )


type Msg
  = Input String
  | SendRequest
  | Conn Connection.Msg
  | Mdl (Material.Msg Msg)

{- vim: set sw=2 ts=2 sts=2 et : -}

module Model exposing (Model, Msg(..), init, initialModel, initialCmd)
import Connection
import Material
import Message.Edit.Model as Edit


type alias Model =
  { connection : Connection.Model
  , mdl : Material.Model
  , edit : Edit.Model
  }

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


type Msg
  = Conn Connection.Msg
  | Mdl (Material.Msg Msg)
  | SendRequest String
  | Edit Edit.Msg

{- vim: set sw=2 ts=2 sts=2 et : -}

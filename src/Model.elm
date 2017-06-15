module Model exposing (Model,  Msg(..), initialModel, applyConnection)
import Connection

type alias Model =
  { connection : Connection.Model
  , input : String
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
  }

type Msg
  = Input String
  | SendRequest
  | Conn Connection.Msg

{- vim: set sw=2 ts=2 sts=2 et : -}

module Message.Edit exposing (Model, Msg(..), model, update, view)
import Html exposing (Html, div, text, input, button)
import Html.Attributes exposing (defaultValue, class)
import Html.Events exposing (onInput, onClick)
import Context exposing (Context)

type alias Model =
  { input : String
  }

model : Model
model =
  { input = """{"method":"ping"}"""
  }


type Msg
  = Input String

update : (Msg -> msg) -> Msg -> Model -> Context msg -> (Model, Cmd msg)
update lift msg model ctx =
  case msg of
    Input newInput -> ( { model | input = newInput }, Cmd.none )

view : (Msg -> msg) -> (String -> msg) -> Model -> Context msg -> Html msg
view msgLift sendRequest model ctx =
  div
    [ class "messageEdit" ]
    [ input [ onInput (msgLift << Input), defaultValue model.input ] []
    , button [ onClick (sendRequest (messageToSend model)) ] [ text "Send" ]
    ]

messageToSend : Model -> String
messageToSend = .input

{- vim: set sw=2 ts=2 sts=2 et : -}

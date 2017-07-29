module Message.Edit exposing (Model, Msg(..), model, context, update, view)
import Html exposing (Html, div, text, input, button)
import Html.Attributes exposing (defaultValue, class)
import Html.Events exposing (onInput, onClick)
import Material

type alias Model =
  { input : String
  }

model : Model
model =
  { input = """{"method":"ping"}"""
  }

type Msg
  = Input String

type alias Context  msg =
  { msgLift : Msg -> msg
  , sendRequest : String -> msg
  , mdlLift : Material.Msg msg -> msg
  , mdl : Material.Model
  }

context
  : (Msg -> msg)
    -> (String -> msg)
    -> (Material.Msg msg -> msg)
    -> Material.Model
    -> Context msg
context msgLift sendRequest mdlLift mdl =
  { msgLift = msgLift, sendRequest = sendRequest, mdlLift =  mdlLift, mdl = mdl }

update : Msg -> Model -> (Model, Cmd msg)
update msg model =
  case msg of
    Input newInput -> ( { model | input = newInput }, Cmd.none )

view : Context msg -> Model -> Html msg
view ctx model =
  div
    [ class "messageEdit" ]
    [ input [ onInput (ctx.msgLift << Input), defaultValue model.input ] []
    , button [ onClick (ctx.sendRequest (messageToSend model)) ] [ text "Send" ]
    ]

messageToSend : Model -> String
messageToSend = .input

{- vim: set sw=2 ts=2 sts=2 et : -}

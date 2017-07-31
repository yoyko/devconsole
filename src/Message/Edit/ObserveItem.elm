module Message.Edit.ObserveItem exposing (observeItemEdit, observeItemResult)
import Message.Edit.Model exposing (Model, Msg(..), Context)
import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Message.Edit.Parts as Parts
import Json.Encode

observeItemEdit : Context msg -> (Context msg -> Model -> Html msg) -> Model -> Html msg
observeItemEdit ctx send model =
  div
    [ class "observeEdit" ]
    [ Parts.url ctx [2, 2] model
    , send ctx model
    ]

observeItemResult : Model -> Result String Json.Encode.Value
observeItemResult model =
  Ok <| Json.Encode.object
    [ ("url", Json.Encode.string model.url)
    , ("method", Json.Encode.string "observeItem")
    ]

{- vim: set sw=2 ts=2 sts=2 et : -}

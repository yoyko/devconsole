module Message.Edit.ObserveItem exposing (observeItemEdit, observeItemResult)
import Message.Edit.Model exposing (Model, Msg(..), Ctx)
import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Message.Edit.Parts as Parts
import Json.Encode
import Json.Decode
import Json.Encode.Maybe exposing (maybeObject)

observeItemEdit : Ctx msg -> (Ctx msg -> Model -> Html msg) -> Model -> Html msg
observeItemEdit ctx send model =
  div
    [ class "observeEdit" ]
    [ Parts.twoLine
        [ Parts.url ctx [2, 2, 1] model ]
        [ Parts.context ctx [2, 2, 2] model ]
    , send ctx model
    ]

observeItemResult : Model -> Result String Json.Encode.Value
observeItemResult model =
  Result.fromMaybe "Bad arguments"
    <| maybeObject
      [ ("params", maybeObject
            [ ("context"
              , model.context |> Json.Decode.decodeString Json.Decode.value |> Result.toMaybe
              )
            ]
        )
      , ("url", Just <| Json.Encode.string model.url)
      , ("method", Just <| Json.Encode.string "observeItem")
      ]

{- vim: set sw=2 ts=2 sts=2 et : -}

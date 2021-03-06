module Message.Edit.Invoke exposing (invokeEdit, invokeResult)
import Message.Edit.Model exposing (Model, Msg(..), Ctx)
import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Message.Edit.Parts as Parts
import Json.Encode
import Json.Decode
import Json.Encode.Maybe exposing (maybeObject,maybeStringValue)

invokeEdit : Ctx msg -> (Ctx msg -> Model -> Html msg) -> Model -> Html msg
invokeEdit ctx send model =
  div
    [ class "invokeEdit" ]
    [ Parts.twoLine
        [ Parts.url ctx [2, 4, 1] model ]
        [ Parts.context ctx [2, 4, 2] model ]
    , send ctx model
    ]

invokeResult : Model -> Result String Json.Encode.Value
invokeResult model =
  Result.fromMaybe "Bad arguments"
    <| maybeObject
      [ ("params", maybeObject
            [ ("context", maybeStringValue model.context)
            ]
        )
      , ("url", Just <| Json.Encode.string model.url)
      , ("method", Just <| Json.Encode.string "invoke")
      ]

{- vim: set sw=2 ts=2 sts=2 et : -}

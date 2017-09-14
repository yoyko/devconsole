module Message.Edit.Raw exposing (rawEdit, rawResult)
import Message.Edit.Model exposing (Model, Msg(..), Ctx)
import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Message.Edit.Parts as Parts exposing (textfield)
import Material.Options as Options
import Material.Textfield as Textfield
import Json.Encode
import Json.Decode

rawEdit : Ctx msg -> (Ctx msg -> Model -> Html msg) -> Model -> Html msg
rawEdit ctx send model =
  div
    [ class "rawEdit" ]
    [ textfield ctx [2, 1] "Message" model.rawMessage RawMessage
        [ Textfield.autofocus
        , Parts.validateJson model.rawMessage
        ]
    , send ctx model
    ]

rawResult : Model -> Result String Json.Encode.Value
rawResult =
  .rawMessage >> Json.Decode.decodeString Json.Decode.value

{- vim: set sw=2 ts=2 sts=2 et : -}

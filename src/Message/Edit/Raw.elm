module Message.Edit.Raw exposing (rawEdit, rawResult)
import Message.Edit.Model exposing (Model, Msg(..), Context)
import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Message.Edit.Parts as Parts exposing (textfield)
import Material.Options as Options
import Material.Textfield as Textfield
import Json.Encode
import Json.Decode

rawEdit : Context msg -> (Context msg -> Model -> Html msg) -> Model -> Html msg
rawEdit ctx send model =
  div
    [ class "rawEdit" ]
    [ textfield ctx [2, 1] "Message" model.rawMessage RawMessage
        [ Textfield.autofocus
        , Textfield.error "Invalid JSON"
            |> Options.when (not <| validJsonString model.rawMessage)
        ]
    , send ctx model
    ]

rawResult : Model -> Result String Json.Encode.Value
rawResult =
  .rawMessage >> Json.Decode.decodeString Json.Decode.value

{- We really check for a valid json object, not just any json value. -}
validJsonString : String -> Bool
validJsonString str =
  Json.Decode.decodeString (Json.Decode.keyValuePairs Json.Decode.value) str
  |> Result.map (always True)
  |> Result.withDefault False

{- vim: set sw=2 ts=2 sts=2 et : -}

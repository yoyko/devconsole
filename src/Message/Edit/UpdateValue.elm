module Message.Edit.UpdateValue exposing (updateValueEdit, updateValueResult)
import Message.Edit.Model exposing (Model, Msg(..), Ctx, UpdateValueOperation(..))
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Message.Edit.Parts as Parts exposing (textfield, validateInt)
import Material.Textfield as Textfield
import Material.Select as Select
import Material.Options as Options
import Material.Dropdown.Item as Item
import Json.Encode
import Json.Decode
import Json.Encode.Maybe exposing (maybeObject,maybeStringValue, maybeStringInt)

updateValueEdit : Ctx msg -> (Ctx msg -> Model -> Html msg) -> Model -> Html msg
updateValueEdit ctx send model =
  div
    [ class "updateValueEdit" ]
    [ Parts.twoLine
        [ Parts.url ctx [2, 5, 1] model
        , operationSelect ctx [2, 5, 3] model
        ]
        [ Parts.context ctx [2, 5, 2] model
        , paramEdit ctx [ 2, 5, 4 ] model
        ]
    , send ctx model
    ]

updateValueResult : Model -> Result String Json.Encode.Value
updateValueResult model =
  Result.fromMaybe "Bad arguments"
    <| maybeObject
      [ ("params", maybeObject
            [ ("context", maybeStringValue model.context)
            , ("operation"
              , model.updateValueOperation
                  |> operationValue |> Maybe.map Json.Encode.string
              )
            , updateValueParam model
            ]
        )
      , ("url", Just <| Json.Encode.string model.url)
      , ("method", Just <| Json.Encode.string "updateValue")
      ]

updateValueParam model =
  case model.updateValueOperation of
    Set -> ("value", maybeStringValue model.updateValueValue)
    Adjust -> ("steps", maybeStringInt model.updateValueSteps)
    Toggle -> ("", Nothing)

operationSelect ctx index model =
  Select.render ctx.mdlLift index ctx.mdl
    [ Options.cs "operation"
    , Select.label "operation"
    , Select.floatingLabel
    , Select.over
    , Select.value <| operationCaption model.updateValueOperation
    ]
    ( showOperations
      |> List.map (\o ->
          Select.item
            [ Item.onSelect (ctx.msgLift <| UpdateValueOperation o) ]
            [ text <| operationCaption o ]
        )
    )

paramEdit ctx index model =
  case model.updateValueOperation of
    Set ->
      textfield ctx index "Value" model.updateValueValue UpdateValueValue
        [ Textfield.autofocus
        , Parts.validateJson model.updateValueValue
        ]
    Adjust ->
      textfield ctx index "Steps" model.updateValueSteps UpdateValueSteps
        [ validateInt model.updateValueSteps ]
    Toggle -> text ""

showOperations = [ Set, Adjust, Toggle ]

operationCaption t =
  case t of
    Set ->    "Set"
    Adjust -> "Adjust"
    Toggle -> "Toggle"

operationValue t =
  case t of
    Set ->    Nothing
    Adjust -> Just "adjust"
    Toggle -> Just "toggle"

{- vim: set sw=2 ts=2 sts=2 et : -}

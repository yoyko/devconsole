module Message.Edit.Browse exposing (browseEdit, browseResult)
import Message.Edit.Model exposing (Model, Msg(..), Ctx, BrowseType(..))
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Message.Edit.Parts as Parts exposing (textfield)
import Material.Options as Options
import Material.Textfield as Textfield
import Material.Select as Select
import Material.Dropdown.Item as Item
import Json.Encode
import Result.Extra

browseEdit : Ctx msg -> (Ctx msg -> Model -> Html msg) -> Model -> Html msg
browseEdit ctx send model =
  let
    isValidInt str =
      (str |> String.toInt |> Result.Extra.isOk) || (String.isEmpty str)
    validateInt str =
      Textfield.error "Number!"
        |> Options.when (not <| isValidInt str)
  in
    div
      [ class "browseEdit" ]
      [ Parts.url ctx [2, 3, 0] model
      , textfield ctx [2, 3, 1] "from" model.browseFrom BrowseFrom
          [ validateInt model.browseFrom ]
      , textfield ctx [2, 3, 2] "count" model.browseCount BrowseCount
          [ validateInt model.browseCount ]
      , Select.render ctx.mdlLift [2, 3, 3] ctx.mdl
          [ Options.cs "type"
          , Select.label "type"
          , Select.floatingLabel
          , Select.over
          , Select.value <| browseTypeCaption model.browseType
          ]
          ( showBrowseTypes
            |> List.map (\bt ->
                Select.item
                  [ Item.onSelect (ctx.msgLift <| BrowseType bt) ]
                  [ text <| browseTypeCaption bt ]
              )
          )
      , send ctx model
      ]

browseResult : Model -> Result String Json.Encode.Value
browseResult model =
  let
    maybeJsonInt = String.toInt >> Result.toMaybe >> Maybe.map Json.Encode.int
  in
    Ok <| Json.Encode.object
      [ ("params", Json.Encode.object
          <| List.filterMap
            (\(k, mv) -> Maybe.map ((,) k) mv)
            [ ("from", model.browseFrom |> maybeJsonInt)
            , ("count", model.browseCount |> maybeJsonInt)
            , ("type", model.browseType |> browseTypeValue |> Maybe.map Json.Encode.string)
            ]
        )
      , ("url", Json.Encode.string model.url)
      , ("method", Json.Encode.string "browse")
      ]

showBrowseTypes = [ Normal, Incremental, Menu ]

browseTypeCaption t =
  case t of
    Normal ->      "Normal"
    Incremental -> "Incremental"
    Menu ->        "Menu"

browseTypeValue t =
  case t of
    Normal ->      Nothing
    Incremental -> Just "incremental"
    Menu ->        Just "menu"

{- vim: set sw=2 ts=2 sts=2 et : -}

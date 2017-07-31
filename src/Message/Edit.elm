module Message.Edit exposing (update, view)
import Message.Edit.Model exposing (Model, Msg(..), Id(..), Context, model, context)
import Message.Edit.Raw exposing (rawEdit, rawResult)
import Message.Edit.ObserveItem exposing (observeItemEdit, observeItemResult)
import Html exposing (Html, div, text, input)
import Html.Attributes exposing (class, classList, type_, placeholder, value)
import Html.Events exposing (onInput, onClick)
import Material.Icon as Icon
import Material.Options as Options
import Material.Tabs as Tabs
import Material.Button as Button
import Material.Toggles as Toggles
import Json.Encode
import Json.Decode

update : Msg -> Model -> (Model, Cmd msg)
update msg model =
  let
    m =
      case msg of
        SelectEditTab idx -> { model | activeTab = idx }
        Id id             -> { model | id = id }
        NextId            -> { model | nextAutoId = model.nextAutoId + 1 }
        CustomId id       -> { model | customId= id }
        ToggleExpandedId  -> { model | expandedId = not model.expandedId }
        RawMessage m      -> { model | rawMessage = m }
        Url url           -> { model | url = url }
  in
    ( m, Cmd.none )

view : Context msg -> Model -> Html msg
view ctx model =
  let
    tabLabel t =
      Tabs.label
        [ Options.center ]
        (tabLabelText t)
  in
    Tabs.render ctx.mdlLift [2] ctx.mdl
      [ Tabs.activeTab model.activeTab
      , Tabs.onSelectTab (ctx.msgLift << SelectEditTab)
      , Options.cs "messageEdit"
      ]
      ( List.map tabLabel showTabs )
      [ tabContent (tabAtIndex model.activeTab) ctx sendWithId model
      ]

type EditTab
  = ObserveItem
  | Raw

showTabs : List EditTab
showTabs = [ ObserveItem, Raw ]

tabAtIndex : Int -> EditTab
tabAtIndex i =
  showTabs
  |> List.drop i
  |> List.head
  |> Maybe.withDefault Raw

activeTab : Model -> EditTab
activeTab =
  .activeTab >> tabAtIndex

tabLabelText : EditTab -> List (Html msg)
tabLabelText tab =
  case tab of
    ObserveItem -> [ Icon.i "info_outline", text "observeItem" ]
    Raw         -> [ Icon.i "code", text "Raw" ]

tabContent tab =
  case tab of
    ObserveItem -> observeItemEdit
    Raw         -> rawEdit

tabEditResult : EditTab -> Model -> Result String Json.Encode.Value
tabEditResult tab=
  case tab of
    ObserveItem -> observeItemResult
    Raw -> rawResult

sendWithId : Context msg -> Model -> Html msg
sendWithId ctx model =
  div
    [ class "sendWithId" ]
    <| List.filterMap identity
        [ if model.expandedId
            then Just <| idSelect ctx model
            else Nothing
        , Just <| sendButton ctx model
        ]

sendButton : Context msg -> Model -> Html msg
sendButton ctx model =
    div
      [ class "send" ]
      [ div
          [ classList
              [ ("idpreview", True)
              , ("expanded", model.expandedId)
              ]
          , onClick (ctx.msgLift ToggleExpandedId)
          ]
          [ text <| "Id: " ++ (id model |> Maybe.withDefault "-")
          ]
      , Button.render ctx.mdlLift [2, 0] ctx.mdl
          [ Button.raised
          , Button.ripple
          , Options.onClick (ctx.sendRequest <| messageToSend model)
          ]
          [ text "Send", Icon.i "send" ]
      ]

idSelect : Context msg -> Model -> Html msg
idSelect ctx model =
  div
    [ class "idSelect"
    ]
    [ div
        [ class "autonone"]
        [ Toggles.radio ctx.mdlLift [2, 0, 1] ctx.mdl
            [ Toggles.group "idSelect"
            , Toggles.ripple
            , Toggles.value (model.id == AutoInc)
            , Options.onToggle <| ctx.msgLift <| Id AutoInc
            ]
            [ text <| "Auto (" ++ (toString model.nextAutoId) ++ ")" ]
        , Toggles.radio ctx.mdlLift [2, 0, 2] ctx.mdl
            [ Toggles.group "idSelect"
            , Toggles.ripple
            , Toggles.value (model.id == None)
            , Options.onToggle <| ctx.msgLift <| Id None
            ]
            [ text "None" ]
        ]
    , Toggles.radio ctx.mdlLift [2, 0, 3] ctx.mdl
        [ Toggles.group "idSelect"
        , Toggles.ripple
        , Toggles.value (model.id == Custom)
        , Options.onToggle <| ctx.msgLift <| Id <| Custom
        ]
        [ input
            [ class ".mdl-textfield__input"
            , type_ "text"
            , placeholder "Custom"
            , value model.customId
            , onInput (ctx.msgLift << CustomId)
            ]
            []
        ]
    ]

id : Model -> Maybe String
id model =
  case model.id of
    AutoInc -> Just <| toString model.nextAutoId
    None -> Nothing
    Custom -> Just model.customId

idValue : Model -> Maybe ( String, Json.Encode.Value)
idValue model =
  model
  |> id
  |> Maybe.map Json.Encode.string
  |> Maybe.map ((,) "id")

{-
  If the edit result is not a corret object, but we are on the raw edit, send
  the original string anyway (if that's what the user wants...)
  Otherwise we "deconstruct" json object into key/value pairs, prepend the id
  and reconstruct the object (and encode it to string).  If the origin object
  included an id (such as one typed into raw edit) it will prevail.
-}
messageToSend : Model -> String
messageToSend model =
  let
    keyValues =
      tabEditResult (tabAtIndex model.activeTab) model
      |> Result.andThen (Json.Decode.decodeValue (Json.Decode.keyValuePairs Json.Decode.value))
  in
    case (activeTab model, keyValues) of
      (Raw, Err e) -> model.rawMessage
      _ ->
        keyValues
        |> Result.withDefault []
        |> (++) (List.filterMap identity [ idValue model ])
        |> Json.Encode.object
        |> Json.Encode.encode 0

{- vim: set sw=2 ts=2 sts=2 et : -}

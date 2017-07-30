module Message.Edit exposing (Model, Msg(..), model, context, update, view)
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Material
import Material.Icon as Icon
import Material.Options as Options
import Material.Tabs as Tabs
import Material.Textfield as Textfield
import Material.Button as Button
import Json.Encode
import Json.Decode

type alias Model =
  { activeTab : Int
  , rawMessage : String
  , url : String
  }

model : Model
model =
  { activeTab = 0
  , rawMessage = """{"method":"ping"}"""
  , url = "/stable/av/volume"
  }

type Msg
  = SelectEditTab Int
  | RawMessage String
  | Url String

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
  let
    m =
      case msg of
        SelectEditTab idx -> { model | activeTab = idx }
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
        ( case t of
          Raw -> [ Icon.i "code", text "Raw" ]
          Observe -> [ Icon.i "info_outline", text "observeItem" ]
        )
  in
    Tabs.render ctx.mdlLift [2] ctx.mdl
      [ Tabs.activeTab model.activeTab
      , Tabs.onSelectTab (ctx.msgLift << SelectEditTab)
      , Options.cs "messageEdit"
      ]
      ( List.map tabLabel showTabs )
      [ case tabAtIndex model.activeTab of
          Raw -> rawEdit ctx model
          Observe -> observeEdit ctx model
      ]

type EditTab
  = Raw
  | Observe

showTabs : List EditTab
showTabs = [ Raw, Observe ]

tabAtIndex : Int -> EditTab
tabAtIndex i =
  showTabs
  |> List.drop i
  |> List.head
  |> Maybe.withDefault Raw

activeTab : Model -> EditTab
activeTab =
  .activeTab >> tabAtIndex

rawEdit : Context msg -> Model -> Html msg
rawEdit ctx model =
  div
    [ class "rawEdit" ]
    [ Textfield.render ctx.mdlLift [2, 1] ctx.mdl
        [ Options.cs "message"
        , Textfield.label "Message"
        , Textfield.floatingLabel
        , Textfield.autofocus
        , Textfield.value model.rawMessage
        , Options.onInput (ctx.msgLift << RawMessage)
        , Textfield.error "Invalid JSON"
            |> Options.when (not <| validJsonString model.rawMessage)
        ]
        []
    , sendButton ctx model
    ]

rawResult : Model -> Result String Json.Encode.Value
rawResult =
  .rawMessage >> Json.Decode.decodeString Json.Decode.value

observeEdit : Context msg -> Model -> Html msg
observeEdit ctx model =
  div
    [ class "observeEdit" ]
    [ Textfield.render ctx.mdlLift [2, 2] ctx.mdl
        [ Options.cs "url"
        , Textfield.label "Url"
        , Textfield.floatingLabel
        , Textfield.autofocus
        , Textfield.value model.url
        , Options.onInput (ctx.msgLift << Url)
        ]
        []
    , sendButton ctx model
    ]

observeResult : Model -> Result String Json.Encode.Value
observeResult model =
  Ok <| Json.Encode.object
    [ ("method", Json.Encode.string "observeItem")
    , ("url", Json.Encode.string model.url)
    ]


sendButton : Context msg -> Model -> Html msg
sendButton ctx model =
  Button.render ctx.mdlLift [2, 0] ctx.mdl
    [ Button.raised
    , Button.ripple
    , Options.onClick (ctx.sendRequest <| messageToSend model)
    ]
    [ text "Send", Icon.i "send" ]


editResult : Model -> Result String Json.Encode.Value
editResult model =
  case activeTab model of
    Raw -> rawResult model
    Observe -> observeResult model

{-
  If the edit result is not a corret object, but we are on the raw edit, send
  the original string anyway (if that's what the user wants...)
  Otherwise we "deconstruct" json object into key/value pairs, and reconstruct
  it again as a preparation for inserting an id later ;)
-}
messageToSend : Model -> String
messageToSend model =
  let
    keyValues =
      editResult model
      |> Result.andThen (Json.Decode.decodeValue (Json.Decode.keyValuePairs Json.Decode.value))
  in
    case (activeTab model, keyValues) of
      (Raw, Err e) -> model.rawMessage
      _ ->
        keyValues
        |> Result.withDefault []
        |> Json.Encode.object
        |> Json.Encode.encode 0

{- We really check for a valid json object, not just any json value. -}
validJsonString : String -> Bool
validJsonString str =
  Json.Decode.decodeString (Json.Decode.keyValuePairs Json.Decode.value) str
  |> Result.map (always True)
  |> Result.withDefault False

{- vim: set sw=2 ts=2 sts=2 et : -}

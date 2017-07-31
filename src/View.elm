module View exposing (view)
import Model exposing (Model, Msg(..))
import Connection exposing (Message(..))
import Html exposing (Html, div, h1, text, input, button)
import Html.Attributes exposing (defaultValue, class, style)
import Html.Events exposing (onInput, onClick)
import Material.Layout as Layout
import Time
import Date
import Date.Extra.Format
import Date.Extra.Config.Configs
import Message.Edit
import Message.Edit.Model

view : Model -> Html Msg
view model =
  Layout.render Mdl model.mdl
    [
    ]
    { header = header model
    , drawer = []
    , tabs = ( [], [] )
    , main = [ consoleView model ]
    }

header : Model -> List (Html Msg)
header model =
  [ Layout.row
    []
    [ Layout.title [] [ text "DevConsole" ]
    , Layout.spacer
    , text model.connection.url
    ]
  ]

consoleView : Model -> Html Msg
consoleView model =
  div
    [ class "console" ]
    [ messages model.connection.messages
    , Message.Edit.view (editContext model) model.edit
    ]

editContext model =
  Message.Edit.Model.context Edit SendRequest Mdl model.mdl

messages : List Message -> Html Msg
messages msgs =
  div [ class "messages" ]
    ( List.map message msgs
    )

formatTs : Time.Time -> String
formatTs =
  Date.fromTime
  >> Date.Extra.Format.format (Date.Extra.Config.Configs.getConfig "en_US") "%H:%M:%S"

message : Message -> Html Msg
message msg =
  let
    o =
      case msg of
        Sent ts m -> { cls = "outgoing", text =  (formatTs ts) ++ ": "++ m }
        Received ts m -> {- TODO parse of course ;) -}
          { cls = if String.contains """"error":""" m then "error" else "incomming"
          , text = (formatTs ts) ++ ": " ++ m
          }
        Opened ts ws -> { cls = "incomming", text = (formatTs ts) ++ ": Opened " ++ ws}
        Closed ts ws -> { cls = "error", text = (formatTs ts) ++ ": Closed " ++ ws}
  in
    div
      [ class o.cls
      ]
      [ text o.text
      ]

{- vim: set sw=2 ts=2 sts=2 et : -}

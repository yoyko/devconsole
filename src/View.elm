module View exposing (view)
import Model exposing (Model, Msg(..))
import Connection exposing (Message(..))
import Html exposing (Html, div, h1, text, input, button)
import Html.Attributes exposing (defaultValue, style)
import Html.Events exposing (onInput, onClick)
import Time
import Date
import Date.Extra.Format
import Date.Extra.Config.Configs

view : Model -> Html Msg
view model =
  div []
    [ h1 []
      [ text "DevConsole"
      ]
    , text <| "Url: " ++ model.connection.url
    , messages model.connection.messages
    , input [ onInput Input, defaultValue model.input ] []
    , button [ onClick SendRequest ] [ text "Send" ]
    ]

messages : List Message -> Html Msg
messages msgs =
  div []
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
        Sent ts m -> { bg = "#ddf", text =  (formatTs ts) ++ ": "++ m }
        Received ts m -> {- TODO parse of course ;) -}
          { bg = if String.contains """"error":""" m then "#fdd" else "#dfd"
          , text = (formatTs ts) ++ ": " ++ m
          }
        Opened ts ws -> { bg = "#dfd", text = (formatTs ts) ++ ": Opened " ++ ws}
        Closed ts ws -> { bg = "#fdd", text = (formatTs ts) ++ ": Closed " ++ ws}
  in
    div {- TODO use css -}
      [ style [ ("backgroundColor", o.bg) ]
      ]
      [ text o.text
      ]

{- vim: set sw=2 ts=2 sts=2 et : -}

module View exposing (view)
import Model exposing (Model, Msg(..), Message(..))
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
    , text <| "Url: " ++ model.url
    , messages model.messages
    , input [ onInput Input, defaultValue model.input ] []
    , button [ onClick (Timestamp SendRequest) ] [ text "Send" ]
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
        Sent     ts m -> { color = "#ddf", text = (formatTs ts) ++ ": " ++ m }
        Received ts m -> { color = "#dfd", text = (formatTs ts) ++ ": " ++ m }
        Opened  ts ws -> { color = "#dfd", text = (formatTs ts) ++ ": Opened " ++ ws}
        Closed  ts ws -> { color = "#fdd", text = (formatTs ts) ++ ": Closed " ++ ws}
  in
    div []
      [ text o.text
      ]

{- vim: set sw=2 ts=2 sts=2 et : -}

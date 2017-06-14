module View exposing (view)
import Model exposing (Model, Msg(..), Message(..))
import Html exposing (Html, div, h1, text, input, button)
import Html.Events exposing (onInput, onClick)

view : Model -> Html Msg
view model =
  div []
    [ h1 []
      [ text "DevConsole"
      ]
    , text <| "Url: " ++ model.url
    , messages model.messages
    , input [ onInput Input ] []
    , button [ onClick SendRequest ] [ text "Send" ]
    ]

messages : List Message -> Html Msg
messages msgs =
  div []
    ( List.map message msgs
    )

message : Message -> Html Msg
message msg =
  let
    o =
      case msg of
        Sent m -> { color = "#ddf", text = m }
        Received m -> { color = "#dfd", text = m}
  in
    div []
      [ text o.text
      ]

{- vim: set sw=2 ts=2 sts=2 et : -}

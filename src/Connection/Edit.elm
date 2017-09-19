module Connection.Edit exposing (view)

import Connection exposing (Msg(Url))
import Html exposing (Html, div, h1, text, input, button)
import Html.Attributes exposing (defaultValue, id, class, style)
import Html.Events exposing (onInput, onClick)
import Material
import Material.Options as Options
import Material.Textfield as Textfield

view : (Msg -> m) -> (Material.Msg m -> m) -> Material.Model -> String -> Html m
view lift mdlLift mdl url =
  Textfield.render mdlLift [9, 9, 9] mdl
    [ Options.cs "connectionUrl"
    , Textfield.label "Url"
    , Textfield.floatingLabel
    , Textfield.value url
    , Options.onInput (lift << Url)
    ]
    []

{- vim: set sw=2 ts=2 sts=2 et : -}

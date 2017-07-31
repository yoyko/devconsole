module Message.Edit.Parts exposing (textfield, url)
import Message.Edit.Model exposing (Model, Msg(..), Context)
import Html exposing (Html)
import Material.Options as Options
import Material.Textfield as Textfield
import Char

textfield : Context msg
  -> List Int
  -> String
  -> String
  -> (String -> Msg)
  -> List (Textfield.Property msg)
  -> Html msg
textfield ctx index label value msg options =
  Textfield.render ctx.mdlLift index ctx.mdl
    ([ Options.cs <| decapitalize label
    , Textfield.label label
    , Textfield.floatingLabel
    , Textfield.value value
    , Options.onInput (ctx.msgLift << msg)
    ] ++ options)
    []

url : Context msg -> List Int -> Model -> Html.Html msg
url ctx index model =
  textfield ctx index "Url" model.url Url
    [ Textfield.autofocus
    ]

decapitalize  : String -> String
decapitalize s =
  case String.uncons s of
    Just (c, s) -> String.cons (Char.toLower c) s
    Nothing -> s

{- vim: set sw=2 ts=2 sts=2 et : -}

module Message.Edit.Parts exposing (textfield, url, context, twoLine, validateJson, validateJsonOrEmpty, validJsonOrEmptyString)
import Message.Edit.Model exposing (Model, Msg(..), Ctx)
import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Material.Options as Options
import Material.Textfield as Textfield
import Char
import Json.Encode
import Json.Decode

textfield : Ctx msg
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

url : Ctx msg -> List Int -> Model -> Html.Html msg
url ctx index model =
  textfield ctx index "Url" model.url Url
    [ Textfield.autofocus
    ]

context : Ctx msg -> List Int -> Model -> Html.Html msg
context ctx index model =
  textfield ctx index "Context" model.context Context
    [ validateJsonOrEmpty model.context
    ]


twoLine : List (Html msg) -> List (Html msg) -> Html msg
twoLine first second =
  div
    [ class "editContent"
    ]
    [ div [] first
    , div [] second
    ]


decapitalize  : String -> String
decapitalize s =
  case String.uncons s of
    Just (c, s) -> String.cons (Char.toLower c) s
    Nothing -> s

validateJson : String -> Textfield.Property msg
validateJson =
  validate validJsonString "Invalid JSON"

validateJsonOrEmpty : String -> Textfield.Property msg
validateJsonOrEmpty =
  validate validJsonOrEmptyString "Invalid JSON"

validate : (String -> Bool) -> String -> String -> Textfield.Property msg
validate predicate errorMessage str =
  Textfield.error errorMessage
    |> Options.when (not <| predicate str)

validJsonOrEmptyString : String -> Bool
validJsonOrEmptyString str =
  case str of
    "" -> True
    _ -> validJsonString str

{- We really check for a valid json object, not just any json value. -}
validJsonString : String -> Bool
validJsonString str =
  Json.Decode.decodeString (Json.Decode.keyValuePairs Json.Decode.value) str
  |> Result.map (always True)
  |> Result.withDefault False

{- vim: set sw=2 ts=2 sts=2 et : -}

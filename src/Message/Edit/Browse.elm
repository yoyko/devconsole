module Message.Edit.Browse exposing (browseEdit, browseResult)
import Message.Edit.Model exposing (Model, Msg(..), Context)
import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Material.Options as Options
import Material.Textfield as Textfield
import Json.Encode

browseEdit : Context msg -> (Context msg -> Model -> Html msg) -> Model -> Html msg
browseEdit ctx send model =
  div
    [ class "browseEdit" ]
    [ Textfield.render ctx.mdlLift [2, 3, 0] ctx.mdl
        [ Options.cs "url"
        , Textfield.label "Url"
        , Textfield.floatingLabel
        , Textfield.autofocus
        , Textfield.value model.url
        , Options.onInput (ctx.msgLift << Url)
        ]
        []
    , Textfield.render ctx.mdlLift [2, 3, 1] ctx.mdl
        [ Options.cs "from"
        , Textfield.label "from"
        , Textfield.floatingLabel
        , Textfield.value model.browseFrom
        , Options.onInput (ctx.msgLift << BrowseFrom)
        ]
        []
    , Textfield.render ctx.mdlLift [2, 3, 2] ctx.mdl
        [ Options.cs "count"
        , Textfield.label "count"
        , Textfield.floatingLabel
        , Textfield.value model.browseCount
        , Options.onInput (ctx.msgLift << BrowseCount)
        ]
        []
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
            ]
        )
      , ("url", Json.Encode.string model.url)
      , ("method", Json.Encode.string "browse")
      ]



{- vim: set sw=2 ts=2 sts=2 et : -}

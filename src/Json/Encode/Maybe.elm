module Json.Encode.Maybe exposing (maybeObject, maybeStringValue)
import Json.Encode
import Json.Decode

maybeObject : (List (String, Maybe Json.Encode.Value)) -> Maybe Json.Encode.Value
maybeObject maybeItems =
  let
    items = List.filterMap
      (\(k, mv) -> Maybe.map ((,) k) mv)
      maybeItems
  in
    case items of
      [] -> Nothing
      _ -> Just <| Json.Encode.object items

maybeStringValue : String -> Maybe Json.Encode.Value
maybeStringValue =
  Json.Decode.decodeString Json.Decode.value >> Result.toMaybe

{- vim: set sw=2 ts=2 sts=2 et : -}

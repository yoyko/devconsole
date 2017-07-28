module Context exposing (Context)
import Material

{- Whole application context, that gets passed to all sub componenets -}
type alias Context a =
  { mdl : Material.Model
  , mdlLift : Material.Msg a -> a
  }

{- vim: set sw=2 ts=2 sts=2 et : -}

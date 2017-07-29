module Delegate exposing (Delegate, create, delegate)

type Delegate big small =
  Delegate
    { get : big -> small
    , set : small -> big -> big
    }

create : (big -> small) -> (small -> big -> big) -> Delegate big small
create get set =
  Delegate { get = get, set = set }

delegate : Delegate big small -> big -> (small -> ( small, Cmd msg )) -> ( big, Cmd msg )
delegate (Delegate deleg) big f =
  big
  |> deleg.get
  |> f
  |> Tuple.mapFirst (\v -> deleg.set v big)

{- vim: set sw=2 ts=2 sts=2 et : -}

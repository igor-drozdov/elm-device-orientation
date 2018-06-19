effect module DeviceOrientation where { subscription = MySub } exposing (isSupported, onDeviceOrientation)

{-|


# Page Orientation

@docs isSupported, onDeviceOrientation

-}

import Native.DeviceOrientation
import Process
import Task exposing (Task)


-- PAGE VISIBILITY


{-| Value describing whether the page is hidden or visible.
-}
type alias Orientation =
    { alpha : Int
    , beta : Int
    , gamma : Int
    , absolute : Bool
    }


{-| Is the page hidden?
-}
isSupported : Task x Bool
isSupported =
    Native.DeviceOrientation.isSupported



-- SUBSCRIPTIONS


{-| Subscribe to any visibility changes. You will get updates about the current
visibility.
-}
onDeviceOrientation : (Orientation -> msg) -> Sub msg
onDeviceOrientation tagger =
    subscription (Tagger tagger)


type MySub msg
    = Tagger (Orientation -> msg)


subMap : (a -> b) -> MySub a -> MySub b
subMap func (Tagger tagger) =
    Tagger (tagger >> func)



-- EFFECT MANAGER


type alias State msg =
    Maybe
        { subs : List (MySub msg)
        , pid : Process.Id
        }


init : Task Never (State msg)
init =
    Task.succeed Nothing


onEffects : Platform.Router msg Orientation -> List (MySub msg) -> State msg -> Task Never (State msg)
onEffects router newSubs state =
    case ( state, newSubs ) of
        ( Nothing, [] ) ->
            Task.succeed state

        ( Nothing, _ :: _ ) ->
            Process.spawn (Native.DeviceOrientation.onDeviceOrientation (Platform.sendToSelf router))
                |> Task.andThen (\pid -> Task.succeed (Just { subs = newSubs, pid = pid }))

        ( Just { pid }, [] ) ->
            Process.kill pid
                |> Task.andThen (\_ -> Task.succeed Nothing)

        ( Just { pid }, _ :: _ ) ->
            Task.succeed (Just { subs = newSubs, pid = pid })


onSelfMsg : Platform.Router msg Orientation -> Orientation -> State msg -> Task Never (State msg)
onSelfMsg router orientation state =
    case state of
        Nothing ->
            Task.succeed state

        Just { subs } ->
            let
                send (Tagger tagger) =
                    Platform.sendToApp router (tagger orientation)
            in
                Task.sequence (List.map send subs)
                    |> Task.andThen (\_ -> Task.succeed state)

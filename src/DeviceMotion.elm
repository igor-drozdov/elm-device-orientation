effect module DeviceMotion where { subscription = MySub } exposing (watch, Motion)

{-|


# Device Motion

@docs watch, Motion

-}

import Native.DeviceOrientation
import Process
import Task exposing (Task)


-- PAGE VISIBILITY


{-| Information from the physical motion of the device running the web page.
-}
type alias Motion =
    { acceleration : { x : Float, y : Float, z : Float }
    , accelerationIncludingGravity : { x : Float, y : Float, z : Float }
    , rotationRate : { alpha : Float, beta : Float, gamma : Float }
    , interval : Int
    }



-- SUBSCRIPTIONS


{-| Subscribe to changes of device motion.
-}
watch : (Motion -> msg) -> Sub msg
watch tagger =
    subscription (Tagger tagger)


type MySub msg
    = Tagger (Motion -> msg)


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


onEffects : Platform.Router msg Motion -> List (MySub msg) -> State msg -> Task Never (State msg)
onEffects router newSubs state =
    case ( state, newSubs ) of
        ( Nothing, [] ) ->
            Task.succeed state

        ( Nothing, _ :: _ ) ->
            Process.spawn (Native.DeviceOrientation.onDeviceMotion (Platform.sendToSelf router))
                |> Task.andThen (\pid -> Task.succeed (Just { subs = newSubs, pid = pid }))

        ( Just { pid }, [] ) ->
            Process.kill pid
                |> Task.andThen (\_ -> Task.succeed Nothing)

        ( Just { pid }, _ :: _ ) ->
            Task.succeed (Just { subs = newSubs, pid = pid })


onSelfMsg : Platform.Router msg Motion -> Motion -> State msg -> Task Never (State msg)
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

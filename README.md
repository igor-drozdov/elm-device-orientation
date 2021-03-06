This library helps to track the data from the physical orientation of the device running the web page.

It is based on [Device Orientation API](https://developer.mozilla.org/en-US/docs/Web/API/DeviceOrientationEvent). You can read about how to use libraries with tasks and subscriptions in [guide.elm-lang.org](guide.elm-lang.org), particularly the section on [Subscriptions](https://guide.elm-lang.org/architecture/effects/).

Basically, the usage of the library comes down to adding a subscription:

```elm
import DeviceOrientation exposing (Orientation, watch)

...

type Msg
    = DeviceOrientationChanged Orientation
    | DeviceMotionChanged Motion


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DeviceOrientationChanged orientation ->
            ( model, Cmd.none )

        DeviceMotionChanged motion ->
            ( model, Cmd.none )

...

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ DeviceOrientation.watch DeviceOrientationChanged
        , DeviceMotion.watch DeviceMotionChanged
        ]

```

Please, feel free to look through the provided example for an extra explanation.

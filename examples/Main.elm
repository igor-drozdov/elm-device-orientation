module Main exposing (..)

import Html exposing (Html, text, div, img)
import Html.Attributes exposing (src)
import DeviceOrientation exposing (Orientation, onDeviceOrientation)
import Time exposing (every, second, Time)


---- MODEL ----


type alias Model =
    Orientation


initialModel =
    Orientation 0 0 0 True


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



---- UPDATE ----


type Msg
    = DeviceOrientationChanged Orientation


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DeviceOrientationChanged orientation ->
            ( orientation, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div [] [ div [] [ text "Your Elm App is working!" ] ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }



---- SUBSCRIPTION ----


subscriptions model =
    Sub.batch
        [ onDeviceOrientation DeviceOrientationChanged
        ]

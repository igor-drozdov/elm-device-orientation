module Main exposing (..)

import Html exposing (Html, text, div, img)
import Html.Attributes exposing (id, class, style)
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
    let
        transform model =
            [ ( "transform", "rotateX(" ++ (toString model.beta) ++ "deg) " ++ "rotateY(" ++ (toString model.gamma) ++ "deg) " ++ "rotateZ(" ++ (toString model.alpha) ++ "deg)" ) ]
    in
        div []
            [ div [ class "cube", style (transform model) ]
                [ div [ class "side one" ]
                    [ text "1" ]
                , div
                    [ class "side two" ]
                    [ text "2" ]
                , div
                    [ class "side three" ]
                    [ text "3" ]
                , div
                    [ class "side four" ]
                    [ text "4" ]
                , div
                    [ class "side five" ]
                    [ text "5" ]
                , div
                    [ class "side six" ]
                    [ text "6" ]
                ]
            ]



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


subscriptions : Model -> Sub Msg
subscriptions model =
    onDeviceOrientation DeviceOrientationChanged

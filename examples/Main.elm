module Main exposing (..)

import Html exposing (Html, text, div, span)
import Html.Attributes exposing (id, class, style)
import DeviceOrientation exposing (Orientation)
import DeviceMotion exposing (Motion)
import Time exposing (every, second, Time)


---- MODEL ----


type alias Model =
    { orientation : Orientation
    , motion : Motion
    }


initialModel =
    { orientation = Orientation 0 0 0 True
    , motion = Motion { x = 0, y = 0, z = 0 } { x = 0, y = 0, z = 0 } { alpha = 0, beta = 0, gamma = 0 } 0
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



---- UPDATE ----


type Msg
    = DeviceOrientationChanged Orientation
    | DeviceMotionChanged Motion


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DeviceOrientationChanged orientation ->
            ( { model | orientation = orientation }, Cmd.none )

        DeviceMotionChanged motion ->
            ( { model | motion = motion }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    let
        transform { orientation } =
            [ ( "transform", "rotateX(" ++ (toString orientation.beta) ++ "deg) " ++ "rotateY(" ++ (toString orientation.gamma) ++ "deg) " ++ "rotateZ(" ++ (toString orientation.alpha) ++ "deg)" ) ]

        motionData { motion } =
            div []
                [ div []
                    [ span [] [ text "Acceleration: " ]
                    , span []
                        [ text ("x: " ++ (toString <| round motion.acceleration.x) ++ ", ")
                        , text ("y: " ++ (toString <| round motion.acceleration.y) ++ ", ")
                        , text ("z: " ++ (toString <| round motion.acceleration.z))
                        ]
                    ]
                , div
                    []
                    [ span [] [ text "Acceleration Incl. Gravity: " ]
                    , span []
                        [ text ("x: " ++ (toString <| round motion.accelerationIncludingGravity.x) ++ ", ")
                        , text ("y: " ++ (toString <| round motion.accelerationIncludingGravity.y) ++ ", ")
                        , text ("z: " ++ (toString <| round motion.accelerationIncludingGravity.z))
                        ]
                    ]
                , div
                    []
                    [ span [] [ text "Rot. Rate: " ]
                    , span []
                        [ text ("alpha: " ++ (toString <| round motion.rotationRate.alpha) ++ ", ")
                        , text ("beta: " ++ (toString <| round motion.rotationRate.beta) ++ ", ")
                        , text ("gamma: " ++ (toString <| round motion.rotationRate.gamma))
                        ]
                    ]
                , div []
                    [ span [] [ text "Interval: " ]
                    , span [] [ text ((toString motion.interval) ++ "ms") ]
                    ]
                ]
    in
        div []
            [ div [] [ motionData model ]
            , div [ class "cube", style (transform model) ]
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
    Sub.batch
        [ DeviceOrientation.watch DeviceOrientationChanged
        , DeviceMotion.watch DeviceMotionChanged
        ]

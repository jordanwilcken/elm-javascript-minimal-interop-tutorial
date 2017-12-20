port module FirstInterop exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


port displayGreeting : String -> Cmd msg


port valentines : ({ from : String, content : String } -> msg) -> Sub msg


view : Model -> Html Msg
view model =
    let
        firstLine =
            if String.length model.valentine.from > 0 then
                "from: " ++ model.valentine.from

            else
                "I've not received anything from javascript yet."
    in
    div []
        [ h2 [] [ text "Send a greeting" ]
        , input
              [ onInput SendGreeting
              , value model.greeting
              ] []
        , hr [] []
        , h2 [] [ text <| "Look at what vanillajs sent!" ]
        , p [] [ text firstLine ]
        , p [] [ text model.valentine.content ]
        ]


type alias Model =
    { greeting : String
    , valentine : Valentine
    }


type alias Valentine =
    { from : String
    , content : String
    }


init : ( Model, Cmd Msg )
init =
    let
        firstModel =
            { greeting = ""
            , valentine =
                { from = ""
                , content = ""
                }
            }
    in
    ( firstModel, Cmd.none )


type Msg
    = SendGreeting String
    | ValentineReceived Valentine


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendGreeting greeting ->
            ( { model | greeting = greeting }, displayGreeting greeting )

        ValentineReceived received ->
            ( { model | valentine = received }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    valentines ValentineReceived


main = Html.program
    { init = init, update = update, view = view, subscriptions = subscriptions }

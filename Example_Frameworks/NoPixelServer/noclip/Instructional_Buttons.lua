--[[
    -- Type: Function
    -- Name: setupScaleform
    -- Use: Builds and returns an instructional buttons scaleform
    -- Created: 2024-05-14
    -- By: VSSVSSN
--]]
local function buttonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandScaleformString()
end

local function button(controlButton)
    PushScaleformMovieFunctionParameterButtonName(controlButton)
end

function setupScaleform(scaleformName, cfg, speedIndex)
    local scaleform = RequestScaleformMovie(scaleformName)

    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(5)
    button(GetControlInstructionalButton(2, cfg.controls.openKey, true))
    buttonMessage("Noclip off")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(4)
    button(GetControlInstructionalButton(2, cfg.controls.goUp, true))
    buttonMessage("Up")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(3)
    button(GetControlInstructionalButton(2, cfg.controls.goDown, true))
    buttonMessage("Down")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    button(GetControlInstructionalButton(1, cfg.controls.turnRight, true))
    button(GetControlInstructionalButton(1, cfg.controls.turnLeft, true))
    buttonMessage("Turn Right / Left")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    button(GetControlInstructionalButton(1, cfg.controls.goBackward, true))
    button(GetControlInstructionalButton(1, cfg.controls.goForward, true))
    buttonMessage("Go Forward / Back")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    button(GetControlInstructionalButton(2, cfg.controls.changeSpeed, true))
    buttonMessage(cfg.speeds[speedIndex].label .. " ")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(cfg.bgR)
    PushScaleformMovieFunctionParameterInt(cfg.bgG)
    PushScaleformMovieFunctionParameterInt(cfg.bgB)
    PushScaleformMovieFunctionParameterInt(cfg.bgA)
    PopScaleformMovieFunctionVoid()

    return scaleform
end


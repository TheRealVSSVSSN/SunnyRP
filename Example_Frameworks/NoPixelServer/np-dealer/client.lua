RegisterNetEvent('cult:weed')
AddEventHandler('cult:weed', function()
    if DoesEntityExist(PlayerPedId()) and not IsEntityDead(PlayerPedId()) then
        playAnim('pickup_object', 'putdown_low')
    end
end)



RegisterNetEvent('farm:weed')
AddEventHandler('farm:weed', function()
    if DoesEntityExist(PlayerPedId()) and not IsEntityDead(PlayerPedId()) then
        playAnim('pickup_object', 'pickup_low')
    end
end)







local function loadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
    end
end

local function playAnim(dict, anim, flag)
    loadAnimDict(dict)
    TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 1.0, -1, flag or 16, 0, false, false, false)
end


RegisterNetEvent('drugGiveAnim')
AddEventHandler('drugGiveAnim', function()
    if DoesEntityExist(PlayerPedId()) and not IsEntityDead(PlayerPedId()) then
        playAnim('mp_safehouselost@', 'package_dropoff')
    end
end)

local attachedProp = 0

local function removeAttachedProp()
    DeleteEntity(attachedProp)
    attachedProp = 0
end

local function createAttachedProp(model, bone, x, y, z, xR, yR, zR)
    local ped = PlayerPedId()
    local boneIndex = GetPedBoneIndex(ped, bone)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end
    attachedProp = CreateObject(model, 1.0, 1.0, 1.0, true, true, false)
    exports['isPed']:GlobalObject(attachedProp)
    AttachEntityToEntity(attachedProp, ped, boneIndex, x, y, z, xR, yR, zR, true, true, false, true, 2, true)
end

--missfinale_c2mcs_2_b mcs_2_b_takeout_phone_peda
local function runAnimation()
    local dict = 'mp_character_creation@lineup@male_a'
    loadAnimDict(dict)
    if not IsEntityPlayingAnim(PlayerPedId(), dict, 'loop_raised', 3) then
        TaskPlayAnim(PlayerPedId(), dict, 'loop_raised', 8.0, -8, -1, 49, 0, 0, 0, 0)
    end
end


function scaleformPaste(scaleform,obj,name,years,cid,date)
    local position = GetOffsetFromEntityInWorldCoords(obj, -0.2, -0.0132 - (GetEntitySpeed(PlayerPedId()) / 50), 0.105)
    local scale = vector3(0.41, 0.23, 1.0)
    local push = GetEntityRotation(obj, 2)

    Citizen.InvokeNative(0x87D51D72255D4E78, scaleform, position, 180.0 + push["x"], 0.0 - GetEntityRoll(obj),GetEntityHeading(obj), 1.0, 0.8, 4.0, scale, 0)

    if not date then
        date = "Mugshot Board"
    end

    if not years then
        years = 0
    end

    if not name then
        name = "No Name"
    end

    PushScaleformMovieFunction(scaleform, "SET_BOARD")
    PushScaleformMovieFunctionParameterString("LOS SANTOS POLICE DEPARTMENT")
    PushScaleformMovieFunctionParameterString(date)
    PushScaleformMovieFunctionParameterString("Sentenced to " .. years .. " Months")
    PushScaleformMovieFunctionParameterString(name)
    PushScaleformMovieFunctionParameterFloat(0.0)
    PushScaleformMovieFunctionParameterString(cid)
    PushScaleformMovieFunctionParameterFloat(0.0)
    PopScaleformMovieFunctionVoid()
end

local count = 0

RegisterNetEvent('drawScaleformJail')
AddEventHandler('drawScaleformJail', function(years,name,cid,date)

    Wait(3000)
    if (#(GetEntityCoords(PlayerPedId()) - vector3(466.99, -1005.86, 24.47)) < 10.0) then
        if count > 0 then
            count = 0
        end
        Wait(1)
        local scaleform = RequestScaleformMovie("mugshot_board_01")
        while not HasScaleformMovieLoaded(scaleform) do
          Wait(1)
        end
        count = 10000
        while count > 0 do
            count = count - 1
            local objFound = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 10.0, GetHashKey('prop_police_id_board'), 0, 0, 0)
            if objFound then
                scaleformPaste(scaleform,objFound,name,years,cid,date)
            end
            Wait(1)
        end
    end
 end)

RegisterNetEvent('attachPropCon')
AddEventHandler('attachPropCon', function(model, bone, x, y, z, xR, yR, zR)
    runAnimation()
    removeAttachedProp()
    SetCurrentPedWeapon(PlayerPedId(), 0xA2719263)
    createAttachedProp(GetHashKey(model), bone, x, y, z, xR, yR, zR)
    local ped = PlayerPedId()
    local start = GetEntityCoords(ped)
    while IsEntityPlayingAnim(ped, 'mp_character_creation@lineup@male_a', 'loop_raised', 3) and (#(GetEntityCoords(ped) - start) <= 1.5) do
        Wait(1)
    end
    ClearPedTasksImmediately(ped)
    removeAttachedProp()
end)

RegisterNetEvent('attachPropDrugsObjectnoanim')
AddEventHandler('attachPropDrugsObjectnoanim', function(model, bone, x, y, z, xR, yR, zR)
    removeAttachedProp()
    SetCurrentPedWeapon(PlayerPedId(), 0xA2719263)
    createAttachedProp(GetHashKey(model), bone, x, y, z, xR, yR, zR)
    Wait(5000)
    removeAttachedProp()
end)
RegisterNetEvent('attachPropDrugsObject')
AddEventHandler('attachPropDrugsObject', function(model, bone, x, y, z, xR, yR, zR)
    removeAttachedProp()
    TriggerEvent('drugGiveAnim')
    SetCurrentPedWeapon(PlayerPedId(), 0xA2719263)
    createAttachedProp(GetHashKey(model), bone, x, y, z, xR, yR, zR)
    Wait(5000)
    removeAttachedProp()
end)


RegisterNetEvent('attachPropHObject')
AddEventHandler('attachPropHObject', function(model, bone, x, y, z, xR, yR, zR)
    removeAttachedProp()
    SetCurrentPedWeapon(PlayerPedId(), 0xA2719263)
    createAttachedProp(GetHashKey(model), bone, x, y, z, xR, yR, zR)
    Wait(10000)
    removeAttachedProp()
end)



RegisterNetEvent('attachPropDrugs2')
AddEventHandler('attachPropDrugs2', function(model, bone, x, y, z, xR, yR, zR)
    removeAttachedProp()
    TriggerEvent('drugGiveAnim')
    SetCurrentPedWeapon(PlayerPedId(), 0xA2719263)
    createAttachedProp(GetHashKey(model), bone, x, y, z, xR, yR, zR)
    Wait(4000)
    removeAttachedProp()
end)

RegisterNetEvent('attachRemoveChopShop')
AddEventHandler('attachRemoveChopShop', function()
    removeAttachedProp()
end)

RegisterNetEvent('attachPropChopShop')
AddEventHandler('attachPropChopShop', function(model, bone, x, y, z, xR, yR, zR)
    removeAttachedProp()
    SetCurrentPedWeapon(PlayerPedId(), 0xA2719263)
    createAttachedProp(GetHashKey(model), bone, x, y, z, xR, yR, zR)
end)

RegisterNetEvent('attachPropDrugs')
AddEventHandler('attachPropDrugs', function(model, bone, x, y, z, xR, yR, zR)
    removeAttachedProp()
    TriggerEvent('drugGiveAnim')
    SetCurrentPedWeapon(PlayerPedId(), 0xA2719263)
    createAttachedProp(GetHashKey(model), bone, x, y, z, xR, yR, zR)
    Wait(4000)
    removeAttachedProp()
end)



local function attachPropCash(model, bone, x, y, z, xR, yR, zR)
    removeAttachedProp()
    SetCurrentPedWeapon(PlayerPedId(), 0xA2719263)
    createAttachedProp(GetHashKey(model), bone, x, y, z, xR, yR, zR)
    Wait(2500)
    removeAttachedProp()
end

local attachPropList = {

    ["crackpipe01"] = { 
        ["model"] = "prop_cs_crackpipe", ["bone"] = 28422, ["x"] = 0.0,["y"] = 0.05,["z"] = 0.0,["xR"] = 135.0,["yR"] = -100.0, ["zR"] = 0.0 
    },

    ["bong01"] = { 
        ["model"] = "prop_bong_01", ["bone"] = 18905, ["x"] = 0.11,["y"] = -0.23,["z"] = 0.01,["xR"] = -90.0,["yR"] = 0.0, ["zR"] = 0.0 
    },

    ["healthpack01"] = { 
        ["model"] = "prop_ld_health_pack", ["bone"] = 18905, ["x"] = 0.15,["y"] = 0.08,["z"] = 0.1,["xR"] = 180.0,["yR"] = 220.0, ["zR"] = 0.0 
    },

    ["briefcase01"] = { 
        ["model"] = "prop_ld_case_01", ["bone"] = 28422, ["x"] = 0.05,["y"] = 0.0,["z"] = 0.0,["xR"] = 135.0,["yR"] = -100.0, ["zR"] = 0.0 
    },

    ["prop_box_guncase_01a"] = { 
        ["model"] = "prop_box_guncase_01a", ["bone"] = 28422, ["x"] = 0.05,["y"] = 0.0,["z"] = 0.0,["xR"] = 135.0,["yR"] = -100.0, ["zR"] = 0.0 
    },

    ["cashcase3"] = { 
        ["model"] = "prop_cash_case_02", ["bone"] = 28422, ["x"] = -0.01,["y"] = -0.1,["z"] = -0.138,["xR"] = 0.0,["yR"] = 0.0, ["zR"] = 0.0 
    },

    ["con1"] = { 
        ["model"] = "prop_police_id_board", ["bone"] = 28422, ["x"] = 0,["y"] = 0,["z"] = 0.1,["xR"] = 0.0,["yR"] = 0.0, ["zR"] = 0.0 
    },

    ["EnginePart"] = { 
        ["model"] = "prop_cs_cardbox_01", ["bone"] = 28422, ["x"] = -0.01,["y"] = -0.1,["z"] = -0.138,["xR"] = 0.0,["yR"] = 0.0, ["zR"] = 0.0 
    },

    ["SuspensionPart"] = { 
        ["model"] = "prop_cs_cardbox_01", ["bone"] = 28422, ["x"] = -0.01,["y"] = -0.1,["z"] = -0.138,["xR"] = 0.0,["yR"] = 0.0, ["zR"] = 0.0 
    },

    ["DampenerPart"] = { 
        ["model"] = "prop_cs_cardbox_01", ["bone"] = 28422, ["x"] = -0.01,["y"] = -0.1,["z"] = -0.138,["xR"] = 0.0,["yR"] = 0.0, ["zR"] = 0.0 
    },

    ["TyrePart"] = { 
        ["model"] = "prop_cs_cardbox_01", ["bone"] = 28422, ["x"] = -0.01,["y"] = -0.1,["z"] = -0.138,["xR"] = 0.0,["yR"] = 0.0, ["zR"] = 0.0 
    },

    ["MetalPart"] = { 
        ["model"] = "prop_cs_cardbox_01", ["bone"] = 28422, ["x"] = -0.01,["y"] = -0.1,["z"] = -0.138,["xR"] = 0.0,["yR"] = 0.0, ["zR"] = 0.0 
    },

    ["AerodynamicsPart"] = { 
        ["model"] = "prop_cs_cardbox_01", ["bone"] = 28422, ["x"] = -0.01,["y"] = -0.1,["z"] = -0.138,["xR"] = 0.0,["yR"] = 0.0, ["zR"] = 0.0 
    },

    ["BrakingPart"] = { 
        ["model"] = "prop_cs_cardbox_01", ["bone"] = 28422, ["x"] = -0.01,["y"] = -0.1,["z"] = -0.138,["xR"] = 0.0,["yR"] = 0.0, ["zR"] = 0.0 
    },

    ["GearboxPart"] = { 
        ["model"] = "prop_cs_cardbox_01", ["bone"] = 28422, ["x"] = -0.01,["y"] = -0.1,["z"] = -0.138,["xR"] = 0.0,["yR"] = 0.0, ["zR"] = 0.0 
    },


    ["gunbox1"] = { 
        ["model"] = "prop_paper_bag_small", ["bone"] = 28422, ["x"] = 0.01,["y"] = 0.01,["z"] = 0.0,["xR"] = 0.0,["yR"] = 0.0, ["zR"] = 0.0 
    },

    ["drugtest02"] = { 
        ["model"] = "prop_mp_drug_pack_blue", ["bone"] = 28422, ["x"] = 0.01,["y"] = 0.01,["z"] = 0.0,["xR"] = 0.0,["yR"] = 0.0, ["zR"] = 0.0 
    },

    ["drugtest01"] = { 
        ["model"] = "prop_mp_drug_package", ["bone"] = 28422, ["x"] = 0.01,["y"] = 0.01,["z"] = 0.0,["xR"] = 0.0,["yR"] = 0.0, ["zR"] = 0.0 
    },

    ["cashcase01"] = { 
        ["model"] = "prop_paper_bag_small", ["bone"] = 28422, ["x"] = 0.05,["y"] = 0.0,["z"] = 0.0,["xR"] = 135.0,["yR"] = -100.0, ["zR"] = 0.0 
    },

    ["cashbag02"] = { 
        ["model"] = "prop_cs_heist_bag_01", ["bone"] = 28422, ["x"] = 0.05,["y"] = 0.0,["z"] = 0.0,["xR"] = 135.0,["yR"] = -100.0, ["zR"] = 0.0 
    },

    ["cashbag01"] = { 
        ["model"] = "prop_cs_heist_bag_01", ["bone"] = 24816, ["x"] = 0.15,["y"] = -0.4,["z"] = -0.38,["xR"] = 90.0,["yR"] = 0.0, ["zR"] = 0.0 
    },

    ["drugpackage01"] = { 
        ["model"] = "prop_meth_bag_01", ["bone"] = 28422, ["x"] = 0.1,["y"] = 0.0,["z"] = -0.01,["xR"] = 135.0,["yR"] = -100.0, ["zR"] = 40.0 
    },


    ["drugpackage02"] = { 
        ["model"] = "prop_weed_bottle", ["bone"] = 28422, ["x"] = 0.09,["y"] = 0.0,["z"] = -0.03,["xR"] = 135.0,["yR"] = -100.0, ["zR"] = 40.0 
    },





    ["bomb01"] = { 
        ["model"] = "prop_ld_bomb", ["bone"] = 28422, ["x"] = 0.22,["y"] = -0.01,["z"] = 0.0,["xR"] = -25.0,["yR"] = -100.0, ["zR"] = 0.0 
    },

    ["phone01"] = { 
        ["model"] = "prop_amb_phone", ["bone"] = 28422, ["x"] = 0.1,["y"] = 0.01,["z"] = 0.0,["xR"] = -255.0,["yR"] = -120.0, ["zR"] = 40.0 
    },

    ["money01"] = { 
        ["model"] = "prop_anim_cash_note", ["bone"] = 28422, ["x"] = 0.1,["y"] = 0.04,["z"] = 0.0,["xR"] = 25.0,["yR"] = 0.0, ["zR"] = 10.0 
    },

    ["armor01"] = { 
        ["model"] = "prop_armour_pickup", ["bone"] = 28422, ["x"] = 0.3,["y"] = 0.01,["z"] = 0.0,["xR"] = 255.0,["yR"] = -90.0, ["zR"] = 10.0 
    },

    ["terd01"] = { 
        ["model"] = "prop_big_shit_01", ["bone"] = 61839, ["x"] = 0.015,["y"] = 0.0,["z"] = -0.01,["xR"] = 3.0,["yR"] = -90.0, ["zR"] = 180.0 
    },

    ["boombox01"] = { 
        ["model"] = "prop_boombox_01", ["bone"] = 28422, ["x"] = 0.2,["y"] = 0.0,["z"] = 0.0,["xR"] = -35.0,["yR"] = -100.0, ["zR"] = 0.0 
    },

    ["bowlball01"] = { 
        ["model"] = "prop_bowling_ball", ["bone"] = 28422, ["x"] = 0.12,["y"] = 0.0,["z"] = 0.0,["xR"] = 75.0,["yR"] = 280.0, ["zR"] = -80.0 
    },

    ["bowlpin01"] = { 
        ["model"] = "prop_bowling_pin", ["bone"] = 28422, ["x"] = 0.12,["y"] = 0.0,["z"] = 0.0,["xR"] = 75.0,["yR"] = 280.0, ["zR"] = -80.0 
    },

    ["crate01"] = { 
        ["model"] = "hei_prop_heist_wooden_box", ["bone"] = 24816, ["x"] = 0.13,["y"] = 0.50,["z"] = 0.05,["xR"] = 45.0,["yR"] = 280.0, ["zR"] = -80.0 
    },

    ["tvcamera01"] = { 
        ["model"] = "prop_v_cam_01", ["bone"] = 57005, ["x"] = 0.13,["y"] = 0.25,["z"] = -0.03,["xR"] = -85.0,["yR"] = 0.0, ["zR"] = -80.0 
    },


        -- 18905 left hand - 57005 right hand
    ["tvmic01"] = { 
        ["model"] = "p_ing_microphonel_01", ["bone"] = 18905, ["x"] = 0.1,["y"] = 0.05,["z"] = 0.0,["xR"] = -85.0,["yR"] = -80.0, ["zR"] = -80.0 
    },

    ["golfbag01"] = { 
        ["model"] = "prop_golf_bag_01", ["bone"] = 24816, ["x"] = 0.12,["y"] = -0.3,["z"] = 0.0,["xR"] = -75.0,["yR"] = 190.0, ["zR"] = 92.0 
    },

    ["golfputter01"] = { 
        ["model"] = "prop_golf_putter_01", ["bone"] = 57005, ["x"] = 0.0,["y"] = -0.05,["z"] = 0.0,["xR"] = 90.0,["yR"] = -118.0, ["zR"] = 44.0 
    },

    ["golfiron01"] = { 
        ["model"] = "prop_golf_iron_01", ["bone"] = 57005, ["x"] = 0.125,["y"] = 0.04,["z"] = 0.0,["xR"] = 90.0,["yR"] = -118.0, ["zR"] = 44.0 
    },
    ["golfiron03"] = { 
        ["model"] = "prop_golf_iron_01", ["bone"] = 57005, ["x"] = 0.126,["y"] = 0.041,["z"] = 0.0,["xR"] = 90.0,["yR"] = -118.0, ["zR"] = 44.0 
    },
    ["golfiron05"] = { 
        ["model"] = "prop_golf_iron_01", ["bone"] = 57005, ["x"] = 0.127,["y"] = 0.042,["z"] = 0.0,["xR"] = 90.0,["yR"] = -118.0, ["zR"] = 44.0 
    },
    ["golfiron07"] = { 
        ["model"] = "prop_golf_iron_01", ["bone"] = 57005, ["x"] = 0.128,["y"] = 0.043,["z"] = 0.0,["xR"] = 90.0,["yR"] = -118.0, ["zR"] = 44.0 
    },      
    ["golfwedge01"] = { 
        ["model"] = "prop_golf_pitcher_01", ["bone"] = 57005, ["x"] = 0.17,["y"] = 0.04,["z"] = 0.0,["xR"] = 90.0,["yR"] = -118.0, ["zR"] = 44.0 
    },

    ["golfdriver01"] = { 
        ["model"] = "prop_golf_driver", ["bone"] = 57005, ["x"] = 0.14,["y"] = 0.00,["z"] = 0.0,["xR"] = 160.0,["yR"] = -60.0, ["zR"] = 10.0 
    }
    
}

RegisterNetEvent('imfat')
AddEventHandler('imfat', function()
    TriggerEvent("attachItemCONLOL","con1")
end)

local attachItemEvents = {
    attachItemCONLOL = 'attachPropCon',
    attachItemObjectH = 'attachPropHObject',
    attachItemObject = 'attachPropDrugsObject',
    attachItemObjectnoanim = 'attachPropDrugsObjectnoanim',
    attachItemDrugs = 'attachPropDrugs',
    attachItemDrugs2 = 'attachPropDrugs2',
    attachItemChop = 'attachPropChopShop'
}

for eventName, targetEvent in pairs(attachItemEvents) do
    RegisterNetEvent(eventName)
    AddEventHandler(eventName, function(item)
        local cfg = attachPropList[item]
        if cfg then
            TriggerEvent(targetEvent, cfg.model, cfg.bone, cfg.x, cfg.y, cfg.z, cfg.xR, cfg.yR, cfg.zR)
        end
    end)
end

--[[
    -- Type: Variable
    -- Name: state variables
    -- Use: Track UI state for clothing interactions
    -- Created: 2024-09-10
    -- By: VSSVSSN
--]]
local firstSpawn = true
local componentScroller = 0
local subComponentScroller = 0
local textureScroller = 0
local paletteScroller = 0
local removeScroller = 0
local opacityScroller = 0
local colourScroller = 0

-- player clothing data container
local player_data = {}

--[[
    -- Type: Function
    -- Name: getPed
    -- Use: Returns the current player's ped for reuse
    -- Created: 2024-09-10
    -- By: VSSVSSN
--]]
local function getPed()
    return PlayerPedId()
end

RegisterNetEvent('fsn_clothing:menu')
AddEventHandler('fsn_clothing:menu', function()
	GUI.maxVisOptions = 20
	titleTextSize = {0.85, 0.80} ------------ {p1, Size}                                      
	titleRectSize = {0.23, 0.085} ----------- {Width, Height}                                 
	optionTextSize = {0.5, 0.5} ------------- {p1, Size}                                      
	optionRectSize = {0.23, 0.035} ---------- {Width, Height}           
	menuX = 0.745 ----------------------------- X position of the menu                          
	menuXOption = 0.11 --------------------- X postiion of Menu.Option text                  
	menuXOtherOption = 0.06 ---------------- X position of Bools, Arrays etc text            
	menuYModify = 0.1500 -------------------- Default: 0.1174   ------ Top bar                
	menuYOptionDiv = 4.285 ------------------ Default: 3.56   ------ Distance between buttons 
	menuYOptionAdd = 0.21 ------------------ Default: 0.142  ------ Move buttons up and down
	clothing_menu = not clothing_menu
	OpenClothes()
end)

function OpenClothes()
    Menu.SetupMenu("clothing_main","Clothing")
    Menu.Switch(nil, "clothing_main")
    for k,v in pairs(menu_options) do
        Menu.addOption("clothing_main", function()
            if(Menu.Option(v.name))then
                 v.f(v.name,v.param)
            end
        end)
    end
end

function listModels(title, table)
    Menu.SetupMenu("clothing_models", title)
    Menu.Switch("clothing_main", "clothing_models")
    for k,v in pairs(table) do
        Menu.addOption("clothing_models", function()
            if(Menu.Option(v))then
                TriggerEvent("clothes:changemodel", v)
            end
        end)
    end
end

function customise(title)
    Menu.SetupMenu("clothing_customise", title)
    Menu.Switch("clothing_main", "clothing_customise")
    if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") or GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
        componentScroller = 0
        subComponentScroller = GetPedDrawableVariation(PlayerPedId(), componentScroller)
        textureScroller = GetPedTextureVariation(PlayerPedId(), componentScroller)
        paletteScroller = GetPedPaletteVariation(PlayerPedId(), componentScroller)
        if not player_data.clothing then
            player_data.clothing = {}
        end
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarString({"Head","Mask","Hair","Arms","Pants","Parachutes","Shoes","Necklace & Ties","Undershirt","Body Armour","Decals","Shirts"}, componentScroller, function(cb)  componentScroller = cb end)) then
                subComponentScroller = GetPedDrawableVariation(PlayerPedId(), componentScroller)
                textureScroller = GetPedTextureVariation(PlayerPedId(), componentScroller)
                paletteScroller = GetPedPaletteVariation(PlayerPedId(), componentScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarInt("Components", subComponentScroller, GetNumberOfPedDrawableVariations(PlayerPedId(), componentScroller), function(cb)  subComponentScroller = cb end)) then
                if componentScroller == 0 then
                    SetPedHeadBlendData(PlayerPedId(), subComponentScroller, subComponentScroller, 0, subComponentScroller, subComponentScroller, 0, 0.5, 0.5, 0.0, false)
                end
                SetPedComponentVariation(PlayerPedId(), componentScroller, 0, 240, 0)
                SetPedComponentVariation(PlayerPedId(), componentScroller, subComponentScroller, textureScroller, paletteScroller)
                textureScroller = 0
                paletteScroller = 0
            end
        end)
        Menu.addOption("clothing_customise", function()
            local textureMax = 0
            if componentScroller == 2 then textureMax = GetNumHairColors() else textureMax = GetNumberOfPedTextureVariations(PlayerPedId(), componentScroller, subComponentScroller) end
            if(Menu.ScrollBarInt("Textures", textureScroller, textureMax, function(cb)  textureScroller = cb end)) then
                if componentScroller == 2 then
                    SetPedComponentVariation(PlayerPedId(), componentScroller, subComponentScroller, 0, 1)
                    SetPedHairColor(PlayerPedId(), textureScroller, textureScroller)
                    player_data.clothing.textures[3] = textureScroller
                else
                    SetPedComponentVariation(PlayerPedId(), componentScroller, subComponentScroller, textureScroller, paletteScroller)
                end
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarInt("Colour Palette", paletteScroller, 2, function(cb)  paletteScroller = cb end)) then
                SetPedComponentVariation(PlayerPedId(), componentScroller, subComponentScroller, textureScroller, paletteScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.Option("Remove Undershirt"))then
                SetPedComponentVariation(PlayerPedId(), 8, 0, 240, 0)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.Option("Randomize"))then
                SetPedRandomComponentVariation(PlayerPedId(), true)
            end
        end)
    else
        componentScroller = 0
        subComponentScroller = GetPedDrawableVariation(PlayerPedId(), componentScroller)
        textureScroller = GetPedTextureVariation(PlayerPedId(), componentScroller)
        paletteScroller = GetPedPaletteVariation(PlayerPedId(), componentScroller)
        Menu.addOption("clothing_customise", function()
            local precomponentTable = {"Head","No idea","Hair","Shirts","Pants","No idea","No idea","No idea","Necklace & Ties","No idea","No idea","No idea"}
            local componentTable = {}
            for i = 0, 11 do
                if GetNumberOfPedDrawableVariations(PlayerPedId(), i) ~= 0 and GetNumberOfPedDrawableVariations(PlayerPedId(), i) ~= false then
                    componentTable[i+1] = precomponentTable[i+1]
                else
                    componentTable[i+1] = "Empty slot"
                end
            end
            if(Menu.ScrollBarString(componentTable, componentScroller, function(cb)  componentScroller = cb end)) then
                subComponentScroller = GetPedDrawableVariation(PlayerPedId(), componentScroller)
                textureScroller = GetPedTextureVariation(PlayerPedId(), componentScroller)
                paletteScroller = GetPedPaletteVariation(PlayerPedId(), componentScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarInt("Components", subComponentScroller, GetNumberOfPedDrawableVariations(PlayerPedId(), componentScroller), function(cb)  subComponentScroller = cb end)) then
                SetPedComponentVariation(PlayerPedId(), componentScroller, 0, 240, 0)
                SetPedComponentVariation(PlayerPedId(), componentScroller, subComponentScroller, textureScroller, paletteScroller)
                textureScroller = 0
                paletteScroller = 0
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarInt("Textures", textureScroller, GetNumberOfPedTextureVariations(PlayerPedId(), componentScroller, subComponentScroller), function(cb)  textureScroller = cb end)) then
                if componentScroller == 2 then player_data.clothing.textures[3] = textureScroller end
                SetPedComponentVariation(PlayerPedId(), componentScroller, subComponentScroller, textureScroller, paletteScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarInt("Colour Palette", paletteScroller, 2, function(cb)  paletteScroller = cb end)) then
                SetPedComponentVariation(PlayerPedId(), componentScroller, subComponentScroller, textureScroller, paletteScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.Option("Randomize"))then
                SetPedRandomComponentVariation(PlayerPedId(), true)
            end
        end)
    end
end

function accessories(title)
    Menu.SetupMenu("clothing_accessories", title)
    Menu.Switch("clothing_main", "clothing_accessories")
    if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") or GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
        componentScroller = 0
        subComponentScroller = GetPedPropIndex(PlayerPedId(), componentScroller)
        textureScroller = GetPedPropTextureIndex(PlayerPedId(), componentScroller)
        Menu.addOption("clothing_accessories", function()
            if(Menu.ScrollBarString({"Hats/Helmets","Glasses","Earrings","Empty slot","Empty slot","Empty slot","Left Wrist","Right Wrist"}, componentScroller, function(cb)  componentScroller = cb end)) then
                subComponentScroller = GetPedPropIndex(PlayerPedId(), componentScroller)
                textureScroller = GetPedPropTextureIndex(PlayerPedId(), componentScroller)
            end
        end)
        Menu.addOption("clothing_accessories", function()
            if(Menu.ScrollBarInt("Components", subComponentScroller, GetNumberOfPedPropDrawableVariations(PlayerPedId(), componentScroller), function(cb)  subComponentScroller = cb end)) then
                SetPedPropIndex(PlayerPedId(), componentScroller, 0, 240, 0)
                SetPedPropIndex(PlayerPedId(), componentScroller, subComponentScroller, textureScroller, false)
                textureScroller = 0
            end
        end)
        Menu.addOption("clothing_accessories", function()
            if(Menu.ScrollBarInt("Textures", textureScroller, GetNumberOfPedPropTextureVariations(PlayerPedId(), componentScroller, subComponentScroller), function(cb)  textureScroller = cb end)) then
                SetPedPropIndex(PlayerPedId(), componentScroller, subComponentScroller, textureScroller, false)
            end
        end)
        Menu.addOption("clothing_accessories", function()
            if(Menu.ScrollBarStringSelect({"Remove helmets","Remove glasses","Remove earrings","Remove left wrist","Remove right wrist"}, removeScroller, function(cb)  removeScroller = cb end)) then
                if removeScroller ~= 3 and removeScroller ~= 4 then
                    ClearPedProp(PlayerPedId(), tonumber(removeScroller))
                elseif removeScroller == 3 then
                    ClearPedProp(PlayerPedId(), 6)
                else
                    ClearPedProp(PlayerPedId(), 7)
                end
            end
        end)
        Menu.addOption("clothing_accessories", function()
            if(Menu.Option("Randomize"))then
                SetPedRandomProps(PlayerPedId())
            end
        end)
    else
        local precomponentTable = {"Hats/Helmets","Glasses","Earrings","Empty slot","Empty slot","Empty slot","Left Wrist","Right Wrist"}
        local componentTable = {}
        for i = 0, 7 do
            if GetNumberOfPedPropDrawableVariations(PlayerPedId(), i) ~= 0 and GetNumberOfPedPropDrawableVariations(PlayerPedId(), i) ~= false then
                componentTable[i+1] = precomponentTable[i+1]
            else
                componentTable[i+1] = "Empty slot"
            end
        end
        componentScroller = 0
        subComponentScroller = GetPedDrawableVariation(PlayerPedId(), componentScroller)
        textureScroller = GetPedTextureVariation(PlayerPedId(), componentScroller)
        Menu.addOption("clothing_accessories", function()
            if(Menu.ScrollBarString(componentTable, componentScroller, function(cb)  componentScroller = cb end)) then
                subComponentScroller = GetPedPropIndex(PlayerPedId(), componentScroller)
                textureScroller = GetPedPropTextureIndex(PlayerPedId(), componentScroller)
            end
        end)
        Menu.addOption("clothing_accessories", function()
            if(Menu.ScrollBarInt("Components", subComponentScroller, GetNumberOfPedPropDrawableVariations(PlayerPedId(), componentScroller), function(cb)  subComponentScroller = cb end)) then
                SetPedPropIndex(PlayerPedId(), componentScroller, 0, 240, 0)
                SetPedPropIndex(PlayerPedId(), componentScroller, subComponentScroller, textureScroller, false)
                textureScroller = 0
            end
        end)
        Menu.addOption("clothing_accessories", function()
            if(Menu.ScrollBarInt("Textures", textureScroller, GetNumberOfPedTextureVariations(PlayerPedId(), componentScroller, subComponentScroller), function(cb)  textureScroller = cb end)) then
                SetPedPropIndex(PlayerPedId(), componentScroller, subComponentScroller, textureScroller, false)
            end
        end)
        Menu.addOption("clothing_accessories", function()
            if(Menu.ScrollBarStringSelect({"Remove helmets","Remove glasses","Remove earrings","Remove left wrist","Remove right wrist"}, removeScroller, function(cb)  removeScroller = cb end)) then
                if removeScroller ~= 3 and removeScroller ~= 4 then
                    ClearPedProp(PlayerPedId(), tonumber(removeScroller))
                elseif removeScroller == 3 then
                    ClearPedProp(PlayerPedId(), 6)
                else
                    ClearPedProp(PlayerPedId(), 7)
                end
            end
        end)
        Menu.addOption("clothing_accessories", function()
            if(Menu.Option("Randomize"))then
                SetPedRandomProps(PlayerPedId())
            end
        end)
    end
end

function overlays(title)
    Menu.SetupMenu("clothing_overlays", title)
    Menu.Switch("clothing_main", "clothing_overlays")
    if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") or GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
        componentScroller = 0
        subComponentScroller = GetPedHeadOverlayValue(PlayerPedId(), componentScroller)
        Menu.addOption("clothing_overlays", function()
            if(Menu.ScrollBarString({"Blemishes","Facial Hair","Eyebrows","Ageing","Makeup","Blush","Complexion","Sun Damage","Lipstick","Moles/Freckles","Chest hair","Body blemishes","Add Body blemishes"}, componentScroller, function(cb)  componentScroller = cb end)) then
                subComponentScroller = GetPedHeadOverlayValue(PlayerPedId(), componentScroller)
            end
        end)
        Menu.addOption("clothing_overlays", function()
            if(Menu.ScrollBarInt("Components", subComponentScroller, 60, function(cb)  subComponentScroller = cb end)) then
                SetPedHeadOverlay(PlayerPedId(), componentScroller, subComponentScroller, 1.0)
                opacityScroller = 1.0
            end
        end)
        Menu.addOption("clothing_overlays", function()
            if(Menu.ScrollBarInt("Opacity", opacityScroller, 10, function(cb)  opacityScroller = cb end)) then
                SetPedHeadOverlay(PlayerPedId(), componentScroller, subComponentScroller, tonumber(opacityScroller/10))
				if not player_data.overlays then
					player_data.overlays = {}
					player_data.overlays.opacity = {}
				end
				if not player_data.overlays.opacity then
					player_data.overlays.opacity = {}
				end
                player_data.overlays.opacity[componentScroller+1] = tonumber(opacityScroller/10)
            end
        end)
        Menu.addOption("clothing_overlays", function()
            if(Menu.ScrollBarInt("Colours", colourScroller, 63, function(cb)  colourScroller = cb end)) then
                local colourType = 0
                if componentScroller == 1 or componentScroller == 2 or componentScroller == 10 then colourType = 1 elseif componentScroller == 5 or componentScroller == 8 then colourType = 2 else colourType = 0 end
                SetPedHeadOverlayColor(PlayerPedId(), componentScroller, colourType, colourScroller, colourScroller)
				if not player_data.overlays then
					player_data.overlays = {}
					player_data.overlays.colours = {}
				end
				if not player_data.overlays.colours then
					player_data.overlays.colours = {}
				end
                player_data.overlays.colours[componentScroller+1] = {colourType = colourType, colour = colourScroller}
            end
        end)
    else
    end
end

--[[
    -- Type: Function
    -- Name: save
    -- Use: Persists current outfit to server
    -- Created: 2024-09-10
    -- By: VSSVSSN
--]]
function save()
    if not player_data then player_data = {} end
    local ped = getPed()
    player_data.model = GetEntityModel(ped)
    player_data.new = false
	if not player_data.clothing then
		player_data.clothing = {}
		player_data.clothing.drawables = {}
		player_data.clothing.textures = {}
		player_data.clothing.palette = {}
	end
    for i = 0, 11 do
        player_data.clothing.drawables[i+1] = GetPedDrawableVariation(ped, i)
        if i ~= 2 then
            player_data.clothing.textures[i+1] = GetPedTextureVariation(ped, i)
        end
        player_data.clothing.palette[i+1] = GetPedPaletteVariation(ped, i)
    end
	
	if not player_data.props then
		player_data.props = {}
		player_data.props.drawables = {}
		player_data.props.textures = {}
	end
    for i = 0, 7 do
        player_data.props.drawables[i+1] = GetPedPropIndex(ped, i)
        player_data.props.textures[i+1] = GetPedPropTextureIndex(ped, i)
    end
	
	if not player_data.overlays then
		player_data.overlays = {}
		player_data.overlays.drawables = {}
	end
    for i = 0, 12 do
        player_data.overlays.drawables[i+1] = GetPedHeadOverlayValue(ped, i)
    end

    if player_data.clothing.drawables[12] == 55 and GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then player_data.clothing.drawables[12] = 56 SetPedComponentVariation(ped, 11, 56, 0, 2) end
    if player_data.clothing.drawables[12] == 48 and GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then player_data.clothing.drawables[12] = 49 SetPedComponentVariation(ped, 11, 49, 0, 2) end

    TriggerServerEvent("clothes:save", player_data)
end

--[[
    -- Type: Function
    -- Name: GetOutfit
    -- Use: Returns current outfit data without saving
    -- Created: 2024-09-10
    -- By: VSSVSSN
--]]
function GetOutfit()
    local ped = getPed()
    player_data.model = GetEntityModel(ped)
    player_data.new = false
	if not player_data.clothing then
		player_data.clothing = {}
		player_data.clothing.drawables = {}
		player_data.clothing.textures = {}
		player_data.clothing.palette = {}
	end
    for i = 0, 11 do
        player_data.clothing.drawables[i+1] = GetPedDrawableVariation(ped, i)
        if i ~= 2 then
            player_data.clothing.textures[i+1] = GetPedTextureVariation(ped, i)
        end
        player_data.clothing.palette[i+1] = GetPedPaletteVariation(ped, i)
    end
	
	if not player_data.props then
		player_data.props = {}
		player_data.props.drawables = {}
		player_data.props.textures = {}
	end
    for i = 0, 7 do
        player_data.props.drawables[i+1] = GetPedPropIndex(ped, i)
        player_data.props.textures[i+1] = GetPedPropTextureIndex(ped, i)
    end
	
	if not player_data.overlays then
		player_data.overlays = {}
		player_data.overlays.drawables = {}
	end
    for i = 0, 12 do
        player_data.overlays.drawables[i+1] = GetPedHeadOverlayValue(ped, i)
    end

    if player_data.clothing.drawables[12] == 55 and GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then player_data.clothing.drawables[12] = 56 SetPedComponentVariation(ped, 11, 56, 0, 2) end
    if player_data.clothing.drawables[12] == 48 and GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then player_data.clothing.drawables[12] = 49 SetPedComponentVariation(ped, 11, 49, 0, 2) end

    return player_data
end

--[[
    -- Type: Function
    -- Name: DisplayHelpText
    -- Use: Renders helper text on screen
    -- Created: 2024-09-10
    -- By: VSSVSSN
--]]
function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

--[[
    -- Type: Event
    -- Name: clothes:changemodel
    -- Use: Applies a new model to the player
    -- Created: 2024-09-10
    -- By: VSSVSSN
--]]
AddEventHandler("clothes:changemodel", function(skin)
    local ped = getPed()
    local health = GetEntityHealth(ped)
    local model = GetHashKey(skin)
    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end
        SetPlayerModel(PlayerId(), model)
        if model ~= GetHashKey("mp_f_freemode_01") and model ~= GetHashKey("mp_m_freemode_01") then
            SetPedRandomComponentVariation(ped, true)
        else
            SetPedComponentVariation(ped, 11, 0, 240, 0)
            SetPedComponentVariation(ped, 8, 0, 240, 0)
            SetPedComponentVariation(ped, 11, 6, 1, 0)
        end
        SetModelAsNoLongerNeeded(model)
    end
    TriggerEvent('fsn_criminalmisc:weapons:equip')
    SetEntityHealth(ped, health)
end)

local savingWeapons = {
  "WEAPON_KNIFE",
  "WEAPON_NIGHTSTICK",
  "WEAPON_HAMMER",
  "WEAPON_BAT",
  "WEAPON_GOLFCLUB",
  "WEAPON_CROWBAR",
  "WEAPON_PISTOL",
  "WEAPON_COMBATPISTOL",
  "WEAPON_APPISTOL",
  "WEAPON_PISTOL50",
  "WEAPON_MICROSMG",
  "WEAPON_SMG",
  "WEAPON_ASSAULTSMG",
  "WEAPON_ASSAULTRIFLE",
  "WEAPON_CARBINERIFLE",
  "WEAPON_ADVANCEDRIFLE",
  "WEAPON_MG",
  "WEAPON_COMBATMG",
  "WEAPON_PUMPSHOTGUN",
  "WEAPON_SAWNOFFSHOTGUN",
  "WEAPON_ASSAULTSHOTGUN",
  "WEAPON_BULLPUPSHOTGUN",
  "WEAPON_STUNGUN",
  "WEAPON_SNIPERRIFLE",
  "WEAPON_SMOKEGRENADE",
  "WEAPON_BZGAS",
  "WEAPON_MOLOTOV",
  "WEAPON_FIREEXTINGUISHER",
  "WEAPON_PETROLCAN",
  "WEAPON_SNSPISTOL",
  "WEAPON_SPECIALCARBINE",
  "WEAPON_HEAVYPISTOL",
  "WEAPON_BULLPUPRIFLE",
  "WEAPON_HOMINGLAUNCHER",
  "WEAPON_PROXMINE",
  "WEAPON_SNOWBALL",
  "WEAPON_VINTAGEPISTOL",
  "WEAPON_DAGGER",
  "WEAPON_FIREWORK",
  "WEAPON_MUSKET",
  "WEAPON_MARKSMANRIFLE",
  "WEAPON_HEAVYSHOTGUN",
  "WEAPON_GUSENBERG",
  "WEAPON_HATCHET",
  "WEAPON_COMBATPDW",
  "WEAPON_KNUCKLE",
  "WEAPON_MARKSMANPISTOL",
  "WEAPON_BOTTLE",
  "WEAPON_FLAREGUN",
  "WEAPON_FLARE",
  "WEAPON_REVOLVER",
  "WEAPON_SWITCHBLADE",
  "WEAPON_MACHETE",
  "WEAPON_FLASHLIGHT",
  "WEAPON_MACHINEPISTOL",
  "WEAPON_DBSHOTGUN",
  "WEAPON_COMPACTRIFLE",
  "GADGET_PARACHUTE"
}

RegisterNetEvent("clothes:spawn")
AddEventHandler("clothes:spawn", function(data)
    local ped = getPed()
    local helf = GetEntityHealth(ped)
    player_data = data
    if data and type(data) == "table" and data.model then
        local model = player_data.model
		-- weapon saving
        local pre_weapons = {}
        for i=1, #savingWeapons do
            if HasPedGotWeapon(ped, GetHashKey(savingWeapons[i])) then
                local ammo = GetAmmoInPedWeapon(ped, GetHashKey(savingWeapons[i]))
                pre_weapons[#pre_weapons+1] = {weaponHash = savingWeapons[i], ammo = ammo}
            end
        end

        if IsModelInCdimage(model) and IsModelValid(model) then
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            SetPlayerModel(PlayerId(), model)
            if model ~= GetHashKey("mp_f_freemode_01") and model ~= GetHashKey("mp_m_freemode_01") then
                SetPedRandomComponentVariation(ped, true)
            else
                SetPedComponentVariation(ped, 11, 0, 240, 0)
                SetPedComponentVariation(ped, 8, 0, 240, 0)
                SetPedComponentVariation(ped, 11, 6, 1, 0)
            end
            SetModelAsNoLongerNeeded(model)
            if not player_data.new then
                TriggerEvent("clothes:setComponents")
            else
                TriggerServerEvent("clothes:loaded")
            end
        end
    else
        TriggerEvent('clothes:firstspawn')
        print('fsn_clothing: no clothing data????')
    end
    TriggerEvent('fsn_criminalmisc:weapons:equip')
    SetPedSuffersCriticalHits(ped,false)
    SetEntityHealth(ped, helf)
end)


AddEventHandler("clothes:setComponents", function()
    local ped = getPed()
    local helf = GetEntityHealth(ped)
    if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") or GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
        for i = 0, 11 do
            if i == 0 then
                SetPedHeadBlendData(ped, player_data.clothing.drawables[i+1], player_data.clothing.drawables[i+1], 0,player_data.clothing.drawables[i+1], player_data.clothing.drawables[i+1], 0, 0.5, 0.5, 0.0, false)
            elseif i == 2 then
                SetPedComponentVariation(ped, i, player_data.clothing.drawables[i+1], 0, 1)
                SetPedHairColor(ped, player_data.clothing.textures[i+1], player_data.clothing.textures[i+1])
            else
                SetPedComponentVariation(ped, i, player_data.clothing.drawables[i+1], player_data.clothing.textures[i+1], player_data.clothing.palette[i+1])
            end
        end
        for i = 0, 7 do
            SetPedPropIndex(ped, i, player_data.props.drawables[i+1], player_data.props.textures[i+1], false)
        end
        if player_data.overlays then
            for i = 0, 12 do
                local draw = player_data.overlays.drawables and player_data.overlays.drawables[i+1] or 0
                local opac = player_data.overlays.opacity and player_data.overlays.opacity[i+1] or 1.0
                SetPedHeadOverlay(ped, i, draw, opac)
                if player_data.overlays.colours and player_data.overlays.colours[i+1] then
                    local colour = player_data.overlays.colours[i+1]
                    SetPedHeadOverlayColor(ped, i, colour.colourType or 0, colour.colour or 0, colour.colour or 0)
                end
            end
        end
    else
        for i = 0, 11 do
            SetPedComponentVariation(ped, i, player_data.clothing.drawables[i+1], player_data.clothing.textures[i+1],player_data.clothing.palette[i+1])
        end
        for i = 0, 7 do
            SetPedPropIndex(ped, i, player_data.props.drawables[i+1], player_data.props.textures[i+1], false)
        end
    end
    TriggerServerEvent("clothes:loaded")
    SetEntityHealth(ped, helf)
end)

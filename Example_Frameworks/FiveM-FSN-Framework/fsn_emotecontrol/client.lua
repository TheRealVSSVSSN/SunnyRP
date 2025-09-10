--[[
    -- Type: Client Script
    -- Name: fsn_emotecontrol
    -- Use: Provides a configurable menu for playing scenarios and animations.
    -- Created: 2023-11-19
    -- By: VSSVSSN
--]]

-- control constants
local CTRL = {UP = 172, DOWN = 173, ENTER = 201, BACK = 177}

local function drawNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

-- basic menu implementation -------------------------------------------------
local Menu = {
    buttons = {},
    title = "",
    selection = 1,
    visible = false,
    parent = nil
}

local posX, posY = 0.1, 0.1
local width, height = 0.22, 0.04

function Menu:open(title, items, parent)
    self.title = title
    self.buttons = items
    self.selection = 1
    self.visible = true
    self.parent = parent
end

function Menu:close()
    self.visible = false
    self.parent = nil
end

local function drawText(x, y, text)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0, 0.35)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    DrawText(x, y)
end

function Menu:render()
    if not self.visible then return end

    -- title
    DrawRect(posX + width / 2, posY - height, width, height, 0, 0, 0, 180)
    drawText(posX + width / 2, posY - height - 0.012, string.upper(self.title))

    for i, btn in ipairs(self.buttons) do
        local y = posY + (i - 1) * height
        local active = (i == self.selection)
        local r, g, b, a = 0, 0, 0, active and 220 or 120
        DrawRect(posX + width / 2, y, width, height, r, g, b, a)
        drawText(posX + width / 2, y - 0.012, btn.label)
    end

    if IsControlJustPressed(0, CTRL.DOWN) then
        self.selection = self.selection % #self.buttons + 1
    elseif IsControlJustPressed(0, CTRL.UP) then
        self.selection = (self.selection - 2) % #self.buttons + 1
    elseif IsControlJustPressed(0, CTRL.ENTER) then
        local selected = self.buttons[self.selection]
        if selected and selected.action then
            selected.action(selected.args)
        end
    elseif IsControlJustPressed(0, CTRL.BACK) then
        if self.parent then
            self.parent()
        else
            self:close()
        end
    end
end

-- emote handling ------------------------------------------------------------
local function playAnimation(dict, anim, flag)
    local ped = PlayerPedId()
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
    if IsEntityPlayingAnim(ped, dict, anim, 3) then
        ClearPedTasks(ped)
        drawNotification("Animation stopped")
    else
        TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, flag or 1, 0.0, false, false, false)
        drawNotification("Animation started")
    end
end

local function playUpperAnimation(dict, anim)
    playAnimation(dict, anim, 49)
end

local function playScenario(scen)
    local ped = PlayerPedId()
    ClearPedTasks(ped)
    TaskStartScenarioInPlace(ped, scen, 0, true)
end

local function stopEmote()
    ClearPedTasks(PlayerPedId())
end

-- configuration -------------------------------------------------------------
local EMOTE_CATEGORIES = {
    {   name = 'Scenarios Part 1',
        items = {
            {label='Binoculars', type='scenario', data='WORLD_HUMAN_BINOCULARS'},
            {label='Slumped', type='scenario', data='WORLD_HUMAN_BUM_SLUMPED'},
            {label='Bummed', type='scenario', data='WORLD_HUMAN_BUM_STANDING'},
            {label='Cheering', type='scenario', data='WORLD_HUMAN_CHEERING'},
            {label='Drinking', type='scenario', data='WORLD_HUMAN_DRINKING'},
            {label='Use Map', type='scenario', data='WORLD_HUMAN_TOURIST_MAP'},
            {label='Take Picture', type='scenario', data='WORLD_HUMAN_TOURIST_MOBILE'},
            {label='Record', type='scenario', data='WORLD_HUMAN_MOBILE_FILM_SHOCKING'},
            {label='Call', type='scenario', data='WORLD_HUMAN_STAND_MOBILE'},
            {label='Text', type='scenario', data='WORLD_HUMAN_STAND_MOBILE_UPRIGHT'},
            {label='Phone Call', type='partial', data={'cellphone@','cellphone_call_listen_base'}},
            {label='Guard Idles', type='scenario', data='WORLD_HUMAN_GUARD_STAND'},
            {label='Hang Out', type='scenario', data='WORLD_HUMAN_HANG_OUT_STREET'},
            {label='Smoking', type='scenario', data='WORLD_HUMAN_SMOKING'},
            {label='Smoking Pot', type='scenario', data='WORLD_HUMAN_SMOKING_POT'},
        }
    },
    {   name = 'Scenarios Part 2',
        items = {
            {label='Sunbathe', type='scenario', data='WORLD_HUMAN_SUNBATHE'},
            {label='Sunbathe Back', type='scenario', data='WORLD_HUMAN_SUNBATHE_BACK'},
            {label='Random Yoga', type='scenario', data='WORLD_HUMAN_YOGA'},
            {label='Jogging', type='scenario', data='WORLD_HUMAN_JOG_STANDING'},
            {label='Leaning', type='scenario', data='WORLD_HUMAN_LEANING'},
            {label='Cleaning', type='scenario', data='WORLD_HUMAN_MAID_CLEAN'},
            {label='Flexing', type='scenario', data='WORLD_HUMAN_MUSCLE_FLEX'},
            {label='Partying', type='scenario', data='WORLD_HUMAN_PARTYING'},
            {label='Sit', type='scenario', data='WORLD_HUMAN_PICNIC'},
            {label='High Class Idles', type='scenario', data='WORLD_HUMAN_PROSTITUTE_HIGH_CLASS'},
            {label='Low Class Idles', type='scenario', data='WORLD_HUMAN_PROSTITUTE_LOW_CLASS'},
            {label='Impatient', type='scenario', data='WORLD_HUMAN_STAND_IMPATIENT'},
            {label='Impatient 2', type='scenario', data='WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT'},
            {label='Impatient 3', type='scenario', data='PROP_HUMAN_STAND_IMPATIENT'},
        }
    },
    {   name = 'Scenarios Part 3',
        items = {
            {label='Bum Rail', type='scenario', data='PROP_HUMAN_BUM_SHOPPING_CART'},
            {label='Chin Ups', type='scenario', data='PROP_HUMAN_MUSCLE_CHIN_UPS'},
            {label='Bench Press', type='scenario', data='PROP_HUMAN_SEAT_MUSCLE_BENCH_PRESS'},
            {label='Sunlounger', type='scenario', data='PROP_HUMAN_SEAT_SUNLOUNGER'},
            {label='Kneel', type='scenario', data='CODE_HUMAN_MEDIC_KNEEL'},
            {label='Fast Kneel', type='scenario', data='CODE_HUMAN_MEDIC_TEND_TO_DEAD'},
        }
    },
    {   name = 'Job Scenarios',
        items = {
            {label='Cop Idles', type='scenario', data='WORLD_HUMAN_COP_IDLES'},
            {label='Write on Notepad', type='scenario', data='CODE_HUMAN_MEDIC_TIME_OF_DEATH'},
            {label='CPR', type='partial', data={'missheistfbi3b_ig8_2', 'cpr_loop_paramedic'}},
            {label='CPR 2', type='anim', data={'missheistfbi3b_ig8_2', 'cpr_loop_paramedic'}},
            {label='Human Statue', type='scenario', data='WORLD_HUMAN_HUMAN_STATUE'},
        }
    },
    {   name = 'Friendly',
        items = {
            {label='Wave 1', type='partial', data={'random@car_thief@victimpoints_ig_3', 'arms_waving'}},
            {label='Wave 2', type='partial', data={'gestures@m@standing@casual', 'gesture_hello'}},
            {label='Hug 1', type='anim', data={'mp_ped_interaction', 'hugs_guy_a'}},
            {label='Hug 2', type='anim', data={'mp_ped_interaction', 'hugs_guy_b'}},
            {label='Kiss 1', type='anim', data={'mp_ped_interaction', 'kisses_guy_a'}},
            {label='Kiss 2', type='anim', data={'mp_ped_interaction', 'kisses_guy_b'}},
            {label='Pet Doggo', type='anim', data={'creatures@rottweiler@tricks@', 'petting_franklin'}},
        }
    },
    {   name = 'Animations',
        items = {
            {label='Cross Arms 1', type='anim', data={'amb@world_human_hang_out_street@male_c@base','base'}},
            {label='Cross Arms 2', type='anim', data={'amb@world_human_hang_out_street@female_arms_crossed@base','base'}},
            {label='One Hand Middle Finger', type='anim', data={'anim@mp_player_intselfiethe_bird','idle_a'}},
            {label='Cross Arms 4', type='anim', data={'amb@world_human_hang_out_street@female_arms_crossed@idle_a','idle_a'}},
            {label='Cross Arms 5', type='anim', data={'missfbi_s4mop','guard_idle_a'}},
            {label='Cross Arms 6', type='anim', data={'oddjobs@assassinate@construction@','unarmed_fold_arms'}},
            {label='Arse Pick', type='anim', data={'mp_player_int_upperarse_pick','mp_player_int_arse_pick'}},
            {label='Fail Fish', type='anim', data={'anim@mp_player_intupperface_palm','idle_a'}},
        }
    },
    {   name = 'Male Dances',
        items = {
            {label='Dance 1', type='partial', data={'misschinese2_crystalmazemcs1_cs', 'dance_loop_tao'}},
            {label='Dance 2', type='anim', data={'move_clown@p_m_two_idles@', 'fidget_short_dance'}},
            {label='Dance 3', type='anim', data={'special_ped@mountain_dancer@monologue_3@monologue_3a', 'mnt_dnc_buttwag'}},
            {label='Dance 4', type='anim', data={'missfbi3_sniping','dance_m_default'}},
            {label='Dance 5', type='partial', data={'anim@mp_player_intcelebrationfemale@oh_snap','oh_snap'}},
            {label='Dance 6', type='partial', data={'anim@mp_player_intcelebrationfemale@raise_the_roof','raise_the_roof'}},
            {label='Dance 7', type='partial', data={'anim@mp_player_intcelebrationfemale@find_the_fish','find_the_fish'}},
        }
    },
    {   name = 'Female Dances',
        items = {
            {label='Dance 1', type='anim', data={'mini@strip_club@private_dance@part1','priv_dance_p1'}},
            {label='Dance 2', type='anim', data={'mini@strip_club@private_dance@part2','priv_dance_p2'}},
            {label='Dance 3', type='anim', data={'mini@strip_club@private_dance@part3','priv_dance_p3'}},
            {label='Dance 4', type='anim', data={'mp_am_stripper','lap_dance_girl'}},
            {label='Pole Dance', type='anim', data={'mini@strip_club@pole_dance@pole_dance1','pd_dance_01'}},
        }
    },
    {   name = 'Sit',
        items = {
            {label='Sit 1', type='anim', data={'rcm_barry3','barry_3_sit_loop'}},
            {label='Sit 2', type='anim', data={'switch@michael@sitting','idle'}},
            {label='Sit 3', type='anim', data={'switch@michael@restaurant','001510_02_gc_mics3_ig_1_base_amanda'}},
            {label='Sit 4', type='anim', data={'timetable@amanda@ig_12','amanda_idle_a'}},
            {label='Sit 5', type='anim', data={'amb@prop_human_seat_deckchair@female@idle_a','idle_a'}},
            {label='Sit 6', type='anim', data={'amb@world_human_picnic@female@idle_a','idle_b'}},
            {label='Sit 7', type='anim', data={'amb@world_human_picnic@male@idle_a','idle_b'}},
        }
    },
    {   name = 'Sleep',
        items = {
            {label='Sleep 1', type='anim', data={'timetable@tracy@sleep@', 'idle_c'}},
        }
    },
    {   name = 'Fitness',
        items = {
            {label='Meditate', type='anim', data={'rcmcollect_paperleadinout@', 'meditiate_idle'}},
            {label='Situps', type='anim', data={'amb@world_human_sit_ups@male@base','base'}},
            {label='Pushups', type='anim', data={'amb@world_human_push_ups@male@base','base'}},
            {label='Yoga 1', type='anim', data={'amb@world_human_yoga@female@base','base_a'}},
            {label='Yoga 2', type='anim', data={'amb@world_human_yoga@female@base','base_b'}},
            {label='Yoga 3', type='anim', data={'amb@world_human_yoga@female@base','base_c'}},
        }
    },
    {   name = 'Surrender',
        items = {
            {label='Hands Up', type='partial', data={'random@mugging3','handsup_standing_base'}},
            {label='Hands Behind Back', type='partial', data={'mp_arresting','idle'}},
            {label='Cry', type='anim', data={'missfam4leadinoutmcs2','tracy_loop'}},
        }
    },
    {   name = 'Others',
        items = {
            {label='Shake Fist', type='partial', data={'amb@code_human_in_car_mp_actions@dance@bodhi@ds@base','idle_a_fp'}},
            {label='Shake Butt', type='anim', data={'switch@trevor@mocks_lapdance','001443_01_trvs_28_idle_stripper'}},
            {label='Pee', type='anim', data={'misscarsteal2peeing','peeing_loop'}},
            {label='Poo', type='anim', data={'missfbi3ig_0','shit_loop_trev'}},
        }
    },
}

-- menu callbacks ------------------------------------------------------------
local function playEmoteFromMenu(data)
    local cat = EMOTE_CATEGORIES[data.category]
    local item = cat.items[data.index]
    if item.type == 'scenario' then
        playScenario(item.data)
    elseif item.type == 'partial' then
        playUpperAnimation(item.data[1], item.data[2])
    else
        playAnimation(item.data[1], item.data[2], item.flag)
    end
end

local function openCategory(index)
    local cat = EMOTE_CATEGORIES[index]
    local items = {}
    for i, v in ipairs(cat.items) do
        items[#items+1] = {label = v.label, action = playEmoteFromMenu, args = {category=index, index=i}}
    end
    items[#items+1] = {label = 'Back', action = openMainMenu}
    Menu:open(cat.name, items, openMainMenu)
end

function openMainMenu()
    local items = {
        {label = 'Stop Animation', action = stopEmote}
    }
    for i, cat in ipairs(EMOTE_CATEGORIES) do
        table.insert(items, {label = cat.name, action = openCategory, args = i})
    end
    Menu:open('Animations', items)
end

-- command -------------------------------------------------------------------
RegisterCommand('emotes', function()
    if Menu.visible then
        Menu:close()
    else
        openMainMenu()
    end
end)
RegisterKeyMapping('emotes', 'Open emote menu', 'keyboard', 'F3')

-- external play event -------------------------------------------------------
RegisterNetEvent('fsn_emotecontrol:play')
AddEventHandler('fsn_emotecontrol:play', function(type, dict, anim)
    if type == 'scenario' then
        playScenario(dict)
    elseif type == 'partial' then
        playUpperAnimation(dict, anim)
    else
        playAnimation(dict, anim)
    end
end)

-- render loop ---------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        Menu:render()
    end
end)


local QBCore = exports['qb-core']:GetCoreObject()


local function LoadAnimationDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(1)
    end
end

local function OpenDoorAnimation()
    local ped = PlayerPedId()
    LoadAnimationDict("anim@heists@keycard@") 
    TaskPlayAnim(ped, "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0)
    Wait(400)
    ClearPedTasks(ped)
end

local function Enterlab(coords)
    local ped = PlayerPedId()
    OpenDoorAnimation()
    Wait(500)
    DoScreenFadeOut(250)
    Wait(250)
    SetEntityCoords(ped, coords.x, coords.y, coords.z - 0.98)
    SetEntityHeading(ped, coords.w)
    Wait(1000)
    DoScreenFadeIn(250)
end

local function Leavelab(coords, labname)
    local ped = PlayerPedId()
    local dict = "mp_heists@keypad@"
    local anim = "idle_a"
    local flag = 0
    local keypad = {coords = {x = 996.92, y = -3199.85, z = -36.4, h = 94.5, r = 1.0}}
    if labname == "methlab" then
        SetEntityCoords(ped, keypad.coords.x, keypad.coords.y, keypad.coords.z - 0.98)
        SetEntityHeading(ped, keypad.coords.h)
        LoadAnimationDict(dict) 
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, flag, 0, false, false, false)
        Wait(2500)
        TaskPlayAnim(ped, dict, "exit", 2.0, 2.0, -1, flag, 0, false, false, false)
        Wait(1000)
        DoScreenFadeOut(250)
        Wait(250)
    else
        OpenDoorAnimation()
        Wait(500)
        DoScreenFadeOut(250)
        Wait(250)
    end
    SetEntityCoords(ped, coords.x, coords.y, coords.z - 0.98)
    SetEntityHeading(ped, coords.w)
    Wait(1000)
    DoScreenFadeIn(250)
end

function hasRequiredIngredients(requiredIngredients)
    for ingredient, quantity in pairs(requiredIngredients) do
        local hasItem = QBCore.Functions.HasItem(ingredient, quantity)
        if not hasItem then
            return false
        end
    end
    return true
end

function hasRequiredCokeIngredients(requiredIngredients)
    local firstIteration = true -- Variable to track if it's the first iteration
    for ingredient, quantity in pairs(requiredIngredients) do
        if not firstIteration then -- Check if it's not the first iteration
            local hasItem = QBCore.Functions.HasItem(ingredient, quantity)
            if not hasItem then
                return false
            end
        else
            firstIteration = false -- Update the variable to indicate it's no longer the first iteration
        end
    end
    return true
end


function HackUi(kind, whichone)
	local p = promise.new() -- Do not touch
    if kind == "ps-ui" then
        if whichone == "circle" then
            exports['ps-ui']:Circle(function(success)
                    p:resolve(success)
            end, Config.meth.psuiNumberOfCircles, Config.meth.psuiCircleMS)
        elseif whichone == "maze" then
            exports['ps-ui']:Maze(function(success)
                p:resolve(success)
            end, Config.meth.psuiMazeTime)
        elseif whichone == "varhack" then  
            exports['ps-ui']:VarHack(function(success)
                p:resolve(success)
            end, Config.meth.psuiNumberOfBlocks, Config.meth.psuiVarhackTime) -- Number of Blocks, Time (seconds)
        elseif whichone == "thermite" then  
            exports['ps-ui']:Thermite(function(success)
                p:resolve(success)
            end, Config.meth.psuiThermiteTime, Config.meth.psuiGridsize, Config.meth.psuiIncorrectBlocks) -- Time, Gridsize (5, 6, 7, 8, 9, 10), IncorrectBlocks
        elseif whichone == "scramble" then 
            exports['ps-ui']:Scrambler(function(success)
                p:resolve(success)
            end, Config.meth.psuiScrumbleType, Config.meth.psuiScrumbleTime, Config.meth.psuiScrumbleMirrored) -- Type (alphabet, numeric, alphanumeric, greek, braille, runes), Time (Seconds), Mirrored (0: Normal, 1: Normal + Mirrored 2: Mirrored only )
        end
    elseif kind == "boii_minigames" then
        if whichone == "anagram" then
            exports['boii_minigames']:anagram({
                style = Config.meth.anagramStyle, -- Style template
                loading_time = 5000, -- Total time to complete loading sequence in (ms)
                difficulty = Config.meth.anagramDifficulty, -- Game difficulty refer to `const word_lists` in `html/scripts/anagram/anagram.js`
                guesses = Config.meth.anagramGuesses, -- Amount of guesses until fail
                timer = Config.meth.anagramTimer -- Time allowed for guessing in (ms)
            }, function(success) -- Game callback
                p:resolve(success)
            end)
        elseif whichone == "button_mash" then
            exports['boii_minigames']:button_mash({
                style = Config.meth.button_mashStyle, -- Style template
                difficulty = Config.meth.button_mashDifficulty -- Difficulty; increasing the difficulty decreases the amount the notch increments on each keypress making the game harder to complete
            }, function(success) -- Game callback
                p:resolve(success)
            end)
        elseif whichone == "chip_hack" then
            exports['boii_minigames']:chip_hack({
                style = Config.meth.chip_hackStyle, -- Style template
                loading_time = 8000, -- Total time to complete loading sequence in (ms)
                chips = Config.meth.chip_hackAmount, -- Amount of chips required to find
                timer = Config.meth.chip_hackTimer -- Total allowed game time in (ms)
            }, function(success)
                p:resolve(success)
            end)
        elseif whichone == "hangman" then
            exports['boii_minigames']:hangman({
                style = Config.meth.hangmanStyle, -- Style template
                loading_time = 5000, -- Total time to complete loading sequence in (ms)
                difficulty = Config.meth.hangmanDifficulty, -- Game difficulty refer to `const word_lists` in `html/scripts/anagram/anagram.js`
                guesses = Config.meth.hangmanGuesses, -- Amount of guesses until fail
                timer = Config.meth.hangmanTimer -- Time allowed for guessing in (ms)
            }, function(success) -- Game callback
                p:resolve(success)
            end)
        elseif whichone == "key_drop" then
            exports['boii_minigames']:key_drop({
                style = Config.meth.key_dropStyle, -- Style template
                score_limit = Config.meth.key_dropscore_limit, -- Amount of keys needed for success
                miss_limit = Config.meth.key_dropmiss_limit, -- Amount of keys allowed to miss before fail
                fall_delay = Config.meth.key_dropfall_delay, -- Time taken for keys to fall from top to bottom in (ms)
                new_letter_delay = Config.meth.key_dropnew_letter_delay -- Time taken to drop a new key in (ms)
            }, function(success) -- Game callback
                p:resolve(success)
            end)
        elseif whichone == "pincode" then
            exports['boii_minigames']:pincode({
                style = Config.meth.pincodeStyle, -- Style template
                difficulty = Config.meth.pincodeDifficulty, -- Difficuly; increasing the value increases the amount of numbers in the pincode; level 1 = 4 number, level 2 = 5 numbers and so on // The ui will comfortably fit 10 numbers (level 6) this should be more than enough
                guesses = Config.meth.pincodeGuesses -- Amount of guesses allowed before fail
            }, function(success) -- Game callback
                p:resolve(success)
            end)
        elseif whichone == "safe_crack" then
            exports['boii_minigames']:safe_crack({
                style = Config.meth.safe_crackStyle, -- Style template
                difficulty = Config.meth.safe_crackDifficulty -- Difficuly; This increases the amount of lock a player needs to unlock this scuffs out a little above 6 locks I would suggest to use levels 1 - 5 only.
            }, function(success)
                p:resolve(success)
            end)
        elseif whichone == "wire_cut" then
            exports['boii_minigames']:wire_cut({
                style = Config.meth.wire_cutStyle, -- Style template
                timer = Config.meth.wire_cutTimer -- Time allowed to complete game in (ms)
            }, function(success)
                p:resolve(success)
            end)
        end
    end
    return Citizen.Await(p) -- Do not touch
end

CreateThread(function()
    for k, v in pairs(Config.labs) do
        exports['qb-target']:AddBoxZone(k..k, vec3(v.outside.x, v.outside.y, v.outside.z), 1.5, 1.5, {
            name = k..k,
            heading = 90.0,
            debugPoly = false,
            minZ = v.outside.z - 1,
            maxZ = v.outside.z + 1,
        }, {
            options = {
                {
                    icon = 'fa-solid fa-bolt',
                    label = Lang:t('label.enterlab'),
                    action = function()
                        TriggerEvent("tn-labs:cl:interactEnter",v)
                    end,
                    
                },
            },
            distance = 1.5
        })
    end
    for k, v in pairs(Config.labs) do
        exports['qb-target']:AddBoxZone(k, vec3(v.inside.x, v.inside.y, v.inside.z), 1.5, 1.5, {
            name = k,
            heading = 90.0,
            debugPoly = false,
            minZ = v.inside.z - 1,
            maxZ = v.inside.z + 1,
        }, {
            options = {
                {
                    icon = 'fa-solid fa-bolt',
                    label = Lang:t('label.leavelab'),
                    action = function()
                        Leavelab(v.outside, v.labname)
                    end,
                },
                {
                    icon = "fas fa-cut", 
                    label = Lang:t('label.changepasscode'),
                    canInteract = function()
                        if v.Security == "password" then return true else return false end
                    end,
                    action = function()
                        TriggerEvent("tn-labs:cl:changePasscode",v)
                    end,
                },
            },
            distance = 1.5
        })
    end
end)


RegisterNetEvent("tn-labs:cl:interactEnter", function(data)
    local LabMenu = {
        {
            header = data.labname,
            isMenuHeader = true
        }
    }
    LabMenu[#LabMenu + 1] = {
        header = Lang:t('menu.enterlabheader'),
        txt = Lang:t('menu.enterlabtext'),
        params = {
            event = "tn-labs:cl:enterAttempt",
            args = {
                data = data
            }
        }
    }
    LabMenu[#LabMenu + 1] = {
        header = Lang:t('menu.raidlockheader'),
        txt = Lang:t('menu.raidlocktext'),
        params = {
            event = "tn-labs:cl:raidLocker",
            args = {
                data = data
            }
        }
    }
    LabMenu[#LabMenu + 1] = {
        header = Lang:t('menu.exitHeader'),
        params = {
            event = "qb-menu:closeMenu"
        }
    }
    exports['qb-menu']:openMenu(LabMenu)
end)

RegisterNetEvent('tn-labs:cl:raidLocker', function(data)
    if QBCore.Functions.GetPlayerData().job.name == "police" then
        local hasItem = QBCore.Functions.HasItem("police_stormram")
        if HasItem then
            -- TODO animation and progressbar
            Enterlab(data.data.inside)
        else
            QBCore.Functions.Notify(Lang:t('error.missingstormram'), "error")
        end
    else
        QBCore.Functions.Notify(Lang:t('error.notpolice'), "error")
    end
end)

RegisterNetEvent('tn-labs:cl:enterAttempt', function(data)
    if data.data.Security == "password" then
        local keyboard, input = exports["l2s-password"]:Keyboard({
            header = "Password", 
            rows = {""}
        })
        QBCore.Functions.TriggerCallback('tn-labs:sv:getData', function(combination)
            if keyboard then
                --print(input)
               -- print(combination)
                if input == combination then
                    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
                    Enterlab(data.data.inside)
                else
                    QBCore.Functions.Notify(Lang:t('error.incorrectpassword'), 'error')
                end  
            end
        end, data.data.labname) 
    elseif data.data.Security == "keys" then
        local item = ""
        if data.data.labname == "methlab" then
            item = "methkey"
        elseif data.data.labname == "cokelab" then
            item = "cokekey"
        elseif data.data.labname == "weedlab" then
            item = "weedkey"
        end
        local hasItem = QBCore.Functions.HasItem(item)
        if hasItem then
            Enterlab(data.data.inside)
        else
            QBCore.Functions.Notify(Lang:t('error.missingkey'), "error")
        end
    elseif data.data.Security == "citizenid" then
        if data.data.citizenid[QBCore.Functions.GetPlayerData().citizenid] then
            Enterlab(data.data.inside)
        else
            QBCore.Functions.Notify(Lang:t('error.notauthorized'), "error")
        end
    elseif data.data.Security == "gang" then
        if data.data.gang[QBCore.Functions.GetPlayerData().gang.name] and QBCore.Functions.GetPlayerData().gang.grade.level >= data.data.gang[QBCore.Functions.GetPlayerData().gang.name] then
            Enterlab(data.data.inside)
        else
            QBCore.Functions.Notify(Lang:t('error.notauthorized'), "error")
        end
    elseif data.data.Security == "job" then
        if data.data.job[QBCore.Functions.GetPlayerData().job.name] and QBCore.Functions.GetPlayerData().job.grade.level >= data.data.job[QBCore.Functions.GetPlayerData().job.name] then
            Enterlab(data.data.inside)
        else
            QBCore.Functions.Notify(Lang:t('error.notauthorized'), "error")
        end
    end
end)

function checkPedClothes()
    local mask = GetPedDrawableVariation(PlayerPedId(), 1)
    local pants = GetPedDrawableVariation(PlayerPedId(), 4)
    local shirt = GetPedDrawableVariation(PlayerPedId(), 8)
    local jacket = GetPedDrawableVariation(PlayerPedId(), 11)
    local arms = GetPedDrawableVariation(PlayerPedId(), 3)
    local shoes = GetPedDrawableVariation(PlayerPedId(), 6)
    local accessoire = GetPedDrawableVariation(PlayerPedId(), 7)
    local hat = GetPedPropIndex(PlayerPedId(), 0)
    local isMale = IsPedModel(PlayerPedId(), 'mp_m_freemode_01')
    local isFeMale = IsPedModel(PlayerPedId(), 'mp_f_freemode_01')
    local other = IsPedModel(PlayerPedId(), 's_m_y_factory_01')
    local other2 = IsPedModel(PlayerPedId(), 's_f_y_factory_01')
    if other or other2 then return true end
    local config = (isMale and Config.meth.Outfits.male) or (isFeMale and Config.meth.Outfits.female)

    -- Check if each item matches the configuration
    return (
        mask == config.mask.item and
        GetPedTextureVariation(PlayerPedId(), 1) == config.mask.texture and
        arms == config.arms.item and
        GetPedTextureVariation(PlayerPedId(), 3) == config.arms.texture and
        shirt == config.shirt.item and
        GetPedTextureVariation(PlayerPedId(), 8) == config.shirt.texture and
        jacket == config.jacket.item and
        GetPedTextureVariation(PlayerPedId(), 11) == config.jacket.texture and
        pants == config.pants.item and
        GetPedTextureVariation(PlayerPedId(), 4) == config.pants.texture and
        shoes == config.shoes.item and
        GetPedTextureVariation(PlayerPedId(), 6) == config.shoes.texture and
        accessoire == config.accessories.item and
        GetPedTextureVariation(PlayerPedId(), 7) == config.accessories.texture and
        hat == config.hat.item and
        GetPedPropTextureIndex(PlayerPedId(), 0) == config.hat.texture
    )
end
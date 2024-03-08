local QBCore = exports['qb-core']:GetCoreObject()

local currentobject = nil
local haschangedclothes = false
local hummerani = false
local addmetharrayani = false
-- Target
CreateThread(function()
    for k, v in pairs(Config.meth.locations) do
        local options = {}
        for _, option in pairs(v.options) do
            print(option.label)
            options[#options + 1] = {
                event = option.event,
                icon = option.icon,
                label = option.label,
            }
        end

        exports['qb-target']:AddBoxZone(k, vec3(v.coords.x, v.coords.y, v.coords.z), 1.5, 1.5, {
            name = k,
            heading = 90.0,
            debugPoly = false,
            minZ = v.coords.z - 1,
            maxZ = v.coords.z + 1,
        },{
            options = options,
            distance = 1.5
        })
    end
end)

-- functions
local function startMixingMethAnimation()
    local animDict, animName = "anim@amb@business@meth@meth_monitoring_cooking@cooking@", "chemical_pour_long_cooker"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(10)
    end
    local ped = PlayerPedId()
    SetEntityCoords(ped, vector3(1005.773, -3200.402, -38.524))
    Citizen.Wait(1)
    local targetPosition = GetEntityCoords(ped)
    local animDuration = (GetAnimDuration(animDict, animName) - 40) * 1000
    FreezeEntityPosition(ped, true)
    local scenePos, sceneRot = vector3(1010.656, -3198.445, -38.925), vector3(0.0, 0.0, 0.0)
    local netScene = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene, animDict, animName, 1.5, -4.0, 1, 16, 1148846080, 0)
    local sacid = CreateObjectNoOffset(`bkr_prop_meth_sacid`, targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(sacid, netScene, animDict, "chemical_pour_long_sacid", 4.0, -8.0, 1)
    local ammonia = CreateObjectNoOffset(`bkr_prop_meth_ammonia`, targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(ammonia, netScene, animDict, "chemical_pour_long_ammonia", 4.0, -8.0, 1)
    local clipboard = CreateObjectNoOffset(`bkr_prop_fakeid_clipboard_01a`, targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(clipboard, netScene, animDict, "chemical_pour_long_clipboard", 4.0, -8.0, 1)
    local pencil = CreateObjectNoOffset(`prop_pencil_01`, targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(pencil, netScene, animDict, "chemical_pour_long_pencil", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(netScene)
    Citizen.Wait(animDuration)
    NetworkStopSynchronisedScene(netScene)
    DeleteObject(sacid)
    DeleteObject(ammonia)
    DeleteObject(clipboard)
    DeleteObject(pencil)
    RemoveAnimDict(animDict)
    FreezeEntityPosition(ped, false)
end

local function checkLabIngrediants()
    local p = promise.new()
    QBCore.Functions.TriggerCallback('tn-labs:sv:checkLabIngrediants', function(result)
        p:resolve(result)
    end)
    return Citizen.Await(p)
end

local function checkWaitTime()
    local p = promise.new()
    QBCore.Functions.TriggerCallback('tn-labs:sv:getRemainingTime', function(result)
        p:resolve(result)
    end)
    return Citizen.Await(p)
end

local function checkLabQuality()
    local p = promise.new()
    QBCore.Functions.TriggerCallback('tn-labs:sv:checkLabQuality', function(result)
        p:resolve(result)
    end)
    return Citizen.Await(p)
end

local function checkMethArrayCanPass()
    local p = promise.new()
    QBCore.Functions.TriggerCallback('tn-labs:sv:CheckCanPassMethArray', function(result)
        p:resolve(result)
    end)
    return Citizen.Await(p)
end

local function checkMethArrayAmount()
    local p = promise.new()
    QBCore.Functions.TriggerCallback('tn-labs:sv:CheckArraysCount', function(result)
        p:resolve(result)
    end)
    return Citizen.Await(p)
end

local function checkMethArrayAmountTwo()
    local p = promise.new()
    QBCore.Functions.TriggerCallback('tn-labs:sv:CheckArraysCountTwo', function(result)
        p:resolve(result)
    end)
    return Citizen.Await(p)
end

local function checkMethArrayAmountThree()
    local p = promise.new()
    QBCore.Functions.TriggerCallback('tn-labs:sv:CheckArraysCountThree', function(result)
        p:resolve(result)
    end)
    return Citizen.Await(p)
end

local function calculateIngredientQuality(value, perfectValue, rangeMin, rangeMax)
    local deviation = 100
    local result
    if value < rangeMin then
        deviation = rangeMin - value
    elseif value > rangeMax then
        deviation = value - rangeMax
    end

    if deviation < 7 then
        result = math.random(7,13)
    elseif deviation < 25 then
        result = math.random(2,7)
    else
        result = 0
    end

    if value >= rangeMin and value <= rangeMax then
        local indeviation = math.abs(value - perfectValue)
        print(indeviation)
        local variation = math.random(1, 9) / 10
        local perfectionScore = indeviation * variation
        print(perfectionScore)
        result = 100 - perfectionScore
    end
    print(result)
    return result
end

function calculateQuality(ingredient1, ingredient2, ingredient3, ingredient4)
    local quality1 = calculateIngredientQuality(ingredient1, 34, 32, 38)
    local quality2 = calculateIngredientQuality(ingredient2, 60, 55, 62)
    local quality3 = calculateIngredientQuality(ingredient3, 80, 70, 90)
    local quality4 = calculateIngredientQuality(ingredient4, 20, 19, 27)
    local totalQuality = (quality1 + quality2 + quality3 + quality4) * 0.25
    return math.floor(totalQuality)
end

local function PreloadAnimation(dick)
	RequestAnimDict(dick)
    while not HasAnimDictLoaded(dick) do
        Citizen.Wait(0)
    end
end

local function ChangeClothesAnim()
    PreloadAnimation('clothingshirt')
    TaskPlayAnim(PlayerPedId(), 'clothingshirt', 'try_shirt_positive_d', 8.0, 1.0, -1, 49, 0, false, false, false)
end

local function ApplyServicerSkin()
	if IsPedModel(PlayerPedId(), 'mp_m_freemode_01') then
        SetPedPropIndex(PlayerPedId(), 0 , Config.meth.Outfits.male.hat.item,Config.meth.Outfits.male.hat.texture, true)
        SetPedPropIndex(PlayerPedId(), 1 , Config.meth.Outfits.male.glass.item,Config.meth.Outfits.male.glass.texture, true)
		SetPedComponentVariation(PlayerPedId(), 1 , Config.meth.Outfits.male.mask.item,Config.meth.Outfits.male.mask.texture) -- Mask
		SetPedComponentVariation(PlayerPedId(), 4, Config.meth.Outfits.male.pants.item,Config.meth.Outfits.male.pants.texture) -- Pants
		SetPedComponentVariation(PlayerPedId(), 8 ,Config.meth.Outfits.male.shirt.item,Config.meth.Outfits.male.shirt.texture) -- Shirt
		SetPedComponentVariation(PlayerPedId(), 11 ,Config.meth.Outfits.male.jacket.item,Config.meth.Outfits.male.jacket.texture) -- Jacket
		SetPedComponentVariation(PlayerPedId(), 3 ,Config.meth.Outfits.male.arms.item,Config.meth.Outfits.male.arms.texture) -- Arms
		SetPedComponentVariation(PlayerPedId(), 6 ,Config.meth.Outfits.male.shoes.item,Config.meth.Outfits.male.shoes.texture) -- Shoes
		SetPedComponentVariation(PlayerPedId(), 7 ,Config.meth.Outfits.male.accessories.item,Config.meth.Outfits.male.accessories.texture) -- Accessory
	elseif IsPedModel(PlayerPedId(), 'mp_f_freemode_01') then
        SetPedPropIndex(PlayerPedId(), 0 , Config.meth.Outfits.male.hat.item,Config.meth.Outfits.male.hat.texture, true)
        SetPedPropIndex(PlayerPedId(), 1 , Config.meth.Outfits.male.glass.item,Config.meth.Outfits.male.glass.texture, true)
		SetPedComponentVariation(PlayerPedId(), 1 ,Config.meth.Outfits.female.mask.item,Config.meth.Outfits.female.mask.texture) -- Mask
		SetPedComponentVariation(PlayerPedId(), 4 ,Config.meth.Outfits.female.pants.item,Config.meth.Outfits.female.pants.texture) -- Pants
		SetPedComponentVariation(PlayerPedId(), 8 ,Config.meth.Outfits.female.shirt.item,Config.meth.Outfits.female.shirt.texture) -- Shirt
		SetPedComponentVariation(PlayerPedId(), 11 ,Config.meth.Outfits.female.jacket.item,Config.meth.Outfits.female.jacket.texture) -- Jacket
		SetPedComponentVariation(PlayerPedId(), 3 ,Config.meth.Outfits.female.arms.item,Config.meth.Outfits.female.arms.texture) -- Arms
		SetPedComponentVariation(PlayerPedId(), 6 ,Config.meth.Outfits.female.shoes.item,Config.meth.Outfits.female.shoes.texture) -- Shoes
		SetPedComponentVariation(PlayerPedId(), 7 ,Config.meth.Outfits.female.accessories.item,Config.meth.Outfits.female.accessories.texture) -- Accessory
    else
        if QBCore.Functions.GetPlayerData().charinfo.gender == 0 then
            local model = "s_m_y_factory_01"
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(20)
            end
            SetPlayerModel(PlayerId(), model)
            SetModelAsNoLongerNeeded(model)
        elseif QBCore.Functions.GetPlayerData().charinfo.gender == 1 then
            local model = "s_f_y_factory_01"
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(20)
            end
            SetPlayerModel(PlayerId(), model)
            SetModelAsNoLongerNeeded(model)
        end
	end
end

local function SpawnItem(prop,xPos,yPos,zPos,xRot,yRot,zRot)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    PreloadAnimation("anim@heists@box_carry@")
    TaskPlayAnim(ped, "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
    currentobject = CreateObject(GetHashKey(prop), coords.x, coords.y, coords.z,  true,  true, true)
    AttachEntityToEntity(currentobject, ped, GetPedBoneIndex(ped, 56604), xPos,yPos,zPos,xRot,yRot,zRot, true, true, false, true, 1, true)
end

local function MethEffect()
    local player = PlayerPedId()
    TriggerEvent('animations:client:EmoteCommandStart', {"cough"})
    if IsPedWalking(player) or IsPedRunning(player) then
        SetPedToRagdollWithFall(player, 2500, 4000, 1, GetEntityForwardVector(player), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    end
    Wait(5000)
    DoScreenFadeOut(1500)
    SetFlash(0, 0, 500, 7000, 500)
    ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 1.00)
    SetEntityHealth(player, GetEntityHealth(player) - 10)
    Wait(2000)
    SetTimecycleModifier('spectator5')
    SetPedMotionBlur(player, true)
    SetPedMovementClipset(player, 'MOVE_M@DRUNK@VERYDRUNK', true)
    SetPedIsDrunk(player, true)
    SetPedAccuracy(player, 0)
    SetFlash(0, 0, 500, 7000, 500)
    ShakeGameplayCam('DRUNK_SHAKE', 1.10)
    Wait(2000)
    DoScreenFadeIn(1800)
    if IsPedWalking(player) or IsPedRunning(player) then
        SetPedToRagdollWithFall(player, 2500, 4000, 1, GetEntityForwardVector(player), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    end
    SetFlash(0, 0, 500, 7000, 500)
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 1.20)
    Wait(2000)            
    Wait(10*6000) -- 10 mins
    DoScreenFadeOut(1400)
    SetFlash(0, 0, 500, 7000, 500)
    ShakeGameplayCam('DRUNK_SHAKE', 1.10)
    Wait(2000)  
    DoScreenFadeIn(1200)
    SetEntityHealth(player, GetEntityHealth(player) - 10)
    if IsPedWalking(player) or IsPedRunning(player) then
        SetPedToRagdollWithFall(player, 2500, 4000, 1, GetEntityForwardVector(player), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    end
    SetFlash(0, 0, 500, 7000, 500)
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 1.05)
    SetEntityHealth(player, GetEntityHealth(player) - 5)
    Wait(1000)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(player, 0)
    SetPedIsDrunk(player, false)
    SetPedMotionBlur(player, false)
end

RegisterNetEvent('tn-labs:cl:meth:mixing', function()
    local hasIngredients = hasRequiredIngredients(Config.meth.mixageIngredients)
    local ing = checkLabIngrediants()
    local isWearingClothes = checkPedClothes()
    if ing == 0 then
        if hasIngredients then
            TriggerEvent('animations:client:EmoteCommandStart', {"clipboard2"})
            if HackUi(Config.meth.mixingHackUi, Config.meth.mixingHackUiType) then
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                TriggerServerEvent("tn-labs:sv:meth:removeMixageIngrediants")
                startMixingMethAnimation()
                QBCore.Functions.Notify(Lang:t('success.putingrediants'), "success")
            else
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify(Lang:t('error.failure'), "error")
            end
        else
            QBCore.Functions.Notify(Lang:t('error.missingingrediants'), "error")
        end
    else
        QBCore.Functions.Notify(Lang:t('error.mixeurfull'), "error")
    end
    if not isWearingClothes then
        MethEffect()
    end
end)

RegisterNetEvent('tn-labs:cl:meth:checkMixageIngrediants', function()
    local status = checkLabIngrediants()
    local LabMenu = {
        {
            header = Lang:t('menu.ingrediantsleftHeader'),
            txt = status,
            isMenuHeader = true
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

RegisterNetEvent('tn-labs:cl:meth:machineprogression', function()
    local time = checkWaitTime()
    SendNUIMessage({
        action = "Time",
        data = time,
        initialTime = Config.meth.cokeTime,
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent('tn-labs:cl:meth:usemachine', function()
    local status = checkLabIngrediants()
    local time = checkWaitTime()
    local quality = checkLabQuality()
    --print(status)
    --print(time)
    --print(quality)
    if time < 1 then
        if quality == 0 then
            if status == 1 then
                SendNUIMessage({
                    action = "Temp",
                })
                SetNuiFocus(true, true)
            else
                QBCore.Functions.Notify(Lang:t('error.putingrediantsfirst'), "error")
            end
        else
            QBCore.Functions.Notify(Lang:t('error.emptymixerfirst'), "error")
        end
    else
        QBCore.Functions.Notify(Lang:t('error.machineisworking'), "error")
    end
end)

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('startProcess', function(data, cb)
    SetNuiFocus(false, false)
    FreezeEntityPosition(PlayerPedId(), true)
    TriggerEvent('animations:client:EmoteCommandStart', {"notepad2"})
    QBCore.Functions.Progressbar("machinemeth", Lang:t('progressbar.setuptemp'), 30 * 1000, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        local resultQuality = calculateQuality(data.ingredient1, data.ingredient2, data.ingredient3, data.ingredient4)
        print("Quality:", resultQuality)
        TriggerServerEvent("tn-labs:sv:meth:processStarted",resultQuality)
        QBCore.Functions.Notify(Lang:t('success.machinestarted'), "success")
        FreezeEntityPosition(PlayerPedId(), false)
    end, function() -- Cancel
        QBCore.Functions.Notify(Lang:t('error.cancel'), "error")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        FreezeEntityPosition(PlayerPedId(), false)
    end)
end)

RegisterNetEvent('tn-labs:cl:meth:passToMethArray', function()
    local time = checkWaitTime()
    local quality = checkLabQuality()
    local passmetharraycanp = checkMethArrayCanPass()
    local metharrayamount = Config.meth.methArrayReward
    if time < 1 and quality > 0 then
        if not passmetharraycanp then return QBCore.Functions.Notify(Lang:t('error.couldntpassmetharray'), "error") end
        FreezeEntityPosition(PlayerPedId(), true)
        TriggerEvent('animations:client:EmoteCommandStart', {"notepad2"})
        QBCore.Functions.Progressbar("passToMethArray", Lang:t('progressbar.emptymixer'), 30 * 1000, false, false, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            TriggerServerEvent("tn-labs:sv:meth:passToMethArray", metharrayamount)
            QBCore.Functions.Notify(Lang:t('success.emptymixer'), "success")
            FreezeEntityPosition(PlayerPedId(), false)
        end, function() -- Cancel
            QBCore.Functions.Notify(Lang:t('error.cancel'), "error")
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            FreezeEntityPosition(PlayerPedId(), false)
        end)
    else
        QBCore.Functions.Notify(Lang:t('error.machinestillworking'), "error")
    end
end)

RegisterNetEvent('tn-labs:cl:meth:CheckArraysCount', function()
    local amount = checkMethArrayAmount()
    local LabMenu = {
        {
            header = Lang:t('menu.metharrayleftheader'),
            txt = amount,
            isMenuHeader = true
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

RegisterNetEvent('tn-labs:cl:meth:tookMethArray', function()
    local amount = checkMethArrayAmount()
    if amount > 0 then
        FreezeEntityPosition(PlayerPedId(), true)
        TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
        QBCore.Functions.Progressbar("tookMethArray", Lang:t('progressbar.takemetharray'), 5 * 1000, false, false, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            TriggerServerEvent("tn-labs:sv:meth:tookMethArray")
            SpawnItem('bkr_prop_meth_tray_02a',-0.08, 0.65, 0.1, 0.0, 0.0, 180.0)
            QBCore.Functions.Notify(Lang:t('success.takemetharray'), "success")
            FreezeEntityPosition(PlayerPedId(), false)
        end, function() -- Cancel
            QBCore.Functions.Notify(Lang:t('error.cancel'), "error")
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            FreezeEntityPosition(PlayerPedId(), false)
        end)
    else
        QBCore.Functions.Notify(Lang:t('error.nometharraytotake'), "error")
    end
    local isWearingClothes = checkPedClothes()
    if not isWearingClothes then
        MethEffect()
    end
end)

RegisterNetEvent('tn-labs:cl:meth:addMethArray', function()
    TriggerServerEvent("tn-labs:sv:meth:toAddMethArray")
end)

RegisterNetEvent('tn-labs:cl:meth:toAddMethArray', function()
    DeleteObject(currentobject)
    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), true)
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    QBCore.Functions.Progressbar("addMethArray", Lang:t('progressbar.addmetharray'), 5 * 1000, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent("tn-labs:sv:meth:addMethArray")
        QBCore.Functions.Notify(Lang:t('success.addMethArray'), "success")
        FreezeEntityPosition(PlayerPedId(), false)
    end, function() -- Cancel
        QBCore.Functions.Notify(Lang:t('error.cancel'), "error")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        FreezeEntityPosition(PlayerPedId(), false)
    end)
end)

RegisterNetEvent('tn-labs:cl:meth:CheckArraysCounttwo', function()
   local amount = checkMethArrayAmountTwo()
   local LabMenu = {
        {
            header = Lang:t('menu.metharrayleftheader'),
            txt = amount,
            isMenuHeader = true
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

local function hummeranimation()
    local ver = ""
    local animDict, animName = "anim@amb@business@meth@meth_smash_weight_check@", "break_weigh_"..ver.."char02"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(10)
    end
    local ped = PlayerPedId()
    local targetPosition = vector3(1012.628, -3194.619, -39.589)
    SetEntityCoords(ped, targetPosition)
    Citizen.Wait(1)
    local animDuration = GetAnimDuration(animDict, animName) * 1000
    FreezeEntityPosition(ped, true)
    local scenePos, sceneRot = vector3(1008.734, -3196.646, -39.99), vector3(0.0, 0.0, 1.08)
    local netScene = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene, animDict, animName, 1.5, -4.0, 1, 16, 1148846080, 0)
    local objects, sceneObjects = {}, {
        {
            hash = `w_me_hammer`,
            animName = "break_weigh_"..ver.."hammer"
        },
        {
            hash = `bkr_Prop_Meth_SmashedTray_01_frag_`,
            animName = "break_weigh_"..ver.."tray01"
        },
        {
            hash = `bkr_Prop_Meth_Tray_02a`,
            animName = "break_weigh_"..ver.."tray01^1"
        },
        {
            hash = `bkr_Prop_Meth_Tray_02a`,
            animName = "break_weigh_"..ver.."tray01^2"
        },
        {
            hash = `bkr_Prop_Meth_SmashedTray_01_frag_`,
            animName = "break_weigh_"..ver.."tray01^3"
        }
    }
    for i=1, #sceneObjects, 1 do
        local obj = CreateObjectNoOffset(sceneObjects[i].hash, targetPosition, true, true, true)
        NetworkAddEntityToSynchronisedScene(obj, netScene, animDict, sceneObjects[i].animName, 4.0, -8.0, 1)
        objects[#objects+1] = obj
    end
    NetworkStartSynchronisedScene(netScene)
    Citizen.Wait(animDuration)
    NetworkStopSynchronisedScene(netScene)
    for i=1, #objects, 1 do
        DeleteObject(objects[i])
    end
    DeleteObject(scoop)
    RemoveAnimDict(animDict)
    FreezeEntityPosition(ped, false)
    hummerani = false
end

RegisterNetEvent('tn-labs:cl:meth:hammerMethArray', function()
    local amount = checkMethArrayAmountTwo()
    if hummerani then return QBCore.Functions.Notify(Lang:t('error.middleofprocess'), "error") end
    if amount > 0 then
        hummerani = true
        hummeranimation()
        TriggerServerEvent("tn-labs:sv:meth:passMethArrayToStageTwo")
        QBCore.Functions.Notify(Lang:t('success.hammerMethArray'), "success")
    else
        QBCore.Functions.Notify(Lang:t('error.noarrays'), "error")
    end
    local isWearingClothes = checkPedClothes()
    if not isWearingClothes then
        MethEffect()
    end
end)

local function PackageMethAnim()
    local ver = "v3_"
    local animDict, animName = "anim@amb@business@meth@meth_smash_weight_check@", "break_weigh_"..ver.."char01"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(10)
    end
    local animDuration = GetAnimDuration(animDict, animName) * 1000
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local scenePos, sceneRot = vector3(1008.734, -3196.646, -39.99), vector3(0.0, 0.0, 1.08)
    local scenes = {
        {
            {
                hash = `bkr_prop_meth_bigbag_04a`,
                animName = "break_weigh_"..ver.."box01"
            },
            {
                hash = `bkr_prop_meth_bigbag_03a`,
                animName = "break_weigh_"..ver.."box01^1"
            },
            {
                hash = `bkr_prop_meth_openbag_02`,
                animName = "break_weigh_"..ver.."methbag01"
            }
        },
        {
            {
                hash = `bkr_prop_meth_openbag_02`,
                animName = "break_weigh_"..ver.."methbag01^1"
            },
            {
                hash = `bkr_prop_meth_openbag_02`,
                animName = "break_weigh_"..ver.."methbag01^2"
            },
            {
                hash = `bkr_prop_meth_openbag_02`,
                animName = "break_weigh_"..ver.."methbag01^3"
            }
        },
        {
            {
                hash = `bkr_prop_meth_openbag_02`,
                animName = "break_weigh_"..ver.."methbag01^4"
            },
            {
                hash = `bkr_prop_meth_openbag_02`,
                animName = "break_weigh_"..ver.."methbag01^5"
            },
            {
                hash = `bkr_prop_meth_openbag_02`,
                animName = "break_weigh_"..ver.."methbag01^6"
            }
        },
        {
            {
                hash = `bkr_prop_meth_scoop_01a`,
                animName = "break_weigh_"..ver.."scoop"
            },
            {
                hash = `bkr_prop_coke_scale_01`,
                animName = "break_weigh_"..ver.."scale"
            },
            {
                hash = `bkr_prop_fakeid_penclipboard`,
                animName = "break_weigh_"..ver.."pen"
            }
        },
        {
            {
                hash = `bkr_prop_fakeid_clipboard_01a`,
                animName = "break_weigh_"..ver.."clipboard"
            }
        }
    }
    local scenesList, entitiesList = {}, {}
    for i=1, #scenes, 1 do
        local scene = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, scene, animDict, animName, 1.5, -4.0, 1, 16, 1148846080, 0)
        for j=1, #scenes[i], 1 do
            local s = scenes[i][j]
            RequestModel(s.hash)
            while not HasModelLoaded(s.hash) do
                Citizen.Wait(0)
            end
            local obj = CreateObjectNoOffset(s.hash, coords, true, true, true)
            SetModelAsNoLongerNeeded(s.hash)
            entitiesList[#entitiesList+1] = obj
            NetworkAddEntityToSynchronisedScene(obj, scene, animDict, s.animName, 4.0, -8.0, 1)
        end
        scenesList[#scenesList+1] = scene
    end
    DisableCamCollisionForEntity(ped)
    FreezeEntityPosition(ped, true)
    for i=1, #scenesList, 1 do
        NetworkStartSynchronisedScene(scenesList[i])
    end
    print(animDuration)
    Citizen.Wait(animDuration-11000)
    -- Citizen.Wait(45000)
    for i=1, #scenesList, 1 do
        NetworkStopSynchronisedScene(scenesList[i])
    end
    for i=1, #entitiesList, 1 do
        DeleteEntity(entitiesList[i])
    end
    RemoveAnimDict(animDict)
    addmetharrayani = false
    FreezeEntityPosition(ped, false)
end


RegisterNetEvent('tn-labs:cl:meth:package', function()
    local amount = checkMethArrayAmountThree()
    if addmetharrayani then return QBCore.Functions.Notify(Lang:t('error.middleofprocess'), "error") end
    if amount > 0 then
        addmetharrayani = true
        PackageMethAnim()
        TriggerServerEvent("tn-labs:sv:meth:package")
        QBCore.Functions.Notify(Lang:t('success.packagereceive'), "success")
    else
        QBCore.Functions.Notify(Lang:t('error.noarrays'), "error")
    end
    local isWearingClothes = checkPedClothes()
    if not isWearingClothes then
        MethEffect()
    end
end)

RegisterNetEvent('tn-labs:cl:meth:stash', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "methlab", {
        maxweight = 100000,
        slots = 35,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "methlab")
end)

RegisterNetEvent('tn-labs:cl:meth:clothes', function()
    ChangeClothesAnim()
    QBCore.Functions.Progressbar('changeparachute', Lang:t('progressbar.changeclothes'), 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        if haschangedclothes then
            TriggerEvent("illenium-appearance:client:reloadSkin")
            haschangedclothes = false
            QBCore.Functions.Notify(Lang:t('success.changecolthesback'), "success")
        else
            ApplyServicerSkin()
            haschangedclothes = true
            QBCore.Functions.Notify(Lang:t('success.changelabclothes'), "success")
        end
        TaskPlayAnim(ped, 'clothingshirt', 'exit', 8.0, 1.0, -1, 49, 0, false, false, false)
    end)
    checkPedClothes()
end)
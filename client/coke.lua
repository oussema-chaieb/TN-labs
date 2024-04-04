local QBCore = exports['qb-core']:GetCoreObject()

local haschangedclothes = false
local procanim = false
local packageanim = false
local unpackageanimation = false
local procleaf = false
-- Target
CreateThread(function()
    for k, v in pairs(Config.coke.locations) do
        local options = {}
        for _, option in pairs(v.options) do
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

local function repairfigurine()
    TriggerEvent('animations:client:EmoteCommandStart', {"argue"})
    QBCore.Functions.Progressbar('repairfugurine', Lang:t('progressbar.repairfigurine'), 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent('tn-labs:sv:coke:repairfigurines')
    end)
end

CreateThread(function()
    RequestModel("g_m_m_chemwork_01")

    while not HasModelLoaded("g_m_m_chemwork_01") do
        Wait(0)
    end
    local ped = CreatePed(0, joaat("g_m_m_chemwork_01"), Config.labs.coke.repairped.x, Config.labs.coke.repairped.y, Config.labs.coke.repairped.z, Config.labs.coke.repairped.w, false, false)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_DRUG_DEALER", 0, true)
    PlaceObjectOnGroundProperly(ped)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    exports['qb-target']:AddTargetEntity(ped, {
        options = {
            {
                label = Lang:t('label.repairfigurine'),
                icon = "fa-solid fa-warehouse",
                action = function()
                    repairfigurine()
                end,
            }
        },
        distance = 2.0
    })
end)

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
        SetPedPropIndex(PlayerPedId(), 0 , Config.coke.Outfits.male.hat.item,Config.coke.Outfits.male.hat.texture, true)
		SetPedComponentVariation(PlayerPedId(), 1 , Config.coke.Outfits.male.mask.item,Config.coke.Outfits.male.mask.texture) -- Mask
		SetPedComponentVariation(PlayerPedId(), 4, Config.coke.Outfits.male.pants.item,Config.coke.Outfits.male.pants.texture) -- Pants
		SetPedComponentVariation(PlayerPedId(), 8 ,Config.coke.Outfits.male.shirt.item,Config.coke.Outfits.male.shirt.texture) -- Shirt
		SetPedComponentVariation(PlayerPedId(), 11 ,Config.coke.Outfits.male.jacket.item,Config.coke.Outfits.male.jacket.texture) -- Jacket
		SetPedComponentVariation(PlayerPedId(), 3 ,Config.coke.Outfits.male.arms.item,Config.coke.Outfits.male.arms.texture) -- Arms
		SetPedComponentVariation(PlayerPedId(), 6 ,Config.coke.Outfits.male.shoes.item,Config.coke.Outfits.male.shoes.texture) -- Shoes
		SetPedComponentVariation(PlayerPedId(), 7 ,Config.coke.Outfits.male.accessories.item,Config.coke.Outfits.male.accessories.texture) -- Accessory
	elseif IsPedModel(PlayerPedId(), 'mp_f_freemode_01') then
        SetPedPropIndex(PlayerPedId(), 0 , Config.coke.Outfits.male.hat.item,Config.coke.Outfits.male.hat.texture, true)
		SetPedComponentVariation(PlayerPedId(), 1 ,Config.coke.Outfits.female.mask.item,Config.coke.Outfits.female.mask.texture) -- Mask
		SetPedComponentVariation(PlayerPedId(), 4 ,Config.coke.Outfits.female.pants.item,Config.coke.Outfits.female.pants.texture) -- Pants
		SetPedComponentVariation(PlayerPedId(), 8 ,Config.coke.Outfits.female.shirt.item,Config.coke.Outfits.female.shirt.texture) -- Shirt
		SetPedComponentVariation(PlayerPedId(), 11 ,Config.coke.Outfits.female.jacket.item,Config.coke.Outfits.female.jacket.texture) -- Jacket
		SetPedComponentVariation(PlayerPedId(), 3 ,Config.coke.Outfits.female.arms.item,Config.coke.Outfits.female.arms.texture) -- Arms
		SetPedComponentVariation(PlayerPedId(), 6 ,Config.coke.Outfits.female.shoes.item,Config.coke.Outfits.female.shoes.texture) -- Shoes
		SetPedComponentVariation(PlayerPedId(), 7 ,Config.coke.Outfits.female.accessories.item,Config.coke.Outfits.female.accessories.texture) -- Accessory
	end
end

local function processAnim(itemqual)
    local animDict, animName = "anim@amb@business@coc@coc_unpack_cut_left@", "coke_cut_coccutter"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(10)
    end
    local animDuration = GetAnimDuration(animDict, animName) * 1000
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local scenePos, sceneRot = vector3(1096.975, -3196.228, -39.632), vector3(0.0, 0.0, 180.0)
    local scenes = {
        {
            {
                hash = `bkr_prop_coke_bakingsoda_o`,
                animName = "coke_cut_bakingsoda"
            },
            {
                hash = `prop_cs_credit_card`,
                animName = "coke_cut_creditcard"
            },
            {
                hash = `prop_cs_credit_card`,
                animName = "coke_cut_creditcard^1"
            }
        }
    }
    local scenesList, entitiesList = {}, {}
    for i=1, #scenes, 1 do
        local scene = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, scene, animDict, animName, 1.5, -4.0, 1, 16, 1148846080, 0)
        for j=1, #scenes[i], 1 do
            local s = scenes[i][j]
            local obj = s.entity
            if not obj or not DoesEntityExist(obj) then
                RequestModel(s.hash)
                while not HasModelLoaded(s.hash) do
                    Citizen.Wait(0)
                end
                obj = CreateObjectNoOffset(s.hash, coords, true, true, true)
                SetModelAsNoLongerNeeded(s.hash)
                entitiesList[#entitiesList+1] = obj
            else
                while not NetworkHasControlOfEntity(obj) do
                    Citizen.Wait(1)
                    NetworkRequestControlOfEntity(obj)
                end
                if not NetworkGetEntityIsNetworked(obj) then
                    NetworkRegisterEntityAsNetworked(obj)
                end
                SetEntityAsMissionEntity(obj, true, true)
                SetEntityDynamic(obj, true)
                FreezeEntityPosition(obj, false)
            end
            NetworkAddEntityToSynchronisedScene(obj, scene, animDict, s.animName, 4.0, -8.0, 1)
        end
        scenesList[#scenesList+1] = scene
    end
    DisableCamCollisionForEntity(ped)
    FreezeEntityPosition(ped, true)
    for i=1, #scenesList, 1 do
        NetworkStartSynchronisedScene(scenesList[i])
    end
    if lib.progressBar({
        duration = animDuration-3500,
        label = Lang:t('label.puringcoke'),
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false,
        },
    }) then
        FreezeEntityPosition(ped, false)
        QBCore.Functions.Notify(Lang:t('success.putingrediants'), "success")
        for key, v in pairs(Config.coke.processRewards) do
            TriggerServerEvent("tn-labs:sv:coke:additem",key, v , itemqual)
        end
    end
    Citizen.Wait(animDuration-3500)
    for i=1, #scenesList, 1 do
        NetworkStopSynchronisedScene(scenesList[i])
    end
    for i=1, #entitiesList, 1 do
        DeleteEntity(entitiesList[i])
    end
    RemoveAnimDict(animDict)
    procanim = false
    FreezeEntityPosition(ped, false)
end

local function packageCoke(info)
    local ver = "v3_"
    local animDict, animName = "anim@amb@business@coc@coc_packing_hi@", "full_cycle_"..ver.."pressoperator"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(10)
    end
    local animDuration = GetAnimDuration(animDict, animName) * 1000
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local scenePos, sceneRot = vector3(1093.58, -3196.614, -39.995), vector3(0.0, 0.0, 0.0)
    local scenes = {
        {
            {
                hash = `bkr_prop_coke_fullscoop_01a`,
                animName = "full_cycle_"..ver.."scoop"
            },
            {
                hash = `bkr_prop_coke_doll`,
                animName = "full_cycle_"..ver.."cocdoll"
            },
            {
                hash = `bkr_prop_coke_boxedDoll`,
                animName = "full_cycle_"..ver.."boxedDoll"
            }
        },
        {
            {
                hash = `bkr_prop_coke_dollCast`,
                animName = "full_cycle_"..ver.."dollcast"
            },
            {
                hash = `bkr_prop_coke_dollCast`,
                animName = "full_cycle_"..ver.."dollCast^1"
            },
            {
                hash = `bkr_prop_coke_dollCast`,
                animName = "full_cycle_"..ver.."dollCast^2"
            }
        },
        {
            {
                hash = `bkr_prop_coke_dollCast`,
                animName = "full_cycle_"..ver.."dollCast^3"
            },
            {
                hash = `bkr_prop_coke_dollmould`,
                animName = "full_cycle_"..ver.."dollmould"
            },
            {
                hash = `bkr_prop_coke_fullmetalbowl_02`,
                animName = "full_cycle_"..ver.."cocbowl"
            }
        },
        {
            {
                hash = `bkr_prop_coke_press_01b`,
                animName = "full_cycle_"..ver.."cokePress"
            },
            {
                hash = `bkr_prop_coke_dollboxfolded`,
                animName = "full_cycle_"..ver.."FoldedBox"
            },
            {
                hash = `bkr_prop_coke_dollboxfolded`,
                animName = "full_cycle_"..ver.."FoldedBox^1"
            }
        },
        {
            {
                hash = `bkr_prop_coke_dollboxfolded`,
                animName = "full_cycle_"..ver.."FoldedBox^2"
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
            NetworkAddEntityToSynchronisedScene(obj, scene, animDict, s.animName, 4.0, -8.0, 1)
            entitiesList[#entitiesList+1] = obj
        end
        scenesList[#scenesList+1] = scene
    end
    DisableCamCollisionForEntity(ped)
    FreezeEntityPosition(ped, true)
    for i=1, #scenesList, 1 do
        NetworkStartSynchronisedScene(scenesList[i])
    end
    if lib.progressBar({
        duration = 45000,
        label = Lang:t('label.packagecoke'),
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false,
        },
    }) then
        QBCore.Functions.Notify(Lang:t('success.Packagecoke'), "success")
        for key, v in pairs(Config.coke.packageRewards) do
            TriggerServerEvent("tn-labs:sv:coke:additem",key, v , info)
        end
    end
    for i=1, #scenesList, 1 do
        NetworkStopSynchronisedScene(scenesList[i])
    end
    for i=1, #entitiesList, 1 do
        DeleteEntity(entitiesList[i])
    end
    RemoveAnimDict(animDict)
    packageanim = false
    FreezeEntityPosition(ped, false)
end

local function unpackageanim(info)
    local ped = PlayerPedId()
    local dict = "anim@amb@business@coc@coc_unpack_cut@"

    RequestAnimDict(dict)
    RequestModel("bkr_prop_coke_box_01a")
    RequestModel("bkr_prop_coke_fullmetalbowl_02")
    RequestModel("bkr_prop_coke_fullscoop_01a")
    while not HasAnimDictLoaded(dict) and not HasModelLoaded("bkr_prop_coke_box_01a") and
        not HasModelLoaded("bkr_prop_coke_fullmetalbowl_02") and
        not HasModelLoaded("bkr_prop_coke_fullscoop_01a") do
        Wait(100)
    end

    CokeBowl = CreateObject(GetHashKey('bkr_prop_coke_fullmetalbowl_02'), x, y, z, 1, 0, 1)
    CokeScoop = CreateObject(GetHashKey('bkr_prop_coke_fullscoop_01a'), x, y, z, 1, 0, 1)
    CokeBox = CreateObject(GetHashKey('bkr_prop_coke_box_01a'), x, y, z, 1, 0, 1)
    local targetRotation = vec3(180.0, 180.0, 0.0)
    local x, y, z = table.unpack(vector3(1087.31, -3196.04, -38.99))
    local netScene = NetworkCreateSynchronisedScene(x - 0.2, y - 0.1, z - 0.65, targetRotation, 2, false
        , false, 1148846080, 0, 1.3)

    NetworkAddPedToSynchronisedScene(ped, netScene, dict, "fullcut_cycle_v1_cokepacker", 1.5, -4.0, 1, 16
        , 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(CokeBowl, netScene, dict, "fullcut_cycle_v1_cokebowl", 4.0, -8.0
        , 1)
    NetworkAddEntityToSynchronisedScene(CokeBox, netScene, dict, 'fullcut_cycle_v1_cokebox', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(CokeScoop, netScene, dict, 'fullcut_cycle_v1_cokescoop', 4.0,
        -8.0, 1)
    FreezeEntityPosition(ped, true)
    Wait(150)
    NetworkStartSynchronisedScene(netScene)
    SetEntityVisible(CokeScoop, false, 0)
    if lib.progressBar({
        duration = 43828,
        label = Lang:t('label.procurecoke'),
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false,
        },
    }) then
        DeleteObject(CokeBowl)
        DeleteObject(CokeBox)
        DeleteObject(CokeScoop)
        FreezeEntityPosition(ped, false)
        QBCore.Functions.Notify(Lang:t('success.procurecoke'), "success")
        for key, v in pairs(Config.coke.unpackageRewards) do
            TriggerServerEvent("tn-labs:sv:coke:additem",key, v , info)
        end
    end
    unpackageanimation = false
    Wait(GetAnimDuration(dict, "fullcut_cycle_v1_cokepacker") * 450)
    SetEntityVisible(CokeScoop, true, 0)
    Wait(GetAnimDuration(dict, "fullcut_cycle_v1_cokepacker") * 65)
    SetEntityVisible(CokeBox, false, 0)
    Wait(GetAnimDuration(dict, "fullcut_cycle_v1_cokepacker") * 245)
end

local function intoboxanim(itemqual)
    local crds = vector4(1101.81, -3193.14, -39.18, 90)
    local object = CreateObject(GetHashKey("bkr_prop_coke_box_01a"), crds.x, crds.y, crds.z, true, true, false)
    SetEntityHeading(object, crds.w)
    TaskTurnPedToFaceCoord(PlayerPedId(), crds, 2000)
    Wait(2000)
    if lib.progressBar({
        duration = 10000,
        label = Lang:t('label.Pouringcoke'),
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false
        },
        anim = {
            dict = "mp_arresting",
            clip = "a_uncuff",
            flags = 49,
        },
        prop = {
            model = `ng_proc_leaves01`,
            pos = vec3(0.13, 0.05, 0.0),
            rot = vec3(0.0, 0.0, 0.0),
            bone = 18905
        },
    }) then
        QBCore.Functions.Notify(Lang:t('success.Pouringcoke'), "success")
        for key, v in pairs(Config.coke.processleafRewards) do
            TriggerServerEvent("tn-labs:sv:coke:additem",key, v , itemqual)
        end
        DeleteObject(object)
    else
        DeleteObject(object)
    end
    procleaf = false
    FreezeEntityPosition(PlayerPedId(), false)
end

RegisterNetEvent('tn-labs:cl:coke:dryingleaf', function()
    local DryMenu = {
        {
            header = "Dry",--Lang:t('menu.dryMeny'),
            isMenuHeader = true
        }
    }
    DryMenu[#DryMenu + 1] = {
        header = "add coke leaf",--Lang:t('menu.exitHeader'),
        txt = "adding coke leaf to dry",
        params = {
            event = "tn-labs:cl:coke:addcokeleaf"
        }
    }
    DryMenu[#DryMenu + 1] = {
        header = "Start drying",--Lang:t('menu.exitHeader'),
        txt = "start dry",
        params = {
            event = "tn-labs:cl:coke:startdrying"
        }
    }
    DryMenu[#DryMenu + 1] = {
        header = "Check time",--Lang:t('menu.exitHeader'),
        txt = "timing",
        params = {
            event = "tn-labs:cl:coke:checktime"
        }
    }
    DryMenu[#DryMenu + 1] = {
        header = "took dried coke",--Lang:t('menu.exitHeader'),
        txt = "dried coke",
        params = {
            event = "tn-labs:cl:coke:tookdriedcoke"
        }
    }
    DryMenu[#DryMenu + 1] = {
        header = Lang:t('menu.exitHeader'),
        params = {
            event = "qb-menu:closeMenu"
        }
    }
    exports['qb-menu']:openMenu(DryMenu)
end)

RegisterNetEvent('tn-labs:cl:coke:addcokeleaf', function()
    local dialog = exports['qb-input']:ShowInput({
        header =  "coke leaf",--Lang:t('menus.max_remise'),
        submitText = "amount",--Lang:t('menus.submit_text'),
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'amount',
                text = "123"
            }
        }
    })
    if dialog then
        if QBCore.Functions.HasItem(Config.coke.dryitem ,tonumber(dialog.amount)) then
            TriggerServerEvent("tn-labs:sv:coke:addcokeleaf",tonumber(dialog.amount))
        else
            QBCore.Functions.Notify("you don't have that much", "error")
        end
    end
end)

local function checkDryIngrediants()
    local p = promise.new()
    QBCore.Functions.TriggerCallback('tn-labs:sv:checkDryIngrediants', function(result)
        p:resolve(result)
    end)
    return Citizen.Await(p)
end

local function checkTime()
    local p = promise.new()
    QBCore.Functions.TriggerCallback('tn-labs:sv:checkTime', function(result)
        p:resolve(result)
    end)
    return Citizen.Await(p)
end

local function checkStash(stash, item, amount)
    local p = promise.new()
    QBCore.Functions.TriggerCallback('tn-labs:sv:checkstash', function(result, result2)
        local test = {
            [1]=result,
            [2]=result2
        }
        p:resolve(test)
    end, stash, item, amount)
    return Citizen.Await(p)
end

RegisterNetEvent('tn-labs:cl:coke:startdrying', function()
    local ingrediants = checkDryIngrediants()
    local time = checkTime()
    if ingrediants < 1 then QBCore.Functions.Notify("you need to add coke leaf to dry first","error") return end
    if time > 1 then QBCore.Functions.Notify("coke are not dried yet","error") return end
    SendNUIMessage({
        action = "Temp",
        data = "coke"
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent('tn-labs:cl:coke:checktime', function()
    local time = checkTime()
    SendNUIMessage({
        action = "Time2",
        data = time,
        initialTime = Config.coke.cokeTime,
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent('tn-labs:cl:coke:tookdriedcoke', function()
    local time = checkTime()
    if time > 1 then QBCore.Functions.Notify("coke are not dried yet","error") return end
    TriggerServerEvent("tn-labs:sv:coke:tookdriedcoke")
end)

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
        local variation = math.random(1, 9) / 10
        local perfectionScore = indeviation * variation
        result = 100 - perfectionScore
    end
    return result
end

local function calculateQuality(ingredient1, ingredient2, ingredient3, ingredient4)
    local quality1 = calculateIngredientQuality(ingredient1, 5, 0, 17)
    local quality2 = calculateIngredientQuality(ingredient2, 15, 10, 30)
    local quality3 = calculateIngredientQuality(ingredient3, 99, 90, 100)
    local quality4 = calculateIngredientQuality(ingredient4, 8, 0, 17)
    local totalQuality = (quality1 + quality2 + quality3 + quality4) * 0.25
    return math.floor(totalQuality)
end

RegisterNUICallback('startCokeProcess', function(data, cb)
    SetNuiFocus(false, false)
    FreezeEntityPosition(PlayerPedId(), true)
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    QBCore.Functions.Progressbar("dryingcoke", "adjust temperature to dry coke", 5 * 1000, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        local resultQuality = calculateQuality(data.ingredient1, data.ingredient2, data.ingredient3, data.ingredient4)
        TriggerServerEvent("tn-labs:sv:coke:dryingStarted",resultQuality)
        QBCore.Functions.Notify("Good job", "success")
        FreezeEntityPosition(PlayerPedId(), false)
    end, function() -- Cancel
        QBCore.Functions.Notify(Lang:t('error.cancel'), "error")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        FreezeEntityPosition(PlayerPedId(), false)
    end)
end)

RegisterNetEvent('tn-labs:cl:coke:addcokeleaftoprocess', function()
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', 'processleafstash',{
        maxweight = 1000,
        slots = 20,
    })
    TriggerEvent('inventory:client:SetCurrentStash', 'processleafstash')
end)

RegisterNetEvent('tn-labs:cl:coke:startleafprocess', function()
    if procleaf then return QBCore.Functions.Notify(Lang:t('error.middleofprocess'), "error") end
    local boolstash
    for ingredient, quantity in pairs(Config.coke.processleafIngrediants) do
        boolstash = checkStash('processleafstash', ingredient, quantity)
    end
    if boolstash[1] then
        procleaf = true
        print(boolstash[2])
        local info = {
            quality = boolstash[2]
        }
        intoboxanim(info)
    else
        QBCore.Functions.Notify(Lang:t('error.missingingrediants'), "error")
    end
end)

RegisterNetEvent('tn-labs:cl:coke:leafproc', function()
    local leafproc = {
        {
            header = "Dry",--Lang:t('menu.dryMeny'),
            isMenuHeader = true
        }
    }
    leafproc[#leafproc + 1] = {
        header = "add coke leaf",--Lang:t('menu.exitHeader'),
        txt = "adding coke leaf to process",
        params = {
            event = "tn-labs:cl:coke:addcokeleaftoprocess"
        }
    }
    leafproc[#leafproc + 1] = {
        header = "Leaf proc",--Lang:t('menu.exitHeader'),
        txt = "Leaf proc",
        params = {
            event = "tn-labs:cl:coke:startleafprocess"
        }
    }
    leafproc[#leafproc + 1] = {
        header = Lang:t('menu.exitHeader'),
        params = {
            event = "qb-menu:closeMenu"
        }
    }
    exports['qb-menu']:openMenu(leafproc)
end)


RegisterNetEvent('tn-labs:cl:coke:startunpackaging', function()
    if unpackageanimation then return QBCore.Functions.Notify(Lang:t('error.middleofprocess'), "error") end
    local boolstash
    for ingredient, quantity in pairs(Config.coke.unpackageIngrediants) do
        boolstash = checkStash('unpackagestash', ingredient, quantity)
    end
    if boolstash[1] then
        unpackageanimation = true
        print(boolstash[2])
        local info = {
            quality = boolstash[2]
        }
        unpackageanim(info)
    else
        QBCore.Functions.Notify(Lang:t('error.missingingrediants'), "error")
    end
end)

RegisterNetEvent('tn-labs:cl:coke:addunpackageingrediants', function()
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', 'unpackagestash',{
        maxweight = 20000,
        slots = 20,
    })
    TriggerEvent('inventory:client:SetCurrentStash', 'unpackagestash')
end)

RegisterNetEvent('tn-labs:cl:coke:unpackage', function()
    local unpackage = {
        {
            header = "Unpackage",--Lang:t('menu.dryMeny'),
            isMenuHeader = true
        }
    }
    unpackage[#unpackage + 1] = {
        header = "add coke box",--Lang:t('menu.exitHeader'),
        txt = "adding coke box to process",
        params = {
            event = "tn-labs:cl:coke:addunpackageingrediants"
        }
    }
    unpackage[#unpackage + 1] = {
        header = "Unpackage",--Lang:t('menu.exitHeader'),
        txt = "Unpackage",
        params = {
            event = "tn-labs:cl:coke:startunpackaging"
        }
    }
    unpackage[#unpackage + 1] = {
        header = Lang:t('menu.exitHeader'),
        params = {
            event = "qb-menu:closeMenu"
        }
    }
    exports['qb-menu']:openMenu(unpackage)
end)

RegisterNetEvent('tn-labs:cl:coke:process', function()
    local process = {
        {
            header = "Unpackage",--Lang:t('menu.dryMeny'),
            isMenuHeader = true
        }
    }
    process[#process + 1] = {
        header = "add coke raw",--Lang:t('menu.exitHeader'),
        txt = "adding coke raw to process",
        params = {
            event = "tn-labs:cl:coke:addcokeraw"
        }
    }
    process[#process + 1] = {
        header = "startprocessing",--Lang:t('menu.exitHeader'),
        txt = "startprocessing",
        params = {
            event = "tn-labs:cl:coke:startprocessing"
        }
    }
    process[#process + 1] = {
        header = Lang:t('menu.exitHeader'),
        params = {
            event = "qb-menu:closeMenu"
        }
    }
    exports['qb-menu']:openMenu(process)
end)

RegisterNetEvent('tn-labs:cl:coke:addcokeraw', function()
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', 'cokerawstash',{
        maxweight = 1000,
        slots = 20,
    })
    TriggerEvent('inventory:client:SetCurrentStash', 'cokerawstash')
end)

RegisterNetEvent('tn-labs:cl:coke:startprocessing', function()
    if procanim then return QBCore.Functions.Notify(Lang:t('error.middleofprocess'), "error") end
    local hasIngredients = hasRequiredCokeIngredients(Config.coke.processIngrediants)
    local firstIteration = true
    local boolstash
    for ingredient, quantity in pairs(Config.coke.processIngrediants) do
        if firstIteration then
            firstIteration = false
            boolstash = checkStash('cokerawstash', ingredient, quantity)
        end
    end
    if hasIngredients then
        if boolstash[1] then
            TriggerServerEvent('tn-labs:sv:coke:removeitems', Config.coke.processIngrediants)
            procanim = true
            print(boolstash[2])
            local info = {
                quality = boolstash[2]
            }
            processAnim(info)
        else
            QBCore.Functions.Notify(Lang:t('error.missingingrediants'), "error")
        end
    else
        QBCore.Functions.Notify("check your pockets cause you miss some items", "error")
    end
end)

RegisterNetEvent('tn-labs:cl:coke:package', function()
    local package = {
        {
            header = "Unpackage",--Lang:t('menu.dryMeny'),
            isMenuHeader = true
        }
    }
    package[#package + 1] = {
        header = "packagestage",--Lang:t('menu.exitHeader'),
        txt = "packagestage",
        params = {
            event = "tn-labs:cl:coke:packagestage"
        }
    }
    package[#package + 1] = {
        header = "packagecoke",--Lang:t('menu.exitHeader'),
        txt = "packagecoke",
        params = {
            event = "tn-labs:cl:coke:packagecoke"
        }
    }
    package[#package + 1] = {
        header = Lang:t('menu.exitHeader'),
        params = {
            event = "qb-menu:closeMenu"
        }
    }
    exports['qb-menu']:openMenu(package)
end)

RegisterNetEvent('tn-labs:cl:coke:packagecoke', function()
    if packageanim then return QBCore.Functions.Notify(Lang:t('error.middleofprocess'), "error") end
    local hasIngredients = hasRequiredCokeIngredients(Config.coke.packageIngrediants)
    local firstIteration = true
    local boolstash
    for ingredient, quantity in pairs(Config.coke.packageIngrediants) do
        if firstIteration then
            firstIteration = false
            boolstash = checkStash('packagestage', ingredient, quantity)
        end
    end
    if hasIngredients then
        if boolstash[1] then
            TriggerServerEvent('tn-labs:sv:coke:removeitems', Config.coke.packageIngrediants)
            packageanim = true
            print(boolstash[2])
            local info = {
                quality = boolstash[2]
            }
            packageCoke(info)
        else
            QBCore.Functions.Notify(Lang:t('error.missingingrediants'), "error")
        end
    else
        QBCore.Functions.Notify("check your pockets cause you miss some items", "error")
    end
end)

RegisterNetEvent('tn-labs:cl:coke:packagestage', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "packagestage", {
        maxweight = 1000,
        slots = 20,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "packagestage")
end)

RegisterNetEvent('tn-labs:cl:coke:stash', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "cokelab", {
        maxweight = 100000,
        slots = 35,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "cokelab")
end)

RegisterNetEvent('tn-labs:cl:coke:clothes', function()
    ChangeClothesAnim()
    QBCore.Functions.Progressbar('changecokelabclothes', Lang:t('progressbar.changeclothes'), 5000, false, true, {
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
    --checkPedClothes()
end)

RegisterNetEvent("tn-labs:cl:coke:usefigure", function()
    if lib.progressBar({
        duration = 6000,
        label = Lang:t('label.breakfigure'),
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false
        },
        prop = {
            model = `bkr_prop_coke_doll`,
            pos = vec3(-0.11, 0.4, -0.11),
            rot = vec3(1.0, 9.0, 115.0),
            bone = 24816
        },
        anim = {
            dict = "anim@heists@box_carry@",
            clip = "idle",
            flags = 49,
        },
    }) then
        TriggerServerEvent("tn-labs:sv:coke:breakingcokefigure")
    end
end)
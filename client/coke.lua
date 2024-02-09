local QBCore = exports['qb-core']:GetCoreObject()

local haschangedclothes = false
-- Target
CreateThread(function()
    for k, v in pairs(Config.coke.locations) do
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

local function repairfigurine()
    TriggerEvent('animations:client:EmoteCommandStart', {"argue"})
    QBCore.Functions.Progressbar('repairfugurine', "Argue with employee to repair figurine", 5000, false, true, {
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
    vector4(1090.69, -3190.49, -38.99, 87.68)
    local ped = CreatePed(0, joaat("g_m_m_chemwork_01"), 1090.69, -3190.49, -38.99 - 1, 87.68, false, false)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_DRUG_DEALER", 0, true)
    PlaceObjectOnGroundProperly(ped)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    exports['qb-target']:AddTargetEntity(ped, {
        options = {
            {
                label = "repair figurine",
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

local function processAnim()
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
        label = 'Puring coke',
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
        QBCore.Functions.Notify("You successfly put the ingrediants", "success")
        TriggerServerEvent("tn-labs:sv:coke:removeandgiveitems", Config.coke.processIngrediants, Config.coke.processRewards)
    end
    -- Citizen.Wait(animDuration-11000)
    Citizen.Wait(animDuration-3500)
    for i=1, #scenesList, 1 do
        NetworkStopSynchronisedScene(scenesList[i])
    end
    for i=1, #entitiesList, 1 do
        DeleteEntity(entitiesList[i])
    end
    RemoveAnimDict(animDict)
    FreezeEntityPosition(ped, false)
end

local function packageCoke()
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
        label = 'Puring coke',
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false,
        },
    }) then
        QBCore.Functions.Notify("You successfly put the ingrediants", "success")
        TriggerServerEvent("tn-labs:sv:coke:removeandgiveitems",Config.coke.packageIngrediants ,Config.coke.packageRewards)
    end
    -- Citizen.Wait(animDuration)
    --Citizen.Wait(45000)
    for i=1, #scenesList, 1 do
        NetworkStopSynchronisedScene(scenesList[i])
    end
    for i=1, #entitiesList, 1 do
        DeleteEntity(entitiesList[i])
    end
    RemoveAnimDict(animDict)
    FreezeEntityPosition(ped, false)
end

local function unpackageanim()
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
        label = "procuring coke",
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
        QBCore.Functions.Notify("You successfly put the ingrediants", "success")
        TriggerServerEvent("tn-labs:sv:coke:removeandgiveitems", Config.coke.unpackageIngrediants, Config.coke.unpackageRewards)
    end
    Wait(GetAnimDuration(dict, "fullcut_cycle_v1_cokepacker") * 450)
    SetEntityVisible(CokeScoop, true, 0)
    Wait(GetAnimDuration(dict, "fullcut_cycle_v1_cokepacker") * 65)
    SetEntityVisible(CokeBox, false, 0)
    Wait(GetAnimDuration(dict, "fullcut_cycle_v1_cokepacker") * 245)
end

local function intoboxanim()
    local crds = vector4(1101.81, -3193.14, -39.18, 90)
    local object = CreateObject(GetHashKey("bkr_prop_coke_box_01a"), crds.x, crds.y, crds.z, true, true, false)
    SetEntityHeading(object, crds.w)
    TaskTurnPedToFaceCoord(PlayerPedId(), crds, 2000)
    Wait(2000)
    if lib.progressBar({
        duration = 10000,
        label = "Pouring Coke into the box",
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
        QBCore.Functions.Notify("You successfly put the ingrediants", "success")
        TriggerServerEvent("tn-labs:sv:coke:removeandgiveitems",Config.coke.processleafIngrediants, Config.coke.processleafRewards)
        DeleteObject(object)
    else
        DeleteObject(object)
    end
    FreezeEntityPosition(PlayerPedId(), false)
end

RegisterNetEvent('tn-labs:cl:coke:leafproc', function()
    local hasIngredients = hasRequiredIngredients(Config.coke.processleafIngrediants)
    if hasIngredients then
        if HackUi(Config.meth.mixingHackUi, Config.meth.mixingHackUiType) then
            intoboxanim()
        else
            QBCore.Functions.Notify("you failed", "error")
        end
    else
        QBCore.Functions.Notify("You are missing something", "error")
    end
end)

RegisterNetEvent('tn-labs:cl:coke:unpackage', function()
    local hasIngredients = hasRequiredIngredients(Config.coke.unpackageIngrediants)
    if hasIngredients then
        if HackUi(Config.meth.mixingHackUi, Config.meth.mixingHackUiType) then
            unpackageanim()
        else
            QBCore.Functions.Notify("you failed", "error")
        end
    else
        QBCore.Functions.Notify("You are missing something", "error")
    end
end)

RegisterNetEvent('tn-labs:cl:coke:process', function()
    local hasIngredients = hasRequiredIngredients(Config.coke.processIngrediants)
    if hasIngredients then
        if HackUi(Config.meth.mixingHackUi, Config.meth.mixingHackUiType) then
            processAnim()
        else
            QBCore.Functions.Notify("you failed", "error")
        end
    else
        QBCore.Functions.Notify("You are missing something", "error")
    end
end)

RegisterNetEvent('tn-labs:cl:coke:package', function()
    local hasIngredients = hasRequiredIngredients(Config.coke.packageIngrediants)
    if hasIngredients then
        if HackUi(Config.meth.mixingHackUi, Config.meth.mixingHackUiType) then
            packageCoke()
        else
            QBCore.Functions.Notify("you failed", "error")
        end
    else
        QBCore.Functions.Notify("You are missing something", "error")
    end
end)

RegisterNetEvent('tn-labs:cl:coke:stash', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "cokelab", {
        maxweight = 100000,
        slots = 35,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "methlab")
end)

RegisterNetEvent('tn-labs:cl:coke:clothes', function()
    ChangeClothesAnim()
    QBCore.Functions.Progressbar('changecokelabclothes', "Changing Clothes", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        if haschangedclothes then
            TriggerEvent("illenium-appearance:client:reloadSkin")
            haschangedclothes = false
            QBCore.Functions.Notify("Time to leave !", "success")
        else
            ApplyServicerSkin()
            haschangedclothes = true
            QBCore.Functions.Notify("you changed your clothes ! let's start working", "success")
        end
        TaskPlayAnim(ped, 'clothingshirt', 'exit', 8.0, 1.0, -1, 49, 0, false, false, false)
    end)
    --checkPedClothes()
end)

RegisterNetEvent("tn-labs:cl:coke:usefigure", function()
    if lib.progressBar({
        duration = 6000,
        label = "Breaking figure",
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
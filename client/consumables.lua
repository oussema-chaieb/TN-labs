local QBCore = exports['qb-core']:GetCoreObject()

local function alienEffect()
    StartScreenEffect('DrugsMichaelAliensFightIn', 3.0, 0)
    Wait(math.random(5000, 8000))
    StartScreenEffect('DrugsMichaelAliensFight', 3.0, 0)
    Wait(math.random(5000, 8000))
    StartScreenEffect('DrugsMichaelAliensFightOut', 3.0, 0)
    StopScreenEffect('DrugsMichaelAliensFightIn')
    StopScreenEffect('DrugsMichaelAliensFight')
    StopScreenEffect('DrugsMichaelAliensFightOut')
end

local function CokeBaggyEffect()
    local startStamina = 20
    local ped = PlayerPedId()
    alienEffect()
    while startStamina > 0 do
        startStamina -= 1
        if math.random(1, 100) < 10 and IsPedRunning(ped) then
            SetPedToRagdoll(ped, math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
        end
        if math.random(1, 300) < 10 then
            alienEffect()
            Wait(math.random(3000, 6000))
        end
    end
    if IsPedRunning(ped) then
        SetPedToRagdoll(ped, math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
    end
end

local function Drug(effect)
    if effect == "weed" then
        RequestAnimSet("move_m@drunk@verydrunk")
        while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
            Wait(0)
        end
        SetPedMotionBlur(PlayerPedId(), true)
        SetPedMovementClipset(PlayerPedId(), "MOVE_M@DRUNK@VERYDRUNK", 1000)
        AnimpostfxPlay("CamPushInFranklin", 10000, true)
        ShakeGameplayCam("DRUNK_SHAKE", 0.3)
        Wait(math.random(25000, 38000))
        AnimpostfxPlay("DrugsDrivingOut", 3000, true)
        AnimpostfxStop("CamPushInFranklin")
        Wait(3000)
        AnimpostfxStop("DrugsDrivingOut")
        AnimpostfxStopAll()
        ShakeGameplayCam("DRUNK_SHAKE", 0.0)
        SetPedMotionBlur(PlayerPedId(), false)
        ResetPedMovementClipset(PlayerPedId(), 2000)
    elseif effect == "xanax" then
        RequestAnimSet("move_m@drunk@verydrunk")
        while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
            Wait(0)
        end
        SetPedMotionBlur(PlayerPedId(), true)
        SetPedMovementClipset(PlayerPedId(), "MOVE_M@DRUNK@VERYDRUNK", 1000)
        AnimpostfxPlay("DeadlineNeon", 10000, true)
        ShakeGameplayCam("DRUNK_SHAKE", 0.3)
        Wait(math.random(25000, 38000))
        AnimpostfxPlay("DrugsDrivingOut", 3000, true)
        AnimpostfxStop("DeadlineNeon")
        Wait(3000)
        AnimpostfxStop("DrugsDrivingOut")
        AnimpostfxStopAll()
        ShakeGameplayCam("DRUNK_SHAKE", 0.0)
        SetPedMotionBlur(PlayerPedId(), false)
        ResetPedMovementClipset(PlayerPedId(), 2000)
    elseif effect == "ecstasy" then
        RequestAnimSet("move_m@drunk@verydrunk")
        while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
            Wait(0)
        end
        SetPedMotionBlur(PlayerPedId(), true)
        SetPedMovementClipset(PlayerPedId(), "MOVE_M@DRUNK@VERYDRUNK", 1000)
        AnimpostfxPlay("DeathFailMichaelIn", 10000, true)
        ShakeGameplayCam("DRUNK_SHAKE", 0.3)
        Wait(math.random(25000, 38000))
        AnimpostfxPlay("DrugsDrivingOut", 3000, true)
        AnimpostfxStop("DeathFailMichaelIn")
        Wait(3000)
        AnimpostfxStop("DrugsDrivingOut")
        AnimpostfxStopAll()
        ShakeGameplayCam("DRUNK_SHAKE", 0.0)
        SetPedMotionBlur(PlayerPedId(), false)
        ResetPedMovementClipset(PlayerPedId(), 2000)
    elseif effect == "coke" then
        RequestAnimSet("move_m@alien")
        while not HasAnimSetLoaded("move_m@alien") do
            Wait(0)
        end
        SetPedMovementClipset(PlayerPedId(), "move_m@alien", 1000)
        AnimpostfxPlay("BeastLaunch", 10000, true)
        ShakeGameplayCam("DRUNK_SHAKE", 0.3)
        Wait(math.random(25000, 38000))
        AnimpostfxPlay("DrugsDrivingOut", 3000, true)
        AnimpostfxStop("BeastLaunch")
        Wait(3000)
        AnimpostfxStop("DrugsDrivingOut")
        AnimpostfxStopAll()
        ShakeGameplayCam("DRUNK_SHAKE", 0.0)
        ResetPedMovementClipset(PlayerPedId(), 2000)
    elseif effect == "Poison" then
        RequestAnimSet("move_m@drunk@verydrunk")
        while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
            Wait(0)
        end
        SetPedMotionBlur(PlayerPedId(), true)
        SetPedMovementClipset(PlayerPedId(), "MOVE_M@DRUNK@VERYDRUNK", 1000)
        AnimpostfxPlay("DeathFailMPIn", 10000, true)
        ShakeGameplayCam("DRUNK_SHAKE", 1.0)
        Wait(math.random(25000, 38000))
        AnimpostfxPlay("DrugsDrivingOut", 3000, true)
        AnimpostfxStop("DeathFailMPIn")
        Wait(3000)
        AnimpostfxStop("DrugsDrivingOut")
        AnimpostfxStopAll()
        ShakeGameplayCam("DRUNK_SHAKE", 0.0)
        SetPedMotionBlur(PlayerPedId(), false)
        ResetPedMovementClipset(PlayerPedId(), 2000)
    elseif effect == "trip" then
        RequestAnimSet("move_m@drunk@verydrunk")
        while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
            Wait(0)
        end
        SetPedMotionBlur(PlayerPedId(), true)
        SetPedMovementClipset(PlayerPedId(), "MOVE_M@DRUNK@VERYDRUNK", 1000)
        AnimpostfxPlay("DMT_flight", 10000, true)
        ShakeGameplayCam("DRUNK_SHAKE", 2.0)
        Wait(math.random(25000, 38000))
        AnimpostfxPlay("DrugsDrivingOut", 3000, true)
        AnimpostfxStop("DMT_flight")
        Wait(3000)
        AnimpostfxStop("DrugsDrivingOut")
        AnimpostfxStopAll()
        ShakeGameplayCam("DRUNK_SHAKE", 0.0)
        SetPedMotionBlur(PlayerPedId(), false)
    elseif effect == "alien" then
        ShakeGameplayCam("DRUNK_SHAKE", 3.0)
        RequestAnimSet("move_m@alien")
        while not HasAnimSetLoaded("move_m@alien") do
            Wait(0)
        end
        SetPedMovementClipset(PlayerPedId(), "move_m@alien", 1000)
        AnimpostfxPlay("DrugsMichaelAliensFight", 3.0, 0)
        Wait(math.random(25000, 38000))
        AnimpostfxPlay("DrugsMichaelAliensFightOut", 3.0, 0)
        ResetPedMovementClipset(PlayerPedId(), 2000)
        ShakeGameplayCam("DRUNK_SHAKE", 0.0)
        AnimpostfxStop("DrugsMichaelAliensFightIn")
        AnimpostfxStop("DrugsMichaelAliensFight")
        AnimpostfxStop("DrugsMichaelAliensFightOut")
    end
end

local function methanim()
    RequestAnimDict("rcmpaparazzo1ig_4")
    while (not HasAnimDictLoaded("rcmpaparazzo1ig_4")) do Wait(0) end
    TaskPlayAnim(PlayerPedId(), 'rcmpaparazzo1ig_4', 'miranda_shooting_up', 8.0, -8, -1, 49, 0, 0, 0, 0)
    local hash = GetHashKey("prop_syringe_01")
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(100)
        RequestModel(hash)
    end
    local prop = CreateObject(hash, GetEntityCoords(PlayerPedId()), true, true, true)
    AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.12, 0.03, 0.03,
        143.0
        ,
        30.0, 0.0, true, true, false, false, 1, true)
    lib.progressBar({
        duration = 12500,
        label = "Preparing seringe",
        useWhileDead = false,
        canCancel = false
    })
    Wait(1000)
    AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.03, -0.02,
        1.0, 0
        ,
        0.0, true, true, false, false, 1, true)
    lib.progressBar({
        duration = 13500,
        label = "Shooting Meth",
        useWhileDead = false,
        canCancel = false
    })
    DetachEntity(prop, 0, 0)
    DeleteEntity(prop)
    ClearPedTasks(PlayerPedId())
    using = false
    Drug("Poison")
end

RegisterNetEvent('tn-labs:cl:coke', function(quality)
    local ped = PlayerPedId()
    local addhealth = 0
    local addarmor = 0
    local addmeth = 0
    if quality < 10 then
        addhealth = 1
    elseif quality < 30 then
        addhealth = 15
        addarmor = 4
    elseif quality < 80 then
        addhealth = 40
        addarmor = 10
    else
        addhealth = 80
        addarmor = 30
    end
    QBCore.Functions.Progressbar("snort_coke", "snort coke", math.random(5000, 8000), false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "switch@trevor@trev_smoking_meth",
        anim = "trev_smoking_meth_loop",
        flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(ped, "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["_pure"], "remove")
        TriggerEvent("evidence:client:SetStatus", "widepupils", 200)
        AddArmourToPed(PlayerPedId(), addarmor)
        SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + addhealth)
        CokeBaggyEffect()
    end, function() -- Cancel
        StopAnimTask(ped, "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        QBCore.Functions.Notify("cancelled", "error")
    end)
end)

RegisterNetEvent('tn-labs:cl:methamine', function(quality)
    local hasitem = QBCore.Functions.HasItem("empty_syringe", 1)
    if not hasitem then QBCore.Functions.Notify('you need empty syringe','error') return end
    TriggerServerEvent("tn-labs:sv:removesyringandmeth")
    local addhealth = 0
    local addarmor = 0
    local addmeth = 0
    if quality < 10 then
        addarmor = 1
    elseif quality < 30 then
        addarmor = 15
        addhealth = 4
    elseif quality < 80 then
        addarmor = 40
        addhealth = 10
    else
        addarmor = 80
        addhealth = 30
    end
    methanim()
    AddArmourToPed(PlayerPedId(), addarmor)
    SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + addhealth)
end)
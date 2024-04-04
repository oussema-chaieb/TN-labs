local spawnedHydrochloricAcidBarrels = 0
local HydrochloricAcidBarrels = {}
local inhydrochloricField = false
local QBCore = exports['qb-core']:GetCoreObject()
local wearing = false
local ptfx

local function ValidateHydrochloricAcidCoord(plantCoord)
	local validate = true
	if spawnedHydrochloricAcidBarrels > 0 then
		for _, v in pairs(HydrochloricAcidBarrels) do
			if #(plantCoord-GetEntityCoords(v)) < 5 then
				validate = false
			end
		end
		if not inhydrochloricField then
			validate = false
		end
	end
	return validate
end

local function GetCoordZHydrochloricAcid(x, y)
	local groundCheckHeights = { 20.0, 21.0, 22.0, 23.0, 24.0, 175.0, 190.0, 200.0, 205.0, 215.0, 225.0 }

	for i, height in ipairs(groundCheckHeights) do
		local found2Ground, z = GetGroundZFor_3dCoord(x, y, height)

		if found2Ground then
			return z
		end
	end

	return 24.5
end

local function GenerateHydrochloricAcidCoords()
	while true do
		Wait(1)

		local weed2CoordX, weed2CoordY

		math.randomseed(GetGameTimer())
		local modX2 = math.random(-15, 15)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY2 = math.random(-15, 15)

		weed2CoordX = Config.CircleZones.HydrochloricAcidFarm.coords.x + modX2
		weed2CoordY = Config.CircleZones.HydrochloricAcidFarm.coords.y + modY2

		local coordZ2 = GetCoordZHydrochloricAcid(weed2CoordX, weed2CoordY)
		local coord2 = vector3(weed2CoordX, weed2CoordY, coordZ2)

		if ValidateHydrochloricAcidCoord(coord2) then
			return coord2
		end
	end
end

local function loadPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        RequestNamedPtfxAsset(dict)
        Citizen.Wait(50)
	end
end

local function gasanim()
    local ptfxAsset = "scr_jewelheist"
    local particleFx = "scr_jewel_fog_volume"

    loadPtfxAsset(ptfxAsset)

    SetPtfxAssetNextCall(ptfxAsset)
    ptfx = StartParticleFxLoopedAtCoord(particleFx, -1069.25, 4945.57, 212.18, 0.0, 0.0, 0.0, 0.5, false, false, false, false)
end

local function SpawnHydrochloricAcidBarrels()
	local model = `mw_hydro_barrel`
	while spawnedHydrochloricAcidBarrels < 5 do
		Wait(0)
		local weedCoords = GenerateHydrochloricAcidCoords()
		RequestModel(model)
		while not HasModelLoaded(model) do
			Wait(100)
		end
		local obj = CreateObject(model, weedCoords.x, weedCoords.y, weedCoords.z, false, true, false)
		PlaceObjectOnGroundProperly(obj)
		FreezeEntityPosition(obj, true)
		table.insert(HydrochloricAcidBarrels, obj)
		spawnedHydrochloricAcidBarrels = spawnedHydrochloricAcidBarrels + 1
	end
	SetModelAsNoLongerNeeded(model)
	gasanim()
end

RegisterNetEvent("tn-labs:client:hydrochloricacid", function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local nearbyObject, nearbyID

	for i=1, #HydrochloricAcidBarrels, 1 do
		if #(coords-GetEntityCoords(HydrochloricAcidBarrels[i])) < 2 then
			nearbyObject, nearbyID = HydrochloricAcidBarrels[i], i
		end
	end
	local hasItem = QBCore.Functions.HasItem('trowel')
    if not hasItem then return QBCore.Functions.Notify("you need a trowel","error") end
	if nearbyObject and IsPedOnFoot(playerPed) then
		isPickingUp = true
		TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
		QBCore.Functions.Progressbar("search_register", Lang:t("progressbar.collecting"), 10000, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {}, {}, {}, function()
			ClearPedTasks(playerPed)
			SetEntityAsMissionEntity(nearbyObject, false, true)
			DeleteObject(nearbyObject)

			table.remove(HydrochloricAcidBarrels, nearbyID)
			spawnedHydrochloricAcidBarrels -= 1

			TriggerServerEvent('tn-labs:pickedUpHydrochloricAcid')
			isPickingUp = false
		end, function()
			ClearPedTasks(playerPed)
			isPickingUp = false
		end)
	end
end)

RegisterNetEvent('tn-lab:client:putmaskhydro', function()
	local ped = PlayerPedId()
    if not wearing then
        QBCore.Functions.Progressbar("puton_mask", "Putting mask on..", 1000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = 'mp_masks@standard_car@ds@',
            anim = 'put_on_mask',
            flags = 16,
        }, {}, {}, function() -- Done
            SetPedComponentVariation(ped, 1, 154, 0)
            wearing = true
        end)
    elseif wearing then
        QBCore.Functions.Progressbar("putoff_mask", "Taking mask off..", 1000, false , true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = 'mp_masks@standard_car@ds@',
            anim = 'put_on_mask',
            flags = 16,
        }, {}, {}, function() -- Done
            SetPedComponentVariation(ped, 1, 0, 0)
            wearing = false
        end)
    end
end)

local function entringChemicalArea()
	CreateThread(function()
		while inhydrochloricField do
			local hasItem2 = QBCore.Functions.HasItem('sodium_mask')
			if not hasItem2 or not wearing then
				SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) - 18)
				SetFlash(0, 0, 500, 7000, 500)
				if math.random(1, 100) < 89 then
					SetFlash(0, 0, 500, 7000, 500)
					ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
					SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) - 10)
				end
			end
			Wait(3000)
		end
	end)
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for _, v in pairs(HydrochloricAcidBarrels) do
			SetEntityAsMissionEntity(v, false, true)
			DeleteObject(v)
		end
	end
end)

CreateThread(function()
	local hydrochloricZone = CircleZone:Create(Config.CircleZones.HydrochloricAcidFarm.coords, 50.0, {
		name = "tn-hydrochloriczone",
		debugPoly = false
	})
	hydrochloricZone:onPlayerInOut(function(isPointInside, point, zone)
        if isPointInside then
            inhydrochloricField = true
            SpawnHydrochloricAcidBarrels()
			--exports["76b-ui"]:Show("Attention", "Chemical Area, Be careful")
			entringChemicalArea()
        else
            inhydrochloricField = false
			--exports["76b-ui"]:Close()
        end
    end)
end)

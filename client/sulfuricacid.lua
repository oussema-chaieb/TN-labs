local spawnedSulfuricAcidBarrels = 0
local SulfuricAcidBarrels = {}
local inSulfuricFarm = false
local QBCore = exports['qb-core']:GetCoreObject()
local wearing = false
local ptfx

local function ValidateSulfuricAcidCoord(plantCoord)
	local validate = true
	if spawnedSulfuricAcidBarrels > 0 then
		for _, v in pairs(SulfuricAcidBarrels) do
			if #(plantCoord - GetEntityCoords(v)) < 5 then
				validate = false
			end
		end
		if not inSulfuricFarm then
			validate2 = false
		end
	end
	return validate
end

local function GetCoordZSulfuricAcid(x, y)
	local groundCheckHeights = { 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 150.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 18.31
end

local function GenerateSulfuricAcidCoords()
	while true do
		Wait(1)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-7, 7)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-7, 7)

		weedCoordX = Config.CircleZones.SulfuricAcidFarm.coords.x + modX
		weedCoordY = Config.CircleZones.SulfuricAcidFarm.coords.y + modY

		local coordZ = GetCoordZSulfuricAcid(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)

		if ValidateSulfuricAcidCoord(coord) then
			return coord
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
    ptfx = StartParticleFxLoopedAtCoord(particleFx, 3483.9, 2581.83, 14.33, 0.0, 0.0, 0.0, 0.5, false, false, false, false)
end

local function SpawnSulfuricAcidBarrels()
	local model = `mw_chemical_barrel`
	while spawnedSulfuricAcidBarrels < 6 do
		Wait(0)
		local weedCoords = GenerateSulfuricAcidCoords()
		RequestModel(model)
		while not HasModelLoaded(model) do
			Wait(100)
		end
		local obj = CreateObject(model, weedCoords.x, weedCoords.y, weedCoords.z, false, true, false)
		PlaceObjectOnGroundProperly(obj)
		FreezeEntityPosition(obj, true)
		table.insert(SulfuricAcidBarrels, obj)
		spawnedSulfuricAcidBarrels += 1
	end
	SetModelAsNoLongerNeeded(model)
	gasanim()
end


RegisterNetEvent("tn-labs:pickSulfuric", function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local nearbyObject, nearbyID

	for i=1, #SulfuricAcidBarrels, 1 do
		if #(coords - GetEntityCoords(SulfuricAcidBarrels[i])) < 2 then
			nearbyObject, nearbyID = SulfuricAcidBarrels[i], i
		end
	end
	local hasItem = QBCore.Functions.HasItem('trowel')
    if not hasItem then return QBCore.Functions.Notify("you need a trowel","error") end
	if nearbyObject and IsPedOnFoot(playerPed) then
		if not isPickingUp then
			isPickingUp = true
			TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
			QBCore.Functions.Progressbar("search_register", Lang:t("progressbar.collecting"), 10000, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {}, function() -- Done
				ClearPedTasks(PlayerPedId())
				SetEntityAsMissionEntity(nearbyObject, false, true)
				DeleteObject(nearbyObject)
				table.remove(SulfuricAcidBarrels, nearbyID)
				spawnedSulfuricAcidBarrels -= 1
				TriggerServerEvent('tn-labs:pickedUpSulfuricAcid')
				isPickingUp = false
			end, function()
				ClearPedTasks(PlayerPedId())
				isPickingUp = false
			end)
		end
	end
end)

RegisterNetEvent('tn-lab:client:putmasksulfuric', function()
	local ped = PlayerPedId()
    if not wearing then
        QBCore.Functions.Progressbar("putonnn_mask", "Putting mask on..", 1000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = 'mp_masks@standard_car@ds@',
            anim = 'put_on_mask',
            flags = 16,
        }, {}, {}, function() -- Done
            SetPedComponentVariation(ped, 1, 71, 0)
            wearing = true
        end)
    elseif wearing then
        QBCore.Functions.Progressbar("putaaoff_mask", "Taking mask off..", 1000, false , true, {
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
		while inSulfuricFarm do
			local hasItem2 = QBCore.Functions.HasItem('sulfuric_mask')
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
		for _, v in pairs(SulfuricAcidBarrels) do
			SetEntityAsMissionEntity(v, false, true)
			DeleteObject(v)
		end
	end
end)

CreateThread(function()
	local sulfuricZone = CircleZone:Create(Config.CircleZones.SulfuricAcidFarm.coords, 50.0, {
		name = "ps-sulfuriczone",
		debugPoly = false
	})
	sulfuricZone:onPlayerInOut(function(isPointInside, point, zone)
        if isPointInside then
            inSulfuricFarm = true
            SpawnSulfuricAcidBarrels()
			exports["76b-ui"]:Show("Attention", "Chemical Area, Be careful")
			entringChemicalArea()
        else
            inSulfuricFarm = false
			exports["76b-ui"]:Close()
        end
    end)
end)

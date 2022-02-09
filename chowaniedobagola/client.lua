local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtestaredObjtestect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local disabledTrunk = {
	[1] = "zentorno",
	[2] = "bdivo",
	[3] = "mini",
	[4] = "trophytruck2",
	[5] = "nova",
	[6] = "pista",
	[7] = "bullet",
	[8] = "gsxb",
	[9] = "ONEFIFTY55",
	[10] = "hs",
	[11] = "c63coupe",
	[12] = "arrinera",
	[13] = "tropos",
	[14] = "charge4",
	[15] = "regera",
	[16] = "ar33",
	[17] = "hermes",
	[18] = "rubi3d",
	[19] = "italigtb2",
	[20] = "jester2",
	[21] = "continental",
	[22] = "GP1",
	[23] = "boss429",
	[24] = "gt3rs",
	[25] = "infernus2",
	[26] = "turismo2",
	[27] = "610lb",
	[28] = "apollos",
	[29] = "e30mt2",
	[30] = "488",
	[31] = "aventadors",
	[32] = "pd458wb",
	[33] = "lp580",
	[34] = "mb300sl",
	[35] = "lp770",
	[36] = "650s",
	[37] = "rmodlp570",
	[38] = "morgan",
	[39] = "lykan",
	[40] = "ts1",
	[41] = "polaventa",
	[42] = "taxi"
}

local inTrunk = nil
local cam = 0

function checkTrunk(veh)
	for i = 1, #disabledTrunk do
		if GetEntityModel(veh) == GetHashKey(disabledTrunk[i]) then
			return false
		end
	end

	return true
end

function cameraTrunk()
	local ped = PlayerPedId()
	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		SetCamActive(cam, true)
		RenderScriptCams(true, false, 0, true, true)
		SetCamCoord(cam, GetEntityCoords(ped))
	end

	AttachCamToEntity(cam, ped, 0.0, -2.0, 1.0, true)
	SetCamRot(cam, -30.0, 0.0, GetEntityHeading(ped))
end

function cameraTrunkDisable()
	RenderScriptCams(false, false, 0, 1, 0)
	DestroyCam(cam, false)
end

function showNotification(msg, me, cop)
	if not cop or me == cop then
		ESX.ShowNotification(msg)
	else
		TriggerServerEvent('mrp_bagaznik:notify', cop, msg)
	end
end

RegisterNetEvent("mrp_bagaznik:forceIn")
AddEventHandler("mrp_bagaznik:forceIn", function(cop)
	local me = GetPlayerServerId(PlayerId())
	if not inTrunk then
		if not exports['esx_jailer']:getJailStatus() and not IsPedDeadOrDying(PlayerPedId(), 1) then
			local targetVehicle = ESX.Game.GetVehicleInDirection()
			if not DoesEntityExist(targetVehicle) then
				showNotification('Zbyt daleko do bagażnika', me, cop)
			elseif IsThisModelACar(GetEntityModel(targetVehicle)) and checkTrunk(targetVehicle) and not DoesVehicleHaveDoor(targetVehicle, 6) and DoesVehicleHaveDoor(targetVehicle, 5) then
				RequestAnimDict("fin_ext_p1-7")
				while not HasAnimDictLoaded("fin_ext_p1-7") do
					Citizen.Wait(0)
				end

				if DoesEntityExist(targetVehicle) then
					local d1, d2 = GetModelDimensions(GetEntityModel(targetVehicle))
					ESX.TriggerServerCallback('mrp_bagaznik:checkOccupied', function(plate)
						if plate then
							inTrunk = { vehicle = targetVehicle, plate = GetVehicleNumberPlateText(targetVehicle)}
							SetVehicleDoorOpen(targetVehicle, 5, false)
							local id = NetworkGetNetworkIdFromEntity(targetVehicle)

							SetNetworkIdCanMigrate(id, true)
							SetEntityAsMissionEntity(targetVehicle, true, false)
							SetVehicleHasBeenOwnedByPlayer(targetVehicle,  true)

							local ped = PlayerPedId()
							Citizen.InvokeNative(0xAAA34F8A7CB32098, ped)
							TaskPlayAnim(ped, "fin_ext_p1-7", "cs_devin_dual-7", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
							AttachEntityToEntity(ped, targetVehicle, 0, -0.1, d1.y + 0.85, d2.z - 0.87, 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
							TriggerServerEvent('mrp_bagaznik', true, inTrunk.plate)
						else
							showNotification('Ten bagażnik jest zajęty', me, cop)
						end
					end, GetVehicleNumberPlateText(targetVehicle))	
				else
					showNotification('Zbyt daleko do bagażnika', me, cop)
				end
			else
				showNotification('W tym aucie nie można umieścić w bagażniku!', me, cop)
			end
		else
			showNotification('Nie można umieścić w bagażniku', me, cop)
		end
	else
		showNotification('Już w bagażniku', me, cop)
	end
end)

RegisterNetEvent("mrp_bagaznik:forceOut")
AddEventHandler("mrp_bagaznik:forceOut", function(cop)
	if inTrunk then
		local ped = PlayerPedId()
		ClearPedTasks(ped)
		DetachEntity(ped)
		
		local DropCoords = GetEntityCoords(ped, true)
		SetEntityCoords(ped, DropCoords.x + 1.5, DropCoords.y + 1.5, DropCoords.z)

		SetVehicleDoorOpen(targetVehicle, 5, 1, 1)	
		cameraTrunkDisable()
		TriggerServerEvent('mrp_bagaznik', false, inTrunk.plate)
		inTrunk = nil
	else
		showNotification('Nie jesteś w bagażniku!', GetPlayerServerId(PlayerId()), cop)
	end
end)

RegisterNetEvent('playerDroped')
AddEventHandler('playerDroped', function()
	if inTrunk then
		TriggerServerEvent('mrp_bagaznik', false, inTrunk.plate)
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if inTrunk and DoesEntityExist(inTrunk.vehicle) and not IsPedDeadOrDying(PlayerPedId(), 1) and not exports['esx_policejob']:IsCuffed() then
			if IsControlJustReleased(0, Keys['H']) and GetVehicleDoorLockStatus(inTrunk.vehicle) < 2 then
				local ped = GetPedInVehicleSeat(inTrunk.vehicle, -1)
				if not DoesEntityExist(ped) or IsPedAPlayer(ped) then
					if GetVehicleDoorAngleRatio(inTrunk.vehicle, 5) > 0 then
						SetVehicleDoorShut(inTrunk.vehicle, 5, false)
					else
						SetVehicleDoorOpen(inTrunk.vehicle, 5, false, false)
					end
				end
			end

			if IsControlJustReleased(0, Keys['Y']) and GetVehicleDoorAngleRatio(inTrunk.vehicle, 5) > 0.0 then
				if not exports['esx_policejob']:IsCuffed() then
					TriggerEvent('mrp_bagaznik:forceOut')
				else
					ESX.ShowNotification('~r~Nie możesz wyjść z bagażnika będąc zakutym')
				end
			end
		end
		
		if inTrunk then
			local out = nil
			if DoesEntityExist(inTrunk.vehicle) then
				if IsEntityVisible(inTrunk.vehicle) then
					cameraTrunk()
					DisableControlAction(2, 24, true) -- Attack
					DisableControlAction(2, 257, true) -- Attack 2
					DisableControlAction(2, 25, true) -- Aim
					DisableControlAction(2, 263, true) -- Melee Attack 1
					DisableControlAction(2, Keys['R'], true) -- Reload
					DisableControlAction(2, Keys['TOP'], true) -- Open phone (not needed?)
					DisableControlAction(2, Keys['SPACE'], true) -- Jump
					DisableControlAction(2, Keys['Q'], true) -- Cover
					DisableControlAction(2, Keys['~'], true) -- Hands up
					DisableControlAction(2, Keys['B'], true) -- Pointing
					DisableControlAction(2, Keys['TAB'], true) -- Select Weapon
					DisableControlAction(2, Keys['F'], true) -- Also 'enter'?
					DisableControlAction(2, Keys['F3'], true) -- Animations
					DisableControlAction(2, Keys['LEFTSHIFT'], true) -- Running
					DisableControlAction(2, Keys['V'], true) -- Disable changing view
					DisableControlAction(2, 59, true) -- Disable steering in vehicle
					DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth
					DisableControlAction(0, 47, true)  -- Disable weapon
					DisableControlAction(0, 264, true) -- Disable melee
					DisableControlAction(0, 257, true) -- Disable melee
					DisableControlAction(0, 140, true) -- Disable melee
					DisableControlAction(0, 141, true) -- Disable melee
					DisableControlAction(0, 142, true) -- Disable melee
					DisableControlAction(0, 143, true) -- Disable melee
					DisableControlAction(0, 75, true)  -- Disable exit vehicle
					DisableControlAction(27, 75, true) -- Disable exit vehicle
					DisableControlAction(0, 73, true) -- Disable X (cancel anim)
					DisableControlAction(0, 11, true)
				else
					out = true
				end
			else
				out = false
			end

			if out ~= nil then
				TriggerEvent('wyspa_bagaznik:forceOut')
				if out then					
					Citizen.InvokeNative(0xEA1C610A04DB6BBB, PlayerPedId(), true)
				end
			end
		end
	end
end)

function checkInTrunk()
	return inTrunk ~= nil
end

AddEventHandler('esx:onPlayerSpawn', function()
	if inTrunk then
		TriggerEvent('mrp_bagaznik:forceOut')
	end
end)

-- Handcuff
CreateThread(function()
	while true do
		Citizen.Wait(1)
		--local playerPed = PlayerPedId()

	if kajdanki then
		DisableControlAction(2, 182, true) -- L
		DisableControlAction(2, 246, true) -- Y

		else
			Citizen.Wait(500)
		end
	end
end)

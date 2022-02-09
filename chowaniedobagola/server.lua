ESX                     = nil
TriggerEvent('esx:getShtestaredObjtestect', function(obj) ESX = obj end)

RegisterServerEvent('mrp_bagaznik:notify')
AddEventHandler('mrp_bagaznik:notify', function(cop, text)
	local xPlayer = ESX.GetPlayerFromId(cop)
	xPlayer.showNotification(text)
end)

local bryki = {
}


RegisterServerEvent('mrp_bagaznik')
AddEventHandler('mrp_bagaznik', function(zalezna, plate)
	if plate ~= nil then
		if zalezna then
			table.insert(bryki, plate)
		else
			for k,v in ipairs(bryki) do
				if v == plate then
					table.remove(bryki, k)
					break
				end
			end
		end
	end
end)

ESX.RegisterServerCallback('mrp_bagaznik:checkOccupied', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
	local found = false
	for k,v in ipairs(bryki) do
		if v == plate then
			found = true
			cb(false)
			break
		end
	end
	
	if not found then
		cb(true)
	end
end)
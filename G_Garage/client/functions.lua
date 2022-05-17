Citizen.CreateThread(function()
	while ESX == nil do 
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
        Citizen.Wait(5000) 
    end
    if ESX.IsPlayerLoaded() then 
        ESX.PlayerData = ESX.GetPlayerData() 
    end
end)

RegisterNetEvent('esx:playerLoaded') 
AddEventHandler('esx:playerLoaded', function(xPlayer) 
    ESX.PlayerData = xPlayer 
end)

function GetDataGarage()
    ESX.TriggerServerCallback('G_Garage:VehicleArrayGarage', function(data)
        Array.Garage = data
    end)
end

function GetDataPound()
    ESX.TriggerServerCallback('G_Garage:VehicleArrayPound', function(data)
        Array.Pound = data
    end)
end
	
function SpawnVehicle(vehicle, plate, spawn)
	ESX.Game.SpawnVehicle(vehicle.model, {x = spawn.x, y = spawn.y, z = spawn.z}, spawn.w, function(xVehicle)
		ESX.Game.SetVehicleProperties(xVehicle, vehicle)
		SetVehRadioStation(xVehicle, "OFF")
		SetVehicleFixed(xVehicle)
		SetVehicleDeformationFixed(xVehicle)
		SetVehicleUndriveable(xVehicle, false)
		SetVehicleEngineOn(xVehicle, true, true)
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), xVehicle, -1)
	end)
	TriggerServerEvent('G_Garage:VehicleStatue', plate, false)
end

function ReturnVehicle(v)
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		ESX.TriggerServerCallback('G_Garage:ReturnVehicle', function(cb)
			if cb then
                ESX.Game.DeleteVehicle(vehicle)
                TriggerServerEvent('G_Garage:VehicleStatue', vehicleProps.plate, true)
                ESX.ShowNotification("Vous venez de ranger votre véhicule")
			else
				ESX.ShowNotification("Vous ne pouvez pas ranger ce véhicule")
			end
		end, vehicleProps)
	else
		ESX.ShowNotification("Aucun véhicule proche")
	end
end

Citizen.CreateThread(function()
    for _,v in pairs(G_Garage.Garage.Pos) do
        local blip = AddBlipForCoord(v.Get.pos.x, v.Get.pos.y, v.Get.pos.z)
        SetBlipSprite(blip, G_Garage.Garage.Blip.Sprite)
        SetBlipScale (blip, G_Garage.Garage.Blip.Scale)
        SetBlipColour(blip, G_Garage.Garage.Blip.Colour)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(G_Garage.Garage.Blip.Title)
        EndTextCommandSetBlipName(blip)
    end
    for _,v in pairs(G_Garage.Pound.Pos) do
        local blip = AddBlipForCoord(v.pos.x, v.pos.y, v.pos.z)
        SetBlipSprite(blip, G_Garage.Pound.Blip.Sprite)
        SetBlipScale (blip, G_Garage.Pound.Blip.Scale)
        SetBlipColour(blip, G_Garage.Pound.Blip.Colour)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(G_Garage.Pound.Blip.Title)
        EndTextCommandSetBlipName(blip)
    end
end)

Citizen.CreateThread(function()
    GetDataGarage()
    GetDataPound()
end)

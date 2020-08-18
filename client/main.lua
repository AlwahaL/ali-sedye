ESX                           = nil
local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
      end
end)


Citizen.CreateThread(function()
	Citizen.Wait(100)
	while true do
		local sleepThread = 500
		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
		local dstCheck = GetDistanceBetweenCoords(pedCoords, Config.Menu["x"], Config.Menu["y"], Config.Menu["z"], true)
		if dstCheck <= 5.0 then
			sleepThread = 5
			local text = "EMS MENÜSÜ"
			if dstCheck <= 0.8 then
				text = "EMS menüsünü açmak için [~g~E~s~] Tusuna bas."
				if IsControlJustPressed(0, 38) then
				  AliMenuOpen(closestObject)
					
				end
			end
			DrawText3Ds(Config.Menu, text, 0.6)
		end
		if dstCheck >= 7.0 then
			Citizen.Wait(100)
		else
			Citizen.Wait(5)
		end
	end
end)



Citizen.CreateThread(function()
	while true do
		local sleep = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		local closestObject = GetClosestObjectOfType(pedCoords, 3.0, GetHashKey("v_med_bed2"), false)

		if DoesEntityExist(closestObject) then
			sleep = 5

			local bedCoords = GetEntityCoords(closestObject)
			local bedForward = GetEntityForwardVector(closestObject)
			local bedY = GetEntityForwardY(closestObject)
			
			local sitCoords = (bedCoords + bedForward * - 1.0)
			local pickupCoords = (bedCoords + bedForward * 1.2)
			local sagoturCoords = (bedCoords + bedForward * - 0.5)
			local soloturCoords = (bedCoords + bedForward * - 0.1)
			local dikyatCoords = (bedCoords + bedForward * 0.8 + bedY * -0.2)

			if GetDistanceBetweenCoords(pedCoords, sitCoords, true) <= 2.0 then
				ESX.ShowHelpNotification('[~g~E~s~] ile sedye menüsünü aç.')
				if IsControlJustPressed(0, 38) then
					OpenActionMenuInteraction(closestObject)
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

function OpenActionMenuInteraction(closestObject)

	local elements = {}

	table.insert(elements, {label = ('Sedyeyi Taşı'), value = 'sedyeyi_tasi'})
	table.insert(elements, {label = ('Yat'), value = 'normal_yat'})
	table.insert(elements, {label = ('Sağa Otur'), value = 'saga_otur'})
	table.insert(elements, {label = ('Sola Otur'), value = 'sola_otur'})
	table.insert(elements, {label = ('Dik Yat'), value = 'dik_yat'})
	table.insert(elements, {label = ('Menüyü kapat'), value = 'exit'})
  
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'action_menu',
		{
			title    = ('Sedye'),
			align    = 'top-left',
			elements = elements
		},
    function(data, menu)

		local player, distance = ESX.Game.GetClosestPlayer()

		ESX.UI.Menu.CloseAll()

		if data.current.value == 'sedyeyi_tasi' then
			exports.pNotify:SendNotification({
				text = "Sedyeyi taşıyorsun",
				type = "info",
				queue = "lmao",
				timeout = 4000,
				layout = "topRight"
			})
			PickUp(closestObject)
			menu.close()
		elseif data.current.value == 'normal_yat' then
			
			Yat(closestObject)
			menu.close()
		elseif data.current.value == 'saga_otur' then
			
			Sagotur(closestObject)
			menu.close()
		elseif data.current.value == 'sola_otur' then
			
			Solotur(closestObject)
			menu.close()
		elseif data.current.value == 'dik_yat' then
			
			Dikyat(closestObject)
			menu.close()
		end
  end)
end


function AliMenuOpen(closestObject)
	local ped = PlayerPedId()
	local elements = {}

	table.insert(elements, {label = ('Sedye Çıkar'), value = 'sedye_cikar'})
	table.insert(elements, {label = ('Tekerlekli Sandalye Çıkar'), value = 'wheel_cikar'})
	table.insert(elements, {label = ('Sedye veya Tekerlekli Sandalye Sil'), value = 'deleteObject'})
	table.insert(elements, {label = ('Menüyü kapat'), value = 'exit'})
  
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'action_menu',
		{
			title    = ('Sedye'),
			align    = 'top-left',
			elements = elements
		},
    function(data, menu)

		local player, distance = ESX.Game.GetClosestPlayer()

		ESX.UI.Menu.CloseAll()

		if data.current.value == 'sedye_cikar' then
			exports.pNotify:SendNotification({
				text = "Sedye çıkarıldı",
				type = "success",
				queue = "lmao",
				timeout = 4000,
				layout = "topRight"
			})

			LoadModel('v_med_bed2')
			local bed = CreateObject(GetHashKey('v_med_bed2'), Config.SedyeSpawn, true)
			
			menu.close()
		
		elseif data.current.value == 'wheel_cikar' then
			ExecuteCommand('wheelchair')
			
		elseif data.current.value == 'deleteObject' then 
			local bed = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 10.0, GetHashKey('v_med_bed2'))
				
			if DoesEntityExist(bed) then
			
				DeleteEntity(bed)
			
				
				
			end
			ExecuteCommand('removewheelchair')
			Citizen.Wait(100)
			ClearPedTasksImmediately(ped)
		end
  end)
end




RegisterCommand('wheelchair', function()
	LoadModel('prop_wheelchair_01')

	local wheelchair = CreateObject(GetHashKey('prop_wheelchair_01'), GetEntityCoords(PlayerPedId()), true)
end, false)

RegisterCommand('removewheelchair', function()
	local wheelchair = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 10.0, GetHashKey('prop_wheelchair_01'))

	if DoesEntityExist(wheelchair) then
		DeleteEntity(wheelchair)
	end
end, false)

Citizen.CreateThread(function()
	while true do
		local sleep = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		local closestObject = GetClosestObjectOfType(pedCoords, 3.0, GetHashKey("prop_wheelchair_01"), false)

		if DoesEntityExist(closestObject) then
			sleep = 5

			local wheelChairCoords = GetEntityCoords(closestObject)
			local wheelChairForward = GetEntityForwardVector(closestObject)
			
			local sitCoords = (wheelChairCoords + wheelChairForward * - 0.5)
			local pickupCoords = (wheelChairCoords + wheelChairForward * 0.3)

			if GetDistanceBetweenCoords(pedCoords, sitCoords, true) <= 1.0 then
				DrawText3Ds(sitCoords, "[E] Otur", 0.4)

				if IsControlJustPressed(0, 38) then
					SitWheel(closestObject)
				end
			end

			if GetDistanceBetweenCoords(pedCoords, pickupCoords, true) <= 1.0 then
				DrawText3Ds(pickupCoords, "[E] Tasi", 0.4)

				if IsControlJustPressed(0, 38) then
					exports.pNotify:SendNotification({
						text = "Tekerlekli sandalyeyi taşıyorsun",
						type = "info",
						queue = "lmao",
						timeout = 4000,
						layout = "topRight"
					})
					PickUpWheel(closestObject)
				end
			end
		end

		Citizen.Wait(sleep)
	end
end)

SitWheel = function(wheelchairObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 3) then
			ShowNotification("Somebody is already using the wheelchair!")
			return
		end
	end

	LoadAnim("missfinale_c2leadinoutfin_c_int")

	AttachEntityToEntity(PlayerPedId(), wheelchairObject, 0, 0, 0.0, 0.4, 0.0, 0.0, 180.0, 0.0, false, false, false, false, 2, true)

	local heading = GetEntityHeading(wheelchairObject)

	while IsEntityAttachedToEntity(PlayerPedId(), wheelchairObject) do
		Citizen.Wait(5)

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(PlayerPedId(), true, true)
		end

		if not IsEntityPlayingAnim(PlayerPedId(), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 3) then
			TaskPlayAnim(PlayerPedId(), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 8.0, 8.0, -1, 69, 1, false, false, false)
		end

		if IsControlPressed(0, 32) then
			local x, y, z  = table.unpack(GetEntityCoords(wheelchairObject) + GetEntityForwardVector(wheelchairObject) * -0.02)
			SetEntityCoords(wheelchairObject, x,y,z)
			PlaceObjectOnGroundProperly(wheelchairObject)
		end

		if IsControlPressed(1,  34) then
			heading = heading + 0.4

			if heading > 360 then
				heading = 0
			end

			SetEntityHeading(wheelchairObject,  heading)
		end

		if IsControlPressed(1,  9) then
			heading = heading - 0.4

			if heading < 0 then
				heading = 360
			end

			SetEntityHeading(wheelchairObject,  heading)
		end

		if IsControlJustPressed(0, 73) then
			DetachEntity(PlayerPedId(), true, true)

			local x, y, z = table.unpack(GetEntityCoords(wheelchairObject) + GetEntityForwardVector(wheelchairObject) * - 0.7)

			SetEntityCoords(PlayerPedId(), x,y,z)
		end
	end
end

PickUpWheel = function(wheelchairObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'anim@heists@box_carry@', 'idle', 3) then
			ShowNotification("Somebody is already driving the wheelchair!")
			return
		end
	end

	NetworkRequestControlOfEntity(wheelchairObject)

	LoadAnim("anim@heists@box_carry@")

	AttachEntityToEntity(wheelchairObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.00, -0.3, -0.73, 195.0, 180.0, 180.0, 0.0, false, false, true, false, 2, true)

	while IsEntityAttachedToEntity(wheelchairObject, PlayerPedId()) do
		Citizen.Wait(5)

		if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
			TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
		end

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(wheelchairObject, true, true)
		end

		if IsControlJustPressed(0, 73) then
			DetachEntity(wheelchairObject, true, true)
		end
	end
end





Sit = function(bedObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 3) then
			return
		end
	end

	LoadAnim("missfinale_c2leadinoutfin_c_int")

	AttachEntityToEntity(PlayerPedId(), bedObject, 0, 0, 0.0, 0.4, 0.0, 0.0, 180.0, 0.0, false, false, false, false, 2, true)

	local heading = GetEntityHeading(bedObject)

	while IsEntityAttachedToEntity(PlayerPedId(), bedObject) do
		Citizen.Wait(5)

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(PlayerPedId(), true, true)
		end

		if not IsEntityPlayingAnim(PlayerPedId(), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 3) then
			TaskPlayAnim(PlayerPedId(), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 8.0, 8.0, -1, 69, 1, false, false, false)
		end

		if IsControlPressed(0, 32) then
			local x, y, z  = table.unpack(GetEntityCoords(bedObject) + GetEntityForwardVector(bedObject) * -0.02)
			SetEntityCoords(bedObject, x,y,z)
			PlaceObjectOnGroundProperly(bedObject)
		end

		if IsControlPressed(1,  34) then
			heading = heading + 0.4

			if heading > 360 then
				heading = 0
			end

			SetEntityHeading(bedObject,  heading)
		end

		if IsControlPressed(1,  9) then
			heading = heading - 0.4

			if heading < 0 then
				heading = 360
			end

			SetEntityHeading(bedObject,  heading)
		end

		if IsControlJustPressed(0, 73) then
			DetachEntity(PlayerPedId(), true, true)

			local x, y, z = table.unpack(GetEntityCoords(bedObject) + GetEntityForwardVector(bedObject) * - 0.7)

			SetEntityCoords(PlayerPedId(), x,y,z)
		end
	end
end

Dikyat = function(bedObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'timetable@amanda@drunk@base', 'base', 3) then
			return
		end
	end

	LoadAnim("timetable@amanda@drunk@base")

	AttachEntityToEntity(PlayerPedId(), bedObject, 0, 0, 0.9, 1.4, 0.0, 0.0, 180.0, 0.0, false, false, false, false, 2, true)

	local heading = GetEntityHeading(bedObject)

	while IsEntityAttachedToEntity(PlayerPedId(), bedObject) do
		Citizen.Wait(5)

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(PlayerPedId(), true, true)
		end

		if not IsEntityPlayingAnim(PlayerPedId(), 'timetable@amanda@drunk@base', 'base', 3) then
			TaskPlayAnim(PlayerPedId(), 'timetable@amanda@drunk@base', 'base', 8.0, 8.0, -1, 69, 1, false, false, false)
		end
		
		if IsControlJustPressed(0, 73) then
			DetachEntity(PlayerPedId(), true, true)

			local x, y, z = table.unpack(GetEntityCoords(bedObject) + GetEntityForwardVector(bedObject) * - 0.7)

			SetEntityCoords(PlayerPedId(), x,y,z)
		end
	end
end

Sagotur = function(bedObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'amb@prop_human_seat_chair_mp@male@generic@base', 'base', 3) then
			return
		end
	end

	LoadAnim("amb@prop_human_seat_chair_mp@male@generic@base")

	AttachEntityToEntity(PlayerPedId(), bedObject, 0, -0.2, 0.0, 0.4, 0.0, 0.0, 90.0, 0.0, false, false, false, false, 2, true)

	local heading = GetEntityHeading(bedObject)

	while IsEntityAttachedToEntity(PlayerPedId(), bedObject) do
		Citizen.Wait(5)

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(PlayerPedId(), true, true)
		end

		if not IsEntityPlayingAnim(PlayerPedId(), 'amb@prop_human_seat_chair_mp@male@generic@base', 'base', 3) then
			TaskPlayAnim(PlayerPedId(), 'amb@prop_human_seat_chair_mp@male@generic@base', 'base', 8.0, 8.0, -1, 69, 1, false, false, false)
		end

		if IsControlJustPressed(0, 73) then
			DetachEntity(PlayerPedId(), true, true)

			local x, y, z = table.unpack(GetEntityCoords(bedObject) + GetEntityForwardVector(bedObject) * - 0.7)

			SetEntityCoords(PlayerPedId(), x,y,z)
		end
	end
end

Solotur = function(bedObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'amb@prop_human_seat_chair_mp@male@generic@base', 'base', 3) then
			return
		end
	end

	LoadAnim("amb@prop_human_seat_chair_mp@male@generic@base")

	AttachEntityToEntity(PlayerPedId(), bedObject, 0, 0.2, 0.0, 0.4, 0.0, 0.0, 270.0, 0.0, false, false, false, false, 2, true)

	local heading = GetEntityHeading(bedObject)

	while IsEntityAttachedToEntity(PlayerPedId(), bedObject) do
		Citizen.Wait(5)

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(PlayerPedId(), true, true)
		end

		if not IsEntityPlayingAnim(PlayerPedId(), 'amb@prop_human_seat_chair_mp@male@generic@base', 'base', 3) then
			TaskPlayAnim(PlayerPedId(), 'amb@prop_human_seat_chair_mp@male@generic@base', 'base', 8.0, 8.0, -1, 69, 1, false, false, false)
		end

		if IsControlJustPressed(0, 73) then
			DetachEntity(PlayerPedId(), true, true)

			local x, y, z = table.unpack(GetEntityCoords(bedObject) + GetEntityForwardVector(bedObject) * - 0.7)

			SetEntityCoords(PlayerPedId(), x,y,z)
		end
	end
end

Yat = function(bedObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'anim@gangops@morgue@table@', 'body_search', 3) then
			return
		end
	end

	LoadAnim("anim@gangops@morgue@table@")

	AttachEntityToEntity(PlayerPedId(), bedObject, 0, 0, 0.0, 1.4, 0.0, 0.0, 180.0, 0.0, false, false, false, false, 2, true)

	local heading = GetEntityHeading(bedObject)

	while IsEntityAttachedToEntity(PlayerPedId(), bedObject) do
		Citizen.Wait(5)

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(PlayerPedId(), true, true)
		end

		if not IsEntityPlayingAnim(PlayerPedId(), 'anim@gangops@morgue@table@', 'body_search', 3) then
			TaskPlayAnim(PlayerPedId(), 'anim@gangops@morgue@table@', 'body_search', 8.0, 8.0, -1, 69, 1, false, false, false)
		end

		if IsControlJustPressed(0, 73) then
			DetachEntity(PlayerPedId(), true, true)

			local x, y, z = table.unpack(GetEntityCoords(bedObject) + GetEntityForwardVector(bedObject) * - 0.7)

			SetEntityCoords(PlayerPedId(), x,y,z)
		end
	end
end

PickUp = function(bedObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'anim@heists@box_carry@', 'idle', 3) then
			ShowNotification("Somebody is already driving the bed!")
			return
		end
	end

	NetworkRequestControlOfEntity(bedObject)

	LoadAnim("anim@heists@box_carry@")

	AttachEntityToEntity(bedObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.00, -1.10, -1.0, 195.0, 180.0, 180.0, 0.0, false, false, true, false, 2, true)

	while IsEntityAttachedToEntity(bedObject, PlayerPedId()) do
		Citizen.Wait(5)

		if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
			TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
		end

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(bedObject, true, true)
		end

		if IsControlJustPressed(0, 73) then
			DetachEntity(bedObject, true, true)
		end
	end
end

DrawText3Ds = function(coords, text, scale)
	local x,y,z = coords.x, coords.y, coords.z
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(scale, scale)
	SetTextFont(1)
	SetTextProportional(0)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 215)

	AddTextComponentString(text)
	DrawText(_x, _y)

	local factor = (string.len(text)) / 370

	--DrawRect(_x, _y + 0.0150, 0.030 + factor, 0.025, 41, 11, 41, 100)
end

function GetPlayers()
    local players = {}

    for _, player in ipairs(GetActivePlayers()) do
        table.insert(players, player)
    end
    return players
end

GetClosestPlayer = function()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)
	
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	
	return closestPlayer, closestDistance
end

LoadAnim = function(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		
		Citizen.Wait(1)
	end
end

LoadModel = function(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		
		Citizen.Wait(1)
	end
end

ShowNotification = function(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringWebsite(msg)
	DrawNotification(false, true)
end

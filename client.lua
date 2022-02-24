--[[
──────────────────────────────────────────────────────────────────
	
	Support: https://discord.gg/eKFb5QM3YF
	
		!!! Change vaules in the config.lua !!!
	DO NOT EDIT THIS IF YOU DON'T KNOW WHAT YOU ARE DOING

──────────────────────────────────────────────────────────────────
]]--

-- Variables
IsDown = false
IsDead = false
secondsRemaining = Config.BleedoutTimer
local ReviveTimer = Config.ReviveTime
local RespawnTimer = Config.RespawnTime
local ReviveTimerShow = false
local RespawnTimerShow = false
local pulse = 0

-- Bleedout timer
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if secondsRemaining > 0 and IsDown or IsDead == true then
            secondsRemaining = secondsRemaining -1
		end
    end
end)

-- when player looses health they go down.
Citizen.CreateThread(function()
    while true do
    	local health = GetEntityHealth(PlayerPedId(-1))
        Citizen.Wait(0)
		if health > Config.DeadHealth and health < Config.DownHealth then
			IsDown = true
			IsDead = false
	    end
	end
end)

-- when player looses even more health they die.
Citizen.CreateThread(function()
    while true do
    	local health = GetEntityHealth(PlayerPedId(-1))
        Citizen.Wait(0)
		if health < Config.DeadHealth then
			IsDown = false
			IsDead = true
	    end
	end
end)

-- if player is down an animatoin will play.
Citizen.CreateThread(function()
    while true do
    	local ped = PlayerPedId(-1)
        Citizen.Wait(0)
        if IsDown == true then
			SetEnableHandcuffs(ped, true)
    		exports.spawnmanager:setAutoSpawn(false)        
        	DownText()
        	SetEntityHealth(ped, 200)
			loadAnimDict( "random@dealgonewrong" )
			TaskPlayAnim(PlayerPedId(-1), "random@dealgonewrong", "idle_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
		end
	end
end)

-- if the playeris dead then this animation will play.
Citizen.CreateThread(function()
    while true do
    	local ped = PlayerPedId(-1)
        Citizen.Wait(0)
        if IsDead == true then
			SetEnableHandcuffs(ped, true)
    		exports.spawnmanager:setAutoSpawn(false)
        	DeadText()
        	SetEntityHealth(ped, 200)
			loadAnimDict( "dead" )
			TaskPlayAnim(PlayerPedId(-1), "dead", "dead_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
		end
	end
end)


-- Commands
RegisterCommand("down", function(source, args, rawCommand)
	IsDead = false
	IsDown = true
end)

RegisterCommand("die", function(source, args, rawCommand)
	IsDown = false
	IsDead = true
end)

RegisterCommand("revive", function(source, args, rawCommand)   
    if IsDown or IsDead == true then
		RevivePlayer()
    end     
end)

RegisterCommand("respawn", function(source, args, rawCommand)   
    if IsDown or IsDead == true then
		RespawnPlayer()
    end     
end)

RegisterCommand("testp", function(source, args)
    local player = GetClosestPlayer()
    if player ~= false then
        if Config.UseChat then TriggerClientEvent("chatMessage", "^2[Pulse +]", {255,255,255}, " ^4Testing...") else notify('~h~~p~[Pulse + ] ~b~Testing...') end
        TriggerServerEvent('GetPedPulse-S', player)
    else
        if Config.UseChat then TriggerClientEvent("chatMessage", "^2[Pulse +]", {255,255,255}, " ^1There is no nearby player!") else notify('~r~There is no nearby player!') end 
    end
end)

RegisterCommand("pulseset", function(source, args)
    if Config.SetPulse then
        pulse = OnScreenKeyBoard('Pulse - Normal Resting Rate: 60 to 100')
            if pulse == nil or pulse == '' or tonumber(pulse) == nil then
                notify('~r~Invalid Pulse Provided!')
            end
            TriggerServerEvent('PulseSet-S', tonumber(pulse))
                if Config.UseChat then TriggerEvent("chatMessage", "^2[Pulse +]", {255,255,255}, " ^4Pulse Set To: ^2" .. tostring(pulse)) else notify('~h~~p~[Pulse + ] ~b~Pulse Set To: ~g~' .. tostring(pulse)) end
        else
            if Config.UseChat then TriggerEvent("chatMessage", "^2[Pulse +]", {255,255,255}, " ^4This server has disabled the ability to set your own pulse. Your pulse will be set automatically based on your health!") else notify('~h~~p~[Pulse + ] ~b~This server has disabled the ability to set your own pulse. Your pulse will be set automatically based on your health!') end
    end
end)

RegisterCommand('resetpulse', function(source, args)
    if Config.SetPulse then
        TriggerServerEvent('PulseSet-S', nil)
        if Config.UseChat then TriggerEvent("chatMessage", "^2[Pulse +]", {255,255,255}, " ^4Pulse Has Been Reset!") else notify('~h~~p~[Pulse + ] ~b~Pulse Has Been Reset') end
    else 
        if Config.UseChat then TriggerEvent("chatMessage", "^2[Pulse +]", {255,255,255}, " ^4This server has disabled the ability to set your own pulse. Your pulse will be set automatically based on your health!") else notify('~h~~p~[Pulse + ] ~b~This server has disabled the ability to set your own pulse. Your pulse will be set automatically based on your health!') end
	end
end)

-- Text when holding E
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)

		if IsDead or IsDown == true then
			if IsControlPressed(0, 51) then
				ReviveTimerShow = true
				text("~w~You will be revived in ~r~" .. ReviveTimer .. " ~w~seconds")
			elseif IsControlReleased(0, 51) then
				ReviveTimerShow = false
				ReviveTimer = Config.ReviveTime
			end
		end
	end
end)

-- Text when holding R
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)

		if IsDead or IsDown == true then
			if IsControlPressed(0, 45) then
				RespawnTimerShow = true
				text("~w~You will respawn in ~r~" .. RespawnTimer .. " ~w~seconds")
			elseif IsControlReleased(0, 45) then
				RespawnTimerShow = false
				RespawnTimer = Config.RespawnTime
			end
		end
	end
end)

-- Timers for when holding E or R
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1000)

		if ReviveTimerShow == true then
			if ReviveTimer > 0 then
				ReviveTimer = ReviveTimer -1
			elseif ReviveTimer == 0 then
				ReviveTimer = Config.ReviveTime
				RevivePlayer()
				ReviveTimerShow = false
			end
		elseif RespawnTimerShow == true then
			if RespawnTimer > 0 then
				RespawnTimer = RespawnTimer -1
			elseif RespawnTimer == 0 then
				RespawnTimer = Config.RespawnTime
				RespawnPlayer()
				RespawnTimerShow = false
			end
		end
	end
end)

-- Citizen Threads
Citizen.CreateThread(function ()
    while true do
        for _, player in ipairs(GetActivePlayers()) do
		    local player2 = GetClosestPlayer()
		    local ped = GetPlayerPed(player)
			local playerped = PlayerPedId()
            local pedpos = GetEntityCoords(ped)
			local playerpedpos = GetEntityCoords(playerped)
			local distance = #(playerpedpos - pedpos)
			local x, y, z = table.unpack(GetEntityCoords(ped))
			local offset = 0.1 + 0.1 * 0.1
			z = z + offset
			if distance < Config.DistToSee then
                if not Config.OnlyDead then
                    if ped ~= playerped then
                    DrawText3D(vector3(x, y, z), Config.PopUp)
                    if IsControlPressed(0, Config.Keybind) then
                        if Config.UseChat then TriggerEvent("chatMessage", "^2[Pulse +]", {255,255,255}, " ^4Testing...") else notify('~h~~p~[Pulse + ] ~b~Testing...') end
                        TriggerServerEvent('GetPedPulse-S', player2)
                        Citizen.Wait(10000)
                    end
                end
            else
                if ped ~= playerped then
                    if TriggerServerEvent('IsMofoDead', player2) then
                        DrawText3D(vector3(x, y, z), Config.PopUp)
                        if IsControlPressed(0, Config.Keybind) then
                            if Config.UseChat then TriggerEvent("chatMessage", "^2[Pulse +]", {255,255,255}, " ^4Testing...") else notify('~h~~p~[Pulse + ] ~b~Testing...') end
                            TriggerServerEvent('GetPedPulse-S', player2)
                            Citizen.Wait(10000)
                        end    
                    end
                end
            end
        end
        end
		Citizen.Wait(0)
    end
end)

-- Events
RegisterNetEvent('GetPedPulse-C')
AddEventHandler('GetPedPulse-C', function(pulse)
    Citizen.Wait(5000)
    if pulse == nil then pulse = 0.00 end
    if tonumber(pulse) < 45 or tonumber(pulse) > 165 then
        if Config.UseChat then TriggerEvent("chatMessage", "^2[Pulse +]", {255,255,255}, " ^4Pulse: ^2" .. tostring(pulse)) else notify('~h~~p~[Pulse + ] ~b~Pulse: ~r~' .. tostring(pulse)) end
    else
        if Config.UseChat then TriggerEvent("chatMessage", "^2[Pulse +]", {255,255,255}, " ^4Pulse: ^1" .. tostring(pulse)) else notify('~h~~p~[Pulse + ] ~b~Pulse: ~g~' .. tostring(pulse)) end
    end
end)


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
    	local health = GetEntityHealth(GetPlayerPed(-1))
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
    	local health = GetEntityHealth(GetPlayerPed(-1))
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
    	local ped = GetPlayerPed(-1)
        Citizen.Wait(0)
        if IsDown == true then
			SetEnableHandcuffs(ped, true)
    		exports.spawnmanager:setAutoSpawn(false)        
        	DownText()
        	SetEntityHealth(ped, 200)
			loadAnimDict( "random@dealgonewrong" )
			TaskPlayAnim(GetPlayerPed(-1), "random@dealgonewrong", "idle_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
		end
	end
end)

-- if the playeris dead then this animation will play.
Citizen.CreateThread(function()
    while true do
    	local ped = GetPlayerPed(-1)
        Citizen.Wait(0)
        if IsDead == true then
			SetEnableHandcuffs(ped, true)
    		exports.spawnmanager:setAutoSpawn(false)
        	DeadText()
        	SetEntityHealth(ped, 200)
			loadAnimDict( "dead" )
			TaskPlayAnim(GetPlayerPed(-1), "dead", "dead_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
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

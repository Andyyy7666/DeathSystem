--[[
──────────────────────────────────────────────────────────────────
	
	Support: https://discord.gg/eKFb5QM3YF
	
		!!! Change vaules in the config.lua !!!
	DO NOT EDIT THIS IF YOU DON'T KNOW WHAT YOU ARE DOING

──────────────────────────────────────────────────────────────────
]]--

-- Text function
function text(text)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.5, 0.5)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextOutline()
	SetTextJustification(0)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.5, 0.9)
end

function alert(msg) 
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function loadAnimDict(dict)
    RequestAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do        
        Citizen.Wait(1)
    end
end

-- Text when player is down.
function DownText(source)
	if secondsRemaining > 1 then 
        alert("Hold ~INPUT_CONTEXT~ to revive or ~INPUT_RELOAD~ to respawn")
	end
   	if secondsRemaining < 1 then 
		IsDown = false
		IsDead = true
   	end
end

-- Text when player dies.
function DeadText(nothing)
	if IsDead == true then
        alert("Hold ~INPUT_CONTEXT~ to revive or ~INPUT_RELOAD~ to respawn")
	end
end

function RevivePlayer()
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)
    SetEnableHandcuffs(ped, false)
    secondsRemaining = Config.BleedoutTimer
    IsDead = false
    IsDown = false
    SetPlayerInvisibleLocally(ped, true)
    Wait(300)
    ClearPedTasks(ped)
    SetPlayerInvisibleLocally(ped, false)        
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, true, false)
    SetEntityHealth(ped, 200) 
end

function RespawnPlayer()
    local ped = GetPlayerPed(-1)
    SetEnableHandcuffs(ped, false)
    IsDead = false
    IsDown = false
    DoScreenFadeOut(3000)
    Citizen.Wait(3000)
    SetEntityHealth(GetPlayerPed(-1), 200)      
    SetEntityCoords(GetPlayerPed(-1), 1853.0, 3710.9, 33.5)
    DoScreenFadeIn(3000)
    FreezeEntityPosition(GetPlayerPed(-1), false)
    ResetPedVisibleDamage(GetPlayerPed(-1))
    secondsRemaining = Config.BleedoutTimer
end

-- Check who the nearest person is
function GetClosestPlayer() local Ped = PlayerPedId() for _, Player in ipairs(GetActivePlayers()) do if GetPlayerPed(Player) ~= GetPlayerPed(-1) then local Ped2 = GetPlayerPed(Player) local x, y, z = table.unpack(GetEntityCoords(Ped)) if (GetDistanceBetweenCoords(GetEntityCoords(Ped2), x, y, z) <  2) then return GetPlayerServerId(Player) end end end return false end

-- Notify above map (disable in config.lua)
function notify(Text) SetNotificationTextEntry('STRING') AddTextComponentString(Text) DrawNotification(true, true) end

-- Keyboard Input Function For pulseset --
function OnScreenKeyBoard(TextEntry) AddTextEntry('FMMC_KEY_TIP1', TextEntry) DisplayOnscreenKeyboard(1, 'FMMC_KEY_TIP1', '', '', '', '', '', 5) BlockInput = true while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do Citizen.Wait(0) end if UpdateOnscreenKeyboard() ~= 2 then local Result = GetOnscreenKeyboardResult() Citizen.Wait(500) BlockInput = false return Result else Citizen.Wait(500) BlockInput = false return nil end end

-- Draw 3D Text | Credit: https://github.com/Cheleber/tag_admin
function DrawText3D(coords, text) local camCoords = GetGameplayCamCoord() local dist = #(coords - camCoords) local scale = 200 / (GetGameplayCamFov() * dist) SetTextScale(0.2, config.TextSize * scale) SetTextFont(4) SetTextColour(255, 255, 255, 255) SetTextDropshadow(0, 0, 0, 0, 255) SetTextEdge(2, 0, 0, 0, 150) SetTextOutline() SetTextCentre(1) SetTextProportional(1) SetTextDropShadow() SetTextCentre(true) BeginTextCommandDisplayText("STRING") AddTextComponentSubstringPlayerName(text) SetDrawOrigin(coords, 0) EndTextCommandDisplayText(0.0, 0.0) ClearDrawOrigin() end

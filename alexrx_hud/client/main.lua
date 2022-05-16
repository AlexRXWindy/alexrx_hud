--Edited por 'Alex_RX™#4718'
--Autor del codigo Medinaa#7364

ESX = exports.es_extended:getSharedObject()

Citizen.CreateThread(function()
    while true do 
        local s = 1000
        local ped = GetPlayerPed(-1)
        local MyPedVeh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
        
        -- Rdarar
        if IsPedSittingInAnyVehicle(ped) and not IsPlayerDead(ped) then

            DisplayRadar(true)

        elseif not IsPedSittingInAnyVehicle(ped) then

            DisplayRadar(false)

        end

        Citizen.Wait(s)
        
	end
	
end)

CreateThread(function()
    while true do
        Wait(1500)

        local hunger = 20

        local thirst = 20

        local stress = 0

        TriggerEvent('esx_status:getStatus', 'hunger', function(status) hunger = status.val / 10000 end)
       
        TriggerEvent('esx_status:getStatus', 'thirst', function(status) thirst = status.val / 10000 end)

        SendNUIMessage({
            action = 'send',
            minimap = IsRadarEnabled(),
            health = (GetEntityHealth(PlayerPedId())-100),
            armour = GetPedArmour(PlayerPedId()),
            hunger = hunger,
            thirst = thirst,
            inWater = IsPedSwimmingUnderWater(PlayerPedId()),
            o2 = round(GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10),
            map = IsPauseMenuActive(),
            anchor = GetMinimapAnchor(),
            stamina = (100 - GetPlayerSprintStaminaRemaining(PlayerId())),
            whenYouNeed = Config.WhenYouNeed
        })
    end
end)

function GetMinimapAnchor()
    -- Safezone goes from 1.0 (no gap) to 0.9 (5% gap (1/20))
    -- 0.05 * ((safezone - 0.9) * 10)
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    Minimap.width = xscale * (res_x / (4 * aspect_ratio))
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.right_x = Minimap.left_x + Minimap.width
    Minimap.top_y = Minimap.bottom_y - Minimap.height
    Minimap.x = Minimap.left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    return Minimap
end

round = function(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

RegisterNUICallback('onChangeColor', function(data)
    TriggerEvent('mdn:onChangeColor', data.color)
end)

RegisterNUICallback('closeNui', function(data)
    SetNuiFocus(false, false)

    if data.color then
        TriggerServerEvent('mdn_hud:saveColor', data.color)
    end
end)

RegisterCommand('changeColor', function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'changeColor'
    })
end)

RegisterCommand('hudColor', function()
    TriggerEvent('mdn_hud:checkHud')
end)

RegisterNetEvent('mdn_hud:checkHud', function()
    print('Checking Hud Data')
    ESX.TriggerServerCallback('mdn:getColor', function(color) 
        if color ~= nil then
            SendNUIMessage({
                action = 'onChangeColor',
                color = color
            })

            TriggerEvent('mdn:onChangeColor', color)
        end
    end)
end)

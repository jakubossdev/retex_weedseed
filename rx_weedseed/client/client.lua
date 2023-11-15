local coords2 = Config.location
local limit = 1
CreateThread(function()
    exports.ox_target:addSphereZone({
		coords = coords2,
		radius = 5,
		rotation = 135,
		debug = false,
		options = {
			{
				name = 'pickupweed',
				icon = 'fas fa-cannabis',
				event = "pickupWeed",
				label = _U('take_weedseed'),
			}
		}
	})
end)
local canDo = true
AddEventHandler('pickupWeed', function()
    if canDo then
        if exports.viper_scoreboard:getcopnumber() >= 0 then
            if limit <= 5 then
                local ped = PlayerPedId()
                local pCoords = GetEntityCoords(ped)
                local clicked = false
                TaskStartScenarioInPlace(ped, "world_human_gardener_plant", 0, true)
                FreezeEntityPosition(ped, true)
                exports.rprogress:MiniGame({
                    Difficulty = "Hard",
                    Timeout = 5000,
                    onComplete = function(success)
                            if success and not clicked then
                                clicked = true
                                lib.notify({
                                    title = _U('success'),
                                    description = _U('weedseed_success'),
                                    type = 'success'
                                })
                                ClearPedTasksImmediately(ped)
                                FreezeEntityPosition(ped, false)
                                local count = 1
                                TriggerServerEvent('weed:pickUp', coords, coords2, pCoords, clicked, Ped, count)
                                limit = limit + 1
                            elseif not success and not clicked then
                                limit = limit + 1
                                clicked = true
                                lib.notify({
                                    title = _U('error'),
                                    description = _U('weedseed_failed'),
                                    type = 'error'
                                })
                                ClearPedTasksImmediately(ped)
                                FreezeEntityPosition(ped, false)
                                local chance = math.random(0, 10)
                                if chance < 10 then
                                    local data = exports['cd_dispatch']:GetPlayerInfo()
                                    TriggerServerEvent('cd_dispatch:AddNotification', {
                                        job_table = {'police', 'sheriff', 'sahp'}, 
                                        coords = data.coords,
                                        title = _U('disptach_title'),
                                        message = _U('disptach_message'), 
                                        flash = 0,
                                        unique_id = data.unique_id,
                                        sound = 1,
                                        blip = {
                                            sprite = 51, 
                                            scale = 1.0, 
                                            colour = 1,
                                            flashes = false, 
                                            text = _U('disptach_text'),
                                            time = 5,
                                            radius = 0,
                                        }
                                    })
                                end
                            end    
                    end,
                    onTimeout = function()
                        ClearPedTasksImmediately(ped)
                        FreezeEntityPosition(ped, false)
                    end
                })
            elseif limit > 5 then
                lib.notify({
                    title = _U('error'),
                    description = _U('weedseed_wait'),
                    type = 'error'
                })
                canDo = false
                SetTimeout(210000, function()
                    canDo = true
                    limit = 0
                end)
            end
        else
            lib.notify({
                title = _U('error'),
                description = _U('weedseed_error'),
                type = 'error'
            })
        end
    end
end)
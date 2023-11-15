local coords2 = vec3(2224.9229, 5576.7070, 54.3)
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
				label = "Sebrat semínko trávy",
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
                                    title = 'ÚSPĚCH',
                                    description = 'Úspěšně jsi sebral semínko trávy',
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
                                    title = 'NEÚSPĚCH',
                                    description = 'Nepodařilo se ti sebrat semínko trávy',
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
                                        title = '10-18 - Trespassing',
                                        message = 'Nějaká osoba vnikla na soukromý pozemek', 
                                        flash = 0,
                                        unique_id = data.unique_id,
                                        sound = 1,
                                        blip = {
                                            sprite = 51, 
                                            scale = 1.0, 
                                            colour = 1,
                                            flashes = false, 
                                            text = '10-18 - Trespassing',
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
                    title = 'ERROR',
                    description = 'Počkej až rostlina znovu vyroste',
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
                title = 'ERROR',
                description = 'Tato akce není nyní možná',
                type = 'error'
            })
        end
    end
end)
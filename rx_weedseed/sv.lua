RegisterNetEvent('weed:pickUp')
AddEventHandler('weed:pickUp', function(coords, coords2, pCoords, clicked, Ped, con)
    local _source = source
    if con ~= 1 then
        exports['wx_anticheat']:ban(_source,"Blacklisted server event: weed:pickUp (count)")
        return
    end
    if #(GetEntityCoords(GetPlayerPed(_source)) - pCoords) > 0.5 then
        exports['wx_anticheat']:ban(_source,"Blacklisted server event: weed:pickUp (dst ped)")
        return
    end
    if Ped ~= nil then
        exports['wx_anticheat']:ban(_source,"Blacklisted server event: weed:pickUp (dst ped)")
        return
    end
    if not clicked then
        exports['wx_anticheat']:ban(_source,"Blacklisted server event: weed:pickUp (dst ped)")
        return
    end
    if exports.ox_inventory:CanCarryItem(_source, 'weed_seed', 1) then
        exports.ox_inventory:AddItem(_source, 'weed_seed', 1)
        for k, v in pairs(GetPlayerIdentifiers(source)) do
			if string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			end
		end
		exports['wx_logs']:SendLog('drugs',{
			title = "Sběr Drugs",
			description = "Hráč **"..GetPlayerName(source).."** license: **"..license.."** -> `Item:` **weed_seed**\n`Počet:` **1x**",
		})
    else
        for k, v in pairs(GetPlayerIdentifiers(source)) do
			if string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			end
		end
		exports['wx_logs']:SendLog('drugs',{
			title = "Sběr Drugs",
			description = "Hráč **"..GetPlayerName(source).."** license: **"..license.."** -> Hráči se nepodařilo sebrat semínko trávy -> nemá místo",
		})
    end
end)
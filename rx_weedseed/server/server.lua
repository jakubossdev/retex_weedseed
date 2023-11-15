RegisterNetEvent('weed:pickUp')
AddEventHandler('weed:pickUp', function(coords, coords2, pCoords, clicked, Ped, con)
    local _source = source
    if con ~= 1 then
        Drop(_source, "Blacklisted server event: weed:pickUp (dst ped)")
        return
    end
    if #(GetEntityCoords(GetPlayerPed(_source)) - pCoords) > 0.5 then
        Drop(_source, "Blacklisted server event: weed:pickUp (dst ped)")
        return
    end
    if Ped ~= nil then
        Drop(_source, "Blacklisted server event: weed:pickUp (dst ped)")
        return
    end
    if not clicked then
        Drop(_source, "Blacklisted server event: weed:pickUp (dst ped)")
        return
    end
    if exports.ox_inventory:CanCarryItem(_source, 'weed_seed', 1) then
        exports.ox_inventory:AddItem(_source, 'weed_seed', 1)
    end
end)
RegisterNetEvent("carRental:pay")
AddEventHandler("carRental:pay", function(id, table)
    if table ~= nil then
        local cat = Config.cars[table.category]
        local car = cat[id]
        if not car then return end
        local src = table.plrid
        local player = NDCore.getPlayer(table.plrid)
        if player.cash >= car.price then
            player.deductMoney(car.price, src, "cash")
            TriggerClientEvent("carRental:confirm", src, table)
            return
        elseif player.bank >= car.price then
            player.deductMoney(car.price, src, "bank")
            TriggerClientEvent("carRental:confirm", src, table)
        elseif player.cash < car.price or player.bank < car.price then
            TriggerClientEvent("poor", id)
            return
        end    
        TriggerClientEvent("carRental:deny", src)
    end
end)

function func(src)
    TriggerClientEvent("Registered")
end

RegisterCommand("registerleo", func, false)

function jobHasAccess(job, info)
    if not info.jobs then return true end
    for _, jobName in pairs(info.jobs) do
        if job == jobName then return true end
    end
    return false
end

RegisterNetEvent("Returned", function (src, amount, vehicle, tf, netid)
    amount = tonumber(amount)
    src = tonumber(src)
    local player = NDCore.getPlayer(src)
    print(tostring(src) .. " returned a LEO vehicle")
    if tf == true then
        player.addMoney("cash",  amount, "Returned Vehicle")
    end
    local vehicle = NetworkGetEntityFromNetworkId(netid)
    DeleteEntity(vehicle)  
    NDCore.giveVehicleAccess(src, vehicle, false)
end)

RegisterNetEvent("Sold", function (tbl)
    local netid = NetworkGetEntityFromNetworkId(tbl.veh)
    print(tostring(tbl.src) .. " Rented an LEO Vehicle")
    NDCore.giveVehicleAccess(tonumber(tbl.src), netid, true)
end)

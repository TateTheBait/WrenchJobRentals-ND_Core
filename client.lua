local rentedcars = {}

local Peds = {}

local blips = {}


RegisterNetEvent("poor", function ()
    lib.notify({
        title = "Wrench Leo Rental",
        description = "You don't have the required amount of money to rent a this vehicle!",
        icon = "hand-fist",
    })
end)


RegisterNetEvent("carRental:confirm", function(table)
    local veh = 0
    local car = table.car
    SelectedCar = table.car
    RequestModel(car.hash)
    veh = CreateVehicle(car.hash, table.location.x, table.location.y, table.location.z, table.location.w, true, false)
    if car.vehicleextras then
        for eid, extra in pairs(car.vehicleextras) do
            SetVehicleExtra(veh, eid, extra)
        end
    else
        for num=1, 14 do 
            SetVehicleExtra(veh, num , 1)
        end
    end
    if car.livery then
        SetVehicleLivery(veh, car.livery)
    end
    VEHICLE = veh
    SetVehicleEngineOn(veh, true, true, false)
    if DoesEntityExist(veh) then     
        SetVehicleDirtLevel(veh, 0.00)
        lib.notify({
            title = "Wrench Leo Rental",
            description = "Successfully rented vehicle for $" .. tostring(car.price) .. "!",
            icon = "hand-fist",
        })
        local netid = NetworkGetNetworkIdFromEntity(veh)
        Netid = netid
        local tbl = {
            veh = netid,
            src = cache.serverId,
        }
        Wait(200)
        TriggerServerEvent("Sold", tbl)
        lib.hideTextUI()
        rentedcars.vehicle = veh
    end
end)

RegisterNetEvent("carRental:deny", function()
    if not rentedcars.vehicle then return end
    local cat = Config.cars[Category]
    local car = cat[SelectedCar]
    lib.notify({
        title = 'Purchase Error',
        description = 'Not enough cash. - $' .. car.price .. " needed.",
        position = 'bottom',
        style = {
            backgroundColor = '#141517',
            color = '#909296'
        },
        icon = 'ban',
        iconColor = '#C53030'
    })
end)

-- Rentals
local function getcars(location)
    local cars = {}
    local cartable = {}
    Locationtbl = {}
    if location.jobs then
        for _, job in pairs(location.jobs) do
            if tostring(NDCore.getPlayer().job) == tostring(job) then
                for _, i in pairs(location.categories) do
                    for _, car in pairs(Config.cars[i]) do
                            if car.ranks then
                                for _, rank in pairs(car.ranks) do
                                    if NDCore.getPlayer().jobInfo.rankName == rank then
                                        if not car.hasrun then
                                            car.hasrun = true
                                            cartable[#cartable + 1] = (car)
                                        end
                                    end
                                end
                            else
                                for _, car in pairs(Config.cars[i]) do
                                    if not car.hasrun then
                                        car.hasrun = true
                                        cartable[#cartable + 1] = (car)
                                    end
                                end
                            end
                        end
                        for _, i in pairs(location.categories) do
                            for _, car in pairs(Config.cars[i]) do
                                car.hasrun = nil
                            end
                        end
                
                    for id, car in pairs(cartable) do
                        cars[#cars + 1] = {
                            title = car.name,
                            onSelect = function()
                                local tbl = {
                                    location = location.vehspawnlocation,
                                    car = Config.cars[i][id],
                                    plrid = cache.serverId
                                }
                                TriggerServerEvent("carRental:pay", id, tbl)
                            end,
                            metadata = {
                                {label = 'Deposit', value = car.price},
                            }
                        }
                    end
                end
            end
        end
    else
        for _, i in pairs(location.categories) do
            for _, car in pairs(Config.cars[i]) do
                    if car.ranks then
                        for _, rank in pairs(car.ranks) do
                            if not car.hasrun then
                                car.hasrun = true
                                if NDCore.getPlayer().job.rankName == rank then
                                    car.hasrun = true
                                    cartable[#cartable + 1] = (car)
                                end
                            end
                        end
                    else
                        for _, car in pairs(Config.cars[i]) do
                            if not car.hasrun then
                                car.hasrun = true
                                cartable[#cartable + 1] = (car)
                            end
                        end
                    end
                end
                for _, i in pairs(location.categories) do
                    for _, car in pairs(Config.cars[i]) do
                        car.hasrun = nil
                    end
                end
        
            for id, car in pairs(cartable) do
                    cars[#cars + 1] = {
                        title = car.name,
                        onSelect = function()
                            local tbl = {
                                location = location.vehspawnlocation,
                                car = Config.cars[i][id],
                                plrid = cache.serverId
                            }
                            TriggerServerEvent("carRental:pay", id, tbl)
                        end,
                        metadata = {
                            {label = 'Deposit', value = car.price},
                        }
                    }
            end
        end
    end
    Wait(300)
    return(cars)
end


RETURNVEHICLE = {
    label = "Return Last Vehicle",
    onSelect = function()
        if rentedcars.vehicle then
            if GetVehicleBodyHealth(VEHICLE) >= 300 and DoesEntityExist(VEHICLE) then
                TriggerServerEvent("Returned", cache.serverId, SelectedCar.price, rentedcars.vehicle, true, Netid)
                lib.notify({
                    title = "Wrench Leo Rental",
                    description = "Thank you for returning your vehicle.",
                    icon = "hand-fist",
                })
            else
                TriggerServerEvent("Returned", cache.serverId, SelectedCar.price, rentedcars.vehicle, false, Netid)
                lib.notify({
                    title = "Wrench Leo Rental",
                    description = "Your car is severely damaged or has been destroyed, please repair it before returning next time!",
                    icon = "hand-fist",
                })
            end
            rentedcars = {}
        else
            lib.notify({
                title = "Wrench Leo Rental",
                description = "You haven't rented a vehicle yet!!!",
                icon = "hand-fist",
            })
        end
    end,
    icon = "caret-right"
}

local function createblip(location)
    AddTextEntry('BlipName', tostring(location.name) .. ' Vehicle Rental')
    local blip = AddBlipForCoord(location.pedlocation)
    SetBlipSprite(blip, 672)
    SetBlipColour(blip, 47)
    BeginTextCommandSetBlipName("BlipName")
    EndTextCommandSetBlipName(blip)
    SetBlipDisplay(blip, 2)
    SetBlipAsShortRange(blip, true)
    blips[#blips+1] = blip
end



local function spawnaiped(location)
    local model = lib.requestModel(location.pedhash)
    local ped = NDCore.createAiPed({
        model = model, 
        coords = vector4(location.pedlocation.x, location.pedlocation.y, location.pedlocation.z-1, location.pedlocation.w),
        anim = {
            clip = "WORLD_HUMAN_COP_IDLES"
        }, 
        options = {
            {
                label = "Open Menu",
                onSelect = function()
                    lib.showContext(tostring(location.name) .. '_menu')
                end,
                icon = "car-rear"
            }, 
            RETURNVEHICLE
        }
    })
    createblip(location)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_COP_IDLES", 0, true)
    Peds[#Peds+1] = ped
end



local function peds()
    for _, ped in pairs(Peds) do
        DeletePed(ped)
    end
    for _, blip in pairs(blips) do
        RemoveBlip(blip)
    end
    for _, location in pairs(Config.locations) do
        local isgood = false
        if location.jobs then
            for _, job in pairs(location.jobs) do
                if NDCore.getPlayer().job == tostring(job) then
                    isgood = true
                end
            end
        else
            isgood = true
        end
        if isgood == true then
            spawnaiped(location)
        end
    end
end

RegisterNetEvent("ND:characterLoaded", function ()
    local player = NDCore.getPlayer()
    lib.notify({
        label = "Job Rental",
        title = "Job Rentals",
        description = tostring(player.job) .. " Character Registered!"
    })
    for _, location in pairs(Config.locations) do
        location.menu = lib.registerContext({
            id = tostring(location.name) .. '_menu',
            title = location.name .. " Rental",
            options = getcars(location),
        })
    end
    peds()
end)


AddEventHandler("ND:characterUnloaded", function(character)
    if rentedcars.vehicle then
        if GetVehicleBodyHealth(VEHICLE) >= 300 and DoesEntityExist(VEHICLE) then
            TriggerServerEvent("Returned", cache.serverId, SelectedCar.price, rentedcars.vehicle, true, Netid)
        else
            TriggerServerEvent("Returned", cache.serverId, SelectedCar.price, rentedcars.vehicle, false, Netid)
        end
        rentedcars = {}
    end
end)


if NDCore.getPlayer() ~= nil then
    local player = NDCore.getPlayer()
    lib.notify({
        label = "Job Rental",
        title = "Job Rentals",
        description = tostring(player.job) .. " Character Registered!"
    })
    for _, location in pairs(Config.locations) do
        location.menu = lib.registerContext({
            id = tostring(location.name) .. '_menu',
            title = location.name .. " Rental",
            options = getcars(location),
        })
    end
    peds()
end

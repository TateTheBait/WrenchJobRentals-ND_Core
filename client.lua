local rentedcars = {}

local Peds = {}


RegisterNetEvent("poor")
AddEventHandler("poor", function ()
    lib.notify({
        title = "Wrench Leo Rental",
        description = "You don't have the required amount of money to rent a this vehicle!",
        icon = "hand-fist",
    })
end)


RegisterNetEvent("carRental:confirm")
AddEventHandler("carRental:confirm", function(table)
        local veh = 0
        local car = table.car
        SelectedCar = table.car
        RequestModel(car.hash)
        while not HasModelLoaded(car.hash) do
            Wait(10)
        end
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

RegisterNetEvent("carRental:deny")
AddEventHandler("carRental:deny", function()
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
function getcars(location)
    local cars = {}
    local cartable = {}
    Locationtbl = {}
    for _, job in pairs(location.jobs) do
        if tostring(NDCore.getPlayer().job) == tostring(job) then
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

function peds()
    for _, ped in pairs(Peds) do
        DeletePed(ped)
    end
    for _, location in pairs(Config.locations) do
        local isgood = false
        for _, job in pairs(location.jobs) do
            if NDCore.getPlayer().job == tostring(job) then
                isgood = true
            end
        end
            if isgood == true then
                local model = lib.requestModel(location.pedhash)
                local ped = CreatePed(4, model, location.pedlocation.x, location.pedlocation.y, location.pedlocation.z-1, location.pedlocation.w, false, false)
                FreezeEntityPosition(ped, true)
                SetEntityInvincible(created_ped, true)
                SetBlockingOfNonTemporaryEvents(ped, true)
                TaskStartScenarioInPlace(ped, "WORLD_HUMAN_COP_IDLES", 0, true)
                local optio = {
                    label = "Open Menu",
                    onSelect = function()
                        lib.showContext(tostring(location.name) .. '_menu')
                    end,
                    icon = "car-rear"
                  }
                exports.ox_target:addLocalEntity(ped, optio)
                exports.ox_target:addLocalEntity(ped, RETURNVEHICLE)
                
                Peds[#Peds+1] = ped
         end
    end
end

RegisterNetEvent("ND:characterLoaded")
AddEventHandler("ND:characterLoaded", function()
    for _, location in pairs(Config.locations) do
        location.menu = lib.registerContext({
            id = tostring(location.name) .. '_menu',
            title = location.name .. " Rental",
            options = getcars(location),
        })
    end
    peds()
end)

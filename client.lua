selectedcar = 0

rentedcars = {}

Distcount = 1

Targets = {}

Peds = {}

Jobs = {}
Location = {}

Runcount = 0

Wait(1000)

for _, location in pairs(Config.locations) do
    for _, fjob in pairs(location.jobs) do
        Jobs[#Jobs+1] = fjob
    end
    Location[#Location+1] = location
end


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
    if not selectedcar then return end
        local veh = 0
        local cat = Config.cars[table.category]
        local car = cat[selectedcar]
        SelectedCar = cat[selectedcar]
        RequestModel(car.hash)
        while not HasModelLoaded(car.hash) do
            Wait(10)
        end
        if table.x == nil or table.y == nil or table.z == nil then
            veh = CreateVehicle(car.hash, table.location.x, table.location.y, table.location.z, table.location.w, true, false)
        elseif table.location.x ~= 0 and table.location.x ~= 0 and table.location.x ~= 0 then
            veh = CreateVehicle(car.hash, table.location.x, table.location.y, table.location.z, table.location.w, true, false)
        else
            veh = CreateVehicle(car.hash, pedCoords.x, pedCoords.y-5, pedCoords.z, GetEntityHeading(ped), true, false)
        end
        for num=1, 14 do 
            SetVehicleExtra(
                veh --[[ Vehicle ]], 
                num --[[ integer ]], 
                1 --[[ boolean ]]
            )
        end
        VEHICLE = veh
        SetVehicleEngineOn(veh, true, true, false)
        if DoesEntityExist(veh) then     
            SetVehicleDirtLevel(veh, 0.00)
            lib.notify({
                title = "Wrench Leo Rental",
                description = "Successfully rented vehicle!",
                icon = "hand-fist",
            })
            local netid = NetworkGetNetworkIdFromEntity(veh)
            Netid = netid
            local tbl = {
                veh = netid,
                src = GetPlayerServerId(PlayerId()),
                ndsrc = NDCore.getPlayer().source
            }
            TriggerServerEvent("Sold", tbl)
            lib.hideTextUI()
            selectedcar = nil 
            rentedcars.vehicle = veh
        end
end)

RegisterNetEvent("carRental:deny")
AddEventHandler("carRental:deny", function()
    if not SelectedCar then return end
    local cat = Config.cars[Category]
    local car = cat[SelectedCar]
    selectedcar = nil 
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
    local Cars2 = {}
    local cartable = {}
    local cartable2 = {}
    Locationtbl = {}
    local tcartable = {}
            local sruncount = 0
            for _, job in pairs(location.jobs) do
                if tostring(NDCore.getPlayer().job) == tostring(job) then
                       
                        for _, i in pairs(location.categories) do
                                
                                for _, car in pairs(Config.cars[i]) do
                                        cartable[#cartable + 1] = (car)
                                end
                                for id, car in pairs(cartable) do
                                    if type(car) ~= "boolean" then
                              
                                        cars[#cars + 1] = {
                                            title = car.name,
                                            onSelect = function(args)
                                                selectedcar = id
                                                local tbl = {
                                                    location = location.vehspawnlocation,
                                                    category = i,
                                                    plrid = GetPlayerServerId(PlayerId())
                                                }
                                                    TriggerServerEvent("carRental:pay", id, tbl)
                                            end,
                                            metadata = {
                                                {label = 'Deposit', value = car.price},
                                            }
                                        }
                                end
                            end
                                Cars = cars
                            end
                        end
                    end
            return(Cars)
end

RETURNVEHICLE = {
    label = "Return Last Vehicle",
    onSelect = function()
            if rentedcars.vehicle then
                if GetVehicleBodyHealth(VEHICLE) >= 300 and DoesEntityExist(VEHICLE) then
                    TriggerServerEvent("Returned", GetPlayerServerId(PlayerId()), SelectedCar.price, rentedcars[vehicle], true, Netid)
                    lib.notify({
                        title = "Wrench Leo Rental",
                        description = "Thank you for returning your vehicle.",
                        icon = "hand-fist",
                    })
                else
                    TriggerServerEvent("Returned", GetPlayerServerId(PlayerId()), SelectedCar.price, rentedcars[vehicle], false, Netid)
                    lib.notify({
                        title = "Wrench Leo Rental",
                        description = "Your car is severely damaged or has been destroyed, please repair it before returning next time!",
                        icon = "hand-fist",
                    })
                end
                rentedcars = {}
                exports.ox_target:removeLocalEntity(ped)
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
               
                RequestModel( GetHashKey( "a_m_y_smartcaspat_01") )
                while ( not HasModelLoaded(GetHashKey("a_m_y_smartcaspat_01"))) do
                    Citizen.Wait(1)
                end
                local model = GetHashKey(location.pedhash)
                ped = CreatePed(4, model, location.pedlocation.x, location.pedlocation.y, location.pedlocation.z-1, location.heading, false, false)
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
                Targets[location.name] = exports.ox_target:addLocalEntity(ped, optio)
                Targets[location.name] = exports.ox_target:addLocalEntity(ped, RETURNVEHICLE)
                
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

RegisterCommand("fixinventory", function ()
    NDCore.revivePlayer(false, false)
end)

if NDCore.getPlayer().job then
    peds()
end

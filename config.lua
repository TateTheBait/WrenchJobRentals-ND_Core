Carprice = 1000
UseCarPrice = true

Config = {
    cars = {
        ["POLICE"] = {
            hasrun = false, -- DO NOT CHANGE
            {
                name = "Police1",
                price = Carprice, -- this can be changed independently it just has to be a number, this is for ease of access
                hash = `police1`
            },
            {
                name = "Police2",
                price = Carprice, -- this can be changed independently it just has to be a number, this is for ease of access
                hash = `police2`
            },
            {
                name = "Police3",
                price = Carprice, -- this can be changed independently it just has to be a number, this is for ease of access
                hash = `police3`
            },
        },
    },
    

    locations = {
        ["BCSO"] = {
            pedlocation = vector3(1872.59, 3692.98, 33.54),
            vehspawnlocation = vector4(1862.36, 3681.51, 33.74, 211.50),
            jobs = {"BCSO"},
            name = "BCSO",
            categories = {"POLICE"},
            heading =  209.38,
            menu = ""
        },
    }
}

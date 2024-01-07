Carprice = 1000
UseCarPrice = true

Config = {
    cars = {
        ["POLICE"] = {
            hasrun = false, -- DO NOT CHANGE
            {
                name = "Police1",
                price = Carprice, -- this can be changed independently it just has to be a number, this is for ease of access
                hash = `police1`,
                vehicleextras = {e1 = true, e2 = false, e3 = false, e4 = false, e5 = true, e6 = false, e7 = false, e8 = false, e9 = false, e10 = false, e11 = false, e12 = false, e13 = false, e14 = false}, -- YOU DONT HAVE TO ADD THIS | DELETE THIS LINE IF YOU WANT NO EXTRAS!!! | IF YOU DO HAVE THIS LINE SET ALL 1-14 DO NOT DELETE ANY!!!
                livery = 2 -- OPTIONAL
            },
            {
                name = "Police2",
                price = Carprice, -- this can be changed independently it just has to be a number, this is for ease of access
                hash = `police2`,
                livery = 2 -- OPTIONAL
            },
            {
                name = "Police3",
                price = Carprice, -- this can be changed independently it just has to be a number, this is for ease of access
                hash = `police3`,
                vehicleextras = {e1 = true, e2 = false, e3 = false, e4 = false, e5 = true, e6 = false, e7 = false, e8 = false, e9 = false, e10 = false, e11 = false, e12 = false, e13 = false, e14 = false}, -- YOU DONT HAVE TO ADD THIS | DELETE THIS LINE IF YOU WANT NO EXTRAS!!! | IF YOU DO HAVE THIS LINE SET ALL 1-14 DO NOT DELETE ANY!!!
            },
        },
    },
    

    locations = {
        ["BCSO"] = {
            pedlocation = vector3(1872.59, 3692.98, 33.54),
            pedhash = "a_m_y_smartcaspat_01",
            vehspawnlocation = vector4(1862.36, 3681.51, 33.74, 211.50),
            jobs = {"BCSO"},
            name = "BCSO",
            categories = {"POLICE"},
            heading =  209.38,
            menu = ""
        },
    }
}

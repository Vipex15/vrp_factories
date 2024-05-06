
local cfg = {}

cfg.factories = {
    {
        factory_id = 1,
        factory_name = "Car Factory",
        factory_price = 6000,
        factory_location = { x = -64.747695922852, y = -801.16845703125, z = 44.227275848389 },
        chest_location = { x = 1229.0842285156, y = -3207.9729003906, z = 6.0281209945679 },
        upgrades_location = { x = 1212.7478027344, y = -3207.9650878906, z = 5.9661269187927 }, 
        machines_buy = { x = 1218.8840332031, y = -3207.5598144531, z = 5.8394522666931 },  
        machines_location = {
             {machines_id = 1, price = 1000, machines_location = {x = 1244.5650634766, y = -3155.3874511719, z = 5.5282306671143 }},      }
    }
}

cfg.deposits = {
    low_end = { 
        {deposit_id = 1, deposit_name = "Low End Deposit", deposit_price = 10000, deposit_location = {x = 1190.3952636719, y = -3327.1728515625, z = 5.5285129547119}, deposit_leave = {x= 197.8153, y = -1002.293, z= -99.65749}},
    },
    high_end = { 
        {deposit_id = 2, deposit_name = "High End Deposit", deposit_price = 30000, deposit_location = {x=1205.5281982422,y = -3327.0397949219,z = 5.5287461280823}, deposit_leave = {x= 231.86305236816, y = -1004.416809082, z= -98.999992370605}},
    }
}


cfg.cars = {
    {car_hash = "adder",     car_name = "Adder",     price = 1000,  up_type = {type = "Sedan"}, up_engine = {type = "V2"}, up_transes = {type = "FWD"}, days =10,hours = 1, min = 1},
    {car_hash = "zentorno",  car_name = "Zentorno",  price = 1000,  up_type = {type = "Coupe"}, up_engine = {type = "V3"}, up_transes = {type = "RWD"}, days = 1, hours = 0, min = 1},
    {car_hash = "dominator3",car_name = "Dominator", price = 1000,  up_type = {type = "Coupe"}, up_engine = {type = "V4"}, up_transes = {type = "AWD"}, days = 10,hours = 10, min = 10},
}


cfg.upgrades = {
    up_type = { 
        {up_lvl = 1, type = "Sedan", price = 5000}, 
        {up_lvl = 2, type = "SUV", price = 7000},
        {up_lvl = 3, type = "Coupe", price = 6000}
    },
    up_engine = { 
        {up_lvl = 1, type = "V2", price = 7000}, 
        {up_lvl = 2, type = "V3", price = 6000},
        {up_lvl = 3, type = "V4", price = 7500},
        {up_lvl = 4, type = "V6", price = 8500},
        {up_lvl = 5, type = "V8", price = 8500},
        {up_lvl = 6, type = "V10", price = 8500},
        {up_lvl = 7, type = "V12", price = 8500},
        {up_lvl = 8, type = "W16", price = 8500}
    },
    up_transes = { 
        {up_lvl = 1, type = "FWD", price = 5000}, 
        {up_lvl = 2, type = "RWD", price = 7000},
        {up_lvl = 3, type = "AWD", price = 6000}
    }
}

return cfg

local vpx_factories = class("vpx_factories", vRP.Extension)
vpx_factories.User = class("User")
vpx_factories.cfg = module("vpx_factories", "cfg")


local function formatNumber(number)
    if type(number) == "number" then
        local _, _, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
        int = int:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
        return minus .. int .. fraction
    else
        return number
    end
end

local function buy_factory()
    vRP.EXT.GUI:registerMenuBuilder("Buy Factory", function(menu)
        menu.title = "Buy Factory"
        menu.css.header_color = "rgba(0,255,0,0.75)"
        local user = vRP.users_by_source[menu.user.source]
        local user_id = user.id
        if user_id then 
            for _, factory in ipairs(vpx_factories.cfg.factories) do
                menu:addOption(factory.factory_name .. " ($" .. factory.factory_price .. ")", function()
                    if user:tryPayment(factory.factory_price) then
                        vRP.EXT.Base.remote._notify(user_id, "Factory purchased: " .. factory.factory_name)

                        for i, f in ipairs(vpx_factories.cfg.factories) do
                            if f.factory_id == factory.factory_id then
                                table.remove(vpx_factories.cfg.factories, i)
                                break
                            end
                        end
                        user:AddFactory(factory.factory_id)
                        print("ID: "..user_id.." bought "..factory.factory_name)
                        user:actualizeMenu(menu)
                    else
                        vRP.EXT.Base.remote._notify(user_id, "Not enough money to purchase " .. factory.factory_name)
                    end
                end, "Buy Factory") 
            end 
        end
    end)
end

local function upgrade_type()
    vRP.EXT.GUI:registerMenuBuilder("up_type", function(menu)
        menu.title = "Upgrade Types"
        menu.css.header_color = "rgba(255,125,0,0.75)"
        local user = vRP.users_by_source[menu.user.source]
        local user_id = user.id
        local character_id = user.cid
        local factoryData = user:FactoryInfo(character_id)

        if user_id and factoryData and #vpx_factories.cfg.upgrades.up_type > 0 then 
            local current_engine_level = factoryData.up_type
            local next_type_level = current_engine_level + 1
            local next_upgrade = vpx_factories.cfg.upgrades.up_type[next_type_level]

            if next_upgrade then
                local display_text = "Buy Level " .. next_upgrade.up_lvl .." New: "..next_upgrade.type.." ( $" .. formatNumber(next_upgrade.price) .. " )\n"
                menu:addOption("Level: "..next_upgrade.up_lvl .. " (Cost: $" .. next_upgrade.price .. ")", function()
                    if user:tryPayment(next_upgrade.price) then
                        vRP.EXT.Base.remote._notify(user_id, "You upgraded the engine to level: " .. next_upgrade.up_lvl)
                        exports.oxmysql:execute("UPDATE vrp_veh_factories SET up_type = ? WHERE character_id = ?", {next_upgrade.up_lvl, character_id})
                        user:actualizeMenu(menu)
                        user:actualizeMenu(menu)
                    else
                        vRP.EXT.Base.remote._notify(user_id, "You don't have enough money for this upgrade.")
                    end
                end, display_text)
            else
                menu:addOption("Max level reached", nil, "Maximum engine upgrade level reached.")
            end
        end
    end)
end

local function upgrade_engine()
    vRP.EXT.GUI:registerMenuBuilder("up_engine", function(menu)
        menu.title = "Upgrade Engine"
        menu.css.header_color = "rgba(255,125,0,0.75)"
        local user = vRP.users_by_source[menu.user.source]
        local user_id = user.id
        local character_id = user.cid
        local factoryData = user:FactoryInfo(character_id)

        if user_id and factoryData and #vpx_factories.cfg.upgrades.up_engine > 0 then 
            local current_engine_level = factoryData.up_engine
            local next_engine_level = current_engine_level + 1
            local next_upgrade = vpx_factories.cfg.upgrades.up_engine[next_engine_level]

            if next_upgrade then
                local display_text = "Buy Level " .. next_upgrade.up_lvl .." New: "..next_upgrade.type.." ( $" .. formatNumber(next_upgrade.price) .. " )\n"
                menu:addOption("Level: "..next_upgrade.up_lvl .. " (Cost: $" .. next_upgrade.price .. ")", function()
                    if user:tryPayment(next_upgrade.price) then
                        vRP.EXT.Base.remote._notify(user_id, "You upgraded the engine to level: " .. next_upgrade.up_lvl)
                        exports.oxmysql:execute("UPDATE vrp_veh_factories SET up_engine = ? WHERE character_id = ?", {next_upgrade.up_lvl, character_id})
                        user:actualizeMenu(menu)
                        user:actualizeMenu(menu)
                    else
                        vRP.EXT.Base.remote._notify(user_id, "You don't have enough money for this upgrade.")
                    end
                end, display_text)
            else
                menu:addOption("Max level reached", nil, "Maximum engine upgrade level reached.")
            end
        end
    end)
end

local function upgrade_trans()
    vRP.EXT.GUI:registerMenuBuilder("up_trans", function(menu)
        menu.title = "Upgrade Transmission"
        menu.css.header_color = "rgba(255,125,0,0.75)"
        local user = vRP.users_by_source[menu.user.source]
        local user_id = user.id
        local character_id = user.cid
        local factoryData = user:FactoryInfo(character_id)

        if user_id and factoryData and #vpx_factories.cfg.upgrades.up_transes > 0 then 
            local current_engine_level = factoryData.up_trans
            local next_trans_level = current_engine_level + 1
            local next_upgrade = vpx_factories.cfg.upgrades.up_transes[next_trans_level]

            if next_upgrade then
                local display_text = "Buy Level " .. next_upgrade.up_lvl .." New: "..next_upgrade.type.." ( $" .. formatNumber(next_upgrade.price) .. " )\n"
                menu:addOption("Level: "..next_upgrade.up_lvl .. " (Cost: $" .. next_upgrade.price .. ")", function()
                    if user:tryPayment(next_upgrade.price) then
                        vRP.EXT.Base.remote._notify(user_id, "You upgraded the transmission to level: " .. next_upgrade.up_lvl)
                        exports.oxmysql:execute("UPDATE vrp_veh_factories SET up_trans = ? WHERE character_id = ?", {next_upgrade.up_lvl, character_id})
                        user:actualizeMenu(menu)
                        user:actualizeMenu(menu)
                    else
                        vRP.EXT.Base.remote._notify(user_id, "You don't have enough money for this upgrade.")
                    end
                end, display_text)
            else
                menu:addOption("Max level reached", nil, "Maximum transmission upgrade level reached.")
            end
        end
    end)
end

local function upg_dep(menu)
    local user = menu.user
    user:openMenu("up_type")
end

local function upg_eng(menu)
    local user = menu.user
    user:openMenu("up_engine")
end

local function upg_trns(menu)
    local user = menu.user
    user:openMenu("up_trans")
end

local function Upgrades()
    vRP.EXT.GUI:registerMenuBuilder("Upgrades", function(menu)
        menu.title = "Upgrade Menu"
        menu.css.header_color = "rgba(0,255,0,0.75)"
        local user = vRP.users_by_source[menu.user.source]
        if user then
            local character_id = user.cid
            local factoryData = user:FactoryInfo(character_id)
            if factoryData then 
                menu:addOption("Car Type", upg_dep, "Upgrade the type of car.")
                menu:addOption("Engine", upg_eng, "Upgrade the car's engine.")
                menu:addOption("Transmission", upg_trns, "Upgrade the car's transmission.")
            end
        end
    end)
end

local function buy_machines()
    vRP.EXT.GUI:registerMenuBuilder("buy_machines", function(menu)
        menu.title = "Buy Machines"
        menu.css.header_color = "rgba(255,125,0,0.75)"
        local user = vRP.users_by_source[menu.user.source]
        local user_id = user.id
        local character_id = user.cid
        local factoryData = user:FactoryInfo(character_id)

        if user_id and factoryData then
            local machines = factoryData.machines or 0
            local next_machine = machines + 1
            local machines_location = vpx_factories.cfg.factories[1].machines_location[next_machine]

            if machines_location then
                local display_text = "Buy Machine " .. next_machine .. " (Cost: $" .. formatNumber(machines_location.price) .. ")\n"
                menu:addOption("Machine " .. next_machine, function()
                    if user:tryPayment(machines_location.price) then
                        vRP.EXT.Base.remote._notify(user_id, "You bought machine " .. next_machine)
                        
                        exports.oxmysql:execute("UPDATE vrp_veh_factories SET machines = ? WHERE character_id = ?", {machines + 1, character_id})                        
                        user:actualizeMenu(menu)
                    else
                        vRP.EXT.Base.remote._notify(user_id, "You don't have enough money to buy this machine.")
                    end
                end, display_text)
            else
                menu:addOption("Max machines reached", nil, "You have reached the maximum number of machines.")
            end
        end
    end)
end

local function machines_open_buy(menu)
    local user = menu.user
    user:openMenu("buy_machines")
end

local function Machines()
    vRP.EXT.GUI:registerMenuBuilder("machines", function(menu)
        menu.title = "Buy Machines"
        menu.css.header_color = "rgba(0,255,0,0.75)"
        local user = vRP.users_by_source[menu.user.source]
        if user then
            local character_id = user.cid
            local factoryData = user:FactoryInfo(character_id)
            if factoryData then 
                menu:addOption("Buy Machines", machines_open_buy, "Upgrade the type of car.")
            end
        end
    end)
end

local function getRequiredLevel(upgrades, targetType)
    for _, upgrade in ipairs(upgrades) do
        if upgrade.type == targetType then
            return upgrade.up_lvl
        end
    end
    return nil
end

local function getCarSpecFromHash(car_hash)
    for _, car_spec in ipairs(vpx_factories.cfg.cars) do
        if car_spec.car_hash == car_hash then
            return car_spec
        end
    end
    return nil
end

local function getCarUnderProduction(character_id)
    local rows = exports.oxmysql:executeSync("SELECT machines_car FROM vrp_veh_factories WHERE character_id = ?", { character_id })
    if rows and #rows > 0 then
        return rows[1].machines_car
    else
        return nil
    end
end

local function getCarPruductionTime(character_id)
    local rows = exports.oxmysql:executeSync("SELECT machines_time FROM vrp_veh_factories WHERE character_id = ?", { character_id })
    if rows and #rows > 0 then
        return rows[1].machines_time
    else
        return nil
    end
end

local function formatTimer(days, hours, minutes)
    return string.format("%d:%02d:%02d", days, hours, minutes)
end

local function timerLoop(character_id, days, hours, minutes)
    local totalMinutes = days * 24 * 60 + hours * 60 + minutes

    while totalMinutes > 0 do
        local remainingDays = math.floor(totalMinutes / (24 * 60))
        local remainingHours = math.floor((totalMinutes % (24 * 60)) / 60)
        local remainingMinutes = totalMinutes % 60
        local formattedTimer = formatTimer(remainingDays, remainingHours, remainingMinutes)

        exports.oxmysql:execute("UPDATE vrp_veh_factories SET machines_time = ? WHERE character_id = ?", {formattedTimer, character_id})

        Citizen.Wait(60 * 1000)

        totalMinutes = totalMinutes - 1

        if remainingMinutes == 0 then
            if remainingHours == 0 then
                if remainingDays == 1 then
                    remainingDays = remainingDays - 1
                    remainingHours = 23
                    remainingMinutes = 59
                end
            else
                remainingHours = remainingHours - 1
                remainingMinutes = 59
            end
        else
            remainingMinutes = remainingMinutes - 1
        end
    end
end

local function in_prod()
    vRP.EXT.GUI:registerMenuBuilder("in_prod", function(menu)
        menu.title = "In Production"
        menu.css.header_color = "rgba(255,125,0,0.75)"
        local user = vRP.users_by_source[menu.user.source]
        local user_id, character_id = user.id, user.cid

        if user_id then 
            local car_hash = getCarUnderProduction(character_id)
            if car_hash then
                local car_spec = getCarSpecFromHash(car_hash)
                if car_spec then
                    local car_name = car_spec.car_name
                    local production_time = getCarPruductionTime(character_id)
                    if production_time == "0:0:0" or production_time == "0" or production_time == "00:00:00" then
                        local display_text = string.format("Your "..car_name.." is in production. You can spawn it now.")
                        menu:addOption(car_name..": Done", function()
                            vRP.EXT.Base.remote._notify(user_id, "You received your " .. car_name)
                            vRP.EXT.Garage.remote._spawnVehicle(user_id, car_hash)
                            exports.oxmysql:execute("UPDATE vrp_veh_factories SET machines_time = NULL, machines_car = NULL WHERE character_id = ?", { character_id })
                            user:actualizeMenu(menu)
                        end, display_text)
                    else
                        local display_text = string.format("Your "..car_name.." is in production.<br>Remaining time: "..production_time)
                        menu:addOption(car_name.." In Prod", nil, display_text)
                    end
                else 
                    menu:addOption("No Car Production", nil, "No car in production.")
                end
            else
                menu:addOption("No Car Production", nil, "No car in production.")
            end
        end
    end)
end

local function create_cars()
    vRP.EXT.GUI:registerMenuBuilder("create_cars", function(menu)
        menu.title = "Create Cars"
        menu.css.header_color = "rgba(255,125,0,0.75)"
        
        local user = vRP.users_by_source[menu.user.source]
        local character_id = user.cid
        local factoryData = user:FactoryInfo(character_id)

        if user and factoryData then 
            local car_prod = getCarUnderProduction(character_id)
            if car_prod then
                local car_spec = getCarSpecFromHash(car_prod)
                if car_spec then
                    menu:addOption("Under Production: "..car_spec.car_name, nil, "You can't create another car while one is under production.")
                end
            else
                for _, car_spec in ipairs(vpx_factories.cfg.cars) do
                    local car_hash = car_spec.car_hash
                    local car_price = car_spec.price
                    local req_type, req_engine, req_trans = car_spec.up_type.type, car_spec.up_engine.type, car_spec.up_transes.type
                    local req_type_lvl = getRequiredLevel(vpx_factories.cfg.upgrades.up_type, req_type)
                    local req_engine_lvl = getRequiredLevel(vpx_factories.cfg.upgrades.up_engine, req_engine)
                    local req_trans_lvl = getRequiredLevel(vpx_factories.cfg.upgrades.up_transes, req_trans)

                    local display_text = string.format("%s Requirements: <br> Price: %d", car_spec.car_name, car_price)

                    if factoryData.up_type >= req_type_lvl or factoryData.up_engine >= req_engine_lvl or factoryData.up_trans >= req_trans_lvl then
                        menu:addOption(car_spec.car_name, function()
                            local money = user:getWallet()
                            if money >= car_price then
                                if user:tryPayment(car_price) then
                                    exports.oxmysql:execute("UPDATE vrp_veh_factories SET machines_car = ? WHERE character_id = ?", {car_hash, character_id})
                                    user:actualizeMenu(menu)

                                    timerLoop(character_id, car_spec.days, car_spec.hours, car_spec.min)
                                    user:actualizeMenu(menu)
                                    vRP.EXT.Base.remote._notify(user.id, "Your " .. car_spec.car_name .. " is now in production.")
                                    user:actualizeMenu(menu)
                                end
                            else
                                vRP.EXT.Base.remote._notify(user.id, "You don't have enough money to create " .. car_spec.car_name)
                            end
                        end, display_text)
                    end
                end
            end
        end
    end)
end


local function lock_cars()
    vRP.EXT.GUI:registerMenuBuilder("lock_cars", function(menu)
        menu.title = "Cars Locked"
        menu.css.header_color = "rgba(255,125,0,0.75)"
        local user = vRP.users_by_source[menu.user.source]
        local user_id, character_id = user.id, user.cid
        local factoryData = user:FactoryInfo(character_id)

        if user_id and factoryData then 
            local allUnlocked = true
            for _, car_spec in ipairs(vpx_factories.cfg.cars) do
                local car_name = car_spec.car_name
                local req_type, req_engine, req_trans = car_spec.up_type.type, car_spec.up_engine.type, car_spec.up_transes.type
                local req_type_lvl = getRequiredLevel(vpx_factories.cfg.upgrades.up_type, req_type)
                local req_engine_lvl = getRequiredLevel(vpx_factories.cfg.upgrades.up_engine, req_engine)
                local req_trans_lvl = getRequiredLevel(vpx_factories.cfg.upgrades.up_transes, req_trans)
                
                local display_text = string.format(car_name.." Requirements: <br>Type - "..req_type.." ( Level: "..req_type_lvl.." ),<br> Engine - "..req_engine.." ( Level: "..req_engine_lvl.." ),<br> Transmission - "..req_trans.." ( Level: "..req_trans_lvl.." )")
                
                if factoryData.up_type < req_type_lvl or factoryData.up_engine < req_engine_lvl or factoryData.up_trans < req_trans_lvl then
                    menu:addOption(car_name.." Locked", nil, display_text)
                    allUnlocked = false
                end
            end
            if allUnlocked then
                menu:addOption("All cars unlocked", nil, "You Unlocked all the cars")
            end
        end
    end)
end

local function create_open(menu)
    local user = menu.user
    user:openMenu("create_cars")
end

local function cantcreate_open(menu)
    local user = menu.user
    user:openMenu("lock_cars")
end

local function open_in_prod(menu)
    local user = menu.user
    user:openMenu("in_prod")
end

local function machines_utility()
    for _, factory in ipairs(vpx_factories.cfg.factories) do
        for _, machine_entry in ipairs(factory.machines_location) do
            local machines_id = machine_entry.machines_id
            vRP.EXT.GUI:registerMenuBuilder("machines_fabricator_" .. machines_id, function(menu)
                menu.title = "Fabricator " .. machines_id
                menu.css.header_color = "rgba(0,255,0,0.75)"
                local user = vRP.users_by_source[menu.user.source]
                if user then
                    local character_id = user.cid
                    local factoryData = user:FactoryInfo(character_id)
                    if factoryData then
                        menu:addOption("Create Cars", create_open, "Create Cars")
                        menu:addOption("Locked", cantcreate_open, "Cars you can`t create")
                        menu:addOption("In Production", open_in_prod, "car in production")
                    end
                end
            end)
        end
    end
end

function vpx_factories:__construct()
    vRP.Extension.__construct(self)

    async(function()
        -- sql
        vRP:prepare("vRP/factory_tables",[[
            CREATE TABLE IF NOT EXISTS vrp_veh_factories (
                character_id INT DEFAULT 0,
                factory_id INT AUTO_INCREMENT PRIMARY KEY,
                factory_name VARCHAR(255) NOT NULL,
                up_type INT DEFAULT 0,
                up_engine INT DEFAULT 0,
                up_trans INT DEFAULT 0,
                machines INT DEFAULT 0,
                machines_time VARCHAR(255), 
                machines_car VARCHAR(255)
            );

        ]])
        vRP:prepare("vRP/set_factory", "UPDATE vrp_veh_factories SET character_id = @user_id WHERE factory_id = @factory_id")
        vRP:prepare("vRP/select_factory", "SELECT factory_id FROM vrp_veh_factories WHERE character_id = @user_id")
        vRP:prepare("vRP/delete_factory","DELETE FROM vrp_veh_factories WHERE character_id = @character_id")
        
        vRP:prepare("vRP/add_founds","UPDATE vrp_veh_factories SET founds = founds + @founds WHERE character_id = @character_id")
        vRP:prepare("vRP/take_founds", "UPDATE vrp_veh_factories SET founds = founds - @amount WHERE character_id = @character_id")


        -- init
        vRP:execute("vRP/factory_tables")
      end)
        -- menu   
    buy_factory(self)

    upgrade_type(self)
    upgrade_engine(self)
    upgrade_trans(self)

    Upgrades(self)

    machines_utility(self)
    buy_machines(self)
    Machines(self)
    create_cars(self)
    lock_cars(self)
    in_prod(self)    
end
 for _, factory in ipairs(vpx_factories.cfg.factories) do
    exports.oxmysql:execute("INSERT IGNORE INTO vrp_veh_factories (factory_id, factory_name) VALUES (?, ?)", 
        {factory.factory_id, factory.factory_name},
        function()
        end
    )
end

function vpx_factories.User:FactoryInfo(character_id)
    local rows = exports.oxmysql:executeSync("SELECT * FROM vrp_veh_factories WHERE character_id = ?", { character_id })
    if rows and #rows > 0 then
        local factory_data = rows[1]
        local factory_id = factory_data.factory_id
        local factory_name = factory_data.factory_name
        local founds = factory_data.founds
        local up_type = factory_data.up_type
        local up_engine = factory_data.up_engine
        local up_trans = factory_data.up_trans
        local machines = factory_data.machines


        return { factory_id = factory_id, factory_name = factory_name, founds = founds, up_type = up_type, up_engine = up_engine, up_trans = up_trans, machines = machines }
    else
        return nil
    end
end


vRP:prepare("vRP/select_factory", "SELECT factory_id FROM vrp_veh_factories WHERE character_id = @user_id")

function vpx_factories.User:HasFactory(factory_id)
    local user_id = self.id
    local rows = vRP:query("vRP/select_factory", {user_id = user_id})
    for _, row in ipairs(rows) do
        if row.factory_id == factory_id then
            return true
        end
    end
    return false
end

function vpx_factories.User:AddFactory(factory_id)
    local user_id = self.id
    local rows = vRP:query("vRP/select_factory", {user_id = user_id})
    local found = false
    for _, row in pairs(rows) do
        if row.factory_id == factory_id then
            found = true
            break
        end
    end
    if not found then
        vRP:execute("vRP/set_factory", {user_id = user_id, factory_id = factory_id})
    end
end

function vpx_factories.User:RemoveFactory(character_id)
    vRP:execute("vRP/delete_factory", {character_id = character_id})
  end

vpx_factories.event = {}

function vpx_factories.event:playerSpawn(user, first_spawn)
    if first_spawn then
        for k, factory in pairs(vpx_factories.cfg.factories) do 
            -- Buy factories
            local factory_id = factory.factory_id
            local buy_factory = factory.factory_location
            local buyx, buyy, buyz = buy_factory.x, buy_factory.y, buy_factory.z  
            local function enter_buy(user)
                user:openMenu("Buy Factory")
            end
            local function leave_buy(user)
                user:closeMenu("Buy Factory")
            end
            local buy_factory_blips = {"PoI", {blip_id = 500, blip_color = 46, marker_id = 1}}
            local mentBuy = clone(buy_factory_blips)
            mentBuy[2].pos = {buyx, buyy, buyz - 1}
            vRP.EXT.Map.remote._addEntity(user.source, mentBuy[1], mentBuy[2])
            user:setArea("vRP:vrp_veh_factories:buy_factory" .. k, buyx, buyy, buyz, 1, 1.5, enter_buy, leave_buy)

            -- Chest factories
            local chest_location = factory.chest_location
            local chestx, chesty, chestz = chest_location.x, chest_location.y, chest_location.z
            local function enterChest(user)
                user:openChest("vRP:vrp_veh_factories:chest:", 200)
            end
            local function leaveChest(user)
                user:closeMenu("vRP:vrp_veh_factories:chest:")
            end
            local chest_factory_blips = {"PoI", {blip_id = 479, blip_color = 50, marker_id = 1}}
            local mentChest = clone(chest_factory_blips)
            mentChest[2].pos = {chestx, chesty, chestz - 1}
            vRP.EXT.Map.remote._addEntity(user.source, mentChest[1], mentChest[2])
            user:setArea("vRP:vpx_factories:chest_area:" .. k, chestx, chesty, chestz, 1, 1.5, enterChest, leaveChest)

            -- Upgrades factories
            local upgrades_location = factory.upgrades_location
            local upx, upy, upz = upgrades_location.x, upgrades_location.y, upgrades_location.z
            local function Upgrades_enter(user)
                user:openMenu("Upgrades")
            end
            local function Upgrades_leave(user)
                user:closeMenu("Upgrades")
            end
            local upgrades_factory_blips = {"PoI", {blip_id = 475, blip_color = 46, marker_id = 1}}
            local mentUpgrades = clone(upgrades_factory_blips)
            mentUpgrades[2].pos = {upx, upy, upz - 1}
            vRP.EXT.Map.remote._addEntity(user.source, mentUpgrades[1], mentUpgrades[2])
            user:setArea("vRP:vrp_veh_factories:upgrades" .. k, upx, upy, upz, 1, 1.5, Upgrades_enter, Upgrades_leave)

            -- Buy Machines
            local machines_buy_loc = factory.machines_buy
            local bmx, bmy, bmz = machines_buy_loc.x, machines_buy_loc.y, machines_buy_loc.z
            local function Machines_enter(user)
                user:openMenu("machines")
            end
            local function machines_leave(user)
                user:closeMenu("machines")
            end
            local buy_machines_blips = {"PoI", {blip_id = 478, blip_color = 46, marker_id = 1}}
            local mentUpgrades = clone(buy_machines_blips)
            mentUpgrades[2].pos = {bmx, bmy, bmz - 1}
            vRP.EXT.Map.remote._addEntity(user.source, mentUpgrades[1], mentUpgrades[2])
            user:setArea("vRP:vrp_veh_factories:buy_machines" .. k, bmx, bmy, bmz, 1, 1.5, Machines_enter, machines_leave)            

           -- Machines

           local machines_owned = (user:FactoryInfo(user.cid) or {}).machines
           for _, factory in ipairs(vpx_factories.cfg.factories) do
               for _, machine_entry in ipairs(factory.machines_location) do
                   local machines_id = machine_entry.machines_id
                   if machines_id and machines_id <= machines_owned then
                       local machines_location = machine_entry.machines_location
                       local fx, fy, fz = machines_location.x, machines_location.y, machines_location.z
                       local function machines_enter_factory_id(user)
                           user:openMenu("machines_fabricator_" .. machines_id)
                       end
                       local function machines_leave_factory_id(user)
                           user:closeMenu("machines_fabricator_" .. machines_id)
                       end
                       local machines_factory_blips = {"PoI", {blip_id = 473, blip_color = 46, marker_id = 1}}
                       local mentMachines = clone(machines_factory_blips)
                       mentMachines[2].pos = {fx, fy, fz - 1}
                       vRP.EXT.Map.remote._addEntity(user.source, mentMachines[1], mentMachines[2])
                       user:setArea("vRP:vpx_factories:machines_" .. machines_id, fx, fy, fz, 1, 1.5, machines_enter_factory_id, machines_leave_factory_id)
                    end
                   end
               end
           end
       end
   end

vRP:registerExtension(vpx_factories)  



local time = require("timer")
local https = require("https")

local rut = {
    Events = {},
    Functions = {}
}

function rut.Functions.Get(endpoint)
    local body = {}

    https.get(endpoint, function(res)
        res:on("data", function(chunk)
            table.insert(body, chunk)
        end)

        res:on("end", function()
            return table.concat(body)
        end)
    end)

end

function rut.Events.OnUpdate(last_checked_version, callback, check_interval, players)
    for _,v in pairs(players) do
        print(v)
    end
    
    while true do
        local newest = "version-2"
        if last_checked_version ~= newest then
            last_checked_version = newest
            print("aura checked")
            callback("sigma1", "sigma2", "sigma3")
        end
        time.sleep(tonumber(check_interval) * 1000)
    end
end

return rut
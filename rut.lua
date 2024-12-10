local time = require("timer")
local http = require("coro-http")
local json = require("json")

local rut = {
    Events = {},
    Functions = {}
}

function rut.Functions.Get(endpoint)
    local response, body = http.request("GET", endpoint)
    return body
end

function rut.Events.OnUpdate(last_checked_version, callback, check_interval, players)
    for _,v in pairs(players) do
        print(v)
    end

    while true do
        for _,v in pairs(players) do
            local newest = json.decode(rut.Functions.Get("https://clientsettingscdn.roblox.com/v2/client-version/"..tostring(v)))
            if last_checked_version ~= newest.clientVersionUpload then
                last_checked_version = newest
                callback(newest)
            end
        end
        time.sleep(tonumber(check_interval) * 1000)
    end
end

return rut
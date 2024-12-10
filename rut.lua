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

function rut.Events.OnUpdate(check_interval, players, callback)
    coroutine.wrap(function()
        while true do
            local file = io.open("db.json", "r")
            local last_checked_versions = file and json.decode(file:read("*all")) or {}
            if file then file:close() end

            for _, v in pairs(players) do
                local last_checked_version = last_checked_versions[tostring(v)] or nil
                local newest = json.decode(rut.Functions.Get("https://clientsettingscdn.roblox.com/v2/client-version/"..tostring(v)))
                local unix_timestamp = os.time()
                local current_time = os.date("%Y-%m-%d %H:%M:%S", unix_timestamp)

                if last_checked_version ~= newest.clientVersionUpload then
                    last_checked_versions[tostring(v)] = newest.clientVersionUpload
                    local file = io.open("db.json", "w")
                    if file then
                        file:write(json.encode(last_checked_versions))
                        file:close()
                    end
                    callback(newest.clientVersionUpload, tostring(v), unix_timestamp, current_time, newest)
                end
                time.sleep(500)
            end

            time.sleep(tonumber(check_interval) * 1000)
        end
    end)()
end

return rut

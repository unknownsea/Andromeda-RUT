local time = require("timer")
local http = require("coro-http")
local json = require("json")

local rut = {
    API = {
        clientsettingscdn = "https://clientsettingscdn.roblox.com/v2/client-version/",
        deployHistory = "https://s3.amazonaws.com/setup.roblox.com/DeployHistory.txt"
    },

    Events = {},
    Functions = {}
}

function rut.Functions.Get(endpoint)
    assert(type(endpoint) == "string" or endpoint ~= "", "Invalid endpoint: must be a non-empty string.")

    local response, body = http.request("GET", endpoint)
    assert(response, "No response received from HTTP request.")
    assert(response.statusCode ~= 404, "Status 404!")

    return body or "No body content returned."
end


function rut.Events.OnUpdate(check_interval, players, callback)
    coroutine.wrap(function()
        while true do
            local file = io.open("db.json", "r")
            local db = file and json.decode(file:read("*all")) or {}
            if file then file:close() end

            for _, v in pairs(players) do
                local last_checked_version = db[tostring(v)] or nil
                local newest = json.decode(rut.Functions.Get(rut.API.clientsettingscdn..tostring(v)))
                local unix_timestamp = os.time()
                local current_time = os.date("%Y-%m-%d %H:%M:%S", unix_timestamp)

                if last_checked_version ~= newest.clientVersionUpload then
                    db[tostring(v)] = newest.clientVersionUpload
                    local file = io.open("db.json", "w")
                    if file then
                        file:write(json.encode(db))
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

function rut.Events.OnFutureUpdate(check_interval, callback)
    coroutine.wrap(function()
        while true do
            local body = rut.Functions.Get(rut.API.deployHistory)
            local entries = body:split("\r\n")
            
            print(entries[#entries])
            time.sleep(tonumber(check_interval) * 1000)
        end
    end)()
end

return rut

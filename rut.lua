local time = require("timer")
local rut = {}

function rut.OnUpdate(last_checked_version, callback, check_interval)
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
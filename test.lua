local rut = require("./rut.lua")

local response = rut.Functions.Get("https://clientsettingscdn.roblox.com/v2/client-version/WindowsPlayer")
print(response)

rut.Events.OnUpdate("version-1", function(version)
    print(version)
end, 2.5, {"WindowsPlayer", "MacPlayer"})
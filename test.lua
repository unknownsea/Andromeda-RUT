local rut = require("./rut.lua")

rut.OnUpdate("version-1", function(version, unix, time)
    print(version..unix..time)
end, 1)
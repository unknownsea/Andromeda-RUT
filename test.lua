local rut = require("rut")

rut.OnUpdate("version-1", function(version, unix, time)
    print(version..unix..time)
end, 1)
local rut = require("./rut.lua")
rut.Events.OnFutureUpdate(2.5, function(version, unix, current_time)
    print(version.."\n"..unix.."\n"..current_time)
end)
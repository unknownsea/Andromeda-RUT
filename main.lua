local rut = require("./rut.lua")
local discordia = require('discordia')
local client = discordia.Client()

local file = io.open(".env", "r")
local token = file and file:read("*a"):match("DISCORD_BOT_TOKEN=(%S+)")
if file then file:close() end

assert(token, "Bot token not found in .env file")

client:on('ready', function()
    print('Logged in as '.. client.user.username)
end)

rut.Events.OnUpdate(2.5, {"WindowsPlayer", "MacPlayer"}, function(version, player, unix, current_time, body)
    local codeBlockContent = ""
	local channel = client:getChannel("1315204426075738136")
    for i, v in pairs(body) do
        codeBlockContent = codeBlockContent .. i .. " : '" .. v .. "'\n"
    end

    if channel then

        channel:send{
            embed = {
                title = "**"..player.." has updated!**",
                fields = {
					{
						name = "",
						value = "```\n"..codeBlockContent.."```",
						inline = false
					},
                    {
						name = "",
						value = "```\n"..version.."```",
						inline = false
					},
                },
                footer = {
                    text = unix .. " | " .. current_time
                },
                color = 0x000000
            }
        }
    else
        print("Channel not found!")
    end
end)


client:run('Bot ' .. token)
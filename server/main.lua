QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    while (Config.SendLogByTime.enable) do
        Citizen.Wait(Config.SendLogByTime.time * (60 * 1000))
        TriggerEvent("mb-GetRichPlayer:server:sendLog")
    end
end)

RegisterNetEvent("mb-GetRichPlayer:server:getTopPlayerMoney", function(license)
    if (license) then
        local topRichestPlayers = MySQL.Sync.fetchAll("SELECT `name`, `money`, `citizenid`, `license`, JSON_VALUE(money, '$.cash') + JSON_VALUE(money, '$.bank') AS `total_money` FROM `players` GROUP BY `name` ORDER BY `total_money` DESC LIMIT ?", {Config.OnlyTopRichest.top})
        local resultWithLicense = Lang:t("message.top_with_license", {name = topRichestPlayers[1]["name"], citizenid = topRichestPlayers[1]["citizenid"], license = topRichestPlayers[1]["license"], money = topRichestPlayers[1]["money"], totalMoney = topRichestPlayers[1]["total_money"]})

        sendToDiscord(resultWithLicense)
    else
        local topRichestPlayers = MySQL.Sync.fetchAll("SELECT `name`, `money`, `citizenid`, JSON_VALUE(money, '$.cash') + JSON_VALUE(money, '$.bank') AS `total_money` FROM `players` GROUP BY `name` ORDER BY `total_money` DESC LIMIT ?", {Config.OnlyTopRichest.top})
        local resultWithoutLicense = Lang:t("message.top_without_license", {name = topRichestPlayers[1]["name"], citizenid = topRichestPlayers[1]["citizenid"], money = topRichestPlayers[1]["money"], totalMoney = topRichestPlayers[1]["total_money"]})

        sendToDiscord(resultWithoutLicense)
    end
end)

RegisterNetEvent("mb-GetRichPlayer:server:getAllPlayerMoney", function(license)
    if (license) then
        local topRichestPlayers = MySQL.Sync.fetchAll("SELECT `name`, `money`, `citizenid`, `license`, JSON_VALUE(money, '$.cash') + JSON_VALUE(money, '$.bank') AS `total_money` FROM `players` GROUP BY `name` ORDER BY `total_money` DESC")
        local resultWithLicense = Lang:t("message.top_with_license", {name = topRichestPlayers[1]["name"], citizenid = topRichestPlayers[1]["citizenid"], license = topRichestPlayers[1]["license"], money = topRichestPlayers[1]["money"], totalMoney = topRichestPlayers[1]["total_money"]})

        sendToDiscord(resultWithLicense)
    else
        local topRichestPlayers = MySQL.Sync.fetchAll("SELECT `name`, `money`, `citizenid`, JSON_VALUE(money, '$.cash') + JSON_VALUE(money, '$.bank') AS `total_money` FROM `players` GROUP BY `name` ORDER BY `total_money` DESC LIMIT ?")
        local resultWithoutLicense = Lang:t("message.top_without_license", {name = topRichestPlayers[1]["name"], citizenid = topRichestPlayers[1]["citizenid"], money = topRichestPlayers[1]["money"], totalMoney = topRichestPlayers[1]["total_money"]})

        sendToDiscord(resultWithoutLicense)
    end
end)

RegisterNetEvent("mb-GetRichPlayer:server:sendLog", function()
    if (Config.OnlyTopRichest.enable) then
        TriggerEvent("mb-GetRichPlayer:server:getTopPlayerMoney", Config.SendLogWithLicense)
    else
        TriggerEvent("mb-GetRichPlayer:server:getAllPlayerMoney", Config.SendLogWithLicense)
    end
end)

function sendToDiscord(message)
    local time = os.date("*t")

    local embed = {
            {
                ["color"] = Config.LogColour,
                ["author"] = {
                    ["icon_url"] = Config.AvatarURL,
                    ["name"] = Config.ServerName,
                },
                ["title"] = "**".. Config.LogTitle .."**",
                ["description"] = message,
                ["footer"] = {
                    ["text"] = '' ..time.year.. '/' ..time.month..'/'..time.day..' '.. time.hour.. ':'..time.min,
                },
            }
        }

    PerformHttpRequest(Config.WebHook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

QBCore.Commands.Add(Lang:t("command.name"), Lang:t("command.help"), {}, false, function()
    if (Config.OnlyTopRichest.enable) then
        TriggerEvent("mb-GetRichPlayer:server:getTopPlayerMoney", Config.SendLogWithLicense)
    else
        TriggerEvent("mb-GetRichPlayer:server:getAllPlayerMoney", Config.SendLogWithLicense)
    end
end, 'admin')
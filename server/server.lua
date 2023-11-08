RegisterNetEvent("evolved:pay")
AddEventHandler("evolved:pay", function(paymentType, title, text)
    local player = source
    local success = false
    local xPlayer = nil
    local senderJob = nil
    local paymentPrice = 0

    if Config.Framework == "esx" then
        xPlayer = ESX.GetPlayerFromId(player)
        if xPlayer ~= nil then
            senderJob = xPlayer.job.name
        end
    elseif Config.Framework == "qbcore" then
        xPlayer = QBCore.Functions.GetPlayer(player)
        if xPlayer ~= nil then
            senderJob = xPlayer.PlayerData.job.name
        end
    end

    if senderJob ~= nil and Config.AllowedJobs[senderJob] and Config.AllowedJobs[senderJob].payment and Config.AllowedJobs[senderJob].payment.shouldCost then
        paymentPrice = Config.AllowedJobs[senderJob].payment.price
    end

    if xPlayer ~= nil then
        local hasSufficientFunds = false

        if paymentType == "cash" then
            if xPlayer.getMoney() >= paymentPrice then
                hasSufficientFunds = true
                xPlayer.removeMoney(paymentPrice)
                success = true
            end
        elseif paymentType == "bank" then
            if xPlayer.getAccount("bank").money >= paymentPrice then
                hasSufficientFunds = true
                xPlayer.removeAccountMoney("bank", paymentPrice)
                success = true
            end
        end

        if success then
            local playerName = GetPlayerName(player)
            SendLog(Webhook.Ads, senderJob, title, text, playerName, Config.AllowedJobs[senderJob].webhookcolor)
            TriggerClientEvent("evolved:sendNotificationCL", -1, senderJob, title, text, Config.AllowedJobs[senderJob].imageDict, Config.AllowedJobs[senderJob].imageTexture)
        elseif not hasSufficientFunds then
            TriggerClientEvent("evolved:showNotification", player, "Insufficient funds")
        end
    end
end)



function SendLog(webhook, senderJob, title, text, playerName, color)
    local tagEveryone = false

    local embedData = {
        {
            ['title'] = title,
            ['color'] = color,
            ['footer'] = {
                ['text'] = Webhook.Servername .. " | Logs | " .. os.date(),
            },
            ['description'] = text,
            ['author'] = {
                ['name'] = playerName .. ' | Logs | ' .. senderJob,
            },
        }
    }

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = 'Logs', embeds = embedData }), { ['Content-Type'] = 'application/json' })

    if tagEveryone then
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = 'Logs', content = '|| @everyone @here ||' }), { ['Content-Type'] = 'application/json' })
    end
end

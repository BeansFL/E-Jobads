Config = {}

Config.Framework = "esx" -- set to esx or qbcore
Config.OxTarget = true -- set to true if you are using ox_target also really useable if youre on qbcore but its also compatible with esx
Config.AllowedJobs = {
    ['police'] = {
        imageDict = "CHAR_CALL911",  -- more imageDict on https://wiki.gtanet.work/index.php?title=Notification_Pictures
        imageTexture = "CHAR_CALL911",
        notificationCooldown = 5000,
        payment = {
            shouldCost = true,
            price = 1000, -- Updated property name to "price"
        },
        webhookcolor = tonumber("3399FF", 16),
    },
    ['ambulance'] = {
        imageDict = "WEB_DIGIFARM",
        imageTexture = "WEB_DIGIFARM",
        notificationCooldown = 5000,
        payment = {
            shouldCost = false,
            price = 1000, -- Updated property name to "price"
        },
        webhookcolor = tonumber("CC0000", 16),
    },
    ['banker'] = {
        imageDict = "CHAR_BANK_MAZE",
        imageTexture = "CHAR_BANK_MAZE",
        notificationCooldown = 5000,
        payment = {
            shouldCost = true,
            price = 1000, -- Updated property name to "price"
        },
        webhookcolor = tonumber("FFFF00", 16), 
    },
}



Config.enablePed = true
Config.Location = { 
    {
        location = vector4(434.5182, -975.0252, 29.7119, 92.4269),
        pedmodel = "s_m_y_cop_01",
    }
}


Config.Sounds = {
    enableSound = true, -- set to false if you don't want to play a sound
    sounddic    = "HUD_MINI_GAME_SOUNDSET", -- more on https://runtime.fivem.net/doc/natives/#_0x7FF4944CC209192D
    soundname   = "5_SEC_WARNING", -- more on https://runtime.fivem.net/doc/natives/#_0x7FF4944CC209192D
    soundvolume = 1.0, -- set the volume of the sound max is 1.0
    soundpitch  = 0.1, -- set the pitch of the sound max is 1.0
}

Config.Locales = { -- this is the locale file, you can change the text here
    PressE = "~y~Press E to advertise for the ~b~", -- this is the text that will be displayed when you are near the ped
    OxTarget = "Advertise for Job", -- this is the text that will be displayed on the ox_target menu
    exitBtnText = "Exit", -- this is the text that will be displayed on the exit button
    paymentBtnText = "Pay", -- this is the text that will be displayed on the payment button
    bankPaymentText = "Bank", -- this is the text that will be displayed on the bank payment button
    cashPaymentText = "Cash", -- this is the text that will be displayed on the cash payment button
    containerTitleText = "Announcements", -- this is the text that will be displayed on the container title
    containerDescriptionText = "Description...", -- this is the text that will be displayed on the container description
    containerTitlePlaceholder = "Title...", -- this is the text that will be displayed on the container title placeholder

}

function NotifyNotEnough()  -- this is a function to notify the player that he does not have enough money
    local message = "You do not have enough money!"
    if Config.Framework == "esx" then
        ESX.ShowNotification(message) -- set your own notification here for esx
    elseif Config.Framework == "qbcore" then
        QBCore.Functions.Notify(message, "error") -- set your own notification here for qbcore
    end
end


function showTextUI()
    local playerJob
    if Config.Framework == 'esx' then
        playerJob = ESX.PlayerData.job.name
        ESX.TextUI(Config.Locales.PressE .. playerJob, "info")
    elseif Config.Framework == 'qbcore' then
        playerJob = QBCore.Functions.GetPlayerData().job.name
        TriggerEvent("QBCore:Notify", Config.Locales.PressE .. playerJob, "info")
    end
    isTextUIShown = true
end

function hideTextUI()
    if Config.Framework == 'esx' then
        ESX.HideUI()
    end
    isTextUIShown = false
end
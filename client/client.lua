local pedList = {} -- List to keep track of created peds
local isNotificationDisplayed = false -- Flag to track if a notification is currently displayed
local isTextUIShown = false
-- Test
RegisterNetEvent("evolved:sendNotificationCL")
AddEventHandler("evolved:sendNotificationCL", function(senderJob, title, text) -- Add title and text as function parameters
    local jobConfig = Config.AllowedJobs[senderJob]
    if jobConfig then
        if not isNotificationDisplayed then
            isNotificationDisplayed = true -- Set the flag to prevent further notifications

            local imageDict = jobConfig.imageDict
            local imageTexture = jobConfig.imageTexture
            RequestStreamedTextureDict(imageDict, false)
            while not HasStreamedTextureDictLoaded(imageDict) do
                Citizen.Wait(0)
            end
            if Config.Sounds.enableSound then
                PlaySoundFrontend(-1, Config.Sounds.soundname, Config.Sounds.sounddic, true)
            end

            SetNotificationTextEntry("STRING")
            AddTextComponentString(text) -- Combine title and text in one string
            SetNotificationMessage(imageDict, imageTexture, true, 1, title, "")
            DrawNotification(false, false)

            Citizen.Wait(jobConfig.notificationCooldown) -- Wait for the specified cooldown period
            isNotificationDisplayed = false -- Reset the flag to allow new notifications
        end
    end 
end)

RegisterNUICallback("getData", function(data, cb)
    TriggerServerEvent("evolved:pay", data.payment, data.title, data.description) -- Pass the correct payment type, title, and text
end)

local isMenuOpen = false

if Config.OxTarget then
    for _, data in ipairs(Config.Location) do
        exports.ox_target:addSphereZone({
            coords = data.location,
            radius = 2.0,
            options = {
                {
                    name = 'pedJobAd',
                    event = 'evolvedads:openPedJobAdMenu',
                    icon = 'fa-solid fa-bullhorn',
                    label = Config.Locales.OxTarget,
                    canInteract = function()
                        return not isMenuOpen  
                    end
                }
            }
        })
    end
end

RegisterNetEvent('evolvedads:openPedJobAdMenu')
AddEventHandler('evolvedads:openPedJobAdMenu', function()
    openMenu()
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(sleep)
        if not Config.OxTarget then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local inVicinity = false

            for i = 1, #Config.Location do
                local locData = Config.Location[i]
                local dist = #(playerCoords - vector3(locData.location.x, locData.location.y, locData.location.z))

                if dist < 2.0 then
                    if not isTextUIShown then
                        showTextUI()
                    end
                    inVicinity = true
                    sleep = 0

                    if IsControlJustReleased(0, 38) then
                        openMenu()
                    end
                    break -- No need to check other locations if we found one within proximity
                end
            end

            -- Only runs if we have not detected proximity to any location
            if not inVicinity then
                hideTextUI()
                sleep = 500
            end
        end
    end  
end)



function openMenu()
    SetNuiFocus(true, true)
    local playerJob

    if Config.Framework == 'esx' then
        playerJob = ESX.PlayerData.job.name
    elseif Config.Framework == 'qbcore' then
        playerJob = QBCore.Functions.GetPlayerData().job.name
    end

    SendNUIMessage({
        display = true,
        job = playerJob,
        texts = {
            exitBtnText = Config.Locales.exitBtnText,
            paymentBtnText = Config.Locales.paymentBtnText,
            bankPaymentText = Config.Locales.bankPaymentText,
            cashPaymentText = Config.Locales.cashPaymentText,
            containerTitleText = Config.Locales.containerTitleText
        },
        placeholders = {
            titlePlaceholder = Config.Locales.containerTitlePlaceholder,
            descriptionPlaceholder = Config.Locales.containerDescriptionText
        }
    })
end

RegisterNUICallback("exit", function()
    SetNuiFocus(false, false)
end)

if Config.enablePed then
    Citizen.CreateThread(function()
        for i = 1, #Config.Location do
            local v = Config.Location[i]
            local hash = GetHashKey(v.pedmodel)
            while not HasModelLoaded(hash) do
                RequestModel(hash)
                Citizen.Wait(20)
            end
            local ped = CreatePed(4, hash, v.location.x, v.location.y, v.location.z, v.location.w, false, true)
            SetEntityHeading(ped, v.location.w)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetPedDiesWhenInjured(ped, false)
            SetPedCanPlayAmbientAnims(ped, true)
            SetPedCanRagdollFromPlayerImpact(ped, false)
            SetEntityCanBeDamaged(ped, false)
            SetPedCanRagdoll(ped, false)
            SetPedCanBeTargetted(ped, false)

            table.insert(pedList, { ped = ped, location = { x = v.location.x, y = v.location.y, z = v.location.z } })
        end
    end)
end

RegisterNetEvent("evolved:showNotification")
AddEventHandler("evolved:showNotification", function()
    NotifyNotEnough()
end)
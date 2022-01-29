local QBCore = exports['qb-core']:GetCoreObject()


local ItemList = {
    ["cannabis"] = "cannabis"
}

local DrugList = {
    ["weed_brick"] = "weed_brick"
}


RegisterServerEvent('apolo_weed:server:processcannabis')
AddEventHandler('apolo_weed:server:processcannabis', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cannabis = Player.Functions.GetItemByName('cannabis')

        if Player.PlayerData.items ~= nil then 
            if cannabis ~= nil then 
                if cannabis.amount >= 2 then 

                    Player.Functions.RemoveItem("cannabis", 2, false)
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['cannabis'], "remove")

                    TriggerClientEvent("apolo_weed:client:weedprocess", src)
                else
                    TriggerClientEvent('QBCore:Notify', src, "You do not have the correct items", 'error')   
                end
            else
                TriggerClientEvent('QBCore:Notify', src, "You do not have the correct items", 'error')   
            end
        else
            TriggerClientEvent('QBCore:Notify', src, "You Have Nothing...", "error")
        end
        
end)


RegisterServerEvent('apolo_weed:server:weedsell')
AddEventHandler('apolo_weed:server:weedsell', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local weed = Player.Functions.GetItemByName('weed_brick')

    if Player.PlayerData.items ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if weed ~= nil then
                if DrugList[Player.PlayerData.items[k].name] ~= nil then 
                    if Player.PlayerData.items[k].name == "weed_brick" and Player.PlayerData.items[k].amount >= 1 then 
                        local random = math.random(50, 65)
                        local amount = Player.PlayerData.items[k].amount * random

                        TriggerClientEvent('chatMessage', source, "Dealer Johnny", "normal", 'Damn you got '..Player.PlayerData.items[k].amount..'bricks of weed')
                        TriggerClientEvent('chatMessage', source, "Dealer Johnny", "normal", 'Ill buy all of it for $'..amount )

                        Player.Functions.RemoveItem("weed_brick", Player.PlayerData.items[k].amount)
                        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['weed_brick'], "remove")
                        Player.Functions.AddMoney("cash", amount)
                        break
                    else
                        TriggerClientEvent('QBCore:Notify', src, "You do not have weed bricks", 'error')
                        break
                    end
                end
            else
                TriggerClientEvent('QBCore:Notify', src, "You do not have weed bricks", 'error')
                break
            end
        end
    end
end)


RegisterServerEvent('apolo_weed:server:getcannabis')
AddEventHandler('apolo_weed:server:getcannabis', function()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem("cannabis", 10)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['cannabis'], "add")
end)

RegisterServerEvent('apolo_weed:server:getweed')
AddEventHandler('apolo_weed:server:getweed', function()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem("weed_brick", 1)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['weed_brick'], "add")
end)



local NeededAttempts = 0
local SucceededAttempts = 0
local FailedAttemps = 0
local weedpicking = false
local weedprocess = false
local nearDealer = false
local QBCore = exports['qb-core']:GetCoreObject()


DrawText3Ds = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while true do
        local inRange = false

        local PlayerPed = PlayerPedId()
        local PlayerPos = GetEntityCoords(PlayerPed)

        local distance = #(PlayerPos - vector3(1487.76, 1128.55, 114.34))
 --        local distance2 = #(PlayerPos - vector3(YOUR COORDS HERE)) -- YOUR COORDS HERE
 --        local distance3 = #(PlayerPos - vector3(YOUR COORDS HERE)) -- YOUR COORDS HERE
        
        if distance < 6 then
            inRange = true

            if distance < 2 then
                DrawText3Ds(1487.76, 1128.55, 114.34, "[G] Process Cannabis")
                if IsControlJustPressed(0, 47) then
					TriggerServerEvent("apolo_weed:server:processcannabis")
                end
            end
			
 --           if distance2 < 2 then
 --               DrawText3Ds(YOUR COORDS HERE, "[G] Process Cannabis")
 --               if IsControlJustPressed(0, 47) then
 --                   TriggerServerEvent("apolo_weed:server:processcannabis")
 --
 --               end
 --          end
			
 --          if distance3 < 2 then
 --             DrawText3Ds(YOUR COORDS HERE, "[G] Process Cannabis")
 --               if IsControlJustPressed(0, 47) then
 --                   TriggerServerEvent("apolo_weed:server:processcannabis")
 --
 --              end
 --           end
            
        end

        if not inRange then
            Citizen.Wait(2000)
        end
        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function()
    while true do
        local inRange = false

        local PlayerPed = PlayerPedId()
        local PlayerPos = GetEntityCoords(PlayerPed)

        local distance = #(PlayerPos - vector3(974.08, -192.22, 73.2))
        
        if distance < 6 then
            inRange = true

            if distance < 2 then
                DrawText3Ds(974.08, -192.22, 73.2, "[G] Sell Weed")
                if IsControlJustPressed(0, 47) then
                    TriggerServerEvent("apolo_weed:server:weedsell")

                end
            end
            
        end

        if not inRange then
            Citizen.Wait(2000)
        end
        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function()
    while true do
        local inRange = false

        local PlayerPed = PlayerPedId()
        local PlayerPos = GetEntityCoords(PlayerPed)

        local distance1 = #(PlayerPos - vector3(1784.2, 4949.96, 44.38))
        local distance2 = #(PlayerPos - vector3(1788.5, 4953.41, 44.81))
        local distance3 = #(PlayerPos - vector3(1793.48, 4957.7, 45.26))
        
        if distance1 < 15 then
            inRange = true

            if distance1 < 2 then
                DrawText3Ds(1784.2, 4949.96, 44.38, "[G] Start Picking")
                if IsControlJustPressed(0, 47) then
                    PrepareAnim()
                    pickProcess()
                end
            end
			
            if distance2 < 2 then
                DrawText3Ds(1788.5, 4953.41, 44.81, "[G] Start Picking")
                if IsControlJustPressed(0, 47) then
                    PrepareAnim()
                    pickProcess()
                end
            end
			

            if distance3 < 2 then
                DrawText3Ds(1793.48, 4957.7, 45.26, "[G] Start Picking")
                if IsControlJustPressed(0, 47) then
                    PrepareAnim()
                    pickProcess()
                end
            end
			
        end

        if not inRange then
            Citizen.Wait(2000)
        end
        Citizen.Wait(3)
    end
end)

RegisterNetEvent('apolo_weed:client:pickcannabis')
AddEventHandler('apolo_weed:client:pickcannabis', function(source)
    PrepareProcessAnim()
    pickProcess()
end)


RegisterNetEvent('apolo_weed:client:weedprocess')
AddEventHandler('apolo_weed:client:weedprocess', function(source)
	PrepareProcessAnim()
    weedProcess()
end)

function pickProcess()
    QBCore.Functions.Progressbar("pick_cannabis", "Picking Cannabis...", math.random(5000,7000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent("apolo_weed:server:getcannabis")
        ClearPedTasks(PlayerPedId())
        cannabispicking = false
    end, function() -- Cancel
        openingDoor = false
        ClearPedTasks(PlayerPedId())
        QBCore.Functions.Notify("Process Canceled", "error")
    end)
end

function weedProcess()
    QBCore.Functions.Progressbar("weed_process", "Process Cannabis...", math.random(5000, 7000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent("apolo_weed:server:getweed")
        ClearPedTasks(PlayerPedId())
        cannabispicking = false
    end, function() -- Cancel
        openingDoor = false
        ClearPedTasks(PlayerPedId())
        QBCore.Functions.Notify("Process Canceled", "error")
    end)
end

function PickMinigame()
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(3, 5)
    end

    local maxwidth = 30
    local maxduration = 3500

    Skillbar.Start({
        duration = math.random(2000, 3000),
        pos = math.random(10, 30),
        width = math.random(20, 30),
    }, function()

        if SucceededAttempts + 1 >= NeededAttempts then
            pickProcess()
            QBCore.Functions.Notify("You picked a cannabis", "success")
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
        else    
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = math.random(2000, 3000),
                pos = math.random(10, 30),
                width = math.random(20, 30),
            })
        end
                
        
	end, function()

            QBCore.Functions.Notify("You messed up the cannabis!", "error")
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
            cannabispicking = false
       
    end)
end

function ProcessMinigame(source)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(3, 5)
    end

    local maxwidth = 30
    local maxduration = 3000

    Skillbar.Start({
        duration = math.random(2000, 3000),
        pos = math.random(10, 30),
        width = math.random(20, 30),
    }, function()

        if SucceededAttempts + 1 >= NeededAttempts then
            weedprocess()
            QBCore.Functions.Notify("You make some weed bricks!", "success")
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
        else    
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = math.random(2000, 3000),
                pos = math.random(10, 30),
                width = math.random(20, 30),
            })
        end
                
        
	end, function()

            QBCore.Functions.Notify("You messed up the process!", "error")
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
            weedprocess = false
       
    end)
end


function PrepareProcessAnim()
    local ped = PlayerPedId()
    LoadAnim('mini@repair')
    TaskPlayAnim(ped, 'mini@repair', 'fixing_a_ped', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
    PreparingProcessAnimCheck()
end

function PreparingProcessAnimCheck()
    weedprocess = true
    Citizen.CreateThread(function()
        while true do
            local ped = PlayerPedId()

            if weedprocess then
            else
                ClearPedTasksImmediately(ped)
                break
            end

            Citizen.Wait(200)
        end
    end)
end

function PrepareAnim()
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_GARDENER_PLANT", 0, true)
    PreparingAnimCheck()
end

function ProcessPrepareAnim()
    local ped = PlayerPedId()
    LoadAnim('amb@prop_human_bbq@male@idle_a')
    TaskPlayAnim(ped, 'amb@prop_human_bbq@male@idle_a', 'idle_b', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
    PreparingAnimCheck()
end

function PreparingAnimCheck()
    cannabispicking = true
    Citizen.CreateThread(function()
        while true do
            local ped = PlayerPedId()

            if cannabispicking then
            else
                ClearPedTasksImmediately(ped)
                break
            end

            Citizen.Wait(200)
        end
    end)
end

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(1)
    end
end

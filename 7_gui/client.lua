-- Notifications

function showNotification(message, color, flash, saveToBrief)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(message) 
    SetNotificationBackgroundColor(color) 
    EndTextCommandThefeedPostTicker(flash, saveToBrief)
end


RegisterCommand('testnotification', function(_,_, rawCommand)
    showNotification(rawCommand, 130, true, true)

end, false)


-- advanced notifications

function showAdvancedNotification(message, sender, subject, textureDict, iconType, saveToBrief, color)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(message)
    ThefeedNextPostBackgroundColor(color)
    EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
    EndTextCommandThefeedPostTicket(false, saveToBrief)
end

RegisterCommand('advanced', function(_,_, rawCommand)
    showAdvancedNotification(rawCommand, 'This is Sender', 'This is Subject', 'CHAR_AMMUNATION', 8, true, 130)
end, false)

-- alerts

function showAlert(message, beep, duration)
    AddTextEntry('7_ALERT', message)
    BeginTextCommandDisplayHelp('7_ALERT')
    EndTextCommandDisplayHelp(0, false, beep, duration)
end

RegisterCommand('alert', function(_,_,rawCommmand)
    showAlert(rawCommmand, true, -1)
end, false)


-- markers


RegisterCommand('marker', function(_,_,rawCommand)
    CreateThread(function()
        local start = GetGameTimer()
    while GetGameTimer() < start + 10000 do 
        Wait(0)
    local playerCoorinates = GetEntityCoords(PlayerPedId())
    DrawMarker(6,  playerCoorinates.x,  playerCoorinates.y, playerCoorinates.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255,  255,  255, 255, true, true,  2,  nil, nil, false)
        end
    end)
    
end, false)


--[[
DrawMarker(
        type,
        posX,
        posY,
        posZ,
        dirX,
        dirY,
        dirZ,
        rotX,
        rotY,
        rotZ,
        scaleX,
        scaleY,
        scaleZ,
        red,
        green,
        blue,
        alpha,
        bobUpAndDown,
        faceCamera,
        p19,
        rotate,
        textureDict,
        textureName,
        drawOnEnts
    )]]




-- subtitles

function showSubtitle(message, duration)
    BeginTextCommandPrint('STRING')
    AddTextComponentString(message)
    EndTextCommandPrint(duration, true)
end

RegisterCommand('subtitle', function(_,_,rawCommand)
    showSubtitle('Go to the ~y~Fleeca~s~ and rob it', 10000)
end, false)


-- Busy Spinner

function showSpinner(message)
    BeginTextCommandBusyspinnerOn('STRING')
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandBusyspinnerOn(5) --4 sau 5. 4 e portocaliu
end

function hideSpinner()
    BusyspinnerOff()
end

RegisterCommand('spinner', function(_,_,rawCommand)
    if rawCommand == 'spinner' then
        hideSpinner()
    else
        showSpinner(rawCommand)
    end
end, false)


-- text input
--[[
    DisplayOnscreenKeyboard(p0 (integer), 
    windowTitle (string), 
    p2 (string), 
    defaultText (string), 
    defaultConcat1 (string), 
    defaultConcat2 (string), 
    defaultConcat3 (string), 
    maxInputLength (integer)
    )
]]

-- -1 daca nu foloseste, 0 daca editeaza, 1 daca a terminat, 2 daca a anulat

function getTextInput(title, inputLength)
    AddTextEntry('7_INPUT', title)
    DisplayOnscreenKeyboard(1, '7_INPUT', '', '', '', '', '', inputLength)
    while UpdateOnscreenKeyboard() == 0 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(0)
        return result
    else
        Citizen.Wait(0)
        return nil
    end


end


RegisterCommand('textinput', function(_,_, rawCommand)
local result = getTextInput(rawCommand, 63)
showNotification(result, 180, true, true)
end, false)
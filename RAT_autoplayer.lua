
--made by 0_Void
if not _G.Executed then--preventing multiple executions. could use getgenv but i'm not to reduce the custom functions used to ake sure everyone understands without having knowledge about custom functions
    _G.Executed =0
    else
    _G.Executed = 1
end
table.sort(_G.chances,function(a, b) return a[2] < b[2]end)
local function sendkey(key)
    keypress(key)
    keyrelease(key)
end

local function random()
    local random = math.random(1, 100)
    local max = math.max(_G.chances[1][2], _G.chances[2][2], _G.chances[3][2], _G.chances[4][2], _G.chances[5][2])
    for i, v in pairs(_G.chances) do
        local as
        if v[2] == max then
            as = i
        end
        if random <= v[2] or random <= 100 and as ~= nil then
            if random <= 100 and random >= max then
                return as
            end
            return i
        end
    end
end
local function lol(button, player, scroll, random)
    local press
    if button == "Left" then
        press = "A"
    elseif button == "Right" then
        press = "D"
    elseif button == "Up" then
        press = "W"
    elseif button == "Down" then
        press = "S"
    end

    local offsets = {
        {"Sweet", 0.1, -3},
        {"Fresh", 0.5, -3},
        {"Good", 0.8, -3},
        {"Bad", 1, -3},
        {"Yikes", 2, -3}
    }

    local function scrollhandle(scroll, judgement)
        for i, v in pairs(offsets) do
            if v[1] == judgement then
                if scroll == "Upscroll" then
                    return v[3], v[2]
                elseif scroll == "Downscroll" then
                    return -v[2], -v[3]
                end
            end
        end
    end

    for i, v in pairs(game.Players.LocalPlayer.PlayerGui:WaitForChild("GameHUD").Frame[player][button]:GetChildren()) do
        task.wait()
        if not v:GetAttribute("Judgement") then
            v:SetAttribute("Judgement", _G.chances[random][1])
        end
        print(v:GetAttribute("Judgement"))
        if not v:GetAttribute("Done") then
            v:SetAttribute("Done", 0)
        end
        if
            v ~= nil and v.Position ~= nil and v.Name == "ImageLabel" and v:GetAttribute("Done") == 0 and v:GetAttribute("Judgement")
         then
            value1, value2 = scrollhandle(scroll, v:GetAttribute("Judgement"))
            if v.Position.Y.Scale >= value1 and v.Position.Y.Scale <= value2 then
                if v:FindFirstChild("Tail") then
                    local var = true
                    keypress(press)
                    repeat
                        task.wait()
                        if v:FindFirstChild("Tail") and v.Tail.Size.Y.Scale <= 0.3 then
                            var = false
                        elseif not v:FindFirstChild("Tail") then
                            var = false
                        end
                    until var == false
                    task.wait(0.005)
                    keyrelease(press)
                    v:SetAttribute("Done", 1)
                else
                    sendkey(press)
                    v:SetAttribute("Done", 1)
                end
            end
        end
    end
end
local function getside()
    local ui = game.Players.LocalPlayer.PlayerGui:WaitForChild("GameHUD")
    if ui.Frame.Player1.Size.X.Scale > ui.Frame.Player2.Size.X.Scale then
        return "Player1"
    else
        return "Player2"
    end
end
local function isingame()
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("GameHUD") then
        return true
    else
        return false
    end
end
local function getscroll()
    if game.Players.LocalPlayer.PlayerGui.Settings.Window.Settings.List:FindFirstChild("Downscroll") then
        if
            game.Players.LocalPlayer.PlayerGui.Settings.Window.Settings.List:FindFirstChild("Downscroll").Toggle.Value.Text ==
                "Off"
         then
            return "Upscroll"
        else
            return "Downscroll"
        end
    end
end

--//loop

while _G.enabled do
    if _G.executed == 1 then print("already executed") break end
    task.wait()
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Settings") then
        scroll = getscroll()
     --to automatically get the scroll open settings on execution or change the value below after the else
    elseif scroll == nil then
        scroll = defaultscroll
    end
    if isingame() then
        local side
        if side == nil then
            side = getside()
        end
        coroutine.wrap(lol)("Down", side, scroll, random())
        coroutine.wrap(lol)("Right", side, scroll, random())
        coroutine.wrap(lol)("Left", side, scroll, random())
        coroutine.wrap(lol)("Up", side, scroll, random())
    end
end --todo: add customizable keybinds, and add support for kill notes at least for arrows.


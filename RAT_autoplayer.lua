if not getgenv().Executed then--preventing multiple executions.
    getgenv().Executed = 0
    else
    getgenv().Executed = 1
end
table.sort(getgenv().chances,function(a, b) return a[2] < b[2]end)
local function sendkey(key)
    keypress(key)
    keyrelease(key)
end

local function random()
    local random = math.random(1, 100)
    local max = math.max(getgenv().chances[1][2], getgenv().chances[2][2], getgenv().chances[3][2], getgenv().chances[4][2], getgenv().chances[5][2])
    for i, v in pairs(getgenv().chances) do
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
        press = 0x41
    elseif button == "Right" then
        press = 0x44
    elseif button == "Up" then
        press = 0x57
    elseif button == "Down" then
        press = 0x53
    end

    local offsets = {
        {"Sweet", 0.1, -3, 0.3},
        {"Fresh", 0.5, -3,0.6},
        {"Good", 1, -3,0.9},
        {"Bad", 1.7, -3,1.3},
        {"Yikes", 2.4, -3,1.3}--anything higher than a good lift can be treated as an early lift so to ensure this doesn't happen the limit is set to good lift
    }

    local function scrollhandle(scroll, judgement)
        for i, v in pairs(offsets) do
            if v[1] == judgement then
                if scroll == "Upscroll" then
                    return v[3], v[2], v[4]
                elseif scroll == "Downscroll" then
                    return -v[2], -v[3], v[4]
                end
            end
        end
    end

    for i, v in pairs(game.Players.LocalPlayer.PlayerGui:WaitForChild("GameHUD").Frame[player][button]:GetChildren()) do
        task.wait()
        if not v:GetAttribute("Judgement") then
            v:SetAttribute("Judgement", getgenv().chances[random][1])
        end
        if not v:GetAttribute("Done") then
            v:SetAttribute("Done", false)
        end
        if
            v ~= nil and v.Position ~= nil and v.Name == "ImageLabel" and v:GetAttribute("Done") == false and v:GetAttribute("Judgement")
         then
            value1, value2, value3 = scrollhandle(scroll, v:GetAttribute("Judgement"))
            if v.Position.Y.Scale >= value1 and v.Position.Y.Scale <= value2 then
                if v:FindFirstChild("Tail") then
                    local var = true
                    keypress(press)
                    repeat
                        task.wait()
                        if v:FindFirstChild("Tail") and v.Tail.Size.Y.Scale <= value3 then
                            var = false
                        elseif not v:FindFirstChild("Tail") then
                            var = false
                        end
                    until var == false
                    task.wait(0.01)
                    keyrelease(press)
                    v:SetAttribute("Done", true)
                else
                    sendkey(press)
                    v:SetAttribute("Done", true)
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

while getgenv().enabled do
    if getgenv().executed == 1 then print("already executed") break end
    task.wait()
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Settings") then
        scroll = getscroll()
     --to automatically get the scroll open settings on execution or change the value below after the else
    elseif scroll == nil then
        scroll = getgenv().defaultscroll
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
end

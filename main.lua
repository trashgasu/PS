--: Constants
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting");
local fixedLighting;
local Time;
local timeToggle = Enum.KeyCode.F3;

--: Better Lighting
local function betterLighting()
    Lighting.EnvironmentDiffuseScale = 0.8;
    Lighting:FindFirstChild("low_color_correction").Contrast = 0;
    for _, v in next, Lighting:GetDescendants() do
        if (v:IsA("Atmosphere")) then
            v.Density = 0.375;
        end
    end
end

--: In-game Clock
local function getTime()
    local totalMinutes = Lighting:GetMinutesAfterMidnight();
    local Hours = math.floor(totalMinutes / 60);
    local Minutes = math.floor(totalMinutes % 60);
    local Period;

    if (Hours < 12) then
        Period = "AM";
    else
        Period = "PM";
        Hours -= 12;
    end

    if (Hours == 0) then
        Hours = 12;
    end

    return string.format("%02d:%02d %s", Hours, Minutes, Period);
end

--: Time UI
local sGUI = Instance.new("ScreenGui");
sGUI.ResetOnSpawn = false;

pcall(function()
    if (gethui) then sGUI.Parent = gethui(); else sGUI.Parent = game:GetService("CoreGui"); end
end)

local timeLabel = Instance.new("TextLabel", sGUI);
timeLabel.AnchorPoint = Vector2.new(0.5, 0.5);
timeLabel.BackgroundTransparency = 1;
timeLabel.Position = UDim2.new(0.087, 0, -0.015, 0);
timeLabel.Size = UDim2.new(0.07, 0, 0.04, 0);
timeLabel.Font = Enum.Font.Nunito;
timeLabel.TextColor3 = Color3.fromRGB(250, 250, 250);
timeLabel.TextScaled = true;

local function updateTime()
    timeLabel.Text = getTime();
end

local function onInputBegan(input, gameProcessed)
    if (input.KeyCode == timeToggle) and (not gameProcessed) then
        sGUI.Enabled = not sGUI.Enabled;
    end
end

--: Listeners
fixedLighting = game:GetService("RunService").RenderStepped:Connect(betterLighting);
Time = game:GetService("RunService").RenderStepped:Connect(updateTime);
UIS.InputBegan:Connect(onInputBegan);

game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All,false)
--game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat,true)
local RunService = game:GetService("RunService")
_G.playerReady = false
game.Players.LocalPlayer:WaitForChild("PlayerScripts").DescendantAdded:Connect(function(inst)
	if inst.Name == "RbxCharacterSounds" or inst.Name == "PlayerScriptsLoader" then
		task.wait()
		inst:Destroy()
	elseif inst.Name == "PlayerModule" then
		task.wait()
		inst:Destroy()
		RunService:UnbindFromRenderStep("cameraRenderUpdate")
		RunService:UnbindFromRenderStep("ControlScriptRenderstep")
		_G.playerReady = true
	end
end)
local function waitForChild(instance, name)
	while not instance:FindFirstChild(name) do
		instance.ChildAdded:wait()
	end
	return instance:FindFirstChild(name)
end

--make the gui
local CoreGui = Instance.new("ScreenGui")
CoreGui.ResetOnSpawn = false
CoreGui.DisplayOrder = 12467865
CoreGui.Name = "CoreGui"
CoreGui.IgnoreGuiInset = true
local RobloxGui = Instance.new("Frame")
RobloxGui.Size = UDim2.new(1,0,1,0)
RobloxGui.BackgroundTransparency = 1
RobloxGui.Name = "RobloxGui"
RobloxGui.Parent = CoreGui
local ControlFrame = Instance.new("Frame")
ControlFrame.Size = UDim2.new(1,0,1,0)
ControlFrame.BackgroundTransparency = 1
ControlFrame.Name = "ControlFrame"
ControlFrame.Parent = RobloxGui
local left = Instance.new("Frame",ControlFrame)
left.BackgroundTransparency = 1
left.Size = UDim2.fromScale(130,46)
left.Position = UDim2.new(0,0,1,-46)
left.BackgroundTransparency = 1
left.Name = "BottomLeftControl"
local right = Instance.new("Frame",ControlFrame)
right.BackgroundTransparency = 1
right.Size = UDim2.fromScale(180,41)
right.Position = UDim2.new(1,-180,1,-41)
right.BackgroundTransparency = 1
right.Name = "BottomRightControl"

local shiftLock = Instance.new("ImageButton",left)
shiftLock.BackgroundTransparency = 1
shiftLock.Position = UDim2.fromOffset(2,-33)
shiftLock.Size = UDim2.fromOffset(149,30)
shiftLock.Name = "MouseLockLabel"
shiftLock.Image = "rbxassetid://16441982688"
shiftLock.HoverImage = "rbxassetid://16441982601"
shiftLock.Visible = false

CoreGui.Parent = game.Players.LocalPlayer.PlayerGui
--global functions
function _G.LoadLibrary(lib)
	return require(script.LoadLibrary:WaitForChild(lib))
end
function _G.PreloadImage(img,hover)
	local hidden = Instance.new("ImageButton")
	hidden.Position = UDim2.new(2,0,2,0)
	hidden.Image = img
	hidden.HoverImage = hover
	hidden.Selectable = false
	hidden.Name = "preload"
	hidden.Active = false
	hidden.BackgroundTransparency = 1
	hidden.Parent = CoreGui
	
	return hidden
end
local functions = {}
_G.Offset = Vector2.new(0,0)
function _G.BindToOffset(func)
	table.insert(functions,func)
end
function _G.SetGlobalSizeOffsetPixel(x,y)
	RobloxGui.Size += UDim2.new(0,x,0,y)
	_G.Offset = Vector2.new(x,y)
	for i,v in pairs(functions) do
		task.spawn(v,_G.Offset)
	end
end
--wait for the coregui
local CoreScripts = {
	"PlayerListScript",
	"Settings",
	"ChatScript",
	"BackpackBuilder",
	"BackpackResizer",
	"BackpackScript"
}
local modules = {
	"Animate",
	"Sound",
	"HealthScript v3.1",
	"MovementScript",
	"CameraScript"
}
for i,v in pairs(CoreScripts) do
	local core = waitForChild(script,v)
	core.Parent = RobloxGui
	task.spawn(require(core))
end
for i,v in pairs(modules) do
	local core = waitForChild(script,v)
	task.spawn(require,core)
end


task.spawn(function()
	local content = game:GetService("ContentProvider")
	local images = {}
	images[1] = _G.PreloadImage("rbxassetid://16430534645","rbxassetid://16430534432") --playerlist_big_hide
	images[2] = _G.PreloadImage("rbxassetid://16430517964","rbxassetid://16430517612") --playerlist_hidden_small
	images[3] = _G.PreloadImage("rbxassetid://16430517514","rbxassetid://16430517090") --playerlist_small_hide
	images[4] = _G.PreloadImage("rbxassetid://16430552256","rbxassetid://16430516542") --playerlist_small_maximize
	images[5] = _G.PreloadImage("rbxassetid://16414547477","rbxassetid://16414547263") --chat
	images[6] = _G.PreloadImage("rbxassetid://16414690134","rbxassetid://16414645716") --chat_small
	images[7] = _G.PreloadImage("rbxassetid://16431815127","rbxassetid://16431814985") --backpackButton
	images[8] = _G.PreloadImage("rbxassetid://35238053","rbxassetid://35238036") --healthbar
	images[9] = _G.PreloadImage("rbxassetid://35238000","rbxassetid://34816363") --healthbar
	images[10] = _G.PreloadImage("rbxassetid://34854607","rbxassetid://34854607") --hurtOverlay
	images[11] = _G.PreloadImage("rbxassetid://16440262075","rbxassetid://16440261061") --SettingsButton
	images[12] = _G.PreloadImage("rbxassetid://16440262343","rbxassetid://16440262343") --RecordStop
	images[13] = _G.PreloadImage("rbxassetid://16441982483","rbxassetid://16441982300") --mouselock_on
	images[14] = _G.PreloadImage("rbxassetid://16441982688","rbxassetid://16441982601") --mouselock_off
	content:PreloadAsync(images)
end)
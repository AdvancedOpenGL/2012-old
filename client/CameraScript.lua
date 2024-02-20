local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local mouse = player:GetMouse()
local CameraDistance = 5

while not _G.playerReady do
    task.wait()
end
--Camera script
_G.shiftlock = false
camera.CameraType = Enum.CameraType.Custom

local MouseDelta
local IsRightClick
local function MouseHandler(action,InputState,input:InputObject)
	if action == "RightClick" then
		if InputState == Enum.UserInputState.Begin and UserInputService.MouseBehavior == Enum.MouseBehavior.Default then
			IsRightClick = true
			UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
		elseif InputState == Enum.UserInputState.End and UserInputService.MouseBehavior == Enum.MouseBehavior.LockCurrentPosition then
			IsRightClick = false
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		end
	end
end
local function CameraKeys(action,InputState,input:InputObject)
	if action == "ZoomIn" and InputState == Enum.UserInputState.Begin then
		CameraDistance -= 1
	elseif action == "ZoomOut" and InputState == Enum.UserInputState.Begin then
		CameraDistance += 1
	end
end
ContextActionService:BindAction("RightClick",MouseHandler,false,Enum.UserInputType.MouseButton2)
ContextActionService:BindAction("ZoomIn",CameraKeys,false,Enum.KeyCode.I)
ContextActionService:BindAction("ZoomOut",CameraKeys,false,Enum.KeyCode.O)
mouse.WheelForward:Connect(function()
	CameraDistance -= 1
end)
mouse.WheelBackward:Connect(function()
	CameraDistance += 1
end)
game:GetService("RunService").RenderStepped:Connect(function()
	local delta = game:GetService("UserInputService"):GetMouseDelta()
	if player.Character and player.Character.Head and not _G.pausecamera then
		local newPosition = (player.Character.Head.CFrame.Position+-(camera.CFrame.LookVector*CameraDistance))+-(camera.CFrame.XVector*(delta.X*0.1))+(camera.CFrame.YVector*(delta.Y*0.1))
		local newVector = CFrame.new(newPosition,player.Character.Head.Position)
		camera.CFrame = newVector
        if _G.shiftlock then
            local _,y,_ = camera.CFrame:ToEulerAnglesXYZ()
            local x,_,z = player.Character.PrimaryPart.CFrame:ToEulerAnglesXYZ()
            player.Character:SetPrimaryPartCFrame(CFrame.Angles(math.rad(x),math.rad(y),math.rad(z))+player.Character.PrimaryPart.Position)
        end
	end
end)

return ""
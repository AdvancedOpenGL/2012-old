local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

while not _G.playerReady do
    task.wait()
end
local function keyDown(key)
	return UserInputService:IsKeyDown(Enum.KeyCode[key])
end
local function getMovement(dt)
	local move = Vector3.new(0,0,0)
	if keyDown("W") then
		move += Vector3.new(0,0,-1*dt)
	end
	if keyDown("A") then
		move += Vector3.new(-1*dt,0,0)
	end
	if keyDown("S") then
		move += Vector3.new(0,0,1*dt)
	end
	if keyDown("D") then
		move += Vector3.new(1*dt,0,0)
	end
	if keyDown("Space") then
		player.Character.Humanoid.Jump = true
	end
	return move
end
local function move(dt)
	if not player.Character then
		return
	end
	if not player.Character:FindFirstChild("Humanoid") then
		return
	end
	player.Character.Humanoid:Move(getMovement(1),true)
end
game:GetService("RunService").Heartbeat:Connect(move)

return ""
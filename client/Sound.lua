local function characterAdded(char)
	-- util

	local function waitForChild(parent, childName)
		local child = parent:findFirstChild(childName)
		if child then return child end
		while true do
			child = parent.ChildAdded:wait()
			if child.Name==childName then return child end
		end
	end

	local function newSound(id)
		local sound = Instance.new("Sound")
		sound.SoundId = id
		sound.Archivable = false
		sound.Parent = char:WaitForChild("Head")
		return sound
	end

	-- declarations

	--[[
	local sDied = newSound("rbxassetid://16416714841")--newSound("rbxasset://sounds/uuhhh.wav")
	local sFallingDown = newSound("rbxassetid://16416715748")--newSound("rbxasset://sounds/splat.wav")
	local sFreeFalling = newSound("rbxassetid://16416715938")--newSound("rbxasset://sounds/swoosh.wav")
	local sGettingUp = newSound("rbxassetid://16416715122")--newSound("rbxasset://sounds/hit.wav")
	local sJumping = newSound("rbxassetid://16416715305")-- newSound("rbxasset://sounds/button.wav")
	local sRunning = newSound("rbxassetid://16416715534")--newSound("rbxasset://sounds/bfsl-minifigfoots1.mp3")
	]]
	local sDied = newSound("rbxasset://sounds/uuhhh.wav")
	local sFallingDown = newSound("rbxasset://sounds/splat.wav")
	local sFreeFalling = newSound("rbxassetid://16416715938")
	local sGettingUp = newSound("rbxasset://sounds/hit.wav")
	local sJumping = newSound("rbxasset://sounds/button.wav")
	local sRunning = newSound("rbxasset://sounds/bfsl-minifigfoots1.mp3")
	sRunning.Looped = true

	local Figure = char
	local Head = waitForChild(Figure, "Head")
	local Humanoid = waitForChild(Figure, "Humanoid")

	-- functions


	local function onState(state, sound)
		if state then
			sound:Play()
		else
			sound:Pause()
		end
	end

	local function onRunning(speed)
		if speed>0 then
			sRunning:Play()
		else
			sRunning:Pause()
		end
	end
	
	local e = {}
	local function disconnect()
		for i,v in pairs(e) do
			if v and v.Disconnect then
				v:Disconnect()
			end
		end
	end
	-- connect up
	local function onDied()
		sDied:Play()
	end
	e[1] = Humanoid.Died:Connect(onDied)
	e[2] = Humanoid.Running:Connect(onRunning)
	e[3] = Humanoid.Jumping:Connect(function(state) onState(state, sJumping) end)
	e[4] = Humanoid.GettingUp:Connect(function(state) onState(state, sGettingUp) end)
	e[5] = Humanoid.FreeFalling:Connect(function(state) onState(state, sFreeFalling) end)
	e[6] = Humanoid.FallingDown:Connect(function(state) onState(state, sFallingDown) end)
end

local function playerAdded(p)
	p.CharacterAdded:Connect(characterAdded)
	if p.Character then
		characterAdded(p.Character)
	end
end
game.Players.PlayerAdded:Connect(playerAdded)
for i,v in pairs(game.Players:GetPlayers()) do
	playerAdded(v)
end

return ""
function waitForChild(parent, childName)
	local child = parent:FindFirstChild(childName)
	if child then return child end
	while true do
		child = parent.ChildAdded:wait()
		if child.Name==childName then return child end
	end
end
local function characterAdded(c : Model)
	c.DescendantAdded:Connect(function(inst)
		if inst.Name == "Animate" then
			task.wait()
			inst:Destroy()
			local a = c:WaitForChild("Humanoid")
			for i,v in pairs(a:GetPlayingAnimationTracks()) do
				v:Stop()
			end
		end
	end)
	if c:FindFirstChild("Animate") then
		c:FindFirstChild("Animate"):Destroy()
	end
	-- ANIMATION

	-- declarations

	local Figure = c
	local Torso = waitForChild(Figure, "Torso")
	local RightShoulder = waitForChild(Torso, "Right Shoulder")
	local LeftShoulder = waitForChild(Torso, "Left Shoulder")
	local RightHip = waitForChild(Torso, "Right Hip")
	local LeftHip = waitForChild(Torso, "Left Hip")
	local Neck = waitForChild(Torso, "Neck")
	local Humanoid = waitForChild(Figure, "Humanoid")
	local pose = "Standing"
	local toolAnim = "None"
	local toolAnimTime = 0

	-- functions

	function onRunning(speed)
		if speed>0 then
			pose = "Running"
		else
			pose = "Standing"
		end
	end

	function onDied()
		pose = "Dead"
	end

	function onJumping()
		pose = "Jumping"
	end

	function onClimbing()
		pose = "Climbing"
	end

	function onGettingUp()
		pose = "GettingUp"
	end

	function onFreeFall()
		pose = "FreeFall"
	end

	function onFallingDown()
		pose = "FallingDown"
	end

	function onSeated()
		pose = "Seated"
	end

	function moveJump()
		RightShoulder.MaxVelocity = 0.5
		LeftShoulder.MaxVelocity = 0.5
		RightShoulder.DesiredAngle = 3.14
		LeftShoulder.DesiredAngle = -3.14
		RightHip.DesiredAngle = 0
		LeftHip.DesiredAngle = 0
	end


	-- same as jump for now

	function moveFreeFall()
		RightShoulder.MaxVelocity = 0.5
		LeftShoulder.MaxVelocity = 0.5
		RightShoulder.DesiredAngle = 3.14
		LeftShoulder.DesiredAngle = -3.14
		RightHip.DesiredAngle = 0
		LeftHip.DesiredAngle = 0
	end

	function moveSit()
		RightShoulder.MaxVelocity = 0.15
		LeftShoulder.MaxVelocity = 0.15
		RightShoulder.DesiredAngle = 3.14 /2
		LeftShoulder.DesiredAngle = -3.14 /2
		RightHip.DesiredAngle = 3.14 /2
		LeftHip.DesiredAngle = -3.14 /2
	end

	function getTool()	
		for _, kid in ipairs(Figure:GetChildren()) do
			if kid.className == "Tool" then return kid end
		end
		return nil
	end

	function getToolAnim(tool)
		for _, c in ipairs(tool:GetChildren()) do
			if c.Name == "toolanim" and c.className == "StringValue" then
				return c
			end
		end
		return nil
	end

	function animateTool()

		if (toolAnim == "None") then
			RightShoulder.DesiredAngle = 1.57
			return
		end

		if (toolAnim == "Slash") then
			RightShoulder.MaxVelocity = 0.5
			RightShoulder.DesiredAngle = 0
			return
		end

		if (toolAnim == "Lunge") then
			RightShoulder.MaxVelocity = 0.5
			LeftShoulder.MaxVelocity = 0.5
			RightHip.MaxVelocity = 0.5
			LeftHip.MaxVelocity = 0.5
			RightShoulder.DesiredAngle = 1.57
			LeftShoulder.DesiredAngle = 1.0
			RightHip.DesiredAngle = 1.57
			LeftHip.DesiredAngle = 1.0
			return
		end
	end

	function move(time)
		local amplitude
		local frequency

		if (pose == "Jumping") then
			moveJump()
			return
		end

		if (pose == "FreeFall") then
			moveFreeFall()
			return
		end

		if (pose == "Seated") then
			moveSit()
			return
		end

		local climbFudge = 0

		if (pose == "Running") then
			RightShoulder.MaxVelocity = 0.15
			LeftShoulder.MaxVelocity = 0.15
			amplitude = 1
			frequency = 9
		elseif (pose == "Climbing") then
			RightShoulder.MaxVelocity = 0.5 
			LeftShoulder.MaxVelocity = 0.5
			amplitude = 1
			frequency = 9
			climbFudge = 3.14
		else
			amplitude = 0.1
			frequency = 1
		end

		desiredAngle = amplitude * math.sin(time*frequency)

		RightShoulder.DesiredAngle = desiredAngle + climbFudge
		LeftShoulder.DesiredAngle = desiredAngle - climbFudge
		RightHip.DesiredAngle = -desiredAngle
		LeftHip.DesiredAngle = -desiredAngle


		local tool = getTool()

		if tool then

			animStringValueObject = getToolAnim(tool)

			if animStringValueObject then
				toolAnim = animStringValueObject.Value
				-- message recieved, delete StringValue
				animStringValueObject.Parent = nil
				toolAnimTime = time + .3
			end

			if time > toolAnimTime then
				toolAnimTime = 0
				toolAnim = "None"
			end

			animateTool()


		else
			toolAnim = "None"
			toolAnimTime = 0
		end
	end


	-- connect events
	local e = {}
	local function disconnectEvents()
		for i,v in pairs(e) do
			if v and v.Disconnect then
				v:Disconnect()
			end
		end
	end
	e[1] = Humanoid.Died:Connect(onDied)
	e[2] = Humanoid.Running:Connect(onRunning)
	e[3] = Humanoid.Jumping:Connect(onJumping)
	e[4] = Humanoid.Climbing:Connect(onClimbing)
	e[5] = Humanoid.GettingUp:Connect(onGettingUp)
	e[6] = Humanoid.FreeFalling:Connect(onFreeFall)
	e[7] = Humanoid.FallingDown:Connect(onFallingDown)
	e[8] = Humanoid.Seated:Connect(onSeated)

	-- main program

	local runService = game:GetService("RunService");
	e[9] = runService.RenderStepped:Connect(function()
		if c and c.Parent then
			move(tick())
		else
			disconnectEvents()
			return
		end
	end)
end

local function playerAdded(p:Player)
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
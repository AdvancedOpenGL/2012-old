--!native
--!optimize 2
--!strict
local HealthGUI_prototype = Instance.new("ScreenGui")
HealthGUI_prototype.Name = "HealthGUI"
HealthGUI_prototype.ResetOnSpawn = false
local frame = Instance.new("Frame",HealthGUI_prototype)
frame.Size = UDim2.fromScale(1,1)
frame.BackgroundTransparency = 1

local lastHealth = 100
local lastHealth2 = 100
local maxWidth = 0.96

local humanoid

local function CreateGUI()
	local p = game.Players.LocalPlayer
	local tray = Instance.new("Frame",frame)
	tray.Size = UDim2.fromOffset(170,18)
	tray.BackgroundTransparency = 1
	tray.Position = UDim2.new(0.5, -44,1, -26)
	tray.SizeConstraint = Enum.SizeConstraint.RelativeYY
	tray.Name = "tray"
	
	local bar2 = Instance.new("Frame",tray)
	bar2.Name = "bar2"
	bar2.Size = UDim2.fromScale(0.192,0.83)
	bar2.Position = UDim2.fromScale(0.019,0.1)
	bar2.BackgroundTransparency = 1
	bar2.BackgroundColor3 = Color3.new(1,1,1)
	bar2.ZIndex = 102
	
	local bar = Instance.new("ImageLabel",tray)
	bar.Image = "rbxassetid://35238053"
	bar.BackgroundTransparency = 1
	bar.Size = UDim2.fromScale(0.96,0.83)
	bar.Position = UDim2.fromScale(0.019,0.1)
	bar.Name = "bar"
	bar.ZIndex = 101
	
	local barRed = Instance.new("ImageLabel",tray)
	barRed.Image = "rbxassetid://35238036"
	barRed.BackgroundTransparency = 1
	barRed.Size = UDim2.fromScale(0,0)
	barRed.Position = UDim2.fromScale(0.019,0.1)
	barRed.Name = "barRed"
	barRed.ZIndex = 101
	
	local bkg = Instance.new("ImageLabel",tray)
	bkg.Size = UDim2.fromScale(1,1)
	bkg.Image = "rbxassetid://35238000"
	bkg.BackgroundTransparency = 1
	bkg.Name = "bkg"
	bkg.ZIndex = 100
	
	local label = Instance.new("ImageLabel",tray)
	label.Image = "rbxassetid://34816363"
	label.BackgroundTransparency = 1
	label.Name = "label"
	label.Size = UDim2.fromScale(0.25,0.35)
	label.Position = UDim2.fromScale(0.68,0.3)
	label.ZIndex = 200
	
	local hurtOverlay = Instance.new("ImageLabel",frame)
	hurtOverlay.Name = "hurtOverlay"
	hurtOverlay.Image = "rbxassetid://34854607"
	hurtOverlay.BackgroundTransparency = 1
	hurtOverlay.Size = UDim2.new(1,0,1.15,30)
	hurtOverlay.Position = UDim2.new(2,0,0,-22)
	
	_G.BindToOffset(function(vector)
		frame.Size += UDim2.new(0,vector.X,0,vector.Y)
	end)
	frame.Size += UDim2.new(0,_G.Offset.X,0,_G.Offset.Y)
	HealthGUI_prototype.Parent = p.PlayerGui
end

local function UpdateGUI(health : number)
	local tray = frame.tray
	local width = (health / humanoid.MaxHealth) * maxWidth
	local height = 0.83
	local lastX = tray.bar.Position.X.Scale
	local x = 0.019 + (maxWidth - width)
	local y = 0.1
	
	tray.bar.Position = UDim2.new(x,0,y, 0) 
	tray.bar.Size = UDim2.new(width, 0, height, 0)
	-- If more than 1/4 health, bar = green.  Else, bar = red.
	if( (health / humanoid.MaxHealth) > 0.25 ) then
		tray.barRed.Size = UDim2.new(0, 0, 0, 0)
	else
		tray.barRed.Position = tray.bar.Position
		tray.barRed.Size = tray.bar.Size
		tray.bar.Size = UDim2.new(0, 0, 0, 0)
	end
	
	if ( (lastHealth - health) > (humanoid.MaxHealth / 10) ) then
		lastHealth = health

		if humanoid.Health ~= humanoid.MaxHealth then
			delay(0,function()
				AnimateHurtOverlay()
			end)
			delay(0,function()
				AnimateBars(x, y, lastX, height)
			end)
		end
	else
		lastHealth = health
	end
end


local function HealthChanged(health)
	UpdateGUI(health)
	if ( (lastHealth2 - health) > (humanoid.MaxHealth / 10) ) then
		lastHealth2 = health
	else
		lastHealth2 = health
	end
end

local function AnimateBars(x : number, y : number, lastX : number, height : number)
	local tray = frame.tray
	local width = math.abs(x - lastX)
	if( x > lastX ) then
		x = lastX
	end
	tray.bar2.Position = UDim2.new(x,0, y, 0)
	tray.bar2.Size = UDim2.new(width, 0, height, 0)
	tray.bar2.BackgroundTransparency = 0
	local GBchannels = 1
	local j = 0.2

	local i_total = 30
	for i=1,i_total do
		-- Increment Values
		if (GBchannels < 0.2) then
			j = -j
		end
		GBchannels = GBchannels + j
		if (i > (i_total - 10)) then
			tray.bar2.BackgroundTransparency = tray.bar2.BackgroundTransparency + 0.1
		end
		tray.bar2.BackgroundColor3 = Color3.new(1, GBchannels, GBchannels)
		
		wait(0.02)
	end
end

local function AnimateHurtOverlay()
	-- Start:
	-- overlay.Position = UDim2.new(0, 0, 0, -22)
	-- overlay.Size = UDim2.new(1, 0, 1.15, 30)
	
	-- Finish:
	-- overlay.Position = UDim2.new(-2, 0, -2, -22)
	-- overlay.Size = UDim2.new(4.5, 0, 4.65, 30)
	
	local overlay = frame.hurtOverlay
	overlay.Position = UDim2.new(-2, 0, -2, -22)
	overlay.Size = UDim2.new(4.5, 0, 4.65, 30)
	-- Animate In, fast
	local i_total = 2
	local wiggle_total = 0
	local wiggle_i = 0.02
	for i=1,i_total do
		overlay.Position = UDim2.new( (-2 + (2 * (i/i_total)) + wiggle_total/2), 0, (-2 + (2 * (i/i_total)) + wiggle_total/2), -22 )
		overlay.Size = UDim2.new( (4.5 - (3.5 * (i/i_total)) + wiggle_total), 0, (4.65 - (3.5 * (i/i_total)) + wiggle_total), 30 )
		wait(0.01)
	end
	
	i_total = 30
	
	wait(0.03)
	
	-- Animate Out, slow
	for i=1,i_total do
		if( math.abs(wiggle_total) > (wiggle_i * 3) ) then
			wiggle_i = -wiggle_i
		end
		wiggle_total = wiggle_total + wiggle_i
		overlay.Position = UDim2.new( (0 - (2 * (i/i_total)) + wiggle_total/2), 0, (0 - (2 * (i/i_total)) + wiggle_total/2), -22 )
		overlay.Size = UDim2.new( (1 + (3.5 * (i/i_total)) + wiggle_total), 0, (1.15 + (3.5 * (i/i_total)) + wiggle_total), 30 )
		wait(0.01)
	end
	
	-- Hide after we're done
	overlay.Position = UDim2.new(10, 0, 0, 0)
end

CreateGUI()
local function characterAdded(c)
	humanoid = c:WaitForChild("Humanoid")
	local a = humanoid.HealthChanged:Connect(HealthChanged)
	local a1
	a1 = humanoid.Died:Connect(function()
		HealthChanged(0) 
		if a then
			a:Disconnect()
		end
		if a1 then
			a1:Disconnect()
		end
	end)
	HealthChanged(humanoid.MaxHealth)
end
game.Players.LocalPlayer.CharacterAdded:Connect(characterAdded)
if game.Players.LocalPlayer.Character then
	characterAdded(game.Players.LocalPlayer.Character)
end
return ""
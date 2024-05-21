local players = game:GetService("Players")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local lp = players.LocalPlayer
local mouse = lp:GetMouse()
local viewport = workspace.CurrentCamera.ViewportSize
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

local infJump
infJumpDebounce = false

Players = game:GetService("Players")
IYMouse = Players.LocalPlayer:GetMouse()

function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	return rootPart
end

FLYING = false
QEfly = true
iyflyspeed = 1
vehicleflyspeed = 1


local Library = {}

function Library:sFLY(vfly)
	repeat wait() until Players.LocalPlayer and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	repeat wait() until IYMouse
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end

	local T = getRoot(Players.LocalPlayer.Character)
	local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local SPEED = 0

	local function FLY()
		FLYING = true
		local BG = Instance.new('BodyGyro')
		local BV = Instance.new('BodyVelocity')
		BG.P = 9e4
		BG.Parent = T
		BV.Parent = T
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new(0, 0, 0)
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		task.spawn(function()
			repeat wait()
				if not vfly and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
					Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
				end
				if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					SPEED = 50
				elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
					SPEED = 0
				end
				if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
					lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
				elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
				else
					BV.velocity = Vector3.new(0, 0, 0)
				end
				BG.cframe = workspace.CurrentCamera.CoordinateFrame
			until not FLYING
			CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			SPEED = 0
			BG:Destroy()
			BV:Destroy()
			if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
				Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
			end
		end)
	end
	flyKeyDown = IYMouse.KeyDown:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 's' then
			CONTROL.B = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'a' then
			CONTROL.L = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'd' then 
			CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
		elseif QEfly and KEY:lower() == 'e' then
			CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed)*2
		elseif QEfly and KEY:lower() == 'q' then
			CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed)*2
		end
		pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
	end)
	flyKeyUp = IYMouse.KeyUp:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		elseif KEY:lower() == 'e' then
			CONTROL.Q = 0
		elseif KEY:lower() == 'q' then
			CONTROL.E = 0
		end
	end)
	FLY()
end

function Library:NOFLY()
	FLYING = false
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
	if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
		Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
	end
	pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

function Library:DraggingEnabled(frame, parent)

	parent = parent or frame

	local dragging = false
	local dragInput, mousePos, framePos

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			mousePos = input.Position
			framePos = parent.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	uis.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			parent.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
		end
	end)
end


function Library:tween(object, goal, callback)
	local tween = tweenService:Create(object, tweenInfo, goal)
	tween.Completed:Connect(callback or function() end)
	tween:Play()
end

function Library:CreateLib(name)

	local GUI = {
		Hover = false,
		MouseDown = false,
		Minimised = false,
	}

	do
		GUI["1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"));
		GUI["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
		GUI["1"]["IgnoreGuiInset"] = true
		GUI["1"]["Name"] = name;
		GUI["1"]["Parent"] = game.CoreGui;

		GUI["2"] = Instance.new("Frame", GUI["1"]);
		GUI["2"]["BorderSizePixel"] = 0;
		GUI["2"]["BackgroundColor3"] = Color3.fromRGB(21, 21, 21);
		GUI["2"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
		GUI["2"]["Size"] = UDim2.new(0, 348, 0, 397);
		GUI["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["2"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
		GUI["2"]["Name"] = [[Border]];

		GUI["3"] = Instance.new("Frame", GUI["2"]);
		GUI["3"]["ZIndex"] = 2;
		GUI["3"]["BorderSizePixel"] = 0;
		GUI["3"]["BackgroundColor3"] = Color3.fromRGB(31, 31, 31);
		GUI["3"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
		GUI["3"]["Size"] = UDim2.new(0, 337, 0, 367);
		GUI["3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["3"]["Position"] = UDim2.new(0.5, 0, 0.5249999761581421, 0);
		GUI["3"]["Name"] = [[Container]];

		GUI["4"] = Instance.new("UIStroke", GUI["3"]);
		GUI["4"]["Color"] = Color3.fromRGB(36, 36, 36);

		GUI["5"] = Instance.new("Frame", GUI["2"]);
		GUI["5"]["BorderSizePixel"] = 0;
		GUI["5"]["BackgroundColor3"] = Color3.fromRGB(171, 71, 71);
		GUI["5"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
		GUI["5"]["Size"] = UDim2.new(0, 345, 0, 395);
		GUI["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["5"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
		GUI["5"]["Name"] = [[ColoredBorder]];

		GUI["6"] = Instance.new("Frame", GUI["2"]);
		GUI["6"]["BorderSizePixel"] = 0;
		GUI["6"]["BackgroundColor3"] = Color3.fromRGB(21, 21, 21);
		GUI["6"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
		GUI["6"]["Size"] = UDim2.new(0, 343, 0, 393);
		GUI["6"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["6"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
		GUI["6"]["Name"] = [[InsideBorder]];

		GUI["7"] = Instance.new("TextLabel", GUI["2"]);
		GUI["7"]["BorderSizePixel"] = 0;
		GUI["7"]["TextYAlignment"] = Enum.TextYAlignment.Top;
		GUI["7"]["BackgroundColor3"] = Color3.fromRGB(26, 26, 26);
		GUI["7"]["TextXAlignment"] = Enum.TextXAlignment.Left;
		GUI["7"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
		GUI["7"]["TextSize"] = 14;
		GUI["7"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["7"]["Size"] = UDim2.new(0, 337, 0, 18);
		GUI["7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["7"]["Text"] = name;
		GUI["7"]["Position"] = UDim2.new(0, 7, 0, 7);

		GUI["7a"] = Instance.new("UIStroke", GUI["7"]);
		GUI["7a"]["Color"] = Color3.fromRGB(31, 31, 31);
		
		GUI["8"] = Instance.new("TextLabel", GUI["3"]);
		GUI["8"]["AnchorPoint"] = Vector2.new(0, 1);
		GUI["8"]["BackgroundTransparency"] = 1;
		GUI["8"]["Position"] = UDim2.new(0, 0, 1, 0);
		GUI["8"]["Size"] = UDim2.new(0, 330, 0, 18);
		GUI["8"]["Text"] = [[Press "H" to hide UI.]];
		GUI["8"]["TextTransparency"] = 0.6;
		GUI["8"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["8"]["TextXAlignment"] = Enum.TextXAlignment.Right;
		
		
	end

	do
		GUI["a"] = Instance.new("Frame", GUI["2"]);
		GUI["a"]["ZIndex"] = 0;
		GUI["a"]["BackgroundTransparency"] = 1;
		GUI["a"]["Size"] = UDim2.new(1, 0, 1, 0);
		GUI["a"]["Name"] = [[shadowHolder]];

		GUI["b"] = Instance.new("ImageLabel", GUI["a"]);
		GUI["b"]["ZIndex"] = 0;
		GUI["b"]["SliceCenter"] = Rect.new(10, 10, 118, 118);
		GUI["b"]["ScaleType"] = Enum.ScaleType.Slice;
		GUI["b"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["b"]["ImageTransparency"] = 0.8600000143051147;
		GUI["b"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
		GUI["b"]["Image"] = [[rbxassetid://1316045217]];
		GUI["b"]["Size"] = UDim2.new(1, 4, 1, 4);
		GUI["b"]["Name"] = [[umbraShadow]];
		GUI["b"]["BackgroundTransparency"] = 1;
		GUI["b"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

		GUI["c"] = Instance.new("ImageLabel", GUI["a"]);
		GUI["c"]["ZIndex"] = 0;
		GUI["c"]["SliceCenter"] = Rect.new(10, 10, 118, 118);
		GUI["c"]["ScaleType"] = Enum.ScaleType.Slice;
		GUI["c"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["c"]["ImageTransparency"] = 0.8799999952316284;
		GUI["c"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
		GUI["c"]["Image"] = [[rbxassetid://1316045217]];
		GUI["c"]["Size"] = UDim2.new(1, 4, 1, 4);
		GUI["c"]["Name"] = [[penumbraShadow]];
		GUI["c"]["BackgroundTransparency"] = 1;
		GUI["c"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

		GUI["d"] = Instance.new("ImageLabel", GUI["50"]);
		GUI["d"]["ZIndex"] = 0;
		GUI["d"]["SliceCenter"] = Rect.new(10, 10, 118, 118);
		GUI["d"]["ScaleType"] = Enum.ScaleType.Slice;
		GUI["d"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["d"]["ImageTransparency"] = 0.8799999952316284;
		GUI["d"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
		GUI["d"]["Image"] = [[rbxassetid://1316045217]];
		GUI["d"]["Size"] = UDim2.new(1, 4, 1, 4);
		GUI["d"]["Name"] = [[ambientShadow]];
		GUI["d"]["BackgroundTransparency"] = 1;
		GUI["d"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
	end

	Library:DraggingEnabled(GUI["7"], GUI["2"])

	function GUI:CreateSection(name, sizex, sizey, posx, posy)

		local Section = {}

		Section["1"] = Instance.new("Frame", GUI["3"]);
		Section["1"]["ZIndex"] = 2;
		Section["1"]["BorderSizePixel"] = 0;
		Section["1"]["BackgroundColor3"] = Color3.fromRGB(26, 26, 26);
		Section["1"]["Size"] = UDim2.new(0, sizex, 0, sizey);
		Section["1"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Section["1"]["Position"] = UDim2.new(0, posx, 0, posy);
		Section["1"]["Name"] = name;

		Section["2"] = Instance.new("UIStroke", Section["1"]);
		Section["2"]["Color"] = Color3.fromRGB(41, 41, 41);

		Section["3"] = Instance.new("Frame", Section["1"]);
		Section["3"]["BorderSizePixel"] = 0;
		Section["3"]["BackgroundColor3"] = Color3.fromRGB(171, 71, 71);
		Section["3"]["Size"] = UDim2.new(1, 0, 0, 0);
		Section["3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);

		Section["4"] = Instance.new("UIStroke", Section["3"]);
		Section["4"]["Color"] = Color3.fromRGB(255, 106, 106);
		Section["4"]["Thickness"] = 0.25;

		Section["5"] = Instance.new("TextLabel", Section["3"]);
		Section["5"]["BorderSizePixel"] = 0;
		Section["5"]["TextYAlignment"] = Enum.TextYAlignment.Top;
		Section["5"]["BackgroundColor3"] = Color3.fromRGB(26, 26, 26);
		Section["5"]["TextXAlignment"] = Enum.TextXAlignment.Left;
		Section["5"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
		Section["5"]["TextSize"] = 14;
		Section["5"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
		Section["5"]["Size"] = UDim2.new(1, -7, 0, 15);
		Section["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Section["5"]["Text"] = name;
		Section["5"]["BackgroundTransparency"] = 1;
		Section["5"]["Position"] = UDim2.new(0, 7, 0, 2);

		Section["5a"] = Instance.new("UIStroke", Section["5"]);
		Section["5a"]["Color"] = Color3.fromRGB(31, 31, 31);

		Section["6"] = Instance.new("ScrollingFrame", Section["1"]);
		Section["6"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
		Section["6"]["BackgroundColor3"] = Color3.fromRGB(171, 71, 71);
		Section["6"]["BackgroundTransparency"] = 1;
		Section["6"]["Size"] = UDim2.new(1, 0, 0.8, 0);
		Section["6"]["Position"] = UDim2.new(0.5, 0, 0.55, 0);
		Section["6"]["ScrollBarThickness"] = 2;
		Section["6"]["ScrollBarImageColor3"] = Color3.fromRGB(255, 255, 255);
		Section["6"]["Name"] = [[Container]];

		Section["6a"] = Instance.new("UIListLayout", Section["6"]);
		Section["6a"]["Padding"] = UDim.new(0.03, 0);
		Section["6a"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
		Section["6a"]["VerticalAlignment"] = Enum.VerticalAlignment.Top;
		Section["6a"]["SortOrder"] = Enum.SortOrder.LayoutOrder

		Section["6b"] = Instance.new("UIPadding", Section["6"]);
		Section["6b"]["PaddingTop"] = UDim.new(0, 2);

		function Section:CreateButton(name, callback)

			local Button = {
				Hover = false,
				MouseDown = false
			}

			Button["1"] = Instance.new("TextLabel", Section["6"]);
			Button["1"]["BorderSizePixel"] = 0;
			Button["1"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
			Button["1"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Button["1"]["TextSize"] = 14;
			Button["1"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
			Button["1"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
			Button["1"]["Size"] = UDim2.new(0.9, 0, 0, 12);
			Button["1"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Button["1"]["Text"] = name;
			Button["1"]["Name"] = name;
			Button["1"]["Position"] = UDim2.new(0.5, 0, 0, 0);

			Button["1a"] = Instance.new("UIStroke", Button["1"]);
			Button["1a"]["Color"] = Color3.fromRGB(46, 46, 46);
			Button["1a"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;

			do
				Button["1"].MouseEnter:Connect(function()
					Button.Hover = true

					if not Button.MouseDown then
						Library:tween(Button["1a"], {Color = Color3.fromRGB(225, 225, 225)})
					end
				end)

				Button["1"].MouseLeave:Connect(function()
					Button.Hover = false

					if not Button.MouseDown then
						Library:tween(Button["1a"], {Color = Color3.fromRGB(41, 41, 41)})
					end
				end)

				uis.InputBegan:Connect(function(input, gpe)
					if gpe then return end

					if input.UserInputType == Enum.UserInputType.MouseButton1 and Button.Hover then
						Button.MouseDown = true
						if Button.Hover then
							Library:tween(Button["1"], {BackgroundColor3 = Color3.fromRGB(200, 200, 200)})
							Library:tween(Button["1a"], {Color = Color3.fromRGB(255, 255, 255)})
							callback()
						end
					end
				end)

				uis.InputEnded:Connect(function(input, gpe)
					if gpe then return end

					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Button.MouseDown = false
						if Button.Hover then
							Library:tween(Button["1"], {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
							Library:tween(Button["1a"], {Color = Color3.fromRGB(255, 255, 255)})
						else
							Library:tween(Button["1"], {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
							Library:tween(Button["1a"], {Color = Color3.fromRGB(45, 45, 45)})
						end	
					end
				end)
			end
			return Button
		end

		function Section:CreateLabel(name, posy, text, color)

			local Label = {}

			Label["1"] = Instance.new("TextLabel", Section["1"]);
			Label["1"]["BorderSizePixel"] = 0;
			Label["1"]["TextYAlignment"] = Enum.TextYAlignment.Top;
			Label["1"]["BackgroundColor3"] = Color3.fromRGB(26, 26, 26);
			Label["1"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			Label["1"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Label["1"]["TextSize"] = 14;
			Label["1"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
			Label["1"]["Size"] = UDim2.new(.9, -7, 0, 15);
			Label["1"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Label["1"]["Text"] = name;
			Label["1"]["BackgroundTransparency"] = 1;
			Label["1"]["Position"] = UDim2.new(0.075, 0, posy, 0)
			Label["1"]["Name"] = name;

			Label["1a"] = Instance.new("UIStroke", Label["1"]);
			Label["1a"]["Color"] = Color3.fromRGB(31, 31, 31);

			Label["2"] = Instance.new("TextLabel", Label["1"]);
			Label["2"]["BorderSizePixel"] = 0;
			Label["2"]["BackgroundColor3"] = Color3.fromRGB(26, 26, 26);
			Label["2"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			Label["2"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Label["2"]["TextSize"] = 14;
			Label["2"]["TextColor3"] = color;
			Label["2"]["Size"] = UDim2.new(0.5, 0, 0.5, 0);
			Label["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Label["2"]["Text"] = text;
			Label["2"]["Name"] = "Color";
			Label["2"]["BackgroundTransparency"] = 1;
			Label["2"]["Position"] = UDim2.new(0.42500001192092896, 0, 0.6499999761581421, 0);
			Label["2"]["AnchorPoint"] = Vector2.new(0, 0.5)

			Label["2a"] = Instance.new("UIStroke", Label["2"]);
			Label["2a"]["Color"] = Color3.fromRGB(31, 31, 31);

			return Label
		end


		function Section:CreateSlider(name, posy, min, max, callback)

			local Slider = {
				MouseDown = false,
				Hover = false,
				Connection = nil
			}

			Slider["1"] = Instance.new("Frame", Section["1"]);
			Slider["1"]["BorderSizePixel"] = 0;
			Slider["1"]["BackgroundColor3"] = Color3.fromRGB(192, 192, 192);
			Slider["1"]["BackgroundTransparency"] = 1;
			Slider["1"]["Size"] = UDim2.new(0, 137, 0, 8);
			Slider["1"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Slider["1"]["Position"] = UDim2.new(0.075, 0, posy, 0);
			Slider["1"]["Name"] = name;

			Slider["1a"] = Instance.new("UIStroke", Slider["1"]);
			Slider["1a"]["Color"] = Color3.fromRGB(41, 41, 41);

			Slider["2"] = Instance.new("TextLabel", Slider["1"]);
			Slider["2"]["BorderSizePixel"] = 0;
			Slider["2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Slider["2"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			Slider["2"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Slider["2"]["TextSize"] = 14;
			Slider["2"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
			Slider["2"]["Size"] = UDim2.new(1, 0, 1, 0);
			Slider["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Slider["2"]["Text"] = name;
			Slider["2"]["BackgroundTransparency"] = 1;
			Slider["2"]["Position"] = UDim2.new(0, 0, -1.75, 0);

			Slider["3"] = Instance.new("Frame", Slider["1"]);
			Slider["3"]["BorderSizePixel"] = 0;
			Slider["3"]["BackgroundColor3"] = Color3.fromRGB(183, 81, 81);
			Slider["3"]["Size"] = UDim2.new(0, 0, 1, 0);
			Slider["3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);

			Slider["4"] = Instance.new("TextLabel", Slider["1"]);
			Slider["4"]["BorderSizePixel"] = 0;
			Slider["4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Slider["4"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			Slider["4"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Slider["4"]["TextSize"] = 14;
			Slider["4"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
			Slider["4"]["Size"] = UDim2.new(0.25, 0, 1, 0);
			Slider["4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Slider["4"]["Text"] = tostring(min);
			Slider["4"]["BackgroundTransparency"] = 1;
			Slider["4"]["Position"] = UDim2.new(0.75, 0, -1.75, 0);

			do	
				function Slider:SetValue(v)

					if v == nil then
						local percentage = math.clamp((mouse.X - Slider["1"].AbsolutePosition.X) / (Slider["1"].AbsoluteSize.X), 0, 1)
						local value = math.floor(((max - min) * percentage) + min)

						Slider["4"].Text = tostring(value)
						Slider["3"].Size = UDim2.fromScale(percentage, 1)
					else
						Slider["4"].Text = tostring(v)
						Slider["3"].Size = UDim2.fromScale(((v - min) / (max - min)), 1)
					end

					callback(Slider:GetValue())
				end

				function Slider:GetValue()
					return tonumber(Slider["4"].Text)
				end
			end	

			-- Logic
			do
				Slider["1"].MouseEnter:Connect(function()
					Slider.Hover = true

					if not Slider.MouseDown then
						Library:tween(Slider["1a"], {Color = Color3.fromRGB(255, 255, 255)})
					end
				end)

				Slider["1"].MouseLeave:Connect(function()
					Slider.Hover = false

					if not Slider.MouseDown then
						Library:tween(Slider["1a"], {Color = Color3.fromRGB(45, 45, 45)})
					end
				end)

				uis.InputBegan:Connect(function(input, gpe)
					if gpe then return end

					if input.UserInputType == Enum.UserInputType.MouseButton1 and Slider.Hover then
						Slider.MouseDown = true

						Library:tween(Slider["1"], {BackgroundColor3 = Color3.fromRGB(225, 225, 225)})
						Library:tween(Slider["1a"], {Color = Color3.fromRGB(255, 255, 255)})

						if not Slider.Connection then
							Slider.Connection = runService.RenderStepped:Connect(function()
								Slider:SetValue()
							end)
						end
					end					
				end)

				uis.InputEnded:Connect(function(input, gpe)
					if gpe then return end

					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Slider.MouseDown = false

						if Slider.Hover then
							Library:tween(Slider["1"], {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
							Library:tween(Slider["1a"], {Color = Color3.fromRGB(255, 255, 255)})

						else
							Library:tween(Slider["1"], {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
							Library:tween(Slider["1a"], {Color = Color3.fromRGB(45, 45, 45)})
						end

						if Slider.Connection then Slider.Connection:Disconnect() end
						Slider.Connection = nil
					end
				end)
			end

			return Slider
		end

		function Section:CreateToggle(name, posy, callback)

			local Toggle = {
				MouseDown = false,
				Hover = false,
				State = false
			}

			Toggle["1"] = Instance.new("Frame", Section["1"]);
			Toggle["1"]["BorderSizePixel"] = 0;
			Toggle["1"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
			Toggle["1"]["BackgroundTransparency"] = 0;
			Toggle["1"]["Size"] = UDim2.new(0, 7, 0, 7);
			Toggle["1"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Toggle["1"]["Position"] = UDim2.new(0.075, 0, posy, 0);
			Toggle["1"]["Name"] = name;

			Toggle["1a"] = Instance.new("UIStroke", Toggle["1"]);
			Toggle["1a"]["Color"] = Color3.fromRGB(45, 45, 45);

			Toggle["1b"] = Instance.new("TextLabel", Toggle["1"]);
			Toggle["1b"]["BorderSizePixel"] = 0;
			Toggle["1b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Toggle["1b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			Toggle["1b"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Toggle["1b"]["TextSize"] = 14;
			Toggle["1b"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
			Toggle["1b"]["Size"] = UDim2.new(10, 0, 1, 0);
			Toggle["1b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Toggle["1b"]["Text"] = name;
			Toggle["1b"]["BackgroundTransparency"] = 1;
			Toggle["1b"]["Position"] = UDim2.new(2, 0, 0, 0);

			do
				function Toggle:Toggle(b)
					if b == nil then
						Toggle.State = not Toggle.State 
					else
						Toggle.State = b
					end

					if Toggle.State then
						Library:tween(Toggle["1"], {BackgroundColor3 = Color3.fromRGB(182, 80, 80)})
						Library:tween(Toggle["1a"], {Color = Color3.fromRGB(255, 255, 255)})
					else
						Library:tween(Toggle["1"], {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
						Library:tween(Toggle["1a"], {Color = Color3.fromRGB(45, 45, 45)})
					end

					callback(Toggle.State)
				end
			end

			do
				Toggle["1"].MouseEnter:Connect(function()
					Toggle.Hover = true

					if not Toggle.MouseDown then
						Library:tween(Toggle["1a"], {Color = Color3.fromRGB(255, 255, 255)})
					end
				end)

				Toggle["1"].MouseLeave:Connect(function()
					Toggle.Hover = false

					if not Toggle.MouseDown then
						Library:tween(Toggle["1a"], {Color = Color3.fromRGB(45, 45, 45)})
					end
				end)

				uis.InputBegan:Connect(function(input, gpe)
					if gpe then return end

					if input.UserInputType == Enum.UserInputType.MouseButton1 and Toggle.Hover then
						Toggle.MouseDown = true

						Library:tween(Toggle["1a"], {Color = Color3.fromRGB(255, 255, 255)})

						Toggle:Toggle()
					end
				end)

				uis.InputEnded:Connect(function(input, gpe)
					if gpe then return end

					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Toggle.MouseDown = false

						if Toggle.Hover then
							Library:tween(Toggle["1a"], {Color = Color3.fromRGB(255, 255, 255)})
						else
							Library:tween(Toggle["1a"], {Color = Color3.fromRGB(45, 45, 45)})

						end

						if Toggle.Connection then
							Toggle.Connection:Disconnect()
							Toggle.Connection = nil
						end
					end
				end)
			end
			return Toggle
		end

		function Section:CreateTextbox(name, placeHolderText)

			local Textbox = {
				Hover = false,
				MouseDown = false
			}

			Textbox["1"] = Instance.new("TextBox", Section["6"]);
			Textbox["1"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
			Textbox["1"]["Size"] = UDim2.new(0.9, 0, 0, 12);
			Textbox["1"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
			Textbox["1"]["PlaceholderText"] = placeHolderText;
			Textbox["1"]["Text"] = [[]];
			Textbox["1"]["Name"] = name

			Textbox["1a"] = Instance.new("UIStroke", Textbox["1"]);
			Textbox["1a"]["Color"] = Color3.fromRGB(45, 45, 45);
			Textbox["1a"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;

			do
				Textbox["1"].MouseEnter:Connect(function()
					Textbox.Hover = true

					if not Textbox.MouseDown then
						Library:tween(Textbox["1a"], {Color = Color3.fromRGB(255, 255, 255)})
					end
				end)

				Textbox["1"].MouseLeave:Connect(function()
					Textbox.Hover = false

					if not Textbox.MouseDown then
						Library:tween(Textbox["1a"], {Color = Color3.fromRGB(45, 45, 45)})
					end
				end)

				uis.InputBegan:Connect(function(input, gpe)
					if gpe then return end

					if input.UserInputType == Enum.UserInputType.MouseButton1 and Textbox.Hover then
						Textbox.MouseDown = true
						
						Library:tween(Textbox["1"], {BackgroundColor3 = Color3.fromRGB(225, 225, 225)})
						Library:tween(Textbox["1a"], {Color = Color3.fromRGB(255, 255, 255)})
					end
				end)

				uis.InputEnded:Connect(function(input, gpe)
					if gpe then return end

					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Textbox.MouseDown = false

						if Textbox.Hover then
							Library:tween(Textbox["1"], {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
							Library:tween(Textbox["1a"], {Color = Color3.fromRGB(255, 255, 255)})
						else
							Library:tween(Textbox["1"], {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
							Library:tween(Textbox["1a"], {Color = Color3.fromRGB(45, 45, 45)})
						end
					end
				end)	
			end
			
		end

		return Section
	end

	return GUI
end

local Window = Library:CreateLib("flxzzrhub")

local Player = Window:CreateSection("Player", 158, 200, 7, 7)
local Teleport = Window:CreateSection("Teleport", 158, 150, 172, 7)
local Visuals = Window:CreateSection("Visuals", 158, 100, 7, 214)
local Misc = Window:CreateSection("Misc", 158, 100, 172, 164)

Player["6"]:Destroy()
Player["6a"]:Destroy()
Visuals["6"]:Destroy()
Visuals["6a"]:Destroy()
Misc["6"]:Destroy()
Misc["6a"]:Destroy()

local Lobby = Teleport:CreateButton("Lobby", function()
	for i, v in pairs(game.Workspace.Lobby.Spawns:GetChildren()) do
		if v:IsA("SpawnLocation") then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Position)
		end
	end
end)

local Map = Teleport:CreateButton("Map", function()
	for i, v in pairs(game.Workspace.Normal.Spawns:GetChildren()) do
		if v:IsA("BasePart") then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Position)
		end
	end
end)

local GunDrop = Teleport:CreateButton("Gun Drop", function()
	if game.Workspace:FindFirstChild("GunDrop") then
		game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(game.Workspace:FindFirstChild("GunDrop").Position)
	end
end)

local UsernameBox = Teleport:CreateTextbox("UsernameBox", "Username")

local TeleportButton = Teleport:CreateButton("Teleport to Player", function()
	local playerTeleportingTo = game.Players:FindFirstChild(game.Players.LocalPlayer.PlayerGui.flxzzrhub.Border.Container.Teleport.Container.UsernameBox.Text)
	
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = playerTeleportingTo.Character.HumanoidRootPart.CFrame
end)

local MurdererPlayer = nil
local SheriffPlayer = nil

local Murderer = Misc:CreateLabel("Murderer:", 0.25, tostring(MurdererPlayer), Color3.fromRGB(255, 83, 83))
local Sheriff = Misc:CreateLabel("Sheriff:", 0.45, tostring(SheriffPlayer), Color3.fromRGB(83, 175, 255))
local GunDrop = Misc:CreateLabel("Status:", 0.65, "Dropped", Color3.fromRGB(109, 255, 83))

local Clipon = false

local NoClip = Player:CreateToggle("Noclip", 0.15, function(state)
	if state then
		Clipon = true
		Stepped = game:GetService("RunService").Stepped:Connect(function()
			if not Clipon == false then
				for a, b in pairs(Workspace:GetChildren()) do
					if b.Name == Players.LocalPlayer.Name then
						for i, v in pairs(Workspace[Players.LocalPlayer.Name]:GetChildren()) do
							if v:IsA("BasePart") then
								v.CanCollide = false
							end end end end
			else
				Stepped:Disconnect()
			end
		end)
	else
		Clipon = false
		Players.LocalPlayer.Character.Humanoid.Jump = true
	end
end)

local Fly = Player:CreateToggle("Fly", 0.25, function(state)
	if state then
		sFLY()
	else
		NOFLY()
	end
end)

local infJump = Player:CreateToggle("Infinite Jump", 0.35, function(state)
	if state then
		if infJump then infJump:Disconnect() end
		infJumpDebounce = false
		infJump = uis.JumpRequest:Connect(function()
			if not infJumpDebounce then
				infJumpDebounce = true
				game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
				wait()
				infJumpDebounce = false
			end
		end)
	else
		if infJump then infJump:Disconnect() end
		infJumpDebounce = false
	end
end)

local XRay = Player:CreateToggle("XRay", 0.75, function(state)
	for i, v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") then
			if state then
				if not v:FindFirstChild("OriginalTransparency") then
					local originalTransparency = Instance.new("NumberValue")
					originalTransparency.Name = "OriginalTransparency"
					originalTransparency.Value = v.Transparency
					originalTransparency.Parent = v
				end

				v.Transparency = 0.9
			else
				v.Transparency = v:FindFirstChild("OriginalTransparency").Value
			end
		end
	end
end)

local WalkSpeed = Player:CreateSlider("WalkSpeed", 0.51, 16, 250, function(v)
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
end)

local JumpPower = Player:CreateSlider("JumpPower", 0.65, 50, 250, function(v)
	game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
end)

local MurderESP = Visuals:CreateToggle("Murderer ESP", 0.3, function(state)

	for i, v in pairs(game.Workspace:GetDescendants()) do
		if v.name == "MurdererESP" then
			if state then
				v.Enabled = true
			else
				v.Enabled = false
			end
		end
	end

end)

local SheriffESP = Visuals:CreateToggle("Sheriff ESP", 0.6, function(state)
	for i, v in pairs(game.Workspace:GetDescendants()) do
		if v.name == "SheriffPlayerESP" then
			if state then
				v.Enabled = true
			else
				v.Enabled = false
			end
		end
	end
end)

local MurdererESP = Instance.new("Highlight", game.Workspace)
MurdererESP.Name = "MurdererESP"
MurdererESP.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
MurdererESP.Enabled = false

local SheriffPlayerESP = Instance.new("Highlight", game.Workspace)
SheriffPlayerESP.Name = "SheriffPlayerESP"
SheriffPlayerESP.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
SheriffPlayerESP.Enabled = false
SheriffPlayerESP.FillColor = Color3.fromRGB(0, 0, 255)



local Hidden = false

uis.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.H then
		if Hidden then
			game.CoreGui.flxzzrhub.Enabled = true
			Hidden = false
		else
			game.CoreGui.flxzzrhub.Enabled = false
			Hidden = true
		end

	end
end)

while wait(5) do
	for i, v in pairs(game.Players:GetPlayers()) do
		if v.Backpack:FindFirstChild("Knife") then
			if v == nil then
				game.CoreGui.flxzzrhub.Border.Container.Misc["Murderer:"].Color.Text = "nil"
			else
				game.CoreGui.flxzzrhub.Border.Container.Misc["Murderer:"].Color.Text = v.Name
				MurdererESP.Parent = v.Character
			end
		elseif v.Backpack:FindFirstChild("Gun") then
			if v == nil then
				game.CoreGui.flxzzrhub.Border.Container.Misc["Sheriff:"].Color.Text = "nil"
			else
				game.CoreGui.flxzzrhub.Border.Container.Misc["Sheriff:"].Color.Text = v.Name
				SheriffPlayerESP.Parent = v.Character
			end

		end
	end

	if game.Workspace:FindFirstChild("GunDrop") then
		game.CoreGui.flxzzrhub.Border.Container.Misc["Status:"].Color.Text = "Dropped"
	else
		game.CoreGui.flxzzrhub.Border.Container.Misc["Status:"].Color.Text = "Not Dropped"
	end
end

return Library

local Replication = {Andromeda=script};

--[[

    𝒜𝓃𝒹𝓇𝑜𝓂𝑒𝒹𝒶 @ 𝘊𝘳𝘦𝘢𝘵𝘦𝘥 𝘣𝘺 𝘓 𝘜 𝘕 𝘈 𝘞 𝘈 𝘙 𝘌

--]]

-- Converter --
local GetClientProperty = require(script["Convert"])();

-- Services --
local Services = setmetatable({},{__index=function(self, x)return game:GetService(x)end})

local Players           : Players               = Services.Players;
local RunService        : RunService            = Services.RunService;
local TweenService      : TweenService          = Services.TweenService;

local LocalPlayer : Player; if RunService:IsClient() then LocalPlayer = Players.LocalPlayer end;

-- Custom Environment --
local Player, Character, Humanoid, HumanoidRootPart, RightArm, LeftArm, RightLeg, LeftLeg, Torso, Head;
local RW, LW, RH, LH, NK, RootJoint;

-- Initial Attributes --
Aura, AurasEnabled, IdleAnimation, IdlesEnabled, LockSwitching, WalkSpeed, FlyingWalkSpeed, JumpPower, Flying, HipHeight, OverlapAnimation = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil;

-- Humanoid State Variable --
local CurrentState;

-- Sine Variable --
local S = 0;

-- Variables --
local CF, V3, C3, CS, CSK, UD2, MT, IT = CFrame, Vector3, Color3, ColorSequence, ColorSequenceKeypoint, UDim2, math, Instance;
local CFN, CFR, V3N, C3N, C3RGB, C3HSV, UD2N, ITN, CFEA = CF.new, CF.Angles, V3.new, C3.new, C3.fromRGB, C3.fromHSV, UD2.new, IT.new, CF.fromEulerAnglesXYZ;
local rad, sin, asin, cos, acos, tan, atan, rand, floor = MT.rad, MT.sin, MT.asin, MT.cos, MT.acos, MT.tan, MT.atan, MT.random, MT.floor;

local EN = Enum;
local STYLE = EN.EasingStyle;
local DIRECTION = EN.EasingDirection;

local Linear, Quad, Quart, Quint, Back, Bounce, Elastic = STYLE.Linear, STYLE.Quad, STYLE.Quart, STYLE.Quint, STYLE.Back, STYLE.Bounce, STYLE.Elastic;
local Out, In, InOut = DIRECTION.Out, DIRECTION.In, DIRECTION.InOut;


-- Functions --
local CFA = function(X,Y,Z)
	return CFR(rad(X),rad(Y),rad(Z));
end;

local toHSV = function(RGB)
	local H,S,V = C3.toHSV(RGB);
	return {H=H,S=S,V=V};
end;

local preciseRandom = function(min, max)
	return Random.new(MT.randomseed()):NextNumber(min, max);
end;

local RayCast = function(Position,Direction,MaxDist,Ignore)
	local RayParams = RaycastParams.new()
	RayParams.IgnoreWater = true;
	RayParams.FilterDescendantsInstances = Ignore or {};
	RayParams.FilterType = Enum.RaycastFilterType.Blacklist;

	local Result = workspace:Raycast(Position,Direction.unit*(MaxDist or 69420), RayParams);
	if not (Result) then
        return false, nil, nil, nil;
    end;

	return (Result.Instance), (Result.Position), (Result.Normal), (Result.Material);
end;

local NewInst = function(className, Parent, Properties)
	assert(className, "className is not defined.");
	if not Properties then return ITN(className, Parent or nil) end;
	local temp = ITN(className, Parent or nil)
	for index, value in next, Properties do temp[index]=value end;
	return temp;
end;

-- Animation Functions --
local function Lerp(X,Y,Z) 
    return X:Lerp(Y,Z) 
end;

local function Tween(Start,End,Time,EasingStyle,EasingDirection,Repeat,Reverse,Delay) 
    assert(Start and End,"Start and End must be set.");
    Time = (Time or .1);
    EasingStyle = (EasingStyle or "Linear");
    EasingDirection = (EasingDirection or "Out");
    Repeat = (Repeat or 0);
    Reverse = (Reverse or false);
    Delay = (Delay or 0);

    local tweenInfo = TweenInfo.new(Time,Enum.EasingStyle[EasingStyle],Enum.EasingDirection[EasingDirection],Repeat,Reverse,Delay);
    local tween = TweenService:Create(Start,tweenInfo,End);
    tween:Play();
    return tween;
end;

-- Animation Offsetting --
local function cs(sine, offset)
    return cos((S + (offset or 0)) / (sine));
end;

local function sn(sine, offset)
    return sin((S + (offset or 0)) / (sine));
end;

-- Replication --
local Andromeda = script.Parent;
local AndromedaConfiguration = Andromeda:FindFirstChild"Configuration";

-- Effects --
local Resources = Andromeda["Resources"];
for x, n in next, Resources.Effects:GetChildren() do if n:IsA("BasePart") then n.Position = V3N(0,1e9,0) end end;

local Effect = function(data)
	
end;

Replication.RequestEffects = function(data)
    
end;

-- Define Attributes --
local Environment = getfenv();

for x, p in next, AndromedaConfiguration:GetAttributes() do
    Environment[x]=p;
    AndromedaConfiguration:GetAttributeChangedSignal(x):Connect(function()Environment[x]=AndromedaConfiguration:GetAttribute(x);end)
end;

-- Replication Functions --

Replication.Main = function(PL : Player)
    -- Setup Variables --
    Player = PL;
    Character = Player.Character;

    Humanoid, HumanoidRootPart  = Character:FindFirstChildOfClass("Humanoid"), Character:FindFirstChild("HumanoidRootPart");

    Head                = Character:FindFirstChild("Head");
    Torso               = Character:FindFirstChild("Torso");
    RightArm, LeftArm   = Character:FindFirstChild("Right Arm"), Character:FindFirstChild("Left Arm");
    RightLeg, LeftLeg   = Character:FindFirstChild("Right Leg"), Character:FindFirstChild("Left Leg");

    RW, LW, RH, LH, NK, RootJoint = Torso["Right Shoulder"], Torso["Left Shoulder"], Torso["Right Hip"], Torso["Left Hip"], Torso["Neck"], HumanoidRootPart["RootJoint"];

    -- Animation Variables --
    local RootCFrames = CFEA(-1.57,0,3.14)
	local NeckValues = CFN(0, 1, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0)

    -- Destroy Animator & Disable Animations --
    if Character:FindFirstChild("Animate")then Character["Animate"]:Destroy()for a,b in pairs(Character:FindFirstChildOfClass("Humanoid"):GetPlayingAnimationTracks())do b:Stop()end end

    -- Raycast Variables --
    local Grounded;
    local TouchingFloor, GroundPosition, GroundNormal;

    -- Replication Loop --
    RunService.RenderStepped:Connect(function(delta)
        -- Update Sine --
        S=(os.clock()*60)

        -- Update Arm C1 --
        RW.C1 = CFN(0,.5,0)
		LW.C1 = CFN(0,.5,0)

        -- Send out Raycast --
        TouchingFloor, GroundPosition, GroundNormal = RayCast(HumanoidRootPart.Position, -HumanoidRootPart.CFrame.upVector, 99999, {Character, Andromeda})

        -- Velocity Variables --
        local WalkingVelocity=(HumanoidRootPart.Velocity*Vector3.new(1,0,1)).magnitude
		local RootVelocity : Vector3 =  HumanoidRootPart.Velocity

        -- Define Vectors --
		local ForwardM = Humanoid.MoveDirection * HumanoidRootPart.CFrame.LookVector
		local SidewaysM = Humanoid.MoveDirection * HumanoidRootPart.CFrame.RightVector

		local Vec = {
			X = SidewaysM.X + SidewaysM.Z,
			Z = ForwardM.X + ForwardM.Z
		};
		local Divide = 1
		if (Vec.Z < 0)then
			Divide = math.clamp( - (1.25 * Vec.Z),1,2)
		end

        -- Set Footplant Values --
		Vec.Z = (Vec.Z/Divide);
		Vec.X = (Vec.X/Divide);

        -- Humanoid Properties --
        if not LockSwitching then
			if Flying then
				Humanoid.WalkSpeed = (FlyingWalkSpeed);
				Humanoid.HipHeight = (HipHeight);
			else
				Humanoid.WalkSpeed = (WalkSpeed);
				Humanoid.HipHeight = 0;
			end
			Humanoid.JumpPower = (JumpPower);
		end;

        -- Set State Value --
        Grounded = ((HumanoidRootPart.Position - (GroundPosition or V3N(0, 0, 0))).Magnitude < (3.5 + Humanoid.HipHeight)) or false;

        -- State Management --
        CurrentState = (function()
			if OverlapAnimation:sub(1,#OverlapAnimation)~="None" then
				return "Attacking"
			elseif IdlesEnabled == true and RootVelocity.Y > 4 and Grounded == false then 
				return "Jumping"
			elseif IdlesEnabled == true and RootVelocity.Y < 4 and Grounded == false then
				return "Falling"
			elseif IdlesEnabled == true and WalkingVelocity < 1 and Grounded == true then
				return "Idle"
			elseif IdlesEnabled == true and WalkingVelocity > 2 and WalkingVelocity < 22 then
				return "Walking"
			elseif IdlesEnabled == true and WalkingVelocity >= 22 then
				return "Running"
			end
		end)();

        -- Leg Animation Raycasts --
        -- massive thanks to Halivirusa (Asarii_IV)

        local RightHit, RightPosition,RightNormal = RayCast(RightLeg.Position, -RightLeg.CFrame.upVector, 2, {Character,Andromeda});
		local LeftHit, LeftPosition,RightNormal = RayCast(LeftLeg.Position, -LeftLeg.CFrame.upVector, 2, {Character,Andromeda});
		local LeftLegHeight, RightLegHeight = 0, 0
		if RightHit then RightLegHeight = (RightLeg.Position - RightPosition).Magnitude - (0.95) end
		if LeftHit then LeftLegHeight = (LeftLeg.Position - LeftPosition).Magnitude - (0.95) end

        -- Animation States --
		if CurrentState == "Falling" then
			local Alpha = .1;
			Tween(RootJoint,{C0=CFN(0,0,0)*CFA(-25,0,0)*RootCFrames},Alpha)
			Tween(NK,{C0=NeckValues*CFA(25,0,0)},Alpha)
			Tween(RW,{C0=CFN(1.4,0.5,0.1)*CFA(25,-11,34)},Alpha)
			Tween(LW,{C0=CFN(-1.5,0.5,0.1)*CFA(21.2,18.9,-23.4)},Alpha)
			Tween(RH,{C0=CFN(0.9,0,-0.9)*CFA(2.7,-20.3,15)*CFA(0,90,0)},Alpha)
			Tween(LH,{C0=CFN(-0.9,-0.3,-0.8)*CFA(-39.6,6.4,-7.7)*CFA(0,-90,0)},Alpha)
		elseif CurrentState == "Jumping" then
			local Alpha = .1;
			Tween(RootJoint,{C0=CFN(0,0,0)*CFA(20,0,0)*RootCFrames},Alpha)
			Tween(NK,{C0=NeckValues*CFA(-20,0,0)},Alpha)
			Tween(RW,{C0=CFN(1.5,0.4,0.1)*CFA(-35,0,20)},Alpha)
			Tween(LW,{C0=CFN(-1.6,0.4,0.1)*CFA(-35,0,-20)},Alpha)
			Tween(RH,{C0=CFN(1.1,-0.6,-0.9)*CFA(-35,-25,0)*CFA(0,90,0)},Alpha)
			Tween(LH,{C0=CFN(-0.9,-0.7,-0.3)*CFA(-39.6,6.4,-7.7)*CFA(0,-90,0)},Alpha)
		elseif CurrentState == "Idle" then
				local Alpha = .1;
				Tween(RootJoint,{C0=CFN(0,0 + .15 * cos(S/23),0)*CFA(-5 - 3 * sin(S/23),0,0)*RootCFrames},Alpha)
				Tween(NK,{C0=NeckValues*CFA(8 - 6 * sin((S+32)/23),0,0)},Alpha)
				Tween(RW,{C0=CFN(1.5,0.5 + .08 * cos(S/23),-0.1)*CFA(-1.3 + 5 * cos(S/46),14.9 - 4 * sin(S/46),10.2 + 5 * cos(S/72))},Alpha)
				Tween(LW,{C0=CFN(-1.5,0.5 + .08 * cos(S/23),0)*CFA(-0.9 - 4 * cos((S+12)/46),-4.9 * cos(S/52),-10 - 5 * cos(S/72))},Alpha)
				Tween(RH,{C0=CFN(1,-0.9 - .15 * cos(S/23) - RightLegHeight,0 - 0.03 * sin(S/23))*CFA(5 + 3 * sin(S/23),-10,5)*CFA(0,90,0)},Alpha)
				Tween(LH,{C0=CFN(-1,-1 - .15 * cos(S/23) - LeftLegHeight,0 - 0.03 * sin(S/23))*CFA(5 + 3 * sin(S/23),10,-5)*CFA(0,-90,0)},Alpha)
		elseif CurrentState == "Walking" then
			if Flying then
				local Alpha = .1;
				Tween(RootJoint,{C0=CFN(0 + .65 * Vec.X,0 + .4 * cos(S/32),0 - .65 * Vec.Z)*CFA(0 - 10 * Vec.Z + 10 * (-Vec.Z) + 5 * cos(S/52),0 - 4 * sin(S/52),(0 - 7.5 * Vec.X) + 4 * cos((S+32)/64))*RootCFrames},Alpha)
				Tween(NK,{C0=NeckValues*CFA(0 - 5 * Vec.Z + 10 * (-Vec.Z) - 3 * cos(S/52),0 + 7.5 * Vec.X,0)},Alpha)
				Tween(RW,{C0=CFN(1.5,0.4,0.2)*CFA(-18.4 * Vec.Z - 5 * cos(S/62),-18.3,21 + 9 * cos(S/72))},Alpha)
				Tween(LW,{C0=CFN(-1.5,0.5,0.2)*CFA(-23.2 * Vec.Z + 7 * sin(S/47),14.3,-20.7 - 6 * sin(S/62))},Alpha)
				Tween(RH,{C0=CFN(1,-0.3,-0.8 + math.clamp(0.2 * (-Vec.Z),0,0.2))*CFA(-19.1 - 10 * Vec.Z - 4 * sin(S/68),-28.5 - 4 * cos((S+32)/63),17.1 + 5 * sin(S/72))*CFA(0,90,0)},Alpha)
				Tween(LH,{C0=CFN(-1,-0.7,-0.2 * Vec.Z)*CFA(-18.5 - 10 * Vec.Z + 3 * cos(S/71),15.3 + 5 * sin(S/71),-8.6 - 4 * cos(S/65))*CFA(0,-90,0)},Alpha)
			else
				local Alpha = .1;
				Tween(RootJoint,{C0=CFN(0 + .65 * Vec.X,.1-.15*cos(S/6),0 - .65 * Vec.Z)*CFR(rad(-15*Vec.Z+5*cos(S/6)),rad(-10*sin(S/12)),rad(-5*Vec.X))*RootCFrames},Alpha)
				Tween(LH,{C0=CFN(-1,-1+.26*sin(S/12),-.04-.5*sin(S/12)*Vec.Z)*CFR(rad(50*math.cos((S+37)/12)*Vec.Z+10*sin(S/12)*Vec.X),rad(-2*cos(S/12)),rad(-13*cos(S/12)*Vec.X))*CFR(rad(0),rad(-90),rad(0))},Alpha)
				Tween(RH,{C0=CFN(1,-1-.26*sin(S/12),-.04+.5*sin(S/12)*Vec.Z)*CFR(rad(-50*math.cos((S+37)/12)*Vec.Z-10*sin(S/12)*Vec.X),rad(2*cos(S/12)),rad(13*cos(S/12)*Vec.X))*CFR(rad(0),rad(90),rad(0))},Alpha)
				Tween(LW,{C0=CFN(-1.5,0.5,0)*CFR(rad(80*cos(S/12)*Vec.Z),rad(0),rad(0))},Alpha)
				Tween(RW,{C0=CFN(1.5,0.5,0)*CFR(rad(-80*cos(S/12)*Vec.Z),rad(0),rad(0))},Alpha)
				Tween(NK,{C0=NeckValues*CFN(0,0,0)*CFR(rad(-4+3*sin(S/6)),rad(0),rad(10*sin(S/12)-40*Vec.X))},Alpha)
			end
		elseif CurrentState == "Running" then
			if Flying then
				local Alpha = .1;
				Tween(RootJoint,{C0=CFN(0 + 1.5 * Vec.X,0 + .4 * cos(S/32),0 - 1.5 * Vec.Z)*CFA(0 - 20 * Vec.Z + 20 * (-Vec.Z) + 5 * cos(S/52),0 - 4 * sin(S/52),(0 - 15 * Vec.X) + 4 * cos((S+32)/64))*RootCFrames},Alpha)
				Tween(NK,{C0=NeckValues*CFA(0 - 20 * Vec.Z + 20 * (-Vec.Z) - 3 * cos(S/52),0 + 15 * Vec.X,0)},Alpha)
				Tween(RW,{C0=CFN(1.5,0.4,0.2)*CFA(-18.4 * Vec.Z - 5 * cos(S/62),-18.3,21 + 9 * cos(S/72))},Alpha)
				Tween(LW,{C0=CFN(-1.5,0.5,0.2)*CFA(-23.2 * Vec.Z + 7 * sin(S/47),14.3,-20.7 - 6 * sin(S/62))},Alpha)
				Tween(RH,{C0=CFN(1,-0.3,-0.8 + math.clamp(0.2 * (-Vec.Z),0,0.2))*CFA(-19.1 - 10 * Vec.Z - 4 * sin(S/68),-28.5 - 4 * cos((S+32)/63),17.1 + 5 * sin(S/72))*CFA(0,90,0)},Alpha)
				Tween(LH,{C0=CFN(-1,-0.7,-0.2 * Vec.Z)*CFA(-18.5 - 10 * Vec.Z + 3 * cos(S/71),15.3 + 5 * sin(S/71),-8.6 - 4 * cos(S/65))*CFA(0,-90,0)},Alpha)
			else
				local Alpha = .1;
				Tween(RootJoint,{C0=CFN(0 + .65 * Vec.X,.11-.15*cos(S/3),0 - .65 * Vec.Z)*CFR(rad(-25*Vec.Z+5*cos(S/3)),rad(-10*sin(S/6)),rad(-13*Vec.X))*RootCFrames},Alpha)
				Tween(LH,{C0=CFN(-1,-1-.46*sin(S/6),-.07+.5*sin(S/6)*Vec.Z)*CFR(rad(100*math.cos((S+37)/6)*Vec.Z+10*sin(S/6)*Vec.X),rad(-2*cos(S/6)),rad(30*cos(S/6)*Vec.X))*CFR(rad(0),rad(-90),rad(0))},Alpha)
				Tween(RH,{C0=CFN(1,-1+.46*sin(S/6),-.07-.5*sin(S/6)*Vec.Z)*CFR(rad(-100*math.cos((S+37)/6)*Vec.Z-10*sin(S/6)*Vec.X),rad(2*cos(S/6)),rad(-30*cos(S/6)*Vec.X))*CFR(rad(0),rad(90),rad(0))},Alpha)
				Tween(LW,{C0=CFN(-1.5,0.5,0)*CFR(rad(-160*cos(S/6)*Vec.Z+30*math.sin((S+12)/6)*Vec.Z),rad(0),rad(0))},Alpha)
				Tween(RW,{C0=CFN(1.5,0.5,0)*CFR(rad(160*cos(S/6)*Vec.Z-30*math.sin((S+12)/6)*Vec.Z),rad(0),rad(0))},Alpha)
				Tween(NK,{C0=NeckValues*CFN(0,0,0)*CFR(rad(-8+5*sin(S/3)),rad(0),rad(10*sin(S/6)-40*Vec.X))},Alpha)
			end
		elseif CurrentState == "Attacking" then

		end

    end);
end;

-- Replication Dependencies --
local Client = script:FindFirstChild("ClientReplication")

Replication.Initialize = function(self, Player : Player, Identifier : string)
    if RunService:IsClient() then return end; -- Initialize must be ran on the server.
    
    -- Setup Replication --
    local function initialize (Player : Player)
        local PlayerGui = Player:WaitForChild("PlayerGui")

        local Replicator = NewInst("ScreenGui", PlayerGui, {Name = Identifier,ResetOnSpawn = false});
        local ClientReplication = Client:Clone();
        ClientReplication.Parent = Replicator;
        ClientReplication.Disabled = false;
    end;

    -- Initialize CR --
    for _, key in next, Players:GetPlayers() do initialize(key) end;
    Players.PlayerAdded:Connect(initialize);
    
    -- Destroy Replication --
    local Character = Player.Character or Player.CharacterAdded:Wait();
    local Humanoid = Character:FindFirstChildOfClass("Humanoid");

    local function destroyReplication()
        if not Character or not Player or Character.Parent == nil or Player.Parent == nil or Humanoid.Health <= 0 then
			for _, x in next, Players:GetDescendants() do if x.Name:match(Identifier) then x:Destroy()end end;
			if workspace:FindFirstChild(Identifier) then workspace:FindFirstChild(Identifier):Destroy() end;
		end;
    end;

    -- Setup Connections --
    Character.AncestryChanged:Connect(destroyReplication);
    Character.Destroying:Connect(destroyReplication);
    Player.AncestryChanged:Connect(destroyReplication);
    Player.Destroying:Connect(destroyReplication);
    Humanoid.Died:Connect(destroyReplication);
end;

return Replication;
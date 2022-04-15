--[[

    𝒜𝓃𝒹𝓇𝑜𝓂𝑒𝒹𝒶 @ 𝘊𝘳𝘦𝘢𝘵𝘦𝘥 𝘣𝘺 𝘓 𝘜 𝘕 𝘈 𝘞 𝘈 𝘙 𝘌

    -- >> DO NOT DISTRIBUTE << --


    How many times am I gonna have to rewrite the entire script just because I don't like it.

--]]

local CustomIdentifier = "%s's Andromeda Replication" -- [%s] ~ PLAYER NAME

local CustomAttributes = {
	-- Defaults --
	["Aura"] = "Default";
	["AurasEnabled"] = true;
	["IdleAnimation"] = "Default";
	["IdlesEnabled"] = true;
	["LockSwitching"] = false;

	["WalkSpeed"] = 16; ["FlyingWalkSpeed"] = 40;
	["JumpPower"] = 50;

	["Flying"] = false;
	["HipHeight"] = 5;

	["OverlapAnimation"] = "None";

	-- Custom --
};

-- Services --
local Services = setmetatable({},{__index=function(self, index)return game:GetService(index)end});

local Players       : Players       = Services.Players;
local RunService    : RunService    = Services.RunService;

-- Initials --
local Player = (Players:GetPlayerFromCharacter(script.Parent) or script:FindFirstAncestorOfClass("Player"));
script.Parent = Player.PlayerGui;

local Character = (Player.Character or Player.CharacterAdded:Wait());

-- Body Parts --
local Humanoid = Character:FindFirstChildOfClass("Humanoid");
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

local Head = Character["Head"];
local Torso = Character["Torso"];

local RightArm, LeftArm, RightLeg, LeftLeg = Character["Right Arm"], Character["Left Arm"], Character["Right Leg"], Character["Left Leg"];

-- Joints --
local RW, LW, RH, LH, NK, RootJoint = Torso["Right Shoulder"], Torso["Left Shoulder"], Torso["Right Hip"], Torso["Left Hip"], Torso["Neck"], HumanoidRootPart["RootJoint"];

-- Variables --
local CF, V3, C3, CS, CSK, UD2, MT, IT = CFrame, Vector3, Color3, ColorSequence, ColorSequenceKeypoint, UDim2, math, Instance;
local CFN, CFR, V3N, C3N, C3RGB, C3HSV, UD2N, ITN = CF.new, CF.Angles, V3.new, C3.new, C3.fromRGB, C3.fromHSV, UD2.new, IT.new;
local rad, sin, asin, cos, acos, tan, atan, rand, floor = MT.rad, MT.sin, MT.asin, MT.cos, MT.acos, MT.tan, MT.atan, MT.random, MT.floor;

local EN = Enum;
local STYLE = EN.EasingStyle;
local DIRECTION = EN.EasingDirection;

local Linear, Quad, Quart, Quint, Back, Bounce, Elastic = STYLE.Linear, STYLE.Quad, STYLE.Quart, STYLE.Quint, STYLE.Back, STYLE.Bounce, STYLE.Elastic;
local Out, In, InOut = DIRECTION.Out, DIRECTION.In, DIRECTION.InOut;

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

-- Replication --
local AndromedaReplication = script["AndromedaReplication"];
local AndromedaConfiguration = AndromedaReplication["Configuration"];

-- Create Vitals --
local Requests = NewInst("RemoteEvent", AndromedaReplication, {
	Name = "Requests",
});

-- Effects & Hitbox Folders --
NewInst("Folder", AndromedaReplication, {Name = "Effects"});
NewInst("Folder", AndromedaReplication, {Name = "Hitboxes"});

-- Assign Identifier and Parent --
CustomIdentifier = CustomIdentifier:format(Player.Name)

AndromedaReplication.Name = CustomIdentifier;
AndromedaReplication.Parent = workspace;

-- Assign Attributes --
for x, p in next, CustomAttributes do AndromedaConfiguration:SetAttribute(x, p) end;

-- Configuration Functions --

local function GetAttribute(attributeName : string)
	return AndromedaConfiguration:GetAttribute(attributeName) or nil;
end;

local function UpdateConfiguration(data)
	for x, p in next, data do AndromedaConfiguration:SetAttribute(x, p) end;
end;

-- Identify Module --
local Andromeda = require(AndromedaReplication["Andromeda"]);

local function clientRun(Requester : Player) -- ran automatically when replication is requested from a client
	Requests:FireClient(Requester, "Main", Player);
end;

local function RequestEffects ( data )
    Requests:FireAllClients("RequestEffects", data);
end;

Requests.OnServerEvent:Connect(function(Requester : Player, Request : string, ...)
	-- Replication Initialization --
	if Request == "InitializeReplication" then clientRun(Requester)end;
end);

Andromeda:Initialize(Player, CustomIdentifier); -- initialize replication.
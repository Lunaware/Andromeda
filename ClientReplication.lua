local Identifier = script:FindFirstAncestorOfClass("ScreenGui").Name;
local Andromeda = workspace:FindFirstChild(Identifier);
if not Andromeda then error("Couldn't find Andromeda Folder inside of workspace") end;

local Replication = require(Andromeda:FindFirstChild"Andromeda");
local Requests = Andromeda:FindFirstChild"Requests";

-- handle server requests --
Requests.OnClientEvent:Connect(function(event, ...)
    if Replication[event] then
        Replication[event](...);
    end;
end)

Requests:FireServer("InitializeReplication"); -- tells the server the client is loaded and ready to recieve requests.
--!strict
local RunService = game:GetService("RunService")

local runContext: "server" | "client" = if RunService:IsServer() then "server" else "client"
local currentId = 11111
local remotes = Instance.new("Folder")
remotes.Name = "remotes"
remotes.Parent = script

type event = {
	sendClient: (client: Player, ...any) -> (),
	sendAllClients: (...any) -> (),
	sendClientList: (list: {Player}, ...any) -> (),
	sendServer: (...any) -> (),
	listen: (callback: (...any) -> ()) -> (),
	once: (callback: (...any) -> ()) -> (),
	wait: () -> (...any),
}

local Line = {}

local function buildEvent(remote): event
	local eventExport = {} :: event
	if runContext == "server" then

		function eventExport.sendClient(client: Player, ...: any)
			remote:FireClient(client, ...)
		end
		
		function eventExport.sendAllClients(...: any)
			remote:FireAllClients(...)
		end

		function eventExport.sendClientList(list: {Player}, ...: any)
			for _, client in list do
				remote:FireClient(client, ...)
			end
		end

		function eventExport.listen(callback: (...any) -> ())
			remote.OnServerEvent:Connect(callback)
		end

		function eventExport.once(callback: (...any) -> ())
			remote.OnServerEvent:Once(callback)
		end

		function eventExport.wait()
			return remote.OnServerEvent:Wait()
		end

	elseif runContext == "client" then

		function eventExport.sendServer(...: any)
			remote:FireServer(...)
		end

		function eventExport.listen(callback: (...any) -> ())
			remote.OnClientEvent:Connect(callback)
		end

		function eventExport.once(callback: (...any) -> ())
			remote.OnClientEvent:Once(callback)
		end

		function eventExport.wait()
			return remote.OnClientEvent:Wait()
		end
		
	end

	return eventExport
end

function Line.event(): event
	currentId += 1
	local remote: RemoteEvent

	if runContext == "server" then
		remote = Instance.new("RemoteEvent")
		remote.Name = "line" .. tostring(currentId)
		remote.Parent = remotes
		return buildEvent(remote)
	else
		remote = remotes:WaitForChild("line" .. tostring(currentId))
		return buildEvent(remote)
	end
end

return Line
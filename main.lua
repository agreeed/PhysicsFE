local module = {}

module.Parts = {}
function module.Parts:DisableCollision(part1, part2)
	local NoCollision = Instance.new("NoCollisionConstraint")
	NoCollison.Part0 = part1
	NoCollison.Part1 = part2
	return NoCollision
end

module.Network = {}
module.Network.NetworkAccess = function()
	settings().Physics.AllowSleep = false
	while game:GetService("RunService").RenderStepped:Wait() do
		for _, Players in next, game:GetService("Players"):GetPlayers() do
			if Players ~= game:GetService("Players").LocalPlayer then
				Players.MaximumSimulationRadius = 0
				sethiddenproperty(Players, "SimulationRadius", 0)
			end
		end
		game:GetService("Players").LocalPlayer.MaximumSimulationRadius = math.pow(math.huge,math.huge)
		setsimulationradius(math.huge)
	end
end

return module

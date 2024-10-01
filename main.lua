local module = {}

module.API = {}
function module.API:AbstractPhysProp(density, friction, elasticity, wfriction, welasticity)
	local c = {}
	
	local physprop = getmetatable(c)
	if typeof(density) == "PhysicalProperties" then
		physprop.D = density.Density
		physprop.F = density.Friction
		physprop.E = density.Elasticity
		physprop.WF = density.FrictionWeight
		physprop.WE = density.ElasticityWeight
	elseif typeof(density) == "number" then
		physprop.D = density
		physprop.F = friction
		physprop.E = elasticity
		physprop.WF = wfriction
		physprop.WE = welasticity
	else
		assert(false, "Invalid argument #1 (expected number got ".. type(density).. ")")
	end
	assert(type(physprop.D) == "number", "Invalid argument #1 (expected number got ".. type(physprop.D).. ")")
	assert(type(physprop.F) == "number", "Invalid argument #2 (expected number got ".. type(physprop.F).. ")")
	assert(type(physprop.E) == "number", "Invalid argument #3 (expected number got ".. type(physprop.E).. ")")
	assert(type(physprop.WF) == "number", "Invalid argument #4 (expected number got ".. type(physprop.WF).. ")")
	assert(type(physprop.WE) == "number", "Invalid argument #5 (expected number got ".. type(physprop.WE).. ")")
	
	physprop.__index = function(self, index)
		assert(type(index) == "string", "Invalid index (expected string got ".. type(index).. ")")
		local lookup = {
			D  = self.D,  Density          = self.D,
			F  = self.F,  Friction         = self.F,
			E  = self.E,  Elasticity       = self.E,
			WF = self.WF, FrictionWeight   = self.WF,
			WE = self.WE, ElasticityWeight = self.WE
		}
		assert(lookup[index], "AbstractPhysProp has no property ".. index)
		return lookup[index]
	end
	physprop.__newindex = function(self, index, value)
		if index == "D" or index == "Density" then
			assert(type(value) == type(self.D), "Invalid value (expected ".. type(self.D).. " got ".. type(value).. ")")
			self.D = value
		elseif index == "F" or index == "Friction" then
			assert(type(value) == type(self.F), "Invalid value (expected ".. type(self.F).. " got ".. type(value).. ")")
			self.F = value
		elseif index == "E" or index == "Elasticity" then
			assert(type(value) == type(self.E), "Invalid value (expected ".. type(self.E).. " got ".. type(value).. ")")
			self.E = value
		elseif index == "WF" or index == "FrictionWeight" then
			assert(type(value) == type(self.WF), "Invalid value (expected ".. type(self.WF).. " got ".. type(value).. ")")
			self.WF = value
		elseif index == "WE" or index == "ElasticityWeight" then
			assert(type(value) == type(self.WE), "Invalid value (expected ".. type(self.WE).. " got ".. type(value).. ")")
			self.WE = value
		else
			assert(false, "AbstractPhysProp has no property ".. index)
		end
	end
	physprop.__metatable = "This metatable is locked!"
	
	setmetatable(c, physprop)
	return c
end

module.Parts = {}
function module.Parts:DisableCollision(part1, part2)
	local NoCollision = Instance.new("NoCollisionConstraint", part1)
	NoCollision.Part0 = part1
	NoCollision.Part1 = part2
	return NoCollision
end
function module.Parts:SetMass(part, mass)
	local density = part.Mass / mass
	if density < 0.001 then
		part.Massless = true
	elseif density >= 0.001
		local o = module.API:AbstractPhysProp(part.CurrentPhysicalProperties)
		local n = PhysicalProperties.new(density, o.F, o.E, o.WF, o.WE)
		part.CustomPhysicalProperties = n
	end
	
	return part1.AssemblyMass
end

module.Network = {}
module.Network.NetworkAccess = function()
	settings().Physics.AllowSleep = false
	while game:GetService("RunService").RenderStepped:Wait() do
		for _, Players in next, game:GetService("Players"):GetPlayers() do
			if Players ~= game:GetService("Players").LocalPlayer then
				Players.MaximumSimulationRadius = 0
				if sethiddenproperty then
					sethiddenproperty(Players, "SimulationRadius", 0)
				end
			end
		end
		game:GetService("Players").LocalPlayer.MaximumSimulationRadius = math.pow(math.huge,math.huge)
		setsimulationradius(math.huge)
	end
end

return module

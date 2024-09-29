local module = {}

module.Parts = {}
function module.Parts:DisableCollision(part1, part2)
	local NoCollision = Instance.new("NoCollisionConstraint")
	NoCollison.Part0 = part1
	NoCollison.Part1 = part2
	return NoCollision
end

return module

--- Filter Mod File Use Overview:
--- =======================================
--- TechTree.xml: Set up ui in tech web screen (more filter pulldowns, moved search bar)
--- TechFilters.xml: Add <TechFilters> rows to be added into filter pulldowns.
--- TechFilterText.xml: Set text labels for filter pulldown entries (<TechFilters>).
--- TechFilterFuntions.lua: Add sorting logic to each filter
--- TechTree.lua: Add support for multiple filter pulldowns, define sorting into different pulldowns by hard coding based on <TechFilters>row.ID 
---			(the filter number), set filter pulldowns to clear if a different  pulldown is pressed, set default text for filter pulldowns, etc.
--- ========================================
---x filter mod: my mod comments are marked with "---" to distinguish them from Firaxis comments
---x filter mod: my changes are marked with "---x" for modders searching through the file for my changes

---x renamed from "TechFilters" to "TechFiltersMOD" to fix crash when switching from single player game to a game with this mod enabled or vice versa
--- error something like structure "TechFilters" already exists
hstructure TechFiltersMOD
	TECHFILTER_FOOD : ifunction
	TECHFILTER_SCIENCE : ifunction
	TECHFILTER_PRODUCTION : ifunction
	TECHFILTER_CULTURE : ifunction
	TECHFILTER_ENERGY : ifunction
	TECHFILTER_HEALTH : ifunction
	TECHFILTER_PURITY : ifunction
	TECHFILTER_HARMONY : ifunction
	TECHFILTER_SUPREMACY : ifunction
	TECHFILTER_IMPROVEMENTS : ifunction
	TECHFILTER_VICTORIES : ifunction
	TECHFILTER_WONDERS : ifunction---x Added all the filters below here (including this one)
	TECHFILTER_MILITARY : ifunction
	TECHFILTER_ORBITAL : ifunction
	TECHFILTER_ALGAE : ifunction
	TECHFILTER_BASALT : ifunction
	TECHFILTER_CHITIN : ifunction
	TECHFILTER_COPPER : ifunction
	TECHFILTER_CORAL : ifunction
	TECHFILTER_FIBER : ifunction
	TECHFILTER_FRUIT : ifunction
	TECHFILTER_FUNGUS : ifunction
	TECHFILTER_GOLD : ifunction
	TECHFILTER_RESILIN : ifunction
	TECHFILTER_SILICA : ifunction
	TECHFILTER_TUBERS : ifunction
	TECHFILTER_FIRAXITE : ifunction
	TECHFILTER_FLOATSTONE : ifunction
	TECHFILTER_GEOTHERMAL : ifunction
	TECHFILTER_PETROLEUM : ifunction
	TECHFILTER_TITANIUM : ifunction
	TECHFILTER_XENOMASS : ifunction
	TECHFILTER_ACADEMY : ifunction
	TECHFILTER_ARRAY : ifunction
	TECHFILTER_BIOWELL : ifunction
	TECHFILTER_DOME : ifunction
	TECHFILTER_FARM : ifunction
	TECHFILTER_GENERATOR : ifunction
	TECHFILTER_MANUFACTORY : ifunction
	TECHFILTER_MINE : ifunction
	TECHFILTER_NODE : ifunction
	TECHFILTER_PADDOCK : ifunction
	TECHFILTER_PLANTATION : ifunction
	TECHFILTER_QUARRY : ifunction
	TECHFILTER_TERRASCAPE: ifunction
end

g_TechFilters = hmake TechFiltersMOD{};---x also renamed, added'MOD' part.

---x THEN JUST CREATE THE FILTERING CRITERIA BELOW, MODELED AFTER THE EXISTING FILTERS. 
--- these filters all use helper functions that I added at the bottom of the file.
--- basically, these will be called somewhere else when the (filter is clicked) by each technology (which passes itself in as the 'techInfo' parameter.)
--- if true is returned, then that technology will be highlighted by the filter.
g_TechFilters.TECHFILTER_WONDERS = function(techInfo)
	if CheckWonder(techInfo) then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_MILITARY = function(techInfo)
	if CheckMilitaryUnits(techInfo) then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_ORBITAL = function(techInfo)
	if CheckOrbitalUnits(techInfo) then
		return true;
	end

	return false;
end
---Basic Resources
g_TechFilters.TECHFILTER_ALGAE = function(techInfo)
	if BasicResourceFilter(techInfo, "RESOURCE_ALGAE") then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_BASALT = function(techInfo)
	if BasicResourceFilter(techInfo, "RESOURCE_BASALT") then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_CHITIN = function(techInfo)
	if BasicResourceFilter(techInfo, "RESOURCE_CHITIN") then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_COPPER = function(techInfo)
	if BasicResourceFilter(techInfo, "RESOURCE_COPPER") then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_CORAL = function(techInfo)
	if BasicResourceFilter(techInfo, "RESOURCE_CORAL") then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_FIBER = function(techInfo)
	if BasicResourceFilter(techInfo, "RESOURCE_FIBER") then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_FRUIT = function(techInfo)
	if BasicResourceFilter(techInfo, "RESOURCE_FRUIT") then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_FUNGUS = function(techInfo)
	if BasicResourceFilter(techInfo, "RESOURCE_FUNGUS") then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_GOLD = function(techInfo)
	if BasicResourceFilter(techInfo, "RESOURCE_GOLD") then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_RESILIN = function(techInfo)
	if BasicResourceFilter(techInfo, "RESOURCE_RESILIN") then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_SILICA = function(techInfo)
	if BasicResourceFilter(techInfo, "RESOURCE_SILICA") then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_TUBERS = function(techInfo)
	if BasicResourceFilter(techInfo, "RESOURCE_TUBERS") then
		return true;
	end

	return false;
end
---Strategic Resources
---searches for techs that reveal it, unlock the improvement that adds the resource to your pool, any techs that contain buildings or units that 
---require or are upgraded by the resource (from pool or improved tile), 
---and also those that upgrade tile improvement of the type used by the resource (eg: Mines for Titanium, geothermal well, and xenomass well)
g_TechFilters.TECHFILTER_FIRAXITE = function(techInfo)
	if StrategicResourceFilter(techInfo, "RESOURCE_FIRAXITE", false, true) then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_FLOATSTONE = function(techInfo)
	if StrategicResourceFilter(techInfo, "RESOURCE_FLOAT_STONE", false, true) then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_GEOTHERMAL = function(techInfo)
	if StrategicResourceFilter(techInfo, "RESOURCE_GEOTHERMAL_ENERGY", true, true) then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_PETROLEUM = function(techInfo)
	if StrategicResourceFilter(techInfo, "RESOURCE_PETROLEUM", true, true) then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_TITANIUM = function(techInfo)
	if StrategicResourceFilter(techInfo, "RESOURCE_TITANIUM", true, true) then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_XENOMASS = function(techInfo)
	if StrategicResourceFilter(techInfo, "RESOURCE_XENOMASS", false, true) then
		return true;
	end

	return false;
end
---Improvements
---Searches for techs that globally increase the yield of the type of improvement selected and techs that unlock the improvement for building
g_TechFilters.TECHFILTER_ACADEMY = function(techInfo)
	local improvementType : string = "IMPROVEMENT_ACADEMY";

	if CheckResourceBuildUnlocked(techInfo, improvementType) then
		return true;
	end

	if CheckImprovementUpgrade(techInfo, improvementType) then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_ARRAY = function(techInfo)
	local improvementType : string = "IMPROVEMENT_ARRAY";

	if CheckResourceBuildUnlocked(techInfo, improvementType) then
		return true;
	end

	if CheckImprovementUpgrade(techInfo, improvementType) then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_BIOWELL = function(techInfo)
	local improvementType : string = "IMPROVEMENT_BIOWELL";

	if CheckResourceBuildUnlocked(techInfo, improvementType) then
		return true;
	end

	if CheckImprovementUpgrade(techInfo, improvementType) then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_DOME = function(techInfo)
	local improvementType : string = "IMPROVEMENT_DOME";

	if CheckResourceBuildUnlocked(techInfo, improvementType) then
		return true;
	end

	if CheckImprovementUpgrade(techInfo, improvementType) then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_FARM = function(techInfo)
	local improvementType : string = "IMPROVEMENT_FARM";

	if CheckResourceBuildUnlocked(techInfo, improvementType) then
		return true;
	end

	if CheckImprovementUpgrade(techInfo, improvementType) then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_GENERATOR = function(techInfo)
	local improvementType : string = "IMPROVEMENT_GENERATOR";

	if CheckResourceBuildUnlocked(techInfo, improvementType) then
		return true;
	end

	if CheckImprovementUpgrade(techInfo, improvementType) then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_MANUFACTORY = function(techInfo)
	local improvementType : string = "IMPROVEMENT_MANUFACTORY";

	if CheckResourceBuildUnlocked(techInfo, improvementType) then
		return true;
	end

	if CheckImprovementUpgrade(techInfo, improvementType) then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_MINE = function(techInfo)
	local improvementType : string = "IMPROVEMENT_MINE";

	if CheckResourceBuildUnlocked(techInfo, improvementType) then
		return true;
	end

	if CheckImprovementUpgrade(techInfo, improvementType) then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_NODE = function(techInfo)
	local improvementType : string = "IMPROVEMENT_NODE";

	if CheckResourceBuildUnlocked(techInfo, improvementType) then
		return true;
	end

	if CheckImprovementUpgrade(techInfo, improvementType) then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_PADDOCK = function(techInfo)
	local improvementType : string = "IMPROVEMENT_PADDOCK";

	if CheckResourceBuildUnlocked(techInfo, improvementType) then
		return true;
	end

	if CheckImprovementUpgrade(techInfo, improvementType) then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_PLANTATION = function(techInfo)
	local improvementType : string = "IMPROVEMENT_PLANTATION";

	if CheckResourceBuildUnlocked(techInfo, improvementType) then
		return true;
	end

	if CheckImprovementUpgrade(techInfo, improvementType) then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_QUARRY = function(techInfo)
	local improvementType : string = "IMPROVEMENT_QUARRY";

	if CheckResourceBuildUnlocked(techInfo, improvementType) then
		return true;
	end

	if CheckImprovementUpgrade(techInfo, improvementType) then
		return true;
	end

	return false;
end
g_TechFilters.TECHFILTER_TERRASCAPE = function(techInfo)
	local improvementType : string = "IMPROVEMENT_TERRASCAPE";

	if CheckResourceBuildUnlocked(techInfo, improvementType) then
		return true;
	end

	if CheckImprovementUpgrade(techInfo, improvementType) then
		return true;
	end

	return false;
end
---x END FILTER MOD FILTERS

-- Food Filter
g_TechFilters.TECHFILTER_FOOD = function(techInfo)
	local yieldType : string = "YIELD_FOOD";

	if CheckUnlocksForYield(techInfo, yieldType) then
		return true;
	end

	return false;
end

-- Science Filter
g_TechFilters.TECHFILTER_SCIENCE = function(techInfo)
	local yieldType : string = "YIELD_SCIENCE";

	if CheckUnlocksForYield(techInfo, yieldType) then
		return true;
	end

	return false;
end

-- Production Filter
g_TechFilters.TECHFILTER_PRODUCTION = function(techInfo)
	local yieldType : string = "YIELD_PRODUCTION";

	if CheckUnlocksForYield(techInfo, yieldType) then
		return true;
	end

	return false;
end

-- Culture Filter
g_TechFilters.TECHFILTER_CULTURE = function(techInfo)
	local yieldType : string = "YIELD_CULTURE";

	if CheckUnlocksForYield(techInfo, yieldType) then
		return true;
	end

	return false;
end

-- Energy Filter
g_TechFilters.TECHFILTER_ENERGY = function(techInfo)
	local yieldType : string = "YIELD_ENERGY";

	if CheckUnlocksForYield(techInfo, yieldType) then
		return true;
	end

	return false;
end

-- Health Filter
g_TechFilters.TECHFILTER_HEALTH = function(techInfo)
	if CheckUnlocksForHealth(techInfo) then
		return true;
	end

	return false;
end

-- Purity Filter
g_TechFilters.TECHFILTER_PURITY = function(techInfo)
	local affinityType : string = "AFFINITY_TYPE_PURITY";

	if CheckAffinity(techInfo, affinityType) then
		return true;
	end

	return false;
end

--Harmony Filter
g_TechFilters.TECHFILTER_HARMONY = function(techInfo)
	local affinityType : string = "AFFINITY_TYPE_HARMONY";

	if CheckAffinity(techInfo, affinityType) then
		return true;
	end

	return false;
end

-- Supremacy Filter
g_TechFilters.TECHFILTER_SUPREMACY = function(techInfo)
	local affinityType : string = "AFFINITY_TYPE_SUPREMACY";

	if CheckAffinity(techInfo, affinityType) then
		return true;
	end

	return false;
end

-- Improvements Filter
g_TechFilters.TECHFILTER_IMPROVEMENTS = function(techInfo)
	-- Improvements
	local condition = "PrereqTech = '" .. techInfo.Type .. "' and ImprovementType IS NOT NULL";
	for row in GameInfo.Builds(condition) do
		if row ~= nil then
			return true;
		end
	end

	return false;
end

-- Victory Conditions Filter
g_TechFilters.TECHFILTER_VICTORIES = function(techInfo)
	-- At present there's no better way than to do this manually, because
	-- each Victory quest can require techs for one of several reasons:
	--		*	The victory requires building a unit or building that is unlocked by the tech	
	--		*	The victory requires the tech itself to advance the quest

	-- Contact Victory
	if (Game.IsVictoryValid(GameInfo.Victories.VICTORY_CONTACT)) then
		-- Transcendental Equation
		if (techInfo.Type == "TECH_TRANSCENDENTAL_MATH") then
			return true;
		end
		-- Deep Space Telescope prereq
		if (techInfo.Type == GameInfo.Units.UNIT_DEEP_SPACE_TELESCOPE.PrereqTech) then
			return true;
		end
	end

	-- Promised Land Victory
	if (Game.IsVictoryValid(GameInfo.Victories.VICTORY_PROMISED_LAND)) then
		-- Lasercom Satellite prereq
		if (techInfo.Type == GameInfo.Units.UNIT_LASERCOM_SATELLITE.PrereqTech) then
			return true;
		end
		-- Purity Gate prereq
		if (techInfo.Type == GameInfo.Projects.PROJECT_PURITY_GATE.TechPrereq) then
			return true;
		end
	end

	-- Emancipation Victory
	if (Game.IsVictoryValid(GameInfo.Victories.VICTORY_EMANCIPATION)) then
		-- Lasercom Satellite prereq
		if (techInfo.Type == GameInfo.Units.UNIT_LASERCOM_SATELLITE.PrereqTech) then
			return true;
		end
		-- Supremacy Gate prereq
		if (techInfo.Type == GameInfo.Projects.PROJECT_SUPREMACY_GATE.TechPrereq) then
			return true;
		end
	end

	-- Transcendence Victory
	if (Game.IsVictoryValid(GameInfo.Victories.VICTORY_TRANSCENDENCE)) then
		-- Quest Techs
		if (techInfo.Type == "TECH_TRANSGENICS" or 
			techInfo.Type == "TECH_SWARM_INTELLIGENCE" or 
			techInfo.Type == "TECH_NANOROBOTICS") 
		then
			return true;
		end
		-- Mind Flower speed-up building prereqs
		if (techInfo.Type == GameInfo.Buildings.BUILDING_MIND_STEM.PrereqTech or 
			techInfo.Type == GameInfo.Buildings.BUILDING_XENO_SANCTUARY.PrereqTech) 
		then
			return true;
		end
	end

	return false;
end

-- ===========================================================================
-- 	Utility Functions
-- ===========================================================================
function CheckUnlocksForYield(techInfo, yieldType)
	-- Buildings
	for row in GameInfo.Buildings{ PrereqTech = techInfo.Type } do
		local buildingType = row.Type;

		-- Direct yield from building
		for row in GameInfo.Building_YieldChanges{ BuildingType = buildingType, YieldType = yieldType } do
			if row.Yield > 0 then
				return true;
			end
		end

		-- Building specialists
		if row.SpecialistType ~= nil and row.SpecialistCount > 0 then
			for row in GameInfo.SpecialistYields{SpecialistType = row.SpecialistType} do
				if row.YieldType == yieldType then
					return true;
				end
			end
		end
	end

	-- Improvements
	-- To find Improvements we must go through Builds
	local condition = "PrereqTech = '" .. techInfo.Type .. "' and ImprovementType IS NOT NULL";
	for row in GameInfo.Builds(condition) do

		local improvementType = row.ImprovementType;		
		for row in GameInfo.Improvement_Yields{ ImprovementType = improvementType, YieldType = yieldType } do
			if row.Yield > 0 then
				return true;
			end
		end
	end

	-- Yield from other sources..?
	-- TODO

	return false;
end

function CheckUnlocksForHealth(techInfo)
	-- Health from Buildings
	for row in GameInfo.Buildings{ PrereqTech = techInfo.Type } do
		if row.Health > 0 then
			return true;
		end
	end

	-- Health from other sources..?
	-- TODO

	return false;
end

function CheckAffinity(techInfo, affinityType)
	for row in GameInfo.Technology_Affinities{ TechType = techInfo.Type, AffinityType = affinityType } do
		if row.AffinityValue > 0 then
			return true;
		end
	end

	return false;
end

--- ===========================================================================
--- 	Filter Mod Functions Below ---x
---   (all below this point were added for the filter mod (I stopped using the '---' comment convention
---    debug prints just commented out with some left enabled)
--- ===========================================================================
--given an improvementType, check if this tech improves its yields
function CheckImprovementUpgrade(techInfo, improvementType)
	--for every tech (each technology calls the filter function, passing itself in techInfo)
		--local techName : string = "" .. techInfo.Type;
		--print(techName);
	local condition = "TechType = '" .. techInfo.Type .. "' and ImprovementType IS NOT NULL";
	--for every tech where there is an Improvement_TechYieldChanges entry that has this tech as the TechType (and has an ImprovementType)
	for row in GameInfo.Improvement_TechYieldChanges(condition) do
	--if that ImprovementType is for the matching improvementType passed as parameter
		if row.ImprovementType == improvementType then
			--print("Tech: " .. row.TechType);
			--print("Improvement: " .. row.ImprovementType);
			return true;
		end
	end

	return false;
end

--gets the types of tile improvements that are built on the resource type passed in if the current resourceType is different than the lastFilteredResource
-- xenomass technically is improved by alien nests, which caused some trouble. so, it stores the improvementTypes found in a global table called g_improvementTypes
function GetImprovementsForResource(resourceType)
	--only checks for the improvementType once per filtering (not once for every tech that is checked against the filter function like it would be without the if statement below)
	if lastFilteredResource ~= resourceType then
		g_improvementTypes = {};

		local condition = "ResourceType = '" .. resourceType .. "'";

		for row in GameInfo.Improvement_ResourceTypes(condition) do
			--adds the improvementType to the end of the global table (# there gets length)
			g_improvementTypes[#g_improvementTypes+1] = row.ImprovementType;
			--also stores the last resourceType filtered for the earlier check
			lastFilteredResource = resourceType;
			print("Resource: " .. resourceType .. " _ Matches Improvement: " .. row.ImprovementType);
		end

		--debug showing how to iterate over all stored values, although the function has finished storing the improvementTypes now.
		print("List of tile improvements stored:");
		for improvement = 1, #g_improvementTypes do
			print(g_improvementTypes[improvement]);
		end
		--just add a line to seperate filter debug text
		print("");
	end
end

--Check if tech reveals the passed in resource
function CheckRevealsResource(techInfo, resourceType)
	--condition: if this tech is the tech that reveals the row's resource...
	local condition = "TechReveal = '" .. techInfo.Type .. "'";

	--and the row's resource is the type passed, return true
	for row in GameInfo.Resources(condition) do
		if row.Type == resourceType then
			return true;
		end
	end
end

--check if tech unlocks the ability to make the passed in improvement type (for workers)
---poorly named as it can be fore improvements that dont require a resource... whoops
function CheckResourceBuildUnlocked(techInfo, improvementType)
	local condition = "PrereqTech = '" .. techInfo.Type .. "' and ImprovementType IS NOT NULL";
	--for every tech where there is a Builds entry that has this tech as the PrereqTech (and has an ImprovementType)
	for row in GameInfo.Builds(condition) do
	--if that ImprovementType is for the matching improvementType passed as parameter
		if row.ImprovementType == improvementType then
			--print("Tech: " .. row.TechType);
			--print("Improvement: " .. row.ImprovementType);
			return true;
		end
	end

	return false;
end
--[[ alternate method of checking (just a different order, i think the other one makes more sense. also this one is from before extra checks were added
function CheckBuildingRequires(techInfo, resourceType)
	local condition = "ResourceType = '" .. resourceType .. "'";
	
	for row in GameInfo.Building_LocalResourceOrs(condition) do
		local buildingType = row.BuildingType;
		--print ("Resource requirement match found: " .. row.ResourceType);
		--print ("Building type is: " .. buildingType);

		local condition2 = "Type = '" .. buildingType .. "'";

		for row in GameInfo.Buildings(condition2) do
			--print ("Type: " .. row.Type);
			--print ("Type_to_match: " .. buildingType);

			if techInfo.Type == row.PrereqTech then
				print ("Match found! A building in " .. techInfo.Type .. " Requires " .. resourceType);
				print("");
				return true;
			end
		end
	end

	return false;
end
--]]

--checks if buildings have anything to do with the passed resource type basically
--it checks if they require the resource spent, require an upgraded source in the city, or if its yields are improved by the resource
--also optical surgery is the only building in the base game that uses the final check (for health change from resource),
--but the function correctly checks for that too.
function CheckBuildingRequires(techInfo, resourceType)
	local condition = "PrereqTech = '" .. techInfo.Type .. "'";
	for row in GameInfo.Buildings(condition) do
		local buildingType = row.Type;
		--print ("Building found that requires " .. techInfo.Type);
		--print ("It is " .. buildingType);

		local condition2 = "BuildingType = '" .. buildingType .. "'";
		--3 seperate checks, the print statements say what they check for (they all check off of the building we found above)
		for row in GameInfo.Building_ResourceQuantityRequirements(condition2) do
			if row.ResourceType == resourceType then
				print ("Match found! A building in " .. techInfo.Type .. " Requires spending of " .. resourceType);
				print("");
				return true;
			end
		end

		for row in GameInfo.Building_ResourceYieldChanges(condition2) do
			if row.ResourceType == resourceType then
				print ("Match found! A building in " .. techInfo.Type .. " Is improved by " .. resourceType);
				print("");
				return true;
			end
		end

		for row in GameInfo.Building_LocalResourceOrs(condition2) do
			if row.ResourceType == resourceType then
				print ("Match found! A building in " .. techInfo.Type .. " Requires " .. resourceType);
				print("");
				return true;
			end
		end

		for row in GameInfo.Building_ResourceHealthChange(condition2) do
			if row.ResourceType == resourceType then
				print ("Match found! A building in " .. techInfo.Type .. " Has health bonuses with " .. resourceType);
				print("");
				return true;
			end
		end
	end

	return false;
end

--check if a unit in the tech requires the resource passed in to be built
function CheckUnitRequires(techInfo, resourceType)
	local condition = "PrereqTech = '" .. techInfo.Type .. "'";
	for row in GameInfo.Units(condition) do
		local unitType = row.Type;

		local condition2 = "UnitType = '" .. unitType .. "'";
		for row in GameInfo.Unit_ResourceQuantityRequirements(condition2) do
			if row.ResourceType == resourceType then
				print ("Match found! A unit in " .. techInfo.Type .. " Requires spending of " .. resourceType);
				print("");
				return true;
			end
		end
	end

	return false;
end

--- ===========================================================================
--- 	More Filter mod Functions Below ---x
---		these are shorthands that use the above helper functions in combination to 
---     check multiple conditions based on the type of filter
--- ===========================================================================

function BasicResourceFilter(techInfo, resourceType)
	--gets the improvement type for the resource and sets it to the global "g_improvementType"
	--checks internally against lastFilteredResource and only changes the improvementType if the resource type has changed (see function)
	GetImprovementsForResource(resourceType);

	--Check if tech improves the yield of the tile improvement for all possible tile improvements for that resource (passive sun/star tech web button)
	for improvement = 1, #g_improvementTypes do
		if CheckImprovementUpgrade(techInfo, g_improvementTypes[improvement]) then
			return true;
		end

		if CheckResourceBuildUnlocked(techInfo, g_improvementTypes[improvement]) then
			return true;
		end
	end
	
	--check if any buildings granted by this tech require the resource
	if CheckBuildingRequires(techInfo, resourceType) then
		return true;
	end

	--no units use basic resources

	return false;
end


---Strategic Resource Filter
---searches for tech that reveals it, contains the improvement that adds the resource to your pool, any techs that contain buildings or units that 
---require or are upgraded by the resource (from pool or improved tile), 
---and also those that upgrade tile improvement of the type used by the resource (eg: Mines for Titanium, geothermal well, and xenomass well)
function StrategicResourceFilter(techInfo, resourceType, checkForReveal, checkForUnits)
	--Check if tech reveals resource if param is true
	if checkForReveal then
		if CheckRevealsResource(techInfo, resourceType) then
			return true;
		end
	end

	--gets the improvement type for the resource and sets it to the global "g_improvementType"
	--checks internally against lastFilteredResource and only changes the improvementType if the resource type has changed (see function)
	GetImprovementsForResource(resourceType);

	--Check if tech improves the yield of the tile improvement for all possible tile improvements for that resource (passive sun/star tech web button)
	for improvement = 1, #g_improvementTypes do
		if CheckImprovementUpgrade(techInfo, g_improvementTypes[improvement]) then
			return true;
		end

		if CheckResourceBuildUnlocked(techInfo, g_improvementTypes[improvement]) then
			return true;
		end
	end

	--check if any buildings granted by this tech require the resource
	if CheckBuildingRequires(techInfo, resourceType) then
		return true;
	end

	--check if any units granted by this tech require the resource, if the param is true
	if checkForUnits then
		if CheckUnitRequires(techInfo, resourceType) then
			return true;
		end
	end

	return false;
end

---does the current tech contain a wonder?
function CheckWonder(techInfo)
	local condition = "PrereqTech = '" .. techInfo.Type .. "'";
	for row in GameInfo.Buildings(condition) do
		local buildingClass = row.BuildingClass;

		local condition2 = "Type = '" .. buildingClass .. "'";
		for row in GameInfo.BuildingClasses(condition2) do
			if row.MaxGlobalInstances == 1 then
				return true;
			end
		end
	end

	return false;
end

---does the current tech contain any military unit?
function CheckMilitaryUnits(techInfo)
	for row in GameInfo.Units{ PrereqTech = techInfo.Type } do
		if row.MilitaryProduction == true then
			return true;
		end
	end

	return false;
end

---does the current tech contain any orbital unit?
--- check for null value rather than string "NULL" for 'NULL' as in <Orbital> default value in CivBEUnits.xml)
function CheckOrbitalUnits(techInfo)
	for row in GameInfo.Units{ PrereqTech = techInfo.Type } do
		if row.Orbital ~= null then
			return true;
		end
	end

	return false;
end
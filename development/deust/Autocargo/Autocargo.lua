local CustomThreatDistance = 3000
local LoadRadius = 1000
local NearRadius = 80

function InfantryCargoRandomRouteBasedOnGroupName(Carrier, CargoGroupName, ThreatDistance)
    local group = GROUP:FindByName( CargoGroupName )
    local group_cargo = CARGO_GROUP:New( group, 'Infantry', CargoGroupName, LoadRadius, NearRadius)
    local CargoSet = SET_CARGO:New():AddCargosByName( CargoGroupName )
    local CarrierGroup = GROUP:FindByName( Carrier )
    local CargoCarrier = AI_CARGO_APC:New( CarrierGroup, CargoSet, ThreatDistance ):Pickup()
    -- CAUTION BUG si no tiene ruta, el servidor se quedará colgado.
    local route = CarrierGroup:GetTaskRoute()
    if #route > 1 then
        CarrierGroup:PatrolRouteRandom(60, 'Cone')
    end
end

function InfantryCargoRandomRouteBasedOnGroupNameLite(Carrier, ThreatDistance)
    local CargoGroupName = Carrier .. deust.Autocargo.CargoSuffix
    local group = GROUP:FindByName( CargoGroupName )
    local group_cargo = CARGO_GROUP:New( group, 'Infantry', CargoGroupName, LoadRadius, NearRadius)
    local CargoSet = SET_CARGO:New():AddCargo( group_cargo )
    local CarrierGroup = GROUP:FindByName( Carrier )
    AI_CARGO_APC:New( CarrierGroup, CargoSet, ThreatDistance ):Pickup()
    -- CAUTION BUG si no tiene ruta, el servidor se quedará colgado.
    local route = CarrierGroup:GetTaskRoute()
    if #route > 1 then
        CarrierGroup:PatrolRouteRandom(60, 'Cone')
    end
end

-- Autodetect carriers and their cargo
local CarrierCandidates = SET_GROUP:New():FilterPrefixes(deust.Autocargo.CarrierPrefix):FilterOnce()
CarrierCandidates:ForEachGroup(function(CarrierGroup)
    -- Avoid _Cargo suffix
    local found = string.find(CarrierGroup.GroupName, deust.Autocargo.CargoSuffix)
    if not found then
        InfantryCargoRandomRouteBasedOnGroupNameLite(CarrierGroup.GroupName, CustomThreatDistance) 
    end
end)

-- Chaser Autocargo
local CarrierCandidates = SET_GROUP:New():FilterPrefixes(deust.AutocargoAndChaser.CarrierPrefix):FilterOnce()
CarrierCandidates:ForEachGroup(function(CarrierGroup)
    -- Avoid _Cargo suffix
    local found = string.find(CarrierGroup.GroupName, deust.Autocargo.CargoSuffix)
    if not found then
        InfantryCargoRandomRouteBasedOnGroupNameLite(CarrierGroup.GroupName, CustomThreatDistance) 
    end
end)

-- Ground Chaser Autocargo
-- Chaser Autocargo
local GroundCarrierCandidates = SET_GROUP:New():FilterPrefixes(deust.G2GDispatcher.GroundAutocargoChasingCarrierPrefix):FilterOnce()
GroundCarrierCandidates:ForEachGroup(function(CarrierGroup)
    -- Avoid _Cargo suffix
    local found = string.find(CarrierGroup.GroupName, deust.Autocargo.CargoSuffix)
    if not found then
        InfantryCargoRandomRouteBasedOnGroupNameLite(CarrierGroup.GroupName, deust.G2GDispatcher.ThreatDistance)
    end
end)

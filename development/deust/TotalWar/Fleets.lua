function TotalWar:onafterAddFleets(From, Event, To)
    local Settings = self.Settings
    local Chief = self.Chief
    local BorderZones = self.Zones.BorderZones
    local DBportZone = self.Zones.PortZones
    local Coalition = Settings.TeamCoalition
    local MainPrefix = Settings.MainPrefix

    for _, Fleet in pairs(Settings.Fleets) do
        --local fleetPrefix = MainPrefix .. " " .. Fleet.Prefix
        local fleetPrefix = Fleet.Prefix
        local fleetAssets = Fleet.Assets

        local statics = SET_STATIC:New()
        --DBObject:FilterCoalitions(coalition) -- REVIEW: Should I add this?
        statics:FilterPrefixes(fleetPrefix)
        statics:FilterZones(BorderZones)
        statics:FilterOnce()

        for _, static in pairs(statics:GetSet()) do
            local FleetName = static:GetName()
            local Alias = CreateNameMGRS(Fleet.Prefix, static:GetCoordinate())

            local PortZone
            local SpawnDist = 10000
            for _, zone in pairs(DBportZone:GetSet()) do
                local dist = UTILS.VecDist2D(static:GetVec2(), zone:GetVec2())
                if dist < SpawnDist then
                    SpawnDist = dist
                    PortZone = zone:GetName()
                end
            end

            local Fleet = self:GenerateFleet(FleetName, Alias, PortZone, Coalition, true)
            if Fleet then
                Fleet:SetMarker(true) --REVIEW

                for _, asset in pairs(fleetAssets) do
                    local template = MainPrefix .. " " .. asset.Template
                    local groups
                    if asset.Economy then
                        groups = self:GetWarehouseAssetProduction(Fleet:GetVec2(), asset.Economy.Factory,
                            asset.Economy.Range, asset.Economy.Rate, Coalition)
                    else
                        groups = asset.Groups
                    end
                    local units = asset.Units
                    local skill --REVIEW
                    --local type = asset.Type
                    local capabilities = asset.Capability
                    local weapons = asset.Weapons

                    local Flotilla = self:GenerateFlotilla(template, groups, units, skill, Alias .. template,
                    capabilities)
                    if Flotilla then
                        for _, weapon in pairs(weapons) do
                            Flotilla:AddWeaponRange(weapon.Number, weapon.Range, weapon.Type)
                        end

                        Fleet:AddFlotilla(Flotilla)
                    end
                end

                Chief:AddFleet(Fleet)
            end
        end
    end
end

deust.TotalWar.Fleets = true

function TotalWar:onafterAddBrigades(From, Event, To)
    local Settings = self.Settings
    local Chief = self.Chief
    local BorderZones = self.Zones.BorderZones
    local DBspZone = self.Zones.SpZones
    local Coalition = Settings.TeamCoalition
    local MainPrefix = Settings.MainPrefix

    for _, Brigade in pairs(Settings.Brigades) do
        --local brigadePrefix = MainPrefix .. " " .. Brigade.Prefix
        local brigadePrefix = Brigade.Prefix
        local brigadeAssets = Brigade.Assets

        local statics = SET_STATIC:New()
        --DBObject:FilterCoalitions(coalition) -- REVIEW: Should I add this?
        statics:FilterPrefixes(brigadePrefix)
        statics:FilterZones(BorderZones)
        statics:FilterOnce()

        for _, static in pairs(statics:GetSet()) do
            local BrigadeName = static:GetName()
            local Alias = CreateNameMGRS(Brigade.Prefix, static:GetCoordinate())

            local SpawnZone
            local SpawnDist = 1000
            for _, zone in pairs(DBspZone:GetSet()) do
                local dist = UTILS.VecDist2D(static:GetVec2(), zone:GetVec2())
                if dist < SpawnDist then
                    SpawnDist = dist
                    SpawnZone = zone:GetName()
                end
            end

            local Brigade = self:GenerateBrigade(BrigadeName, Alias, SpawnZone, Coalition)
            if Brigade then
                Brigade:SetMarker(true) --REVIEW

                for _, asset in pairs(brigadeAssets) do
                    local template = MainPrefix .. " " .. asset.Template
                    local groups
                    if asset.Economy then
                        groups = TotalWar:GetWarehouseAssetProduction(Brigade:GetVec2(), asset.Economy.Factory,
                            asset.Economy.Range, asset.Economy.Rate, Coalition)
                    else
                        groups = asset.Groups
                    end
                    local units = asset.Units
                    local skill --REVIEW
                    --local type = asset.Type
                    local capabilities = asset.Capability

                    if groups > 0 then
                        local Platoon = self:GeneratePlatoon(template, groups, units, skill, Alias .. template, capabilities)
                        if Platoon then
                            Brigade:AddPlatoon(Platoon)
                        end
                    end
                end

                Chief:AddBrigade(Brigade)
                --[[
                -- SECTION: OnAfterAssetDead event
                function Brigade:OnAfterAssetDead(From, Event, To, asset, request)
                    local asset = asset --Functional.Warehouse#WAREHOUSE.Assetitem
                    local request = request --Functional.Warehouse#WAREHOUSE.Pendingitem

                    -- Get assignment.
                    local assignment = Brigade:GetAssignment(request)

                    -- Get nearest warehouse with the asset type
                    local nearest, dist = Brigade:FindNeighborWarehouse(3, WAREHOUSE.Descriptor.ATTRIBUTE,
                        asset.attribute,
                        nil, nil, 3000)

                    -- Resupply from the nearest warehouse
                    if nearest then
                        if asset.attribute == WAREHOUSE.Attribute.GROUND_INFANTRY then
                            nearest:AddRequest(Brigade, WAREHOUSE.Descriptor.ATTRIBUTE, asset.attribute, 1,
                                WAREHOUSE.TransportType.APC, nil, nil, "Resupply")
                        else
                            nearest:AddRequest(Brigade, WAREHOUSE.Descriptor.ATTRIBUTE, asset.attribute, 1, nil,
                                nil,
                                nil, "Resupply")
                        end
                    end
                end
                -- !SECTION
                ]]
                --
            end
        end
    end
end

function TotalWar:onafterAddAirwings(From, Event, To)
    local Settings = self.Settings
    local Chief = self.Chief
    local BorderZones = self.Zones.BorderZones
    local Coalition = Settings.TeamCoalition
    local MainPrefix = Settings.MainPrefix

    for _, Airwing in pairs(Settings.Airwings) do
        --local airwingPrefix = MainPrefix .. " " .. Airwing.Prefix
        local airwingPrefix = Airwing.Prefix
        local airwingAssets = Airwing.Assets

        local statics = SET_STATIC:New()
        --DBObject:FilterCoalitions(coalition) -- REVIEW: Should I add this?
        statics:FilterPrefixes(airwingPrefix)
        statics:FilterZones(BorderZones)
        statics:FilterOnce()

        for _, static in pairs(statics:GetSet()) do
            local AirwingName = static:GetName()
            local Alias = CreateNameMGRS(Airwing.Prefix, static:GetCoordinate())

            local Airwing = self:GenerateAirwing(AirwingName, Alias, Coalition)
            if Airwing then
                Airwing:SetMarker(true) --REVIEW

                for _, asset in pairs(airwingAssets) do
                    local template = MainPrefix .. " " .. asset.Template
                    local groups
                    if asset.Economy then
                        groups = self:GetWarehouseAssetProduction(Airwing:GetVec2(), asset.Economy.Factory,
                            asset.Economy.Range, asset.Economy.Rate, Coalition)
                    else
                        groups = asset.Groups
                    end
                    local units = asset.Units
                    local range = asset.Range
                    local skill --REVIEW
                    local scramble = asset.Scramble
                    local payloads = asset.Payloads
                    -- TODO: Attribute
                    --local type = asset.Type
                    local capabilities = asset.Capability

                    if groups > 0 then
                        local Squadron = self:GenerateSquadron(template, groups, units, range, skill, Alias .. template,
                            capabilities, scramble)
                        if Squadron then
                            Airwing:AddSquadron(Squadron)

                            for payload, capabilities in pairs(payloads) do
                                local payload = template .. " " .. payload
                                self:T(self.LogHeader .. "GenerateTotalWar function: Checking if the asset, " ..
                                    payload .. ", exists in the mission")
                                if Group.getByName(payload) then
                                    Airwing:NewPayload(payload, capabilities.Availabe, capabilities.Task,
                                        capabilities.Ability)
                                else
                                    self:E(self.LogHeader .. "GenerateTotalWar function: The asset, " ..
                                        payload .. ", does not exist in the mission")
                                end
                            end
                        end
                    end
                end

                Chief:AddAirwing(Airwing)
            end
        end
    end
end

deust.TotalWar.Airwings = true

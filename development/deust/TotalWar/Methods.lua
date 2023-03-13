function TotalWar:GeneratePlatoon(TemplateGroupName, Ngroups, Nunits, Skill, PlatoonName, Capability)
    -- check exists
    self:T(self.LogHeader .. "GeneratePlatoon function: Checking if the asset, " ..
        TemplateGroupName .. ", exists in the mission")
    if Group.getByName(TemplateGroupName) then
        -- check is ground unit
        self:T(self.LogHeader .. "GeneratePlatoon function: Checking the template category is " .. Group.Category.GROUND)
        if Group.getByName(TemplateGroupName):getCategory() == Group.Category.GROUND then -- I should use moose first
            local Platoon = PLATOON:New(TemplateGroupName, Ngroups, PlatoonName)
            if Nunits then
                Platoon:SetGrouping(Nunits)
            end
            if Skill then
                Platoon:SetSkill(Skill)
            end
            for task, ability in pairs(Capability) do
                Platoon:AddMissionCapability(task, ability)
            end

            return Platoon
        else
            self:E(self.LogHeader .. "GeneratePlatoon function: Template category: " ..
                Group.getByName(TemplateGroupName):getCategory() .. " Expected: " .. Group.Category.GROUND)

            return false
        end
    else
        self:E(self.LogHeader .. "GeneratePlatoon function: The asset, " ..
            TemplateGroupName .. ", does not exist in the mission")

        return false
    end
end

function TotalWar:GenerateSquadron(TemplateGroupName, Ngroups, Nunits, Range, Skill, SquadronName, Capability, Scramble)
    -- check exists
    self:T(self.LogHeader .. "GenerateSquadron function: Checking if the asset, " ..
        TemplateGroupName .. ", exists in the mission")
    if Group.getByName(TemplateGroupName) then
        -- check is ground unit
        self:T(self.LogHeader .. "GenerateSquadron function: Checking the template category is " ..
            Group.Category.AIRPLANE .. "/" .. Group.Category.HELICOPTER)
        if (Group.getByName(TemplateGroupName):getCategory() == Group.Category.AIRPLANE) or
            (Group.getByName(TemplateGroupName):getCategory() == Group.Category.HELICOPTER) then -- I should use moose first
            local Squadron = SQUADRON:New(TemplateGroupName, Ngroups, SquadronName)
            if Nunits then
                Squadron:SetGrouping(Nunits)
            end
            if Range then
                Squadron:SetMissionRange(Range)
            end
            if Skill then
                Squadron:SetSkill(Skill)
            end
            Squadron:AddMissionCapability(Capability, 60)
            if Scramble then
                Squadron:AddMissionCapability({ AUFTRAG.Type.ALERT5 })
            end

            return Squadron
        else
            self:E(self.LogHeader .. "GenerateSquadron function: Template category: " ..
                Group.getByName(TemplateGroupName):getCategory() ..
                " Expected: " .. Group.Category.AIRPLANE .. "/" .. Group.Category.HELICOPTER)

            return false
        end
    else
        self:E(self.LogHeader .. "GenerateSquadron function: The asset, " ..
            TemplateGroupName .. ", does not exist in the mission")

        return false
    end
end

function TotalWar:GenerateFlotilla(TemplateGroupName, Ngroups, Nunits, Skill, FlotillaName, Capability)
    -- check exists
    self:T(self.LogHeader .. "GenerateFlotilla function: Checking if the asset, " ..
        TemplateGroupName .. ", exists in the mission")
    if Group.getByName(TemplateGroupName) then
        -- check is ground unit
        self:T(self.LogHeader .. "GenerateFlotilla function: Checking the template category is " .. Group.Category.SHIP)
        if Group.getByName(TemplateGroupName):getCategory() == Group.Category.SHIP then -- I should use moose first
            local Flotilla = FLOTILLA:New(TemplateGroupName, Ngroups, FlotillaName)
            if Nunits then
                Flotilla:SetGrouping(Nunits)
            end
            if Skill then
                Flotilla:SetSkill(Skill)
            end
            for task, ability in pairs(Capability) do
                Flotilla:AddMissionCapability(task, ability)
            end

            return Flotilla
        else
            self:E(self.LogHeader .. "GenerateFlotilla function: Template category: " ..
                Group.getByName(TemplateGroupName):getCategory() ..
                " Expected: " .. Group.Category.SHIP)

            return false
        end
    else
        self:E(self.LogHeader .. "GenerateFlotilla function: The asset, " ..
            TemplateGroupName .. ", does not exist in the mission")

        return false
    end
end

function TotalWar:GenerateBrigade(Brigade, Alias, SpawnZone, BrigadeCoalition) -- alias not needed?
    self:T(self.LogHeader .. "GenerateBrigade function: Checking if the warehouse, " ..
        Brigade .. ", exists in the mission")
    if StaticObject.getByName(Brigade) then
        self:T(self.LogHeader .. "GenerateBrigade function: Checking if the warehouse, " .. Brigade .. ", is alive")
        if STATIC:FindByName(Brigade):IsAlive() then
            self:T(self.LogHeader .. "GenerateBrigade function: Checking if the warehouse, " ..
                Brigade .. ", belongs to the coalition " .. BrigadeCoalition)
            if STATIC:FindByName(Brigade):GetCoalition() == BrigadeCoalition then
                local Brigade = BRIGADE:New(Brigade, Alias) --Ops.Brigade#BRIGADE
                if SpawnZone then
                    Brigade:SetSpawnZone(ZONE:New(SpawnZone))
                end

                return Brigade
            else
                self:T(self.LogHeader .. "GenerateBrigade function: The warehouse, " ..
                    Brigade .. ", does not belong to the coalition " .. BrigadeCoalition)

                return false
            end
        else
            self:T(self.LogHeader .. "GenerateBrigade function: The warehouse, " ..
                Brigade .. ", is not alive")

            return false
        end
    else
        self:E(self.LogHeader .. "GenerateBrigade function: The warehouse, " ..
            Brigade .. ", does not exist in the mission")

        return false
    end
end

function TotalWar:GenerateAirwing(Airwing, Alias, AirwingCoalition) -- alias not needed?
    self:T(self.LogHeader .. "GenerateAirwing function: Checking if the warehouse, " ..
        Airwing .. ", exists in the mission")
    if StaticObject.getByName(Airwing) then
        self:T(self.LogHeader .. "GenerateAirwing function: Checking if the warehouse, " .. Airwing .. ", is alive")
        if STATIC:FindByName(Airwing):IsAlive() then
            self:T(self.LogHeader .. "GenerateAirwing function: Checking if the warehouse, " ..
                Airwing .. ", belongs to the coalition " .. AirwingCoalition)
            if STATIC:FindByName(Airwing):GetCoalition() == AirwingCoalition then
                local Airwing = AIRWING:New(Airwing, Alias) --Ops.Airwing#AIRWING

                return Airwing
            else
                self:T(self.LogHeader .. "GenerateAirwing function: The warehouse, " ..
                    Airwing .. ", does not belong to the coalition " .. AirwingCoalition)

                return false
            end
        else
            self:T(self.LogHeader .. "GenerateAirwing function: The warehouse, " .. Airwing .. ", is not alive")

            return false
        end
    else
        self:E(self.LogHeader .. "GenerateAirwing function: The warehouse, " ..
            Airwing .. ", does not exist in the mission")

        return false
    end
end

function TotalWar:GenerateFleet(Fleet, Alias, PortZone, FleetCoalition, Pathfinding) -- alias not needed?
    self:T(self.LogHeader .. "GenerateFleet function: Checking if the warehouse, " ..
        Fleet .. ", exists in the mission")
    if StaticObject.getByName(Fleet) then
        self:T(self.LogHeader .. "GenerateFleet function: Checking if the warehouse, " .. Fleet .. ", is alive")
        if STATIC:FindByName(Fleet):IsAlive() then
            self:T(self.LogHeader .. "GenerateFleet function: Checking if the warehouse, " ..
                Fleet .. ", belongs to the coalition " .. FleetCoalition)
            if STATIC:FindByName(Fleet):GetCoalition() == FleetCoalition then
                local Fleet = FLEET:New(Fleet, Alias) --Ops.Fleet#FLEET
                if PortZone then
                    Fleet:SetPortZone(ZONE:New(PortZone))
                end
                if Pathfinding then
                    Fleet:SetPathfinding(Pathfinding)
                end

                return Fleet
            else
                self:T(self.LogHeader .. "GenerateFleet function: The warehouse, " ..
                    Fleet .. ", does not belong to the coalition " .. FleetCoalition)

                return false
            end
        else
            self:T(self.LogHeader .. "GenerateFleet function: The warehouse, " .. Fleet .. ", is not alive")

            return false
        end
    else
        self:E(self.LogHeader .. "GenerateFleet function: The warehouse, " ..
            Fleet .. ", does not exist in the mission")

        return false
    end
end

function TotalWar:GenerateChief(ChiefCoalition, BorderZones, ConflictZones, AttackZones, Strategy, AgentSet, Alias)
    local Chief = CHIEF:New(ChiefCoalition, AgentSet, Alias)
    Chief:SetBorderZones(BorderZones)
    Chief:SetConflictZones(ConflictZones)
    Chief:SetAttackZones(AttackZones)
    Chief:SetStrategy(Strategy)

    --Chief:__Start(5)
    return Chief
end

function TotalWar:GetWarehouseAssetProduction(coor, factory, range, rate, coalition)
    local coalition = coalition
    local zone = ZONE_RADIUS:New("scanfactorieszone", coor, range)
    --zone:SetRadius(range)
    --zone:SetVec2(coor)

    if type(coalition) ~= "string" then
        coalition = string.lower(UTILS.GetCoalitionName(coalition))
    end

    local statics = SET_STATIC:New()
    statics:FilterCoalitions(coalition)
    statics:FilterPrefixes(factory)
    statics:FilterZones({zone})
    statics:FilterOnce()

    local FactoryCount = 0

    for _, static in pairs(statics:GetSet()) do
        if static:IsAlive() then
            FactoryCount = FactoryCount + 1
        end
    end
    return FactoryCount * rate
end

deust.TotalWar.Methods = true

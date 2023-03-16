function TotalWar:onafterScanBorderZones(From, Event, To)
    local prefix = self.Settings.MainPrefix .. " BorderZone"
    local BorderZones = self.Zones.BorderZones

    BorderZones:FilterPrefixes(prefix)
    BorderZones:FilterOnce()

    local PolygonBorderZones = SET_GROUP:New()
    PolygonBorderZones:FilterPrefixes(prefix)
    PolygonBorderZones:FilterOnce()

    for _, zone in pairs(PolygonBorderZones:GetSet()) do
        local zone = ZONE_POLYGON:New(zone:GetName(), zone)
        BorderZones:AddZone(zone)
    end
end

function TotalWar:onafterScanConflictZones(From, Event, To)
    local prefix = self.Settings.MainPrefix .. " ConflictZone"
    local ConflictZones = self.Zones.ConflictZones

    ConflictZones:FilterPrefixes(prefix)
    ConflictZones:FilterOnce()

    local PolygonConflictZones = SET_GROUP:New()
    PolygonConflictZones:FilterPrefixes(prefix)
    PolygonConflictZones:FilterOnce()

    for _, zone in pairs(PolygonConflictZones:GetSet()) do
        local zone = ZONE_POLYGON:New(zone:GetName(), zone)
        ConflictZones:AddZone(zone)
    end
end

function TotalWar:onafterScanAttackZones(From, Event, To)
    local prefix = self.Settings.MainPrefix .. " AttackZone"
    local AttackZones = self.Zones.AttackZones

    AttackZones:FilterPrefixes(prefix)
    AttackZones:FilterOnce()

    local PolygonAttackZones = SET_GROUP:New()
    PolygonAttackZones:FilterPrefixes(prefix)
    PolygonAttackZones:FilterOnce()

    for _, zone in pairs(PolygonAttackZones:GetSet()) do
        local zone = ZONE_POLYGON:New(zone:GetName(), zone)
        AttackZones:AddZone(zone)
    end
end

function onafterScanSpZones(From, Event, To)
    local DBspZone = self.Zones.SpZones

    DBspZone:FilterPrefixes("spzone")
    DBspZone:FilterOnce()
end

function onafterScanPortZones(From, Event, To)
    local DBportZone = self.Zones.PortZones

    DBportZone:FilterPrefixes("portzone")
    DBportZone:FilterOnce()
end

function TotalWar:onafterAddCapZones(From, Event, To)
    local DBcapZone = SET_ZONE:New()
    local BorderZones = self.Zones.BorderZones

    DBcapZone:FilterPrefixes("capzone")
    DBcapZone:FilterOnce()

    for _, zone in pairs(DBcapZone:GetSet()) do
        for _, border in pairs(BorderZones:GetSet()) do
            if border:IsCoordinateInZone(zone:GetCoordinate()) then
                self.Chief:AddCapZone(zone, 20000, 350, 270, 30)
                break
            end
        end
    end
end

function TotalWar:onafterAddAwacsZones(From, Event, To)
    local DBawacsZone = SET_ZONE:New()
    local BorderZones = self.Zones.BorderZones

    DBawacsZone:FilterPrefixes("awacszone")
    DBawacsZone:FilterOnce()

    for _, zone in pairs(DBawacsZone:GetSet()) do
        for _, border in pairs(BorderZones:GetSet()) do
            if border:IsCoordinateInZone(zone:GetCoordinate()) then
                self.Chief:AddAwacsZone(zone, 25000)
                break
            end
        end
    end
end

function TotalWar:onafterAddTankerZones(From, Event, To)
    local DBtankerZone = SET_ZONE:New()
    local BorderZones = self.Zones.BorderZones

    DBtankerZone:FilterPrefixes("tankerzone")
    DBtankerZone:FilterOnce()

    for _, zone in pairs(DBtankerZone:GetSet()) do
        for _, border in pairs(BorderZones:GetSet()) do
            if border:IsCoordinateInZone(zone:GetCoordinate()) then
                self.Chief:AddTankerZone(zone, 18000)
                break
            end
        end
    end
end

function TotalWar:onafterAddStrategicZones(From, Event, To)
    local Chief = self.Chief
    local BorderZones = self.Zones.BorderZones
    local ConflictZones = self.Zones.ConflictZones
    local AttackZones = self.Zones.AttackZones

    local DBopsZones = SET_OPSZONE:New()
    DBopsZones:FilterPrefixes("capzone")
    DBopsZones:FilterOnce()

    for _, zone in pairs(deust.TotalWar.StrategicZones) do
        local zoneName = zone:GetName()
        local splitName = {}
        for str in string.gmatch(zoneName, "%S+") do
            table.insert(splitName, str)
        end
        local priotity = tonumber(splitName[2])
        local importance = tonumber(splitName[3])

        for _, border in pairs(ConflictZones:GetSet()) do
            if border:IsCoordinateInZone(zone:GetCoordinate()) then
                priotity = priotity - 30
                importance = importance + 3
                break
            end
        end

        for _, border in pairs(AttackZones:GetSet()) do
            if border:IsCoordinateInZone(zone:GetCoordinate()) then
                priotity = priotity - 60
                importance = importance + 6
                break
            end
        end

        if zone.IsStrategicZone then
            local ResourceListEmpty, ResourceListOccupied = self:GenerateRandomReaction("StrategicZone")
            Chief:AddStrategicZone(zone, priotity, importance, ResourceListOccupied, ResourceListEmpty)
        elseif zone.IsSamSite then
            local ResourceListEmpty, ResourceListOccupied = self:GenerateRandomReaction("SamSite")
            Chief:AddStrategicZone(zone, priotity, importance, ResourceListOccupied, ResourceListEmpty)
        elseif zone.IsCheckPoint then
            local ResourceListEmpty, ResourceListOccupied = self:GenerateRandomReaction("CheckPoint")
            Chief:AddStrategicZone(zone, priotity, importance, ResourceListOccupied, ResourceListEmpty)
        elseif zone.IsSeaZone then
            local ResourceListEmpty, ResourceListOccupied = self:GenerateRandomReaction("SeaZone")
            Chief:AddStrategicZone(zone, priotity, importance, ResourceListOccupied, ResourceListEmpty)
        end
    end
end

deust.TotalWar.Zones = true

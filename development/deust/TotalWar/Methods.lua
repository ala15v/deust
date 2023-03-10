function TotalWar:ScanBorderZones()
    local prefix = self.Settings.MainPrefix .. " BorderZone"

    self.BorderZones:FilterPrefixes(prefix)
    self.BorderZones:FilterOnce()

    local PolygonBorderZones = SET_GROUP:New()
    PolygonBorderZones:FilterPrefixes(prefix)
    PolygonBorderZones:FilterOnce()

    for _, zone in pairs(PolygonBorderZones:GetSet()) do
        local zone = ZONE_POLYGON:New(zone:GetName(), zone)
        self.BorderZones:AddZone(zone)
    end

    return true
end

function TotalWar:ScanConflictZones()
    local prefix = self.Settings.MainPrefix .. " ConflictZone"

    self.ConflictZones:FilterPrefixes(prefix)
    self.ConflictZones:FilterOnce()

    local PolygonConflictZones = SET_GROUP:New()
    PolygonConflictZones:FilterPrefixes(prefix)
    PolygonConflictZones:FilterOnce()

    for _, zone in pairs(PolygonConflictZones:GetSet()) do
        local zone = ZONE_POLYGON:New(zone:GetName(), zone)
        self.ConflictZones:AddZone(zone)
    end

    return true
end

function TotalWar:ScanAttackZones()
    local prefix = self.Settings.MainPrefix .. " AttackZone"

    self.AttackZones:FilterPrefixes(prefix)
    self.AttackZones:FilterOnce()

    local PolygonAttackZones = SET_GROUP:New()
    PolygonAttackZones:FilterPrefixes(prefix)
    PolygonAttackZones:FilterOnce()

    for _, zone in pairs(PolygonAttackZones:GetSet()) do
        local zone = ZONE_POLYGON:New(zone:GetName(), zone)
        self.AttackZones:AddZone(zone)
    end

    return true
end

deust.TotalWar.Methods = true

-- ANCHOR: Class declaration
StrategicZone = {
    IsStrategicZone = false,
    IsSamSite = false,
    IsCheckPoint = false,
    IsSeaZone = false
}

-- ANCHOR: Constructor
function StrategicZone:New(ZoneName)
    -- Inherit everthing from FSM class.
    local self = BASE:Inherit(self, OPSZONE:New(ZoneName)) -- #OPSZONE

    -- Detect the type of zone
    if string.find(ZoneName, "StrategicZone") then
        self.IsStrategicZone = true
    end
    if string.find(ZoneName, "SamSite") then
        self.IsSamSite = true
    end
    if string.find(ZoneName, "CheckPoint") then
        self.IsCheckPoint = true
    end
    if string.find(ZoneName, "SeaZone") then
        self.IsSeaZone = true
    end

    table.insert(deust.TotalWar.StrategicZones, self)   -- inserting new StrategicZone in the DB
    return self
end

function StrategicZone:ScanMap()
    -- Scanning map
    local DBstrategicZones
    DBstrategicZones = SET_ZONE:New()
    DBstrategicZones:FilterPrefixes({"StrategicZone", "SamSite", "CheckPoint", "SeaZone"})
    DBstrategicZones:FilterOnce()

    -- Creating new Strategic Zones
    for _, zone in pairs(DBstrategicZones:GetSet()) do
        local zone = zone
        StrategicZone:New(zone:GetName())
    end
end
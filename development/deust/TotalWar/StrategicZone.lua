--[[

# StrategicZone

This class Inherit the OPSZONE class from Moose and adds 4 new properties to help the editor to classify the OPSZONE

## StrategicZone:New(ZoneName)

It initiate a new instance of the class StrategicZone

> ### **Parameters**
>
> |           Name             |       Type        |                                     Description                                         |
> |:--------------------------:|:-----------------:|:----------------------------------------------------------------------------------------|
> |         ZoneName           |       String      | This is the name of a trigger zone in the mission editor                                |

> ### **Return**
>
> |         Name           |             Type               |                       Description                            |
> |:----------------------:|:------------------------------:|:-------------------------------------------------------------|
> |     StrategicZone      |            Table               | New instance of the class StrategicZone                      |

> ### **Example**
>
>> Input: `MyStrategicZone = StrategicZone:New("Factory StrategicZone")`

## StrategicZone:ScanMap()

This is a function that scans the map searching for trigger zones with the prefix *"StrategicZone"*, *"SamSite"*, *"CheckPoint"* or *"SeaZone"* in the name. The function creates one OPSZONE for each zone with one of those prefix in the name. This function should be only call at the mission start.

> ### **Example**
>
>> Input: `StrategicZone.ScanMap()`

]]
--

-- ANCHOR: Class declaration
StrategicZone = {
    IsStrategicZone = false,
    IsSamSite = false,
    IsCheckPoint = false,
    IsSeaZone = false,
    StZone = nil,
    SpyAgent = nil
}

-- ANCHOR: Constructor
function StrategicZone:New(ZoneName, SpyAgent)
    local ZoneName = ZoneName
    local SpyAgent = SpyAgent

    self.StZone = OPSZONE:New(ZoneName)

    self.StZone:SetObjectCategories(Object.Category.UNIT)

    -- KNOWNISSUE: Is not coalition dependent
    if type(SpyAgent) == "string" then
        self.SpyAgent = SpyAgent

        local zone = ZONE_RADIUS:New("scanspieszone", self.StZone:GetZone():GetVec2(), 10000) --REVIEW

        local spies = SET_GROUP:New()
        spies:FilterPrefixes(SpyAgent)
        spies:FilterZones({ zone })
        spies:FilterOnce()

        local SpyCount = 0

        for _, spy in pairs(spies:GetSet()) do
            if spy:IsAlive() then
                -- TODO: Caught probability
                SpyCount = SpyCount + 1
            end
        end

        if SpyCount < 1 then    -- TODO: Add some probability
            self.StZone:SetDrawZone(false)
        end

        if SpyCount < 2 then    -- TODO: Add some probability
            self.StZone:SetMarkZone(false)
        end
    end
    -- !KNOWNISSUE

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

    self.StZone:Start()
    table.insert(deust.TotalWar.StrategicZones, self) -- inserting new StrategicZone in the DB
    return self
end

function StrategicZone:ScanMap(SpyAgent)
    local SpyAgent = SpyAgent

    -- Scanning map
    local DBstrategicZones
    DBstrategicZones = SET_ZONE:New()
    DBstrategicZones:FilterPrefixes({ "StrategicZone", "SamSite", "CheckPoint", "SeaZone" })
    DBstrategicZones:FilterOnce()

    -- Creating new Strategic Zones
    for _, zone in pairs(DBstrategicZones:GetSet()) do
        local zone = zone
        StrategicZone:New(zone:GetName(), SpyAgent)
    end
end

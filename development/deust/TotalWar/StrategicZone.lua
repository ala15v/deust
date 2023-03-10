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

]]--

-- ANCHOR: Class declaration
StrategicZone = {
    IsStrategicZone = false,
    IsSamSite = false,
    IsCheckPoint = false,
    IsSeaZone = false
}

-- ANCHOR: Constructor
function StrategicZone:New(ZoneName)
    -- Inherit everthing from OPSZONE class.
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
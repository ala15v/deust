---------------------------
-- START G2G SuicideBomber --
---------------------------
local SuicideBomberRadius = 300
local DetectionMeters = 20
local HighExplosionMin = 150
local HighExplosionMax = 300
local LowExplosionMin = 30
local LowExposionMax = 60
local ExplosionDelay = 2
local ScanTime = 60

local SetBombsGroups = SET_GROUP:New():FilterPrefixes('SuicideBomb'):FilterStart()

SetBombsGroups:ForEachGroup(
    function( Group )
        Group:OptionROTNoReaction()
        Group:OptionAlarmStateGreen()
    end
)

function SuciceBomberMissionRoute(bomber, target)
    local route, reliable = bomber:TaskGroundOnRoad(target:GetCoordinate(), 20, 'On Road', true, nil, function(group, waypoint, totalwaypoints)
        if waypoint == totalwaypoints then
            local coord = group:GetCoordinate()
            local unitFound, staticFound, scenaryFound, units, statics, scenaries = coord:ScanObjects(DetectionMeters, true, false, false)
            for _, value in ipairs(units) do
                -- detectar si la unidad detectada en la coordenada no es enemigo o no es ella misma
                if value ~= group and value:IsFriendly(coalition.side.BLUE) then
                    local ExplosionTNT = 20
                    if group:GetThreatLevel() == 1 then -- si es infanteria reducir la carga explosiva que tiene
                        ExplosionTNT = math.random(LowExplosionMin, LowExposionMax)
                    else
                        ExplosionTNT = math.random(HighExplosionMin, HighExplosionMax)
                    end
                    group:GetCoordinate():Explosion(ExplosionTNT, ExplosionDelay)
                end
            end
        end
    end)
    local waypoint = target:GetCoordinate():WaypointGround()
    waypoint.task = route[#route].task
    route[#route+1]=waypoint
    bomber:Route(route, 2)
end

function SucideBomberMission()
    SetBombsGroups:ForEachGroup(
        function( MooseGroup )
            local ZoneName = MooseGroup.GroupName
            local Zone1 = ZONE_RADIUS:New(ZoneName, MooseGroup:GetVec2(), SuicideBomberRadius, true)
            -- Zone1:SmokeZone(SMOKECOLOR.Blue)
            Zone1:Scan({Object.Category.UNIT},{Unit.Category.GROUND_UNIT})
            local GroupDetected = Zone1:GetScannedSetGroup():FilterCoalitions("blue"):FilterOnce():GetFirst():GetUnit(1)
            if GroupDetected then
                if MooseGroup:GetCoordinate():Get2DDistance(GroupDetected:GetCoordinate()) <= SuicideBomberRadius then
                    SuciceBomberMissionRoute(MooseGroup, GroupDetected)
                end
            end
        end
    )
end

-- Activar solo si hay grupos de suicidas
if SetBombsGroups:Count() > 0 then
    Messager = SCHEDULER:New( nil,
    function()
      SucideBomberMission()
    end, 
    {}, 0, ScanTime )
end
---------------------------
-- START G2G SuicideBomber --
---------------------------
local SuicideBomberRadius = 300
local DetectionMeters = 20
local HighExplosionMin = 150
local HighExplosionMax = 300
local LowExplosionMin = 50
local LowExposionMax = 100
local ExplosionDelay = 2
local ScanTime = 60

local SetBombsGroups = SET_GROUP:New():FilterPrefixes(deust.G2GDispatcher.SuicideBombPrefix):FilterStart()

SetBombsGroups:ForEachGroup(
    function( Group )
        _deustlog_debug('SuicideBomberGroup: ' .. Group.GroupName, true)
        Group:OptionROTNoReaction()
        Group:OptionAlarmStateGreen()
    end
)

function SuciceBomberMissionRoute(bomber, target)
    local route, reliable = bomber:TaskGroundOnRoad(target:GetCoordinate(), 20, 'Off Road', true, nil, function(group, waypoint, totalwaypoints)

        if waypoint == totalwaypoints then
            local coord = group:GetCoordinate()
            local unitFound, staticFound, scenaryFound, units, statics, scenaries = coord:ScanObjects(DetectionMeters, true, false, false)
            local AttackedCoalition = nil
            for _, value in ipairs(units) do
                if group:GetCoalition() == coalition.side.BLUE then
                    AttackedCoalition = coalition.side.RED
                else
                    -- neutral coalition goes here too
                    AttackedCoalition = coalition.side.BLUE
                end
                -- detectar si la unidad detectada en la coordenada no es enemigo o no es ella misma
                if value ~= group and value:IsFriendly(AttackedCoalition) then
                    local ExplosionTNT = 20
                    if group:GetThreatLevel() == 1 then -- si es infanteria reducir la carga explosiva que tiene
                        ExplosionTNT = math.random(LowExplosionMin, LowExposionMax)
                    else
                        ExplosionTNT = math.random(HighExplosionMin, HighExplosionMax)
                    end
                    group:GetCoordinate():Explosion(ExplosionTNT, ExplosionDelay)
                    _deustlog_info('SuicideBomber Explosion launched from: ' .. group.GroupName .. ' target:' .. target.GroupName, true)
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
            _deustlog_debug('SuicideBomberGroup Scanning: ' .. MooseGroup.GroupName, true)
            local AttackedCoalition = nil
            local ZoneName = MooseGroup.GroupName
            local Zone1 = ZONE_RADIUS:New(ZoneName, MooseGroup:GetVec2(), SuicideBomberRadius, false)
            Zone1:DrawZone()
            Zone1:Scan({Object.Category.UNIT},{Unit.Category.GROUND_UNIT})

            Zone1:GetScannedSetGroup():FilterStop():FilterCoalitions("blue", true):FilterStart():ForEachGroupAnyInZone(Zone1, function(group)
                if group:GetCoalition() ~=  MooseGroup:GetCoalition() then
                    local targetUnit = group:GetUnit(1)
                    _deustlog_debug('SuicideBomberGroup detection: ' .. group.GroupName .. ' by ' .. MooseGroup.GroupName, true)
                    _deustlog_debug('SuicideBomberGroup distance to target: ' .. tostring(MooseGroup:GetCoordinate():Get2DDistance(targetUnit:GetCoordinate())), true)
                    if MooseGroup:GetCoordinate():Get2DDistance(targetUnit:GetCoordinate()) <= SuicideBomberRadius then
                        _deustlog_info('SuicideBomber Mission Launched from: ' .. MooseGroup.GroupName .. ' target:' .. group.GroupName, true)
                        SuciceBomberMissionRoute(MooseGroup, targetUnit)
                    end
                end
            end)

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
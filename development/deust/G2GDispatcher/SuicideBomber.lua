-- TODO: respawn vied from zero creation in a zone.
-- TODO: take target random unit and assign one vied to one target


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

local viedRouteControl = {}

local SetBombsGroups = SET_GROUP:New():FilterPrefixes(deust.G2GDispatcher.SuicideBombPrefix):FilterStart()
local SetVIEDneutrals = SET_GROUP:New():FilterCoalitions("neutral"):FilterPrefixes(deust.G2GDispatcher.vied.prefix):FilterActive():FilterStart()
local SetVIEDtargets = SET_UNIT:New():FilterCoalitions("blue"):FilterActive():FilterStart()

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

-- Función para verificar la proximidad
deust.G2GDispatcher.vied.checkProximity = function (chaser)
    local chaser = chaser or false
    SetVIEDneutrals:ForEachGroupAlive(
      function(VIEDgroup)
        if not VIEDgroup:IsActive() then return end
        _deustlog_debug(string.format('Grupo VIED detectado: %s', VIEDgroup.GroupName), true)

        local VIEDcoord = VIEDgroup:GetCoordinate()

        SetVIEDtargets:ForEachUnit(
          function(VIEDtarget)
            if VIEDtarget:IsAlive() == false then return end

            local VIEDtargetCoord = VIEDtarget:GetCoordinate()
            local distance = VIEDcoord:Get2DDistance(VIEDtargetCoord)

            if distance > deust.G2GDispatcher.vied.maxDistance then return end

            -- TODO: memory leak if we don't remove the viedRouteControl
            if chaser then
                if viedRouteControl[VIEDgroup.GroupName] == nil or (timer.getTime() - viedRouteControl[VIEDgroup.GroupName]) > deust.G2GDispatcher.vied.calcRouteTime then
                    viedRouteControl[VIEDgroup.GroupName] = timer.getTime()
                    local route, reliable = VIEDgroup:TaskGroundOnRoad(VIEDtarget:GetCoordinate(), 60, 'Off Road', true, nil)
                    local waypoint = VIEDtarget:GetCoordinate():WaypointGround()
                    waypoint.task = route[#route].task
                    route[#route+1]=waypoint
                    VIEDgroup:Route(route, 2)
                end
            end

            if distance < 15 then  -- distancia en metros
                _deustlog_debug(string.format('Target VIED exploding: %s', VIEDtarget:GetName()), true)
              local randomInterval
  
              VIEDcoord:Explosion(500)
  
              randomInterval = math.random(1,6)
              VIEDcoord:Explosion(100, randomInterval)
  
              randomInterval = math.random(1, 6) + randomInterval
              VIEDcoord:Explosion(100, randomInterval)
  
              randomInterval = math.random(1,6) + randomInterval
              VIEDcoord:Explosion(100, randomInterval)
  
            end
          end
        )
      end
    )
end

deust.G2GDispatcher.vied.eventManager = {}
function deust.G2GDispatcher.vied.eventManager:onEvent(event)
    if event.id == world.event.S_EVENT_BDA then
        -- TODO: solo detectar explosiones de ieds
        if event.target then
            local targetName = event.target:getName()
            if not deust.utils.startsWith(targetName, deust.G2GDispatcher.vied.prefix) then return end

            local vec3 = event.target:getPoint()
            local initialCoord = COORDINATE:NewFromVec3(vec3)
            local randomInterval
            initialCoord:Explosion(600)

            randomInterval = math.random(1,6)
            initialCoord:Explosion(100, randomInterval)

            randomInterval = math.random(1, 6) + randomInterval
            initialCoord:Explosion(100, randomInterval)

            randomInterval = math.random(1,6) + randomInterval
            initialCoord:Explosion(100, randomInterval)

            -- wait 30 segundos
            local longOffset = 30
            randomInterval = math.random(1,6) + randomInterval + longOffset
            initialCoord:Explosion(100, randomInterval)

            randomInterval = math.random(1, 6) + randomInterval
            initialCoord:Explosion(100, randomInterval)

            randomInterval = math.random(1,6) + randomInterval
            initialCoord:Explosion(100, randomInterval)

        end
    end
end

-- Activar solo si hay grupos de suicidas
if SetBombsGroups:Count() > 0 then
    Messager = SCHEDULER:New( nil,
    function()
      SucideBomberMission()
    end, 
    {}, 0, ScanTime )
end

if deust.G2GDispatcher.vied.enable then
    _deustlog_info('[VIED] Enabling event manager')
    world.addEventHandler(deust.G2GDispatcher.vied.eventManager)
    TIMER:New(deust.G2GDispatcher.vied.checkProximity, true):Start(0, deust.G2GDispatcher.vied.scan)
end
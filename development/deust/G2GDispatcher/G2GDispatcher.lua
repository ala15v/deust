--------------------------
-- START G2G Dispatcher --
--------------------------
-- BUGS

-- TODO
-- * aprovechar carretera
-- * utilizar UNIT:GetThreatLevel() para calibrar la fuerza enemiga con la que se enfrenta, es decir
-- ref: https://flightcontrol-master.github.io/MOOSE_DOCS/Documentation/Wrapper.Unit.html##(UNIT).GetThreatLevel
_deustlog_info('[MODULE] G2GDispatcher loading')

local _DEBUG = false

-- Detection Set
-- El grupo debe tener la tarea de FAC
G2GDetectionSetGroup = SET_GROUP:New()
G2GDetectionSetGroup:FilterPrefixes( {deust.G2GDispatcher.GroundSpotterPrefix } )
G2GDetectionSetGroup:FilterStart()

G2GDetectionSetGroup:ForEachGroup(function(Group)
    Group:OptionROTNoReaction()
end)

G2GDetection = DETECTION_AREAS:New( G2GDetectionSetGroup, deust.G2GDispatcher.DetectionRange )

G2GDetection:SetRefreshTimeInterval(deust.G2GDispatcher.DetectionRefresh)
G2GDetection:SetFriendliesRange(deust.G2GDispatcher.FriendliesRange)
G2GDetection:InitDetectVisual( true )
G2GDetection:InitDetectIRST( true )
G2GDetection:InitDetectRadar( true )
G2GDetection:InitDetectRWR( true )
G2GDetection:InitDetectOptical( true )
-- G2GDetection:FilterCategories(Unit.Category.GROUND_UNIT)
G2GDetection:SetIntercept(true, deust.G2GDispatcher.AnticipationSeconds) -- Segundos de anticipación

G2GDetection:Start()

-- Define Chase Pursuit Groups
deust.G2GDispatcher.ChasePursuitGroups = SET_GROUP:New():FilterPrefixes(deust.G2GDispatcher.GroundChasingGroupPrefix):FilterStart()
deust.G2GDispatcher.AutocargoChasePursuitGroups = SET_GROUP:New():FilterPrefixes(deust.G2GDispatcher.GroundAutocargoChasingGroupPrefix):FilterStart()
-- Save initial position
deust.G2GDispatcher.ChasePursuitGroups:ForEachGroup(function(ChaserGroup)
    deust.G2GDispatcher.ChasingGroups[ChaserGroup.GroupName] = {}
    deust.G2GDispatcher.ChasingGroups[ChaserGroup.GroupName].coord = ChaserGroup:GetCoordinate()
end)
deust.G2GDispatcher.AutocargoChasePursuitGroups:ForEachGroup(function(ChaserGroup)
    deust.G2GDispatcher.ChasingGroups[ChaserGroup.GroupName] = {}
    deust.G2GDispatcher.ChasingGroups[ChaserGroup.GroupName].coord = ChaserGroup:GetCoordinate()
end)

if _DEBUG then
    SCHEDULER:New(nil, function()
        local DetectionReport = G2GDetection:DetectedReportDetailed()
        MESSAGE:New( DetectionReport, 15, "Detection" ):ToAll()
    end, {}, 1, 3)
end

-- Propiedas de DetectedItem
-- https://flightcontrol-master.github.io/MOOSE_DOCS/Documentation/Functional.Detection.html##(DETECTION_BASE.DetectedItem)
function G2GDetection:OnAfterDetectedItem(From, Event, To, DetectedItem)
    local limit_chasing = 3
    local counter_chasing = 0

    self:CalculateIntercept(DetectedItem)
    local intercept = DetectedItem.InterceptCoord
    local friendsNearBy = self:GetFriendliesNearBy(DetectedItem, Unit.Category.GROUND_UNIT)
    -- TODO: control more than unit chasing
    -- BUG: si se detectan varios aliados, no se inician múltiples persecuciones por area. En distintas areas si. Quizás con DETECTION_UNITS o DETECTION_TYPES se arregle.

    -- Detectar distancia entre el perseguido y el perserguidor y aplicar
    -- DETECTION_AREAS:ForgetDetectedUnit(UnitName)

    if DetectedItem.IsDetected then
        if friendsNearBy then
            for _, _unit in pairs(friendsNearBy) do
                local group = _unit:GetGroup()
                local groupName = group.GroupName
                local isChaseGroup = deust.G2GDispatcher.ChasePursuitGroups:FindGroup(groupName)
                local isAutoCargoChaseGroup = deust.G2GDispatcher.AutocargoChasePursuitGroups:FindGroup(groupName)

                if isChaseGroup then
                    local route, reliable = group:TaskGroundOnRoad(intercept:GetCoordinate(), deust.G2GDispatcher.InterceptSpeed, 'On Road', true, nil)
                    local waypoint = intercept:GetCoordinate():WaypointGround()
                    waypoint.task = route[#route].task
                    route[#route+1]=waypoint
                    group:Route(route, 1)
                    group:OptionROEWeaponFree()
                    group:OptionAlarmStateRed()
                    counter_chasing = counter_chasing + 1
                    if counter_chasing == limit_chasing then
                        return
                    end
                elseif isAutoCargoChaseGroup then
                    local route, reliable = group:TaskGroundOnRoad(intercept:GetCoordinate(), deust.G2GDispatcher.InterceptSpeed, 'On Road', true, nil)
                    local waypoint = intercept:GetCoordinate():WaypointGround()
                    waypoint.task = route[#route].task
                    route[#route+1]=waypoint
                    group:Route(route, 2)
                    group:OptionROEWeaponFree()
                    group:OptionAlarmStateRed()
                    counter_chasing = counter_chasing + 1
                    if counter_chasing == limit_chasing then
                        return
                    end
                end
            end
        end
    end
end

_deustlog_info('[MODULE] G2GDispatcher loaded')
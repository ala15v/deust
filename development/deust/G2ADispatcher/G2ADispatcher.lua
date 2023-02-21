--------------------------
-- START A2G Dispatcher --
--------------------------

-- Detection Set
-- El grupo debe tener la tarea de FAC
RedDetectionSetGroup = SET_GROUP:New()
RedDetectionSetGroup:FilterPrefixes( { deust.G2ADispatcher.SpotterPrefix } )
RedDetectionSetGroup:FilterStart()

-- RedDetection = DETECTION_UNITS:New( RedDetectionSetGroup, 30000 )
RedDetection = DETECTION_AREAS:New( RedDetectionSetGroup, 5000 )
-- RedDetection = DETECTION_TYPES:New( RedDetectionSetGroup, 30000 )

RedDetection:SetRefreshTimeInterval(60)
RedDetection:SetFriendliesRange(15000)
RedDetection:InitDetectVisual( true )
RedDetection:InitDetectIRST( true )
RedDetection:InitDetectRadar( true )
RedDetection:InitDetectRWR( true )
RedDetection:InitDetectOptical( true )
-- RedDetection:SetAcceptRange( 5000 ) -- Rango para iniciar un chasing, no funciona como se espera. Investigar.
RedDetection:FilterCategories(Unit.Category.HELICOPTER)
RedDetection:SetIntercept(true, 120) -- Segundos de anticipación

RedDetection:Start()

-- Define Chase Pursuit Groups
deust.G2ADispatcher.ChasePursuitGroups = SET_GROUP:New():FilterPrefixes(deust.G2ADispatcher.ChasingGroupsPrefix):FilterStart()
deust.G2ADispatcher.AutocargoChasePursuitGroups = SET_GROUP:New():FilterPrefixes(deust.AutocargoAndChaser.CarrierPrefix):FilterStart()
-- Save initial position
deust.G2ADispatcher.ChasePursuitGroups:ForEachGroup(function(ChaserGroup)
    deust.G2ADispatcher.ChasingGroups[ChaserGroup.GroupName] = {}
    deust.G2ADispatcher.ChasingGroups[ChaserGroup.GroupName].coord = ChaserGroup:GetCoordinate()
end)
deust.G2ADispatcher.AutocargoChasePursuitGroups:ForEachGroup(function(ChaserGroup)
    deust.G2ADispatcher.ChasingGroups[ChaserGroup.GroupName] = {}
    deust.G2ADispatcher.ChasingGroups[ChaserGroup.GroupName].coord = ChaserGroup:GetCoordinate()
end)

if _DEBUG then
    SCHEDULER:New(nil, function()
        local DetectionReport = RedDetection:DetectedReportDetailed()
        MESSAGE:New( DetectionReport, 15, "Detection" ):ToAll()
    end, {}, 1, 3)
end

-- Propiedas de DetectedItem
-- https://flightcontrol-master.github.io/MOOSE_DOCS/Documentation/Functional.Detection.html##(DETECTION_BASE.DetectedItem)
function RedDetection:OnAfterDetectedItem(From, Event, To, DetectedItem)
    local limit_chasing = 2
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
                local isChaseGroup = deust.G2ADispatcher.ChasePursuitGroups:FindGroup(groupName)
                local isAutoCargoChaseGroup = deust.G2ADispatcher.AutocargoChasePursuitGroups:FindGroup(groupName)
                if isChaseGroup then
                    group:RouteToVec3(intercept:GetVec3(), 120 / 3.6)
                    counter_chasing = counter_chasing + 1
                    if counter_chasing == limit_chasing then
                        return
                    end
                elseif isAutoCargoChaseGroup then
                    group:RouteToVec3(intercept:GetVec3(), 120 / 3.6)
                    counter_chasing = counter_chasing + 1
                    if counter_chasing == limit_chasing then
                        return
                    end
                end
            end
        end
    end
end

-- Detect speed 0 for at more than five seconds in order to return to initial point
-- SCHEDULER:New(nil, function()
--     deust.G2ADispatcher.ChasePursuitGroups:ForEachGroup(function(ChaserGroup)
--         local speed = ChaserGroup:GetVelocityKMH()
--         local groupName = ChaserGroup.GroupName
--         local initialCoord = deust.G2ADispatcher.ChasingGroups[groupName].coord
--         local threshold = 100

--         if speed then
--             if speed == 0 then
--                 -- Check if it is on initial point with some threshold
--                 local distance = initialCoord:Get2DDistance(ChaserGroup:GetCoordinate())
--                 if distance > threshold then
--                     BASE:E('Sending Chasing Group to Initial Point')
--                     ChaserGroup:RouteToVec2(initialCoord:GetVec2(), 120 / 3.6)
--                 end
--             end
--         end
--     end)
-- end, {}, 1, 3)

-- copiar los waypoints para cuando deje de seguirle restaurar su ruta
-- probar combinado con vehículos con carga
-- si el spot es en visual añadir factores de distancia y esas cosas
-- random DETECTION_AREAS:FlareDetectedUnits()
-- ¿Cómo detectar que un chaser ha dejado de perseguir? ¿Quizás detectando velocidad cero después de n segundos? GROUP:GetVelocityKMH()
--####################--
-- END A2G Dispatcher --
--####################--


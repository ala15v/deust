------------------
-- START FATCOW --
------------------
_deustlog_info('[MODULE] Fat Cow loading')

local lz = MARKEROPS_BASE:New("lz",{"lz"})
local rtb = MARKEROPS_BASE:New("rtb",{"rtb"})
local orbit = MARKEROPS_BASE:New( "orbit" )

deust.fatcow.getPosition = function()
    _deustlog_debug('getting fatcow position')
    local group = deust.fatcow.group

    if group then
        local coord = group:GetCoordinate()
        local mark = MARKER:New(coord, 'Fatcow current position. Mark auto-remove on 30 seconds.'):ToCoalition( coalition.side.BLUE )
        mark:Remove(30)
    else
        MESSAGE:New('No fatcow in flight', 10, 'deust Info', false):ToCoalition( coalition.side.BLUE )
    end
end

deust.fatcow.ETAtoLanding = function()
    local group = deust.fatcow.group
    local baseSpeed = 100

    if group then
        local coord = group:GetCoordinate()
        local distance = deust.fatcow.lz_coord:Get2DDistance(coord)
        -- calculating nm
        local nm = distance / 1852
        -- calulating time based on 100kts Chinook average cruise speed
        local seconds = (nm / baseSpeed) * 60 * 60
        local remainingTime = deust.getHumanReadTime(seconds)

        MESSAGE:New(string.format('ETA Fat Cow: %s', remainingTime), 30, 'Fat Cow'):ToCoalition( coalition.side.BLUE )
    else
        MESSAGE:New(string.format('ETA Fat Cow: %s', '<no Fat Cow in flight>'), 30, 'Fat Cow'):ToCoalition( coalition.side.BLUE )
    end
end

deust.fatcow.echoETA = function(destCoord, taskName)
    local group = deust.fatcow.group
    local baseSpeed = 100

    if group then
        local coord = group:GetCoordinate()
        local distance = destCoord:Get2DDistance(coord)
        -- calculating nm
        local nm = distance / 1852
        -- calulating time based on 100kts Chinook average cruise speed
        local seconds = (nm / baseSpeed) * 60 * 60
        local remainingTime = deust.getHumanReadTime(seconds)

        MESSAGE:New(string.format('ETA Fat Cow on %s: %s', taskName, remainingTime), 30, 'Fat Cow'):ToCoalition( coalition.side.BLUE )
    else
        MESSAGE:New(string.format('ETA Fat Cow: %s', '<no Fat Cow in flight>'), 30, 'Fat Cow'):ToCoalition( coalition.side.BLUE )
        
    end
end

deust.fatcow.GetLLDDM = function()
    local group = deust.fatcow.group
    if group then
        local llddm = deust.fatcow.lz_coord:ToStringLLDDM()
        MESSAGE:New(string.format('LZ Coordinates Fat Cow: %s', llddm), 30, 'Fat Cow'):ToCoalition( coalition.side.BLUE )
    end
end

function rtb:OnAfterMarkChanged(From,Event,To,Text,Keywords,Coord)
    _deustlog_info('Sending Chinook to RTB')
    deustTextToSpeechType('rtb')
    MESSAGE:New('Fat Cow on RTB.', 30, 'Fat Cow'):ToCoalition( coalition.side.BLUE )
    deust.destroyStatics(deust.fatcow.farp_statics)
    local rtbtask = deust.fatcow.group:TaskLandAtVec2(deust.fatcow.rtb, 32000)
    deust.fatcow.FatCowEscort()
    deust.fatcow.echoETA(deust.fatcow.rtbcoord, 'RTB')
    deust.fatcow.group:SetTask( rtbtask, 1 )
    deust.fatcow.landScheduler:Stop()
    collectgarbage()
    deust.fatcow.onrtb = true
    if (_deustdebug)
    then
        deust.fatcow.rtb_zone:SmokeZone(SMOKECOLOR.Blue)
    end

    deust.fatcow.rtbScheduler = SCHEDULER:New(nil)
    deust.fatcow.rtbSchedulerCheck = deust.fatcow.rtbScheduler:Schedule(nil,
    function()
        _deustlog_debug('Checking RTB')
        if (deust.fatcow.group:AllOnGround())
            then
                _deustlog_info('RTB landing detected')
                MESSAGE:New(string.format('Fat Cow has reached RTB.'), 30, 'Fat Cow'):ToCoalition( coalition.side.BLUE )
                deust.fatcow.group:Destroy(false)
                deust.fatcow.DestroyFatCowEscort()
                deust.fatcow.dead = false
                deust.fatcow.group = nil
                deust.fatcow.onrtb = false
                SCHEDULER:Stop(deust.fatcow.rtbSchedulerCheck)
            end
    end, {}, 5, 10)
    collectgarbage()
end

function orbit:OnAfterMarkChanged(From, Event, To, Text, Keywords, Coord)
    if not deust.fatcow.group then
        MESSAGE:New(string.format('Not Fat Cow in flight to request orbit'), 30, 'Fat Cow'):ToCoalition( coalition.side.BLUE )
        return
    end
    deustTextToSpeechType('orbit')
    deust.fatcow.echoETA(Coord, 'Orbit')
    local orbittask = deust.fatcow.group:TaskOrbitCircleAtVec2(Coord:GetVec2(), 100, 90 / 1.9375)
    deust.fatcow.group:SetTask( orbittask, 1 )
end

function lz:OnAfterMarkChanged(From,Event,To,Text,Keywords,Coord)
    _deustlog_info( 'LZ Mark Detected')

    deustTextToSpeechType('lz')

    local where = Coord:GetVec2()
    deust.fatcow.lz_coord = Coord
    local zone = ZONE_RADIUS:New('zone_lz', where, 100)

    Coord:SmokeBlue()

    if deust.fatcow.dead then
        _deustlog_info('Fat Cow unavailable')
        deustTextToSpeechType('mayday')
        MESSAGE:New('No more fat cow available. Last fat cow is dead.', 30, 'Fat Cow'):ToCoalition( coalition.side.BLUE )
        return
    end

    if deust.fatcow.group and deust.fatcow.onrtb then
        deust.fatcow.onrtb = false
        deust.fatcow.rtbScheduler:Stop()
        collectgarbage()
        _deustlog_info('Aborting RTB. Changing LZ to new position.')
        MESSAGE:New('Aborting RTB. New LZ marked.', 30, 'Fat Cow'):ToCoalition( coalition.side.BLUE )
        deust.fatcow.echoETA(Coord, 'New LZ')
        local landingtask = deust.fatcow.group:TaskLandAtVec2(where, 32000)
        deust.fatcow.group:SetTask( landingtask, 1 )
        _deustlog_info('Moving Chinook')

        deust.fatcow.landScheduler, deust.fatcow.landSchedulerCheck = SCHEDULER:New(deust.fatcow.group,
          function()
            _deustlog_debug('Checking Landing')
            if not deust.fatcow.group:IsAlive() then
                _deustlog_info('Fatcow dead')
                deust.fatcow.dead = true
                MESSAGE:New('Incoming Fat Cow dead', 30, 'Fat Cow'):ToCoalition( coalition.side.BLUE )
                SCHEDULER:Stop(deust.fatcow.landSchedulerCheck)
                return
            end
            if (deust.fatcow.group:AllOnGround())
            then
                deust.fatcow.FatCowEscortOrbitOnLZ(Coord)
                MESSAGE:New('Fat Cow has just reached LZ point.', 30, 'Fat Cow'):ToCoalition( coalition.side.BLUE )
                deust.buildFobFatcow(deust.fatcow.SpawnFOB,
                deust.fatcow.SpawnFuel,
                deust.fatcow.SpawnAmmo,
                deust.fatcow.SpawnTent,
                deust.fatcow.SpawnSoldier,
                deust.fatcow.group)
                SCHEDULER:Stop(deust.fatcow.landSchedulerCheck)
            end
          end, {}, 5, 10)
        return
    end

    if deust.fatcow.group then
        _deustlog_info('Fat Cow in flight. Changing LZ to new position.')
        MESSAGE:New('Fat Cow currently in flight. Changing LZ to new position.', 30, 'Fat Cow'):ToCoalition( coalition.side.BLUE )
        deust.fatcow.echoETA(Coord, 'New LZ')
        local landingtask = deust.fatcow.group:TaskLandAtVec2(where, 32000)
        deust.fatcow.group:SetTask( landingtask, 1 )
        _deustlog_info('Moving Chinook')
        return
    end
    deust.fatcow.group = SPAWN:New( deust.fatcow.groupName ):InitKeepUnitNames():InitAIOff():Spawn()
    deust.fatcow.FatCowEscort()
    deust.fatcow.group:OptionROTPassiveDefense()
    deust.fatcow.rtb = deust.fatcow.group:GetVec2()
    deust.fatcow.rtbcoord = deust.fatcow.group:GetCoordinate()
    deust.fatcow.rtb_zone = ZONE_RADIUS:New('zone_rtb', deust.fatcow.rtb, 100)

    MESSAGE:New(string.format('Fat Cow Requested'), 30, 'Fat Cow'):ToCoalition( coalition.side.BLUE )
    deust.fatcow.ETAtoLanding()

    if (_deustdebug)
    then
        zone:SmokeZone(SMOKECOLOR.Red)
    end

    for _, _word in pairs (Keywords) do
        _deustlog_info('Enabling Chinook')

        local landingtask = deust.fatcow.group:TaskLandAtVec2(where, 32000)
        deust.fatcow.group:SetTask( landingtask, 1 )
        _deustlog_info('Moving Chinook')

        -- land event
        deust.fatcow.landScheduler, deust.fatcow.landSchedulerCheck = SCHEDULER:New(deust.fatcow.group,
          function()
            _deustlog_debug('Checking Landing')
            if not deust.fatcow.group:IsAlive() then
                _deustlog_info('Fatcow dead')
                deust.fatcow.dead = true
                MESSAGE:New('Incoming Fat Cow dead', 30, 'Fat Cow'):ToCoalition( coalition.side.BLUE )
                SCHEDULER:Stop(deust.fatcow.landSchedulerCheck)
                return
            end

            if (deust.fatcow.group:AllOnGround())
            then
                deust.fatcow.FatCowEscortOrbitOnLZ(Coord)
                MESSAGE:New('Fat Cow has just reached LZ point.', 30, 'Fat Cow'):ToCoalition( coalition.side.BLUE )
                deustTextToSpeechType('lz_reached')
                deust.buildFobFatcow(deust.fatcow.SpawnFOB,
                deust.fatcow.SpawnFuel,
                deust.fatcow.SpawnAmmo,
                deust.fatcow.SpawnTent,
                deust.fatcow.SpawnSoldier,
                deust.fatcow.group)
                SCHEDULER:Stop(deust.fatcow.landSchedulerCheck)
            end
          end, {}, 5, 10)
    end
    collectgarbage()
end

deust.buildFobFatcow = function (StaticFOB, StaticFuel, StaticAmmo, StaticTent, StaticSoldier, GroupZone)
    -- MESSAGE:New( "Built confirmed", 25, "Fat Cow" ):ToCoalition( coalition.side.BLUE )

    -- move fob position
    local fobPosition = POINT_VEC2:NewFromVec2(GroupZone:GetVec2())
    fobPosition:AddY(25)
    table.insert(deust.fatcow.farp_statics, StaticFOB:SpawnFromPointVec2( fobPosition, 0 ))

    -- move position to avoid objects overlap
    local tentPosition = POINT_VEC2:NewFromVec2(GroupZone:GetVec2())
    tentPosition:AddX(-20)
    tentPosition:AddY(25)
    table.insert(deust.fatcow.farp_statics, StaticTent:SpawnFromPointVec2( tentPosition, 0 ))

    local fuelPosition = POINT_VEC2:NewFromVec2(GroupZone:GetVec2())
    fuelPosition:AddY(25)
    table.insert(deust.fatcow.farp_statics, StaticFuel:SpawnFromPointVec2( fuelPosition, 0 ))

    local AmmoPosition = POINT_VEC2:NewFromVec2(GroupZone:GetVec2())
    AmmoPosition:AddX(10)
    AmmoPosition:AddY(25)
    table.insert(deust.fatcow.farp_statics, StaticAmmo:SpawnFromPointVec2( AmmoPosition, 0 ))

    -- soldiers
    local soldierPosition = POINT_VEC2:NewFromVec2(GroupZone:GetVec2())
    soldierPosition:AddX(-20)
    soldierPosition:AddY(20)
    table.insert(deust.fatcow.farp_statics, StaticSoldier:SpawnFromPointVec2( soldierPosition, 270 ))
    soldierPosition:AddX(10)
    table.insert(deust.fatcow.farp_statics, StaticSoldier:SpawnFromPointVec2( soldierPosition, 270 ))

    soldierPosition:AddX(5)
    table.insert(deust.fatcow.farp_statics, StaticSoldier:SpawnFromPointVec2( soldierPosition, 270 ))

    soldierPosition:AddX(10)
    table.insert(deust.fatcow.farp_statics, StaticSoldier:SpawnFromPointVec2( soldierPosition, 270 ))
end

deust.destroyStatics = function(staticsTable)
    for count = 1, #staticsTable do
        staticsTable[count]:Destroy(false)
    end
    deust.fatcow.farp_statics = {}
end

deust.getHumanReadTime = function(seconds)
    local remaining_time = nil
    
    if seconds <= 0 then
        remaining_time = "00:00:00"
    else
      local hours = string.format("%02.f", math.floor(seconds/3600))
      local mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)))
      local secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60))
      remaining_time = hours.. ":" .. mins .. ":" ..secs
    end

    return remaining_time
  end

  _deustlog_info('[MODULE] Fat Cow loaded')

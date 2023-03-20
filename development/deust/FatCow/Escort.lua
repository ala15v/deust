deust.fatcow.FatCowEscort = function()
    -- TargetTypes: https://wiki.hoggitworld.com/view/DCS_enum_attributes
    local threats = {"Ground vehicles", "Helicopters"}
    if GROUP:FindByName(deust.fatcow.EscortGroupName) then
        if not deust.fatcow.EscortGroup then
            deust.fatcow.EscortGroup = SPAWN:New( deust.fatcow.EscortGroupName ):InitKeepUnitNames():InitAIOff():Spawn()
            _deustlog_info('Fat Cow Escort Spawned')
        end
        local task = deust.fatcow.EscortGroup:TaskEscort(deust.fatcow.group, POINT_VEC3:New( -50, 0 , 100 ), nil, UTILS.NMToMeters(10), threats)
        deust.fatcow.EscortGroup:SetTask( task, 3 )
        _deustlog_info('Fat Cow Escort Task Started')
    else
        _deustlog_warn('Fat Cow Escort Group not available')
    end
end

deust.fatcow.FatCowEscortOrbitOnLZ = function(Coord)
    if deust.fatcow.EscortGroup then
        _deustlog_info('Fat Cow Escort Orbit Started')
        local orbittask = deust.fatcow.EscortGroup:TaskOrbitCircleAtVec2(Coord:GetVec2(), 100, 90 / 1.9375)
        deust.fatcow.EscortGroup:SetTask( orbittask, 3 )
        deust.fatcow.EscortGroup:OptionAlarmStateRed()
        deust.fatcow.EscortGroup:OptionROEOpenFireWeaponFree()
    end
end

deust.fatcow.DestroyFatCowEscort = function()
    if deust.fatcow.EscortGroup then
        deust.fatcow.EscortGroup:Destroy(false)
        deust.fatcow.EscortGroup = nil
    end
end


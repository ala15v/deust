deust.fatcow.FatCowEscort = function()
    -- TargetTypes: https://wiki.hoggitworld.com/view/DCS_enum_attributes
    local threats = {"Ground vehicles", "Helicopters"}
    if GROUP:FindByName(deust.fatcow.escortGroupName) then
        deust.fatcow.EscortGroup = SPAWN:New( deust.fatcow.escortGroupName ):InitKeepUnitNames():InitAIOff():Spawn()
        local task = deust.fatcow.EscortGroup:TaskEscort(deust.fatcow.group, POINT_VEC3:New( -50, 0 , 100 ), nil, UTILS.NMToMeters(10), threats)
        deust.fatcow.EscortGroup:SetTask( task, 3 )
        _deustlog_info('Fat Cow Escort Spawned')
    else
        _deustlog_warn('Fat Cow Escort Group not available')
    end
end

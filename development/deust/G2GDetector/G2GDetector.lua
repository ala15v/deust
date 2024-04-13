do
    if not deust.G2GDetector.enabled then
        return
    end
    _deustlog_info('[MODULE] G2GDetector loading')



    G2GDetectorsSetGroup = SET_GROUP:New():FilterCategories("ground"):FilterStart()
    function G2GDetectorScanner()
        G2GDetectorsSetGroup = SET_GROUP:New():FilterCategories("ground"):FilterStart()

        G2GDetectorsSetGroup:ForEachGroup(function(Group)
            Group:OptionROTNoReaction()
        end)
        G2GDetectorsSetGroup:ForEachGroup(
            function(DetectorGroup)
                local firstUniteAlive = DetectorGroup:GetFirstUnitAlive()
                if firstUniteAlive and deust.utils.IsValueInTable(deust.G2GDetector.validTypes, firstUniteAlive:GetTypeName()) then
                    local ZoneName = DetectorGroup.GroupName
                    local Zone1 = ZONE_RADIUS:New(ZoneName, DetectorGroup:GetVec2(), deust.G2GDetector.Range)
                    local color
                    if DetectorGroup:GetCoalition() == coalition.side.BLUE then
                        color = {0,0,0.5}
                    else
                        color = {0.5,0,0}
                    end
                    Zone1:DrawZone(DetectorGroup:GetCoalition(), color, 1, color, 0.1, 0)
                    Zone1:Scan({Object.Category.UNIT},{Unit.Category.GROUND_UNIT})

                    Zone1:GetScannedSetGroup():FilterStart():ForEachGroupAnyInZone(Zone1, function(GroupInZone)
                        if GroupInZone:GetCoalition() ~=  DetectorGroup:GetCoalition() then
                            _deustlog_info('G2GDetectorScanner GroupInZone: ' .. GroupInZone.GroupName)
                            local coord = GroupInZone:GetCoordinate()
                            local markMessage = string.format('Detection Report of %s:\n\n%i units detected', DetectorGroup.GroupName, GroupInZone:CountAliveUnits())
                            local mark = MARKER:New(coord, markMessage):ToCoalition(DetectorGroup:GetCoalition())
                            mark:Remove(deust.G2GDetector.DetectionRefresh)
                        end
                    end)
                end
            end)
    end

    if G2GDetectorsSetGroup:Count() > 0 then
        Messager = SCHEDULER:New( nil,
        function()
            G2GDetectorScanner()
        end, 
        {}, 0, deust.G2GDetector.DetectionRefresh )
    end

    _deustlog_info('[MODULE] G2GDetector loaded')
end
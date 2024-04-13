do
    if not deust.persistence.enabled then
        return
    end
    _deustlog_info('[MODULE] Persistence loading')

    do
        deust.persistence.dummy = {}
        function deust.persistence:new(savepath, updateFrequency, saveFrequency)
            local obj = {}
            obj.saveFile = 'deust.persistence.lua'
            if savepath then
                obj.saveFile = savepath
            end

            if not updateFrequency then updateFrequency = deust.persistence.updateFrequency end
            if not saveFrequency then saveFrequency = deust.persistence.saveFrequency end
            
            obj.updateFrequency = updateFrequency
            obj.saveFrequency = saveFrequency
            
            self:log('Creating new Persistence object with updateFrequency:' .. tostring(updateFrequency) .. ' and saveFrequency:' .. tostring(saveFrequency) .. ' on file:' .. savepath, true)

            setmetatable(obj, self)
            self.__index = self
            return obj
        end

        function deust.persistence:init()
            timer.scheduleFunction(function(arg, time)
                self:log('Saving now on ' .. self.saveFile, true)
                self.saveToDisk(self)
                self:log('Saved :)', true)
                return time + self.saveFrequency
            end, nil, timer.getTime() + self.saveFrequency)
        end

        function deust.persistence:saveToDisk()
            local statedata = self:getData()
            deust.utils.saveTable(self.saveFile, 'deustPersistenceData', statedata)
        end

        function deust.persistence:loadFromDisk()
            self:log('Loading now from ' .. self.saveFile, true)
            deust.utils.loadTable(self.saveFile)
            if deustPersistenceData then
                self:log('Loaded :)', true)
                return deustPersistenceData
            end
        end

        function deust.persistence:getData()
            local states = {}
            local success, groups = pcall(self.getGroups, self)
            if success then
                states = {groups=groups}
            else
                _deustlog_error('deust.persistence:getData() on groups')
            end
            return states
        end

        function deust.persistence:getGroups()
            local groupSet = SET_GROUP:New():FilterCoalitions("blue"):FilterCategoryGround():FilterActive(true):FilterOnce()
            local groups = {}
            local units = {}
            local mustSave
            groups.blueGroups = {}

            groupSet:ForEachGroup(function(group)
                local unitsInGroup = nil
                unitsInGroup = group:GetUnits()
                mustSave = false
                for _i=1, #unitsInGroup do
                    local unit = unitsInGroup[_i]
                    if unit:IsAlive() then
                        local unitToInsert = {
                            name = unit:Name(),
                            skill = 'Average',
                            category = unit:GetCategoryName(),
                            type = unit:GetTypeName(),
                            country = unit:GetCountry(),
                            heading = unit:GetHeading(),
                            playerCanDrive = true,
                            x = unit:GetCoord().x,
                            y = unit:GetCoord().y,
                        }
                        table.insert(units, unitToInsert)
                        if unit:GetTypeName() == '1L13 EWR' then
                            mustSave = true
                        end
                    end
                end
                local routePointsToInsert = {}
                local success, mission = pcall(group.GetTaskMission, group)
                if success then
                    local routePoints = mission.route.points
                    for _point=1, #routePoints do
                        local pointToInsert = {
                            [_point] = routePoints[_point].task
                        }
                        table.insert(routePointsToInsert, pointToInsert)    
                    end
                end
                if mustSave then
                    table.insert(groups.blueGroups, {groupname = group.GroupName, units = units, tasks=routePointsToInsert})
                end
                routePointsToInsert = {}
                units = {}
            end)
            return groups
        end

        function deust.persistence:log(message, tofile)
            _deustlog_info('[PERSISTENCE] ' .. message, tofile)
        end
    end


    local filepath = 'deust.persistence.test.lua'
    if lfs then 
        local dir = lfs.writedir()..'Missions/Saves/'
        lfs.mkdir(dir)
        filepath = dir..filepath
    end

    DeustPersistence = deust.persistence:new(filepath, 10, 60)
    DeustPersistence:init()

    -- deust.persistence.enabled.saveTable(self.saveFile, 'zonePersistance', statedata)

    _deustlog_info('[MODULE] Persistence loaded')
end
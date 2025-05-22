_deustlog_info('[MODULE] Utils Misc loading')

deust.utils.navPoints = {}

function deust.utils.navPoints:new()
    local obj = {}
    obj.mission_nav_points = {}

    if debug then
        self.debug = true
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function deust.utils.navPoints:log(message)
    _deustlog_info("[navPoints]: " .. message)
end

function deust.utils.navPoints:split(str, delimiter)
    local result = {}
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result    
end

function deust.utils.navPoints:trim_quotes(str)
    return str:match('^"(.*)"$')
end

function deust.utils.navPoints:parse_nav_point(point)
    local nav_point = {}
    local id = point.id
    local name = point.callsignStr
    local vec2 = { x= point.x , y= point.y }

    nav_point = {}
    nav_point.name = name
    nav_point.id = id
    nav_point.vec2 = vec2

    local comment = point.comment
    local lines = self:split(comment, "\n")

    for _, line in ipairs(lines) do
        local key_value = self:split(line, "=")
        local key = key_value[1]
        local value = key_value[2]
        nav_point[key] = value
        self:log(key .. "=" .. value)
    end
    table.insert(self.mission_nav_points, nav_point)
end

function deust.utils.navPoints:process_nav_points()
    for _, point in pairs(env.mission.coalition.neutrals.nav_points) do
        local success, error = pcall(self.parse_nav_point, self, point)
        if error then
            self:log("ERROR en procesado de nav_point: " .. point.callsignStr)
        end
    end
end

function deust.utils.navPoints:existProperty_nav_points( key)
    local results = {}
    for _, table1 in ipairs(self.mission_nav_points) do
        for _, table2 in pairs(table1) do
            if table2[key] ~= nil then
                results[#results+1] = table1
            end
        end
    end
    return results
end

function deust.utils.navPoints:filter(key, value)
    local results = {}
    for _, table1 in ipairs(self.mission_nav_points) do
        if table1[key] == value then
            results[#results+1] = table1
        end
    end
    return results
end

_deustlog_info('[MODULE] Utils Misc loaded')
function CreateNameMGRS(prefix, coord)
    -- ANCHOR: Input validation
    local invalidInput = false

    if type(prefix) ~= "string" then
        invalidInput = true
    end
    if type(coord) ~= "table" or coord.ClassName ~= "COORDINATE" then
        invalidInput = true
    end

    -- ANCHOR: Start point
    if not invalidInput then
        local mgrs = {}
        for value in string.gmatch(coord:GetName(), "%S+") do
            table.insert(mgrs, value)
        end
        return mgrs[3] .. string.sub(mgrs[4], 1, 1) .. string.sub(mgrs[5], 1, 1) .. "_" .. prefix
    else
        env.error("Deust CreateNameMGRS: Invalid Input")
    end
end

deust.utils.CreateNameMGRS = true

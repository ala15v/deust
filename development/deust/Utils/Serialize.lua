_deustlog_info('[MODULE] Utils Serialize loading')

deust.utils = deust.utils or {}

deust.utils.lfsEnabled = true
if not lfs then
    deust.utils.lfsEnabled = false
    _deustlog_error('[MODULE] Utils Serialie lfs disabled')
    return
end

deust.utils.saveTable = function (filename, variablename, data)
    if not deust.utils.lfsEnabled then
        return
    end

    local str = variablename..' = {}'
    for i,v in pairs(data) do
        str = str..'\n'..variablename..'[\''..i..'\'] = '..deust.utils.serializeValue(v)
    end

    File = io.open(filename, "w")
    File:write(str)
    File:close()
end

deust.utils.serializeValue = function (value)
    local res = ''
    if type(value)=='number' or type(value)=='boolean' then
        res = res..tostring(value)
    elseif type(value)=='string' then
        res = res..'\''..value..'\''
    elseif type(value)=='table' then
        res = res..'{ '
        for i,v in pairs(value) do
            if type(i)=='number' then
                res = res..'['..i..']='..deust.utils.serializeValue(v)..','
            else
                res = res..'[\''..i..'\']='..deust.utils.serializeValue(v)..','
            end
        end
        res = res:sub(1,-2)
        res = res..' }'
    end
    return res
end

deust.utils.loadTable = function (filename)
    if not deust.utils.lfsEnabled then
        return
    end
    
    if lfs.attributes(filename) then
        dofile(filename)
    end
end

_deustlog_info('[MODULE] Utils Serialize loaded')
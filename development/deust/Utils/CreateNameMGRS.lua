

function CreateNameMGRS(prefix, coord)
    local mgrs = {}
    for value in string.gmatch(coord:GetName(), "%S+") do
        table.insert(mgrs, value)
    end
    return mgrs[3] .. string.sub(mgrs[4], 1, 1) .. string.sub(mgrs[5], 1, 1) .. "_" .. prefix
end


deust.utils.CreateNameMGRS = true
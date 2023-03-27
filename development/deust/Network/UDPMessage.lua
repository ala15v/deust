-- Get Zone Properties in order to get host and port


_deustlog_info('[MODULE] Network UDP Message loading')

deust.network.udp.createSocket = function()
    local deustZoneProperties = ZONE:FindByName('deust')
    if deustZoneProperties then
        local udp_host = deustZoneProperties:GetProperty('udp_host')
        local udp_port = deustZoneProperties:GetProperty('udp_port')

        if udp_host and udp_port then
            local udpSocket = SOCKET:New(tonumber(udp_port), udp_host)
            return udpSocket
        else
            return false
        end
    end
end

deust.network.sendMessage = function(from, message)
    local finalMessage = message
    finalMessage.from = from
    local UDPSocket = deust.network.udp.createSocket()
    if UDPSocket then
        UDPSocket:SendTable(finalMessage)
    else
        _deustlog_warn('[MODULE][UDPMessage] some error to create socket')
        return false
    end
end

_deustlog_info('[MODULE] Network UDP Message loaded')
_deustdebug = false

if _deustdebug then
    BASE:TraceOn()
    env.info('ALA15V DEUST DEBUG: DEBUG ENABLED')
end

function _deustlogfile(message)
    local logFile = io.open(lfs.writedir()..[[Logs\deust.log]], "a")
    local timestamp = os.date("*t")
    local timestampString = string.format("%02d:%02d:%02d %02d-%02d-%04d", timestamp.hour, timestamp.min, timestamp.sec, timestamp.day, timestamp.month, timestamp.year)

    if logFile then
        logFile:write(timestampString .. " " .. message .. "\n")
        logFile:flush()
        logFile:close()
    end
end


function _deustlog(level, message, tofile)
    local prefix = string.format('[ALA15V DEUST][%s]: ', string.upper(level))
    local fullmessage = string.format( '%s%s', prefix, message)
    if (level == 'info' and not tofile)
    then
        env.info(fullmessage)
    elseif (not tofile) then
        env.info(fullmessage)
    end
    _deustlogfile(fullmessage)
end

function _deustlog_info(message, tofile)
    _deustlog('INFO', message, tofile)
end

function _deustlog_warn(message, tofile)
    _deustlog('WARN', message, tofile)
end

function _deustlog_error(message, tofile)
    _deustlog('ERROR', message, tofile)
end

function _deustlog_debug(message, tofile)
    if _deustdebug then
        _deustlog( 'DEBUG', message, tofile )
    end
end

_deustlog_info('Initializing deust')


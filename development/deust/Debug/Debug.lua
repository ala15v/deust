_deustdebug = false

if _deustdebug then
    BASE:TraceOn()
    env.info('ALA15V DEUST DEBUG: DEBUG ENABLED')
end


function _deustlog(level, message)
    local prefix = string.format('ALA15V DEUST %s: ', string.upper(level))
    local fullmessage = string.format( '%s%s', prefix, message)
    if (level == 'info')
    then
        env.info(fullmessage)
    else
        env.info(fullmessage)
    end
end

function _deustlog_info(message)
    _deustlog('INFO', message)
end

function _deustlog_warn(message)
    _deustlog('WARN', message)
end

function _deustlog_error(message)
    _deustlog('ERROR', message)
end

function _deustlog_debug(message)
    if _deustdebug then
        _deustlog( 'DEBUG', message )
    end
end

_deustlog_info('Initializing deust')


_deustdebug = false

if _deustdebug then
    BASE:TraceOn()
end


function _deustlog(level, message)
    local prefix = string.format('[DEUST %s LOG]: ', string.upper(level))
    local fullmessage = string.format( '%s%s', prefix, message)
    if (level == 'info')
    then
        env.info(fullmessage)
    else
        env.info(fullmessage)
    end
end

function _deustlog_info(message)
    _deustlog('info', message)
end

function _deustlog_warn(message)
    _deustlog('warn', message)
end

function _deustlog_debug(message)
    if _deustdebug then
        _deustlog( 'debug', message )
    end
end

_deustlog_info('Initializing deust')


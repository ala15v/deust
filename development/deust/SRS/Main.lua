--------------------------------------
-- DETECT SRS Text-To-Speech Script --
--------------------------------------

if deust.SRS then
    _deustlog_info('Activando SRS')
    deust.SRS = true
end

function deustTextToSpeech(Message)
    if not deust.SRS then
        return
    end
    STTS.TextToSpeech(Message,
        deust.SRS_Tactical,
        deust.SRS_Modulation,
        deust.SRS_Volume,
        deust.SRS_Callsign,
        deust.SRS_Coalition,
        nil,
        deust.SRS_Speed,
        deust.SRS_Gender,
        deust.SRS_Language)
end

function deustTextToSpeechType(MessageType)
    local MessageClass = deust.SRS_TextCollection[MessageType]
    if not MessageClass then
        _deustlog_info('ERROR en deustTextToSpeech con MessageType: ' .. MessageType)
        return
    end
    local MessageToSpeech = UTILS.GetRandomTableElement(MessageClass)
    deustTextToSpeech(MessageToSpeech)

end

function deustTextToSpeechCustom(Message)
    deustTextToSpeech(Message)
end

--------------------------------
-- Text-To-Speech Collection  --
--------------------------------
deust.SRS_TextCollection = {
    lz = {
        'fat cau en camino, repito Fat Cau en camino. Prepárense. Necesitaremos la zona asegurada.',
        'Le envíamos una fat cau para munición y combustible. Prepárense. Necesitaremos la zona asegurada.',
    },
    rtb = {
        'fat cau volviendo a base. Buena suerte ahí fuera',
        'fat cau volviendo a base. Buena suerte'
    },
    lz_reached = {
        'Para toda la malla de fat cau. Acabamos de llegar a la l z designada.',
        'Para toda la malla de fat cau. Acabamos de llegar a la l z designada. Por favor desen prisa.',
    },
    eta = {
        'De fat cau, nuestro tiempo estimado de llegada es %s'
    },
    orbit = {
        'De fat cau. Afirmativo, permaneceremos en la zona orbitando'
    },
    mayday = {
        'mei dei, mei dei, mei dei, nos están atacando, caemos, envíen a alguien para rescatarnos',
        'súper 6 1 cayendo, repito, súper 6 1 cayendo, mei dei, mei dei'
    }
}
-- BASE:E(UTILS.GetRandomTableElement(deust.SRS_TextCollection.lz))


/*
** ClientXMPP.qml by undwad
** xmpp client object for qml
**
** https://github.com/undwad/qmlxmpp mailto:undwad@mail.ru
** see copyright notice in ./LICENCE
*/

import QtQuick 2.0
import atnix.web 1.0
import 'utils.js' as Utils

XMLProtocol
{
    id: _
    property string barejid: username + '@' + socket.host
    property string jid: barejid + '/' + resource
    property string username
    property string resource
    property string password
    property string email
    property string name
    property int connectInterval: 0
    property int pingInterval: 0

    opentags: ['stream:stream']

    property int sid: 0

    property var features

    signal error(var stanza)
    signal unknown(var stanza)
    signal connecting()
    signal established()
    signal presence(var stanza)
    signal message(var stanza)
    signal timeout()
    signal finished(var stanza)

    property var handler:
    {
        'stream:stream': function(){ },
        'stream:features': handleFeatures,
        proceed: socket.startClientEncryption,
        iq:
        {
            'ping': handlePing
        },
        message: message,
        presence: presence
    }

    onJidChanged:
    {
        var url = StringUtils.parseURL('jid://' + jid)
        socket.host = url.host
        username = url.userName
        resource = url.fileName
    }

    socket.onStateChanged:
    {
        if(SSLSocket.ConnectingState === socket.state && !connectInterval)
            connecting()
    }

    socket.onConnected:
    {
        socket.setSocketOption(SSLSocket.LowDelayOption, 1)
        socket.setSocketOption(SSLSocket.KeepAliveOption, 1)
        clear()
        reset()
        sendInit()
    }

    socket.onEncrypted:
    {
        reset()
        sendInit()
    }

    onTimeout: socket.abort()

    onReceived:
    {
        //object.prettyPrint()

        if('object' == typeof object)
        {
            if('stream:error' === object.$name || 'failure' === object.$name || 'error' === object.type)
            {
                object.$error = object.$name
                error(object)
            }

            if(object.$name in this.handler)
            {
                var handler = this.handler[object.$name]
                switch(typeof handler)
                {
                case 'function':
                    handler(object)
                    return
                case 'object':
                    if('id' in object && object.id in handler)
                    {
                        var id = object.id
                        var callback = handler[id]
                        if(callback) callback(object)
                        delete handler[id]
                        return
                    }
                    else
                    {
                        var handled = false
                        for(var key in object.$elements)
                        {
                            var name = object.$elements[key].$name
                            if(handled = name in handler)
                                handler[name](object)
                        }
                        if(handled)
                            return
                    }
                }
            }

            unknown(object)
        }
        else
            finished(object)
    }

    function translateError(error)
    {
        switch(error)
        {
        case 'bad-format': return qsTr('bad format')
        case 'bad-namespace-prefix': return qsTr('bad namespace prefix')
        case 'conflict': return qsTr('conflict')
        case 'host-gone': return qsTr('host gone')
        case 'host-unknown': return qsTr('unknown host')
        case 'improper-addressing': return qsTr('improper addressing')
        case 'invalid-from': return qsTr('invalid from')
        case 'invalid-namespace': return qsTr('invalid namespace')
        case 'invalid-xml': return qsTr('invalid xml')
        case 'not-authorized': return qsTr('not authorized')
        case 'not-well-formed': return qsTr('not well formed')
        case 'policy-violation': return qsTr('policy violation')
        case 'remote-connection-failed': return qsTr('remote connection failed')
        case 'reset': return qsTr('reset')
        case 'resource-constraint': return qsTr('resource constraint')
        case 'restricted-xml': return qsTr('restricted xml')
        case 'see-other-host': return qsTr('see other host')
        case 'system-shutdown': return qsTr('system shutdown')
        case 'undefined-condition': return qsTr('undefined condition')
        case 'unsupported-encoding': return qsTr('unsupported encoding')
        case 'unsupported-feature': return qsTr('unsupported feature')
        case 'unsupported-stanza-type': return qsTr('unsupported stanza type')
        case 'unsupported-version': return qsTr('unsupported version')
        case 'aborted': return qsTr('aborted')
        case 'account-disabled': return qsTr('account disabled')
        case 'credentials-expired': return qsTr('credentials expired')
        case 'encryption-required': return qsTr('encryption required')
        case 'incorrect-encoding': return qsTr('incorrect encoding')
        case 'invalid-authzid': return qsTr('invalid authzid')
        case 'invalid-mechanism': return qsTr('invalid mechanism')
        case 'malformed-request': return qsTr('malformed request')
        case 'mechanism-too-weak': return qsTr('mechanism too weak')
        case 'temporary-auth-failure': return qsTr('temporary auth failure')
        case 'resource-constraint': return qsTr('resource constraint')
        case 'not-allowed': return qsTr('not allowed')
        case 'bad-request': return qsTr('bad request')
        case 'not-acceptable': return qsTr('not acceptable')
        case 'item-not-found': return qsTr('item not found')
        case 'remote-server-not-found': return qsTr('remote server not found')
        case 'gone': return qsTr('gone')
        case 'forbidden': return qsTr('forbidden')
        case 'unsupported': return qsTr('unsupported')
        case 'payment-required': return qsTr('payment required')
        case 'policy-violation': return qsTr('policy violation')
        case 'feature-not-implemented': return qsTr('feature not implemented')
        case 'unexpected-request': return qsTr('unexpected request')
        case 'service-unavailable': return qsTr('service unavailable')
        //case '': return qsTr('')
        case 'unknown-error': return qsTr('unknown error')
        default: return error
        }
    }

    function parseErrorTag(tag)
    {
        var error = translateError(Utils.getNestedValue(tag, '$elements', 0, '$name') || 'unknown-error')
        var extra = Utils.getNestedValue(tag, '$elements', Utils.toObject.bind(null, '$name'), 'text', '$value')
        if(extra) error = '%1 (%2)'.arg(error).arg(extra)
        return error
    }

    function parseError(stanza)
    {
        switch(stanza.$error)
        {
        case 'stream:error':
        case 'failure':
            return parseErrorTag(stanza)
        case 'iq':
        case 'message':
        case 'presence':
            return parseErrorTag(Utils.getNestedValue(stanza, '$elements', Utils.toObject.bind(null, '$name'), 'error'))
        default: return qsTr('unknown error')
        }
    }

    function ifNotError(action, stanza) { if(!('$error' in stanza)) return action() }
    function bindIfNotError(action) { return ifNotError.bind(null, action) }

    function sendInit()
    {
        send({
                 $name: 'stream:stream',
                 from: jid,
                 to: socket.host,
                 version: '1.0',
                 'xml:lang': 'en',
                 xmlns: 'jabber:client',
                 'xmlns:stream': 'http://etherx.jabber.org/streams'
             }, false)
    }

    function sendStartTLS()
    {
        send({
                 $name: 'starttls',
                 xmlns: 'urn:ietf:params:xml:ns:xmpp-tls'
             })
    }

    function setAuthCallbackChain(callback)
    {
        handler.failure = callback
        handler.success = function(result)
        {
            if('$error' in result)
                callback(result)
            else
                sendBindResource(function(result)
                {
                    if('$error' in result)
                        callback(result)
                    else
                        sendStartSession(callback)
                })
        }
    }

    function sendAnonAuth(callback)
    {
        setAuthCallbackChain(callback)
        send({
                 $name: 'auth',
                 xmlns: 'urn:ietf:params:xml:ns:xmpp-sasl',
                 mechanism: 'ANONYMOUS'
             })
    }

    function sendPlainAuth(callback)
    {
        setAuthCallbackChain(callback)
        send({
                 $name: 'auth',
                 xmlns: 'urn:ietf:params:xml:ns:xmpp-sasl',
                 mechanism: 'PLAIN',
                 $value: StringUtils.toBase64('\0' + username + '\0' + password)
             })
    }

    function clear(handler)
    {
        handler = handler || this.handler
        for(var key in handler)
        {
            if('#' === key[0])
                delete handler[key]
            else
            {
                var item = handler[key]
                if('object' == typeof item)
                    clear(item)
            }
        }
    }

    function nextsid() { return '#' + sid++ }

    function sendIQ(object, callback)
    {
        var id = nextsid()
        object.$name = 'iq'
        object.id = id
        handler.iq[id] = callback
        send(object)
        return id
    }

    function sendBindResource(callback)
    {
        return sendIQ({
                          type: 'set',
                          bind$:
                          {
                              xmlns: 'urn:ietf:params:xml:ns:xmpp-bind',
                              resource$: resource
                          }
                      }, callback)
    }

    function sendStartSession(callback)
    {
        return sendIQ({
                          type: 'set',
                          session$: { xmlns: 'urn:ietf:params:xml:ns:xmpp-session' }
                      }, callback)
    }

    function sendPing(to, callback)
    {
        return sendIQ({
                          from: jid,
                          to: to,
                          type: 'get',
                          ping$: { xmlns: 'urn:xmpp:ping' }
                      }, callback)
    }

    function sendPresence(show, status)
    {
        show = show || 'unavailable'
        if('unavailable' === show)
            send({
                     $name: 'presence',
                     type: 'unavailable'
                 })
        else
            send({
                     $name: 'presence',
                     show: show,
                     status: status
                 })
    }

    function sendRegistration(callback)
    {
        return sendIQ({
                          type: 'set',
                          query$:
                          {
                              xmlns: 'jabber:iq:register',
                              username$: username,
                              password$: password,
                              email$: email,
                              name$: name
                          }
                      }, callback)
    }

    function sendGetRegistration(callback)
    {
        return sendIQ({
                          type: 'get',
                          query$: { xmlns: 'jabber:iq:register' }
                      }, callback)
    }

    function sendDiscoItems(to, callback)
    {
        return sendIQ({
                          from: jid,
                          to: to,
                          type: 'get',
                          query$: { xmlns: 'http://jabber.org/protocol/disco#items' }
                      }, callback)
    }

    function sendDiscoInfo(to, callback)
    {
        return sendIQ({
                          from: jid,
                          to: to,
                          type: 'get',
                          query$: { xmlns: 'http://jabber.org/protocol/disco#info' }
                      }, callback)
    }

    function sendMessage(to, text, type, lang)
    {
        send({
                 $name: 'message',
                 from: jid,
                 to: to,
                 type: type || 'chat',
                 'xml:lang': lang || 'en',
                 body$: text
             })
    }

    function handleFeatures(object)
    {
        features = Utils.toObject('$name', object.$elements)
        if(!socket.isEncrypted)
        {
            if('starttls' in features) sendStartTLS()
            else throw 'starttls is not supported by server'
        }
        else established()
    }

    function handlePing(object) { send({ $name: 'iq', from: jid, to: socket.host, id: object.id, type: 'result' }) }

    Timer
    {
        repeat: true
        interval: connectInterval * 1000
        triggeredOnStart: true
        running: connectInterval > 0

        onTriggered:
        {
            if(SSLSocket.UnconnectedState === socket.state)
            {
                connecting()
                socket.connect()
            }
        }
    }

    Timer
    {
        repeat: true
        interval: pingInterval * 1000
        running: pingInterval > 0
        property string sid

        onTriggered:
        {
            if(SSLSocket.ConnectedState === socket.state)
            {
                if(sid && sid in handler.iq)
                {
                    stop()
                    timeout()
                }
                else
                    sid = _.sendPing(_.socket.host)
            }
        }
    }
}






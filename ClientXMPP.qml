/*
** XMPPClient.qml by undwad
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
    id: root
    property string jid
    property string barejid
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
    property var items

    signal error(var stanza)
    signal unknown(var stanza)
    signal connecting()
    signal established()
    signal registred()
    signal authenticated()
    signal discovered()
    signal presence(var stanza)
    signal message(var stanza)
    signal timeout()

    property var handler:
    {
        'stream:stream': function(){ },
        'stream:features': handleFeatures,
        failure: error,
        proceed: socket.startClientEncryption,
        success: sendBindResource,
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
        barejid = username + '@' + socket.host
    }

    socket.onStateChanged:
    {
        if(SSLSocket.ConnectingState === socket.state)
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
        //Utils.prettyPrint(object)

        var name = object.$name

        if('failure' === name || ('type' in object && 'error' === object.type))
            error(object)

        if(name in this.handler)
        {
            var handler = this.handler[name]
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

    function sendAnonAuth()
    {
        send({
                 $name: 'auth',
                 xmlns: 'urn:ietf:params:xml:ns:xmpp-sasl',
                 mechanism: 'ANONYMOUS'
             })
    }

    function sendPlainAuth()
    {
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

    function sendBindResource()
    {
        return sendIQ({
                          type: 'set',
                          bind$:
                          {
                              xmlns: 'urn:ietf:params:xml:ns:xmpp-bind',
                              resource$: resource
                          }
                      }, sendStartSession)
    }

    function sendStartSession()
    {
        return sendIQ({
                          type: 'set',
                          session$: { xmlns: 'urn:ietf:params:xml:ns:xmpp-session' }
                      }, authenticated)
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

    function sendRegistration()
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
                      }, function(result)
                      {
                          if('result' === result.type)
                            registred()
                      })
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
                          to: to || socket.host,
                          type: 'get',
                          query$: { xmlns: 'http://jabber.org/protocol/disco#items' }
                      }, callback || function(result)
                      {
                          if('result' === result.type)
                          {
                              var query = Utils.toObject(result.$elements, '$name').query
                              items = Utils.toObject(query.$elements, 'jid')
                              discovered()
                          }
                      })
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
        features = Utils.toObject(object.$elements, '$name')
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
        id: connectTimer
        repeat: true
        interval: connectInterval * 1000
        triggeredOnStart: true
        running: connectInterval > 0

        onTriggered:
        {
            if(SSLSocket.UnconnectedState === socket.state)
                socket.connect()
        }
    }

    Timer
    {
        id: pingTimer
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
                    sid = root.sendPing(root.socket.host)
            }
        }
    }
}






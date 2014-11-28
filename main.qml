import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0
import atnix.web 1.0
import 'utils.js' as Utils

Rectangle
{
    id: _
    width: 400
    height: 600

    Presets { id: _presets }

    ClientMicroBlog
    {
        id: _xmpp
        resource: _presets.appName
        socket.host: 'jabber.integra-s.com'
        socket.port: 5222
        socket.protocol: SSLSocket.SslV3
        connectInterval: 5
        pubsubjid: 'pubsub.jabber.integra-s.com'

        socket.onConnected: socket.ignoreSslErrors()

        onConnecting: _waiter.wait()
        onEstablished:
        {
            _waiter.stop()
            //if(!_enter.visible)

        }

        socket.onError: print('SOCKET ERROR', socket.error)
        onXmlError: print('XML ERROR', error)
        onError: print('ERROR', Utils.toPrettyString(stanza))

        socket.onEncrypted: print("ENCRYPTED")
        socket.onReadyRead: print("READ", socket.bytesAvailable)
        socket.onBytesWritten: print("WRITTEN", bytes)
        socket.onDisconnected: print('DISCONNECTED')
        onTimeout: print('TIMEOUT')
        onFinished: print('FINISHED', stanza)

        onMessage: if(!isError(stanza)) print('MESSAGE', Utils.toPrettyString(stanza))
        onPresence: if(!isError(stanza)) print('PRESENCE', Utils.toPrettyString(stanza))
        onUnknown: print('UNKNOWN', Utils.toPrettyString(stanza))
    }

    Image
    {
        anchors.fill: parent
        source: 'images/background.jpg'
        fillMode: Image.PreserveAspectFit
    }

    FormEnter
    {
        id: _enter
        client: _xmpp
        waiting: _waiter.waiting

        onLogin:
        {
            _xmpp.username = front.username
            _xmpp.password = front.password
            _.login()
        }

        onRegister:
        {
            _xmpp.username = back.username
            _xmpp.password = back.password
            _xmpp.email = back.email
            _xmpp.name = back.name
            _xmpp.sendRegistration(function(result)
            {
                Utils.prettyPrint(result)
            })
        }
    }

    FormProblem
    {
        id: _problem
        interval: _xmpp.connectInterval
    }

    ControlWaiting
    {
        id: _waiter
        onAttemptsChanged:
        {
            if(attempts > 3)
            {
                _problem.show(qsTr('service temporary unavailable'))
                attempts = 0
            }
        }
    }

    function login()
    {
        _xmpp.sendPlainAuth(function(result)
        {
            if(!_xmpp.isError(result))
                _enter.hide()
        })
    }

    Button
    {
        text: 'JODER'
        anchors.bottom: parent.bottom
        onClicked: _enter.show()
    }

    Component.onCompleted:
    {

    }
}


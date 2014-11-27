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
        socket.port: 5224
        socket.protocol: SSLSocket.SslV3
        connectInterval: 5
        pubsubjid: 'pubsub.jabber.integra-s.com'

        socket.onConnected: socket.ignoreSslErrors()

        onConnecting: _waiter.wait()
        onEstablished: _waiter.stop()

        socket.onError: print('SOCKET ERROR', socket.error)
        onXmlError: print('XML ERROR', error)
        onError: print('ERROR', Utils.toPrettyString(stanza))

        socket.onEncrypted: print("ENCRYPTED")
        socket.onReadyRead: print("READ", socket.bytesAvailable)
        socket.onBytesWritten: print("WRITTEN", bytes)
        socket.onDisconnected: print('DISCONNECTED')
        onTimeout: print('TIMEOUT')

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
        waiting: _waiter.waiting
    }

    FormProblem { id: _problem }

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
}

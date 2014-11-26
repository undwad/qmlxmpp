/*
** main.qml by undwad
** micro blogging xmpp qml client
**
** https://github.com/undwad/qmlxmpp mailto:undwad@mail.ru
** see copyright notice in ./LICENCE
*/

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

        onConnecting: _entrance.front.waiting = _entrance.back.waiting = true
        onEstablished: _entrance.front.waiting = _entrance.back.waiting = false

        socket.onError: print('SOCKET ERROR', socket.error)
        onError: print('ERROR', Utils.toPrettyString(stanza))
        onXmlError: print('XML ERROR', error)

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

    Flipable
    {
        id: _entrance
        anchors.fill: parent

        property bool flipped: false

        front: FormLogin
        {
            id: _login
            onLogin: print('LOGIN', username, password)
            onRegister: _entrance.flipped = true

            Settings
            {
                category: "login"
                property alias username: _login.username
                property alias password: _login.password
            }
        }

        back: FormProfile
        {
            id: _profile
            onRegister: print('REGISTER', username, password, email, name, info)
            onBack: _entrance.flipped = false
        }

        transform: Rotation
        {
            id: _rotation
            origin.x: _.width / 2
            origin.y: _.height / 2
            axis.x: 0; axis.y: 1; axis.z: 0
            angle: 0
        }

        states: State
        {
            PropertyChanges { target: _rotation; angle: 180 }
            when: _entrance.flipped
        }

        transitions: Transition { NumberAnimation { target: _rotation; property: "angle"; duration: 500 } }
    }
}


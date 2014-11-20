import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import atnix.web 1.0

Window
{
    width: 300
    height: 600
    visible: true

    DNSResolver
    {
        host: 'jabber.integra-s.com'
        onResolved: print(host, ':', addresses)
        onFailed: print(error)
    }

    XMPPClient
    {
        id: xmpp
        jid: from.text
        password: password.text
        email: email.text
        name: name.text
        socket.port: 5222
        socket.protocol: SSLSocket.SslV3
        connectInterval: 5
        //pingInterval: 5

        socket.onConnected:
        {
            print("CONNECTED");
            socket.ignoreSslErrors()
        }

        socket.onEncrypted: print("ENCRYPTED")
        socket.onReadyRead: print("READ", socket.bytesAvailable)
        socket.onBytesWritten: print("WRITTEN", bytes)
        socket.onDisconnected: print('DISCONNECTED')
        socket.onError: print('SOCKET ERROR', socket.error)

        onEstablished: print('ESTABLISHED')
        onRegistred: print('REGISTRED')
        onAuthenticated: print('AUTHENTICATED')
        onTimeout: print('TIMEOUT')
        onMessage: print('MESSAGE', stanza.stringify())
        onPresence: print('PRESENCE', stanza.stringify())
        onUnknown: print('UNKNOWN', stanza.stringify())
        onFailure: print('FAILURE', stanza.stringify())
        onError: print('XML ERROR', error)
    }

    ListView
    {
        id: list
        spacing: 5
        orientation: ListView.Vertical
        anchors.fill: parent
        model: VisualItemModel
        {
            RowLayout { Text { text: 'user jid:' } TextInput { id: from; text: 'undwad2@jabber.integra-s.com' } }
            RowLayout { Text { text: 'user password:' } TextInput { id: password; echoMode: TextInput.PasswordEchoOnEdit; text: 'ilcleo2';  } }
            RowLayout { Text { text: 'user email:' } TextInput { id: email; text: 'undwad@mail.ru' } }
            RowLayout { Text { text: 'user name:' } TextInput { id: name; text: 'Ушат Помоев' } }
            RowLayout { Text { text: 'recipient jid:' } TextInput { id: to; text: 'undwad@jabber.integra-s.com' } }
            RowLayout { Text { text: 'message/status:' } TextInput { id: msg; text: 'хуй гортензия' } }
            Button { text: 'registration'; onClicked: xmpp.sendRegistration() }
            Button { text: 'authenticate'; onClicked: xmpp.sendPlainAuth() }
            Button { text: 'ping'; onClicked: xmpp.sendPing(to.text, function(result){ print('PONG', result.from, 'result' === result.type) }) }
            ComboBox { model: ListModel { ListElement { text: "unavailable" } ListElement { text: "chat" } ListElement { text: "away" } ListElement { text: "xa" } ListElement { text: "dnd" } } onCurrentTextChanged: xmpp.sendPresence(currentText) }
            Button { text: 'message'; onClicked: xmpp.sendMessage(to.text, msg.text) }
        }
    }
}


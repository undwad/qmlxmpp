/*
** sample.qml by undwad
** xmpp client for qml example
**
** https://github.com/undwad/qmlxmpp mailto:undwad@mail.ru
** see copyright notice in ./LICENCE
*/

import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import 'utils.js' as Utils
import atnix.web 1.0

Window
{
    width: 300
    height: 800
    visible: true

    DNSResolver
    {
        host: 'jabber.org'
        onResolved: print(host, ':', addresses)
        onFailed: print(error)
    }

    PubSubClient
    {
        id: xmpp
        jid: from.text
        password: password.text
        email: email.text
        name: name.text
        socket.port: 5222
        socket.protocol: SSLSocket.SslV3

        pubsubjid: pubsub.text

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
        onDiscovered:
        {
            print('DISCOVERED')
            itemlist.model.clear()
            for(var jid in items)
                itemlist.model.append({text: items[jid].name, jid: jid})
        }
        onMessage: print('MESSAGE', Utils.toPrettyString(stanza))
        onPresence: print('PRESENCE', Utils.toPrettyString(stanza))

        onUnknown: print('UNKNOWN', Utils.toPrettyString(stanza))
        onError: print('ERROR', Utils.toPrettyString(stanza.stringify))
        onXmlError: print('XML ERROR', error)
        onTimeout: print('TIMEOUT')
    }

    ColumnLayout
    {
        anchors.fill: parent
        RowLayout { Text { text: 'user jid:' } TextInput { id: from; text: 'undwad2@jabber.integra-s.com' } }
        RowLayout { Text { text: 'user password:' } TextInput { id: password; echoMode: TextInput.PasswordEchoOnEdit; text: '21345678';  } }
        RowLayout { Text { text: 'user email:' } TextInput { id: email; text: 'undwad@mail.ru' } }
        RowLayout { Text { text: 'user name:' } TextInput { id: name; text: 'Ушат Помоев' } }
        RowLayout { Text { text: 'recipient jid:' } TextInput { id: to; text: 'undwad@jabber.integra-s.com' } }
        RowLayout { Text { text: 'message/status:' } TextInput { id: msg; text: 'хуй гортензия' } }
        CheckBox { text: 'autoconnect'; onCheckedChanged: xmpp.connectInterval = checked ? 5 : 0 }
        CheckBox { text: 'autoping'; onCheckedChanged: xmpp.pingInterval = checked ? 5 : 0 }
        Button { text: 'registration'; onClicked: xmpp.sendRegistration() }
        RowLayout { Text { text: 'auth:' } Button { text: 'plain'; onClicked: xmpp.sendPlainAuth() } Button { text: 'anon'; onClicked: xmpp.sendAnonAuth() } }
        Button { text: 'ping'; onClicked: xmpp.sendPing(to.text, function(result){ print('PONG', result.from, 'result' === result.type) }) }
        ComboBox { model: ListModel { ListElement { text: "unavailable" } ListElement { text: "chat" } ListElement { text: "away" } ListElement { text: "xa" } ListElement { text: "dnd" } } onCurrentTextChanged: xmpp.sendPresence(currentText) }
        Button { text: 'message'; onClicked: xmpp.sendMessage(to.text, msg.text) }
        Button { text: 'discover items'; onClicked: xmpp.sendDiscoItems() }
        RowLayout { Text { text: 'items:' } ComboBox { id: itemlist; model: ListModel { ListElement { text: "no discovered items" } } onCurrentIndexChanged: xmpp.sendDiscoInfo(model.get(currentIndex).jid, printResult) } }
        RowLayout { Text { text: 'pubsub jid:' } TextInput { id: pubsub; text: 'pubsub.jabber.integra-s.com' } }
        Button { text: 'discover pubsub'; onClicked: xmpp.sendDiscoItems(pubsub.text, function(result){
            topnodes.model.clear()
            var query = Utils.toObject(result.$elements, '$name').query
            if('$elements' in query)
            {
                var items = Utils.toObject(query.$elements, 'node')
                for(var node in items)
                    topnodes.model.append({text: '%1(%2)'.arg(items[node].name).arg(node), node: node})
            }
        })}
        RowLayout { Text { text: 'items:' } ComboBox { id: topnodes; model: ListModel { ListElement { text: "no discovered nodes" } } } }
        RowLayout { Text { text: 'node:' } TextInput { id: nodeid; text: 'samplenode' } Text { text: 'name:' } TextInput { id: nodename; text: 'sample node' } }
        Button { text: 'create node'; onClicked: xmpp.sendCreateNode(nodeid.text, {
                                                                         'pubsub#title': nodename.text
                                                                     }, printResult) }
        Button { text: 'get node cfg'; onClicked: xmpp.sendGetNodeConfig(nodeid.text, printResult) }
        Button { text: 'delete node'; onClicked: xmpp.sendDeleteNode(nodeid.text, printResult) }
        Button { text: 'disconnect'; onClicked: xmpp.socket.disconnect() }
    }

    function printResult(result) { Utils.prettyPrint(result) }
}

/*
 */

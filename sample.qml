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

    ClientPubSub
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

        onConnecting: print('CONNECTING')
        onEstablished: print('ESTABLISHED')
        onMessage: if(!('$error' in stanza)) print('MESSAGE', Utils.toPrettyString(stanza))
        onPresence: if(!('$error' in stanza)) print('PRESENCE', Utils.toPrettyString(stanza))

        onUnknown: print('UNKNOWN', Utils.toPrettyString(stanza))
        onError: print('ERROR', Utils.toPrettyString(stanza))
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
        RowLayout { Button { text: 'registration'; onClicked: xmpp.sendRegistration(printResult) } Button { text: 'info'; onClicked: xmpp.sendGetRegistration(printResult) } }
        RowLayout { Text { text: 'auth:' } Button { text: 'plain'; onClicked: xmpp.sendPlainAuth(printResult) } Button { text: 'anon'; onClicked: xmpp.sendAnonAuth(printResult) } }
        Button { text: 'ping'; onClicked: xmpp.sendPing(to.text, function(result){ print('PONG', result.from, 'result' === result.type) }) }
        ComboBox { model: ListModel { ListElement { text: "unavailable" } ListElement { text: "chat" } ListElement { text: "away" } ListElement { text: "xa" } ListElement { text: "dnd" } } onCurrentTextChanged: xmpp.sendPresence(currentText) }
        Button { text: 'message'; onClicked: xmpp.sendMessage(to.text, msg.text) }
        Button { text: 'discover items'; onClicked: xmpp.sendDiscoItems(xmpp.socket.host, function(result)
        {
            var query = Utils.toObject('$name', result.$elements).query
            var items = Utils.toObject('jid', query.$elements)
            itemlist.model.clear()
            for(var jid in items)
                itemlist.model.append({text: items[jid].name, jid: jid})
        }) }
        RowLayout { Text { text: 'items:' } ComboBox { id: itemlist; model: ListModel { ListElement { text: "no discovered items" } } onCurrentIndexChanged: xmpp.sendDiscoInfo(model.get(currentIndex).jid, printResult) } }
        RowLayout { Text { text: 'pubsub jid:' } TextInput { id: pubsub; text: 'pubsub.jabber.integra-s.com' } }
        Button { text: 'discover pubsub'; onClicked: xmpp.sendDiscoItems(pubsub.text, function(result){
            topnodes.model.clear()
            var query = Utils.toObject('$name', result.$elements).query
            if('$elements' in query)
            {
                var items = Utils.toObject('node', query.$elements)
                for(var node in items)
                    topnodes.model.append({text: '%1(%2)'.arg(items[node].name).arg(node), node: node})
            }
        })}
        RowLayout { Text { text: 'items:' } ComboBox { id: topnodes; model: ListModel { ListElement { text: "no discovered nodes" } } } }
        RowLayout { Text { text: 'node:' } TextInput { id: node; text: 'samplenode' } Text { text: 'name:' } TextInput { id: nodeTitle; text: 'sample node' } TextInput { id: nodeDescription; text: 'sample description for sample node' } }
        Button { text: 'create node'; onClicked: xmpp.sendCreateNode(node.text, {
                                                                         'pubsub#title': nodeTitle.text, // Short name for the node
                                                                         'pubsub#description': nodeDescription.text, // Description of the node
                                                                         'pubsub#node_type': 'leaf', // (leaf|collection) Whether the node is a leaf (default) or a collection
//                                                                         'pubsub#collection': 'collection', // The collection with which a node is affiliated
                                                                         'pubsub#subscribe': 1, // (1|0) Allow subscriptions to node
                                                                         'pubsub#subscription_required': 0, // (0|1) New subscriptions require configuration
                                                                         'pubsub#deliver_payloads': 0, // (1|0) Deliver payloads with event notifications
                                                                         'pubsub#notify_config': 0, // (1|0) Notify subscribers when the node configuration changes
                                                                         'pubsub#notify_delete': 0, // (1|0) Notify subscribers when the node is deleted
                                                                         'pubsub#notify_retract': 0, // (1|0) Notify subscribers when items are removed from the node
                                                                         'pubsub#presence_based_delivery': 0, // (0|1) Only deliver notifications to available users
//                                                                         'pubsub#type': '', // Type of payload data to be provided at this node
//                                                                         'pubsub#body_xslt': '', // Message body XSLT
//                                                                         'pubsub#dataform_xslt': '', // Payload XSLT
                                                                         'pubsub#access_model': 'open', // (open|authorize|presence|roster|whitelist) Specify who may subscribe and retrieve items
                                                                         'pubsub#publish_model': 'open', // (publishers|subscribers|open) Publisher model
//                                                                         'pubsub#roster_groups_allowed': [], // [groups] Roster groups allowed to subscribe
//                                                                         'pubsub#contact': [], // [jids] People to contact with questions
//                                                                         'pubsub#language': 'English', // (English|...) Default language
//                                                                         'pubsub#owner': [from.text, to.text], // [jids] Node owners
//                                                                         'pubsub#publisher': [], // [jids] Node publishers
//                                                                         'pubsub#itemreply': 'owner', // (owner|publisher) Select entity that should receive replies to items
//                                                                         'pubsub#replyroom': [], // [jids] Multi-user chat room to which replies should be sent
//                                                                         'pubsub#send_item_subscribe': 1, // (1|0) Send items to new subscribers
                                                                         'pubsub#persist_items': 1, // (0|1) Persist items to storage
                                                                         'pubsub#max_items': -1, // Max number of items to persist
                                                                         'pubsub#max_payload_size': 5120, // Max payload size in bytes
                                                                     }, printResult) }
        Button { text: 'get node cfg'; onClicked: xmpp.sendGetNodeConfig(topnodes.model.get(topnodes.currentText).node, printResult) }
        Button { text: 'delete node'; onClicked: xmpp.sendDeleteNode(topnodes.model.get(topnodes.currentText).node, printResult) }
        Button { text: 'get subscriptions'; onClicked: xmpp.sendGetNodeSubscriptions(topnodes.model.get(topnodes.currentText).node, printResult) }
        Button { text: 'subscribe node'; onClicked: xmpp.sendSubscribeToNode(topnodes.model.get(topnodes.currentText).node, printResult) }
        Button { text: 'unsubscribe node'; onClicked: xmpp.sendUnsubscribeFromNode(topnodes.model.get(topnodes.currentText).node, null, printResult) }
        Button { text: 'disconnect'; onClicked: xmpp.socket.disconnect() }
    }

    function printResult(result) { Utils.prettyPrint(result) }
}

/*
 */

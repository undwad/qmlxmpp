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

    ColumnLayout
    {
        anchors.fill: parent
        //RowLayout { Text { text: 'user jid:' } TextInput { id: from; text: 'undwad2@jabber.integra-s.com' } }
        Button { text: 'joder'; onClicked:
            {

                AsyncUtils.defer(2000, false)
                AsyncUtils.defer(2000, function(){ print('JODER') }) }
            }
    }
}

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
    id: _
    width: 600
    height: 800
    visible: true

    FormOAuth2
    {
        id: _oauth2
        onLogin:
        {
            hide()
            Utils.prettyPrint(credentials)
        }
    }

    ControlWaiting { waiting: _oauth2.loading }
}

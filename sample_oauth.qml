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

    property string token

    FormOAuth2
    {
        id: _oauth2


        onLoggedIn:
        {
            hide()
            _.token = token
            Utils.prettyPrint(token)
        }
    }

    ControlWaiting { waiting: _oauth2.loading }

    Button
    {
        text: 'JODER'
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        onClicked:
        {
            var req = new XMLHttpRequest()
            req.open('GET', 'https://zalupa.org/login', true)
            req.onreadystatechange=function()
            {
                if (XMLHttpRequest.HEADERS_RECEIVED === req.readyState)
                      print(req.getAllResponseHeaders());
                else if(XMLHttpRequest.DONE === req.readyState)
                {
                    print('status', req.statusText)
                    print('response', req.responseText)
                }
            }
            req.send('token=' + token)
        }
    }
}

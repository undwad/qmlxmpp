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
            token.prettyPrint()
        }
    }

    ControlWaiting { waiting: _oauth2.loading }

    HTTPClient
    {
        id: _http
        onNetworkAccessibleChanged: print('accessible', HTTPClient.Accessible === networkAccessible)
        onSslErrors: print('SSL ERRORS', errors)
    }

    ColumnLayout
    {
        Button { text: 'login'; onClicked: _oauth2.show() }
        Button { text: 'test error1'; onClicked: _http.get(HTTPClient.NormalPriority, 'https://zalupa.org1', {}, httpRequestCallback) }
        Button { text: 'test error2'; onClicked: _http.get(HTTPClient.NormalPriority, 'https://zalupa.org/login1', {}, httpRequestCallback) }
        Button { text: 'test error3'; onClicked: _http.get(HTTPClient.NormalPriority, 'https://zalupa.org/login?token=' + token + '1', {}, httpRequestCallback) }
        Button { text: 'test success'; onClicked: _http.get(HTTPClient.NormalPriority, 'http://ibn.integra-s.com:8888/files/getnested.lua', {}, httpRequestCallback) }
        Button { text: 'test url'; onClicked: StringUtils.parseURL('http://host:port/path?param1=1#param2=2').prettyPrint() }

    }

    function httpRequestCallback(headers, data)
    {
        if(headers)
        {
            if('content-type' in headers)
            {
                print('JODER')
                headers.prettyPrint()
                print(data)
            }
        }
        else
            print('ERROR', data)
    }

    Component.onCompleted:
    {
    }
}

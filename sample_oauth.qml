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
import QtWebKit 3.0
import QtWebKit.experimental 1.0
import 'utils.js' as Utils
import atnix.web 1.0

Window
{
    id: _
    width: 600
    height: 800
    visible: true


    WebView
    {
        id: webview
        url: 'https://zalupa.org/login'
        anchors.fill: parent

        experimental.certificateVerificationDialog: Item
        {
            Component.onCompleted: model.accept();
        }

        onNavigationRequested:
        {
            var url = StringUtils.parseURL(request.url.toString())
            Utils.prettyPrint(url)
            Utils.prettyPrint(StringUtils.parseURLQuery(url.query))
            Utils.prettyPrint(StringUtils.parseURLQuery(url.fragment))
            request.action = WebView.AcceptRequest;
        }

        Tracer {}
    }
}

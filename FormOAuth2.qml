import QtQuick 2.3
import QtQuick.Controls 1.2
import QtWebKit 3.0
import QtWebKit.experimental 1.0
import QtQuick.Layouts 1.1
import 'utils.js' as Utils
import atnix.web 1.0


Flipable
{
    id: _
    visible: false
    y: -parent.height
    width: parent.width
    height: parent.height

    property string appname
    property bool flipped: false
    property bool loading: _webview.loading

    signal loggedIn(string token)

    front: ColumnLayout
    {
        id: _services
        anchors.fill: parent
        enabled: !_.flipped
        ControlHeader { id: _header; text: qsTr('login via:') }
        ControlImageButton { source: 'images/google.svg'; onClicked: _webview.loginVia('google') }
        ControlImageButton { source: 'images/yandex.svg'; onClicked: _webview.loginVia('yandex') }
    }

    back: WebView
    {
        id: _webview
        anchors.fill: parent
        enabled: _.flipped

        ControlImageButton
        {
            source: 'images/back.svg';
            width: _header.font.pixelSize;
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            onClicked: _.flipped = false
        }

        experimental.certificateVerificationDialog: Item { Component.onCompleted: model.accept(); }

        onNavigationRequested:
        {
            var url = StringUtils.parseURL(request.url.toString())
            if('/oauth2/ok' === url.path)
                loggedIn(StringUtils.parseURLQuery(url.fragment).token)
            request.action = WebView.AcceptRequest;
        }

        function loginVia(service)
        {
            _webview.url = 'http://ibn.integra-s.com:8888/oauth2/login?service=' + service
            _.flipped = true
        }

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
        when: _.flipped
    }

    transitions: Transition { NumberAnimation { target: _rotation; property: "angle"; duration: 500 } }

    NumberAnimation
    {
        id: _hide
        target: _
        property: 'y'
        from: 0
        to: parent.height
        onRunningChanged: if(!running) _.flipped = _.visible = false
    }

    NumberAnimation
    {
        id: _show
        target: _
        property: 'y'
        from: parent.height
        to: 0
        onRunningChanged: if(!running) _.anchors.fill = parent
    }

    function hide()
    {
        anchors.fill = null
        _hide.start()
    }

    function show()
    {
        visible = true
        _show.start()
    }
}

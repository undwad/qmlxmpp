/*
** FormLogin.qml by undwad
** simple login qml form
**
** https://github.com/undwad/qmlxmpp mailto:undwad@mail.ru
** see copyright notice in ./LICENCE
*/

import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Rectangle
{
    id: _

    Presets { id: _presets }

    property bool waiting: true
    property string username
    property string password

    anchors.centerIn: parent
    width: _layout.spacing + _layout.width + _layout.spacing
    height: _layout.spacing + _layout.height + _layout.spacing
    color: _presets.transparentBackgroundColor

    signal login()
    signal register()

    ColumnLayout
    {
        id: _layout

        anchors.centerIn: parent
        spacing: _presets.spacingRatio * _header.font.pixelSize

        Label
        {
            id: _header
            text: _presets.appName
            color: _presets.headerFontColor
            font.bold: true
            font.pointSize: _presets.headerFontPointSize
        }

        ControlTextField
        {
            id: _username
            label.text: qsTr('username')
            field.text: username
        }

        ControlTextField
        {
            id: _password
            secret: true
            label.text: qsTr('password')
            field.text: password
        }

        RowLayout
        {
            Layout.fillWidth: true

            ControlLinkButton
            {
                text: qsTr('register')
                onClicked: register()
            }

            ControlLinkButton
            {
                enabled: !waiting && _username.field.length > 0 && _password.field.length > 0
                text: qsTr('login')
                horizontalAlignment: Text.AlignRight
                onClicked:
                {
                    username = _username.field.text
                    password = _password.field.text
                    login()
                }
            }
        }
    }

    ControlWaiting
    {
        anchors.bottom: parent.bottom
        waiting: _.waiting
    }
}

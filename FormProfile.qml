/*
** FormProfile.qml by undwad
** simple profile qml form
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
    property string email
    property string name
    property string info

    anchors.centerIn: parent
    width: _layout.spacing + _layout.width + _layout.spacing
    height: _layout.spacing + _layout.height + _layout.spacing
    color: _presets.transparentBackgroundColor

    signal register()
    signal back()

    ColumnLayout
    {
        id: _layout

        anchors.centerIn: parent
        spacing: _presets.spacingRatio * _header.font.pixelSize

        Label
        {
            id: _header
            text: _presets.appName
            color: 'navy'
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

        ControlTextField
        {
            id: _email
            label.text: qsTr('email')
            field.inputMethodHints: Qt.ImhEmailCharactersOnly
            field.text: email
        }

        ControlTextField
        {
            id: _name
            label.text: qsTr('name')
            field.text: name
        }

        ControlTextField
        {
            id: _info
            label.text: qsTr('info')
            field.text: info
        }

        RowLayout
        {
            Layout.fillWidth: true

            ControlLinkButton
            {
                text: qsTr('back')
                onClicked: back()
            }

            ControlLinkButton
            {
                enabled: !waiting && _username.field.length > 0 && _password.field.length > 0 && _email.field.length > 0
                text: qsTr('register')
                horizontalAlignment: Text.AlignRight
                onClicked:
                {
                    username = _username.field.text
                    password = _password.field.text
                    email = _email.field.text
                    name = _name.field.text
                    info = _info.field.text
                    register()
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

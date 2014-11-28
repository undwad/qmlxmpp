import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0
import atnix.web 1.0

Rectangle
{
    id: _

    Presets { id: _presets }

    property bool waiting: true
    property string username
    property string password
    property bool autologin

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
            field.onTextChanged: username = field.text
        }

        ControlTextField
        {
            id: _password
            secret: true
            label.text: qsTr('password')
            field.text: password
            field.onTextChanged:
            {
                password = field.text
                if(autologin)
                    _settings.password = StringUtils.toHex(password)
            }
        }

        ControlCheckBox
        {
            id: _autologin
            text: qsTr('auto login')
            checked: autologin
            onCheckedChanged:
            {
                autologin = checked
                if(autologin && password.length > 0)
                    _settings.password = StringUtils.toHex(password)
                else if(!autologin)
                    _settings.password = ''
            }
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
                onClicked: login()
                onEnabledChanged:
                {
                    if(enabled && autologin)
                        login()
                }
            }
        }
    }

    Settings
    {
        id: _settings

        category: "login"

        property alias username: _.username
        property alias autologin: _.autologin

        property string password

        Component.onCompleted: _.password = StringUtils.fromHex(password)
    }

}

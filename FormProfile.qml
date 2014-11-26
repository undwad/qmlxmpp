import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1


Rectangle
{
    id: root

    Presets { id: presets }

    property bool waiting: true

    anchors.centerIn: parent
    width: layout.spacing + layout.width + layout.spacing
    height: layout.spacing + layout.height + layout.spacing
    color: presets.transparentBackgroundColor

    signal register(string username, string password, string email, string name, string info)
    signal back()

    ColumnLayout
    {
        id: layout

        anchors.centerIn: parent
        spacing: presets.spacingRatio * header.font.pixelSize

        Label
        {
            id: header
            text: 'microblog'
            color: 'navy'
            font.bold: true
            font.pointSize: presets.headerFontPointSize
        }

        ControlTextField
        {
            id: username
            label.text: qsTr('username')
        }

        ControlTextField
        {
            id: password
            secret: true
            label.text: qsTr('password')
        }

        ControlTextField
        {
            id: email
            label.text: qsTr('email')
            field.inputMethodHints: Qt.ImhEmailCharactersOnly
        }

        ControlTextField
        {
            id: name
            label.text: qsTr('name')
        }

        ControlTextField
        {
            id: info
            label.text: qsTr('info')
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
                enabled: !waiting && username.field.length > 0 && password.field.length > 0 && email.field.length > 0
                text: qsTr('register')
                horizontalAlignment: Text.AlignRight
                onClicked: register(username.field.text, password.field.text, email.field.text, name.field.text, info.field.text)
            }
        }
    }

    ControlWaiting
    {
        anchors.bottom: parent.bottom
        waiting: root.waiting
    }
}

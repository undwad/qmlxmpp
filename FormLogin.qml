import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Rectangle
{
    id: root

    Presets { id: presets }

    anchors.centerIn: parent
    width: layout.spacing + layout.width + layout.spacing
    height: layout.spacing + layout.height + layout.spacing
    color: presets.transparentBackgroundColor

    signal login(string username, string password)
    signal register()

    ColumnLayout
    {
        id: layout

        anchors.centerIn: parent
        spacing: presets.spacingRatio * header.font.pixelSize

        Label
        {
            id: header
            text: 'microblog'
            color: presets.headerFontColor
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
                enabled: username.field.length > 0 && password.field.length > 0
                text: qsTr('login')
                horizontalAlignment: Text.AlignRight
                onClicked: login(username.field.text, password.field.text)
            }
        }

    }
}

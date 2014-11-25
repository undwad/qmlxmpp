import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

ColumnLayout
{
    id: root

    Presets { id: presets }

    anchors.centerIn: parent
    spacing: presets.spacingRatio * header.font.pixelSize

    signal register()
    signal back()

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

    RowLayout
    {
        Layout.fillWidth: true

        ControlLinkLike
        {
            text: qsTr('back')
            onClicked: back()
        }

        ControlLinkLike
        {
            enabled: username.field.length > 0 && password.field.length > 0 && email.field.length > 0
            text: qsTr('register')
            horizontalAlignment: Text.AlignRight
            onClicked: register()
        }
    }

    Rectangle
    {
        anchors.fill: parent
        anchors.margins: -root.spacing
        color: presets.transparentBackgroundColor
    }
}

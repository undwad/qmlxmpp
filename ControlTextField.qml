import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

ColumnLayout
{
    id: root

    Presets { id: presets }

    property bool secret: false

    spacing: label.font.pixelSize * presets.spacingRatio

    Label
    {
        id: label
        color: presets.headerFontColor
        font.bold: true
        font.pointSize: presets.fontPointSize
    }

    TextField
    {
        id: field
        textColor: presets.textFontColor
        font.pointSize: presets.fontPointSize
        Layout.fillWidth: true
        placeholderText: label.text
        echoMode: !secret || mouse.pressed ? TextInput.Normal : TextInput.Password

        Image
        {
            anchors.right: field.right
            anchors.top: field.top
            anchors.bottom: field.bottom
            anchors.margins: 2
            width: height
            fillMode: Image.PreserveAspectFit
            source: 'images/eye.png'
            visible: root.secret
            smooth: true

            MouseArea { id: mouse; anchors.fill: parent }
        }

    }

    property alias label: label
    property alias field: field
}

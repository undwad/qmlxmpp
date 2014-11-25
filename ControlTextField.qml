import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

ColumnLayout
{
    id: root

    property real fontPointSize: 10
    property real spacingFactor: 0.3
    property bool secret: false

    spacing: label.font.pixelSize * spacingFactor

    Label
    {
        id: label
        color: 'navy'
        font.bold: true
        font.pointSize: fontPointSize
    }

    TextField
    {
        id: field
        textColor: 'black'
        font.pointSize: fontPointSize
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

            MouseArea { id: mouse; anchors.fill: parent }
        }

    }

    property alias label: label
    property alias field: field
}

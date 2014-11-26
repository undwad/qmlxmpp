/*
** ControlTextField.qml by undwad
** text field with label qml control
**
** https://github.com/undwad/qmlxmpp mailto:undwad@mail.ru
** see copyright notice in ./LICENCE
*/

import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

ColumnLayout
{
    id: _

    Presets { id: _presets }

    property bool secret: false

    spacing: _label.font.pixelSize * _presets.spacingRatio

    Label
    {
        id: _label
        color: _presets.headerFontColor
        font.bold: true
        font.pointSize: _presets.fontPointSize
    }

    TextField
    {
        id: _field
        textColor: _presets.textFontColor
        font.pointSize: _presets.fontPointSize
        Layout.fillWidth: true
        placeholderText: _label.text
        echoMode: !secret || _mouse.pressed ? TextInput.Normal : TextInput.Password

        Image
        {
            anchors.right: _field.right
            anchors.top: _field.top
            anchors.bottom: _field.bottom
            anchors.margins: 2
            width: height
            fillMode: Image.PreserveAspectFit
            source: 'images/eye.png'
            visible: _.secret
            smooth: true

            MouseArea { id: _mouse; anchors.fill: parent }
        }

    }

    property alias label: _label
    property alias field: _field
}

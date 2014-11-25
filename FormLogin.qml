import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

ColumnLayout
{
    id: root

    Presets { id: presets }

    spacing: presets.spacingFactor * header.font.pixelSize

    Label
    {
        id: header
        text: qsTr('login')
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

    RowLayout
    {
        Layout.fillWidth: true

        ControlLinkLike
        {
            text: qsTr('register')
            onClicked: print('REGISTER')
        }

        ControlLinkLike
        {
            visible: username.field.length > 0 && password.field.length > 0
            text: qsTr('login')
            horizontalAlignment: Text.AlignRight
            onClicked: print('LOGIN')
        }
    }

}

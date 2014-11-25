import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

ColumnLayout
{
    id: root

    Label
    {
        text: qsTr('login')
        color: 'navy'
        font.bold: true
        font.pointSize: 2 * username.fontPointSize
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

        Text
        {
            Layout.fillWidth: true
            textFormat: Text.RichText
            text: '<a href=\"http://\">%1</a>'.arg(qsTr('register'))
            font.pointSize: username.fontPointSize
            onLinkActivated: print('REGISTER')
        }

        Text
        {
            visible: username.field.length > 0 && password.field.length > 0
            textFormat: Text.RichText
            text: '<a href=\"http://\">%1</a>'.arg(qsTr('login'))
            font.pointSize: username.fontPointSize
            onLinkActivated: print('LOGIN')
        }
    }

}

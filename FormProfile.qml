import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

ColumnLayout
{
    id: root

    property Presets presets

    Label
    {
        text: qsTr('profile')
        font.pointSize: presets.headerTextSize
        font.bold: true
        font.family: presets.fontFamily
        color: presets.labelTextColor
    }

    Label
    {
        text: qsTr('username')
        font.pointSize: presets.textSize
        font.bold: true
        font.family: presets.fontFamily
        color: presets.labelTextColor
    }

    Rectangle
    {
        radius: presets.borderRadius
        border.width: presets.borderWidth
        border.color: presets.borderWidth


//            TextInput
//            {
//                id: username
//                font.pointSize: presets.textSize
//                font.family: presets.fontFamily
//                color: presets.textColor
//                text: 'JODER'
//            }
    }


}

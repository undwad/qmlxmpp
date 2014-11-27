import QtQuick 2.0

Item
{
    anchors.fill: parent
    property color color: 'black'
    property real border: 1

    Rectangle
    {
        anchors.fill: parent
        color: 'transparent'
        border.width: parent.border
        border.color: parent.color
    }
}

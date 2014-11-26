/*
** Tracer.qml by undwad
** simple control tracer
**
** https://github.com/undwad/qmlxmpp mailto:undwad@mail.ru
** see copyright notice in ./LICENCE
*/

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

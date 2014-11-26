/*
** ControlWaiting.qml by undwad
** waiting for completition qml control
**
** https://github.com/undwad/qmlxmpp mailto:undwad@mail.ru
** see copyright notice in ./LICENCE
*/

import QtQuick 2.0

Item
{
    id: _

    property color color: 'blue'
    property int count: 3
    property bool waiting: false
    property int duration: 1500

    visible: waiting
    height: 4
    anchors.left: parent.left
    anchors.right: parent.right

    Repeater
    {
        id: repeater

        model: _.count

        delegate: Rectangle
        {
            height: _.height
            width: height
            color: _.color

            NumberAnimation
            {
                id: animation
                from: 0; to: _.width - _.height
                properties: "x"
                duration: _.duration
                easing.type: Easing.OutInQuad
                onRunningChanged:
                {
                    if(target)
                        target.visible = running
                }
            }

            property alias animation: animation
        }
    }

    Timer
    {
        property int index: 0

        interval: _.duration / _.count
        repeat: true
        triggeredOnStart: true
        running: _.waiting

        onTriggered:
        {
            index = index % repeater.count
            var item = repeater.itemAt(index)
            if(!item.animation.running)
            {
                item.animation.target = item
                item.animation.restart()
            }
            index++
        }
    }
}

import QtQuick 2.0

Item
{
    id: root

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

        model: root.count

        delegate: Rectangle
        {
            height: root.height
            width: height
            color: root.color

            NumberAnimation
            {
                id: animation
                from: 0; to: root.width - root.height
                properties: "x"
                duration: root.duration
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

        interval: root.duration / root.count
        repeat: true
        triggeredOnStart: true
        running: root.waiting

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

import QtQuick 2.0

Item
{
    id: _

    property int count: 5
    property bool waiting: false
    property real duration: 1.5
    property int attempts: 0

    visible: waiting
    height: 4
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom

    Repeater
    {
        id: repeater

        model: _.count

        delegate: Rectangle
        {
            height: _.height
            width: height

            NumberAnimation
            {
                id: _animation
                from: 0; to: _.width - _.height
                properties: "x"
                duration: _.duration * 1000
                easing.type: Easing.OutInQuad
                onRunningChanged:
                {
                    if(target)
                        target.visible = running
                }
            }

            property alias animation: _animation
        }
    }

    Timer
    {
        property int index: 0

        interval: _.duration * 1000 / _.count
        repeat: true
        triggeredOnStart: true
        running: _.waiting

        onTriggered:
        {
            index = index % repeater.count
            var item = repeater.itemAt(index)
            if(!item.animation.running)
            {
                item.color = index + 2 > _.attempts ? 'blue' : 'red'
                item.animation.target = item
                item.animation.restart()
            }
            index++
        }
    }

    function wait()
    {
        waiting = true
        attempts++
    }

    function stop()
    {
        waiting = false
        attempts = 0
    }
}

import QtQuick 2.3
import QtQuick.Controls 1.2

Rectangle
{
    id: _

    Presets { id: _presets }

    property real interval: 5

    visible: height > 0
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    color: Qt.rgba(1, 0, 0, 0.8)
    clip: true

    property real spacing: _presets.spacingRatio * _text.font.pixelSize

    Text
    {
        id: _text
        anchors.fill: parent
        color: 'white'
        font.pointSize: _presets.fontPointSize
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
    }

    NumberAnimation
    {
        id: _animation
        target: _
        properties: "height"
        duration: 500
    }

    Timer
    {
        id: _timer
        interval: _.interval * 1000
        onTriggered: hide()
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked: hide()
    }

    function hide()
    {
        _animation.from = _.height
        _animation.to = 0
        _animation.restart()
    }

    function show(problem)
    {
        _text.text = problem
        _timer.restart()
        _animation.from = 0
        _animation.to = spacing + _text.font.pixelSize + spacing + _text.font.pixelSize + spacing
        _animation.restart()
    }
}

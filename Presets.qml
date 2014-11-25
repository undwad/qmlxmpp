import QtQuick 2.0

QtObject
{
    property real fontPointSize: 15
    property real headerFontPointSize: 2 * fontPointSize
    property real spacingRatio: 0.3

    property color linkFontColor: 'blue'
    property color headerFontColor: 'navy'
    property color inactiveFontColor: 'gray'
    property color textFontColor: 'black'
    property color transparentBackgroundColor: Qt.rgba(0, 0, 0, 0.5)
}

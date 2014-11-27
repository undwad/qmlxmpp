import QtQuick 2.0

QtObject
{
    property string appName: 'microblog'

    property real fontPointSize: 12
    property real headerFontPointSize: 2 * fontPointSize
    property real spacingRatio: 0.3

    property color linkFontColor: 'blue'
    property color headerFontColor: 'navy'
    property color inactiveFontColor: 'gray'
    property color textFontColor: 'black'
    property color transparentBackgroundColor: Qt.rgba(0.5, 0.5, 0.5, 0.5)
}

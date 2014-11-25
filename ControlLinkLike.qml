import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Text
{
    id: root

    Presets { id: presets }

    Layout.fillWidth: true

    font.pointSize: presets.fontPointSize
    font.underline: true
    color: enabled ? presets.linkFontColor : presets.inactiveFontColor

    signal clicked()

    MouseArea
    {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}

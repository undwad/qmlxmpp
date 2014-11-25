import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

RowLayout
{
    Presets { id: presets }

    property string text
    property var horizontalAlignment


    signal clicked()

    Text
    {
        Layout.fillWidth: true
        anchors.fill: parent
        textFormat: Text.RichText
        horizontalAlignment: parent.horizontalAlignment
        text: '<a href=\"http://\">%1</a>'.arg(parent.text)
        font.pointSize: presets.fontPointSize
        onLinkActivated: clicked()
    }
}

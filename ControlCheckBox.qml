import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.2

CheckBox
{
    id: _

    Presets { id: _presets }

    Layout.fillWidth: true

    style: CheckBoxStyle
    {
        label: Text
        {
            color: _presets.headerFontColor
            font.pointSize: _presets.fontPointSize
            font.bold: true
            text: _.text
        }

        indicator: Rectangle
        {
            implicitWidth: _.height
            implicitHeight: implicitWidth
            border.color: control.activeFocus ? "darkblue" : "gray"
            border.width: 1
            Rectangle
            {
                visible: control.checked
                color: "#555"
                border.color: "#333"
                anchors.margins: 4
                anchors.fill: parent
            }
        }
    }
}

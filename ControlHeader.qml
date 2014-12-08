import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Label
{
    Presets { id: _presets }

    Layout.fillWidth: true
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    color: _presets.headerFontColor
    font.bold: true
    font.pointSize: _presets.headerFontPointSize
}


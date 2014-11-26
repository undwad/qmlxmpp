/*
** ControlLinkButton.qml by undwad
** linklike button qml control
**
** https://github.com/undwad/qmlxmpp mailto:undwad@mail.ru
** see copyright notice in ./LICENCE
*/

import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Text
{
    id: _

    Presets { id: _presets }

    Layout.fillWidth: true

    font.pointSize: _presets.fontPointSize
    font.underline: true
    color: enabled ? _presets.linkFontColor : _presets.inactiveFontColor

    signal clicked()

    MouseArea
    {
        anchors.fill: parent
        onClicked: _.clicked()
    }
}

import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Image
{
    Layout.fillWidth: true
    fillMode: Image.PreserveAspectFit

    signal clicked()

    MouseArea
    {
        anchors.fill: parent
        onClicked: parent.clicked()
    }
}

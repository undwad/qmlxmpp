import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import 'utils.js' as Utils
import atnix.web 1.0

Window
{
    visible: true
    width: 400
    height: 600

    FormLogin
    {
        id: login
        anchors.centerIn: parent

        //Tracer { color: 'red' }
    }

    Component.onCompleted:
    {
    }

}

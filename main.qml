import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import 'utils.js' as Utils
import atnix.web 1.0

Rectangle
{
    id: root
    width: 400
    height: 600

    Image
    {
        anchors.fill: parent
        source: 'images/background.jpg'
        fillMode: Image.PreserveAspectFit
    }

    Flipable
    {
        id: entrance
        anchors.fill: parent

        property bool flipped: false

        front: FormLogin
        {
            id: login
            onLogin: print('LOGIN', username, password)
            onRegister: entrance.flipped = true
        }

        back: FormProfile
        {
            id: profile
            onRegister: print('REGISTER', username, password, email, name)
            onBack: entrance.flipped = false
        }

        transform: Rotation
        {
            id: rotation
            origin.x: root.width / 2
            origin.y: root.height / 2
            axis.x: 0; axis.y: 1; axis.z: 0
            angle: 0
        }

        states: State
        {
            PropertyChanges { target: rotation; angle: 180 }
            when: entrance.flipped
        }

        transitions: Transition { NumberAnimation { target: rotation; property: "angle"; duration: 500 } }
    }

}


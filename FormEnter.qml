import QtQuick 2.3
import QtQuick.Controls 1.2

Flipable
{
    id: _
    anchors.fill: parent

    property bool flipped: false
    property bool waiting

    front: FormLogin
    {
        id: _login
        waiting: _.waiting
        onLogin: print('LOGIN', username, password, autologin)
        onRegister:
        {
            _profile.username = username
            _profile.password = password
            _profile.autologin = autologin
            _.flipped = true
        }
    }

    back: FormProfile
    {
        id: _profile
        waiting: _.waiting
        onRegister: print('REGISTER', username, password, email, name, autologin)
        onBack: _.flipped = false
    }

    transform: Rotation
    {
        id: _rotation
        origin.x: _.width / 2
        origin.y: _.height / 2
        axis.x: 0; axis.y: 1; axis.z: 0
        angle: 0
    }

    states: State
    {
        PropertyChanges { target: _rotation; angle: 180 }
        when: _.flipped
    }

    transitions: Transition { NumberAnimation { target: _rotation; property: "angle"; duration: 500 } }
}

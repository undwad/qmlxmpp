import QtQuick 2.3
import QtQuick.Controls 1.2

Flipable
{
    id: _
    anchors.fill: parent

    property ClientMicroBlog client
    property bool flipped: false
    property bool waiting: true

    signal login()
    signal register()

    front: FormLogin
    {
        id: _login
        waiting: _.waiting
        enabled: !_.flipped

        onLogin: _.login()

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
        enabled: _.flipped

        onRegister:
        {
            _login.username = username
            _login.password = password
            _login.autologin = autologin
            _.register()
        }

        onBack:
        {
            _login.username = username
            _login.password = password
            _login.autologin = autologin
            _.flipped = false
        }
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

    NumberAnimation
    {
        id: _hide
        target: _
        property: 'y'
        from: 0
        to: parent.height
        onRunningChanged: if(!running) _.visible = false
    }

    NumberAnimation
    {
        id: _show
        target: _
        property: 'y'
        from: parent.height
        to: 0
        onRunningChanged: if(!running) _.anchors.fill = parent
    }

    function hide()
    {
        anchors.fill = null
        _hide.start()
    }

    function show()
    {
        visible = true
        _show.start()
    }
}

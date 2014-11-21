/*
** atnixweb_plugin.h by undwad
** qml plugin
**
** https://github.com/undwad/qmlxmpp mailto:undwad@mail.ru
** see copyright notice in ./LICENCE
*/

#pragma once

#include <qqml.h>
#include <QQmlExtensionPlugin>

#include "regtypes.h"

class AtnixwebPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char*) { ::registerTypes(); }
};



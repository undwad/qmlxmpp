#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "regtypes.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    registerTypes();
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/sample.qml")));
    return app.exec();
}

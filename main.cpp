#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QJSEngine>
#include <QDebug>

#include "stringutils.h"
#include "dnsresolver.h"
#include "sslsocket.h"
#include "xmlprotocol.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // @uri atnix.web
    qmlRegisterSingletonType<StringUtils>("atnix.web", 1, 0, "StringUtils", StringUtils::provider);
    qmlRegisterType<DNSResolver>("atnix.web", 1, 0, "DNSResolver");
    qmlRegisterType<SSLSocket>("atnix.web", 1, 0, "SSLSocket");
    qmlRegisterType<XMLProtocol>("atnix.web", 1, 0, "XMLProtocol");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

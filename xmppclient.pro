TEMPLATE = app

QT += qml quick
CONFIG += c++11

SOURCES += main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    dnsresolver.h \
    sslsocket.h \
    xmlprotocol.h \
    stringutils.h \
    regtypes.h \
    asyncutils.h \
    httpclient.h

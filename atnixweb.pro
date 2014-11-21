TEMPLATE = lib
TARGET = atnixweb
QT += qml quick
CONFIG += qt plugin

TARGET = $$qtLibraryTarget($$TARGET)
uri = atnix.web

# Input
HEADERS += \
    atnixweb_plugin.h \
    atnixweb_plugin.h \
    dnsresolver.h \
    sslsocket.h \
    stringutils.h \
    xmlprotocol.h \
    regtypes.h

OTHER_FILES = qmldir_

!equals(_PRO_FILE_PWD_, $$OUT_PWD) {
    copy_qmldir.target = $$OUT_PWD/qmldir_
    copy_qmldir.depends = $$_PRO_FILE_PWD_/qmldir_
    copy_qmldir.commands = $(COPY_FILE) \"$$replace(copy_qmldir.depends, /, $$QMAKE_DIR_SEP)\" \"$$replace(copy_qmldir.target, /, $$QMAKE_DIR_SEP)\"
    QMAKE_EXTRA_TARGETS += copy_qmldir
    PRE_TARGETDEPS += $$copy_qmldir.target
}

qmldir.files = qmldir_
unix {
    installPath = $$[QT_INSTALL_QML]/$$replace(uri, \\., /)
    qmldir.path = $$installPath
    target.path = $$installPath
    INSTALLS += target qmldir_
}


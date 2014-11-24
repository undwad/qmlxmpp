/*
** stringutils.h by undwad
** some qt string utils binding to qml
** look ./utils.js for usage example
**
** https://github.com/undwad/qmlxmpp mailto:undwad@mail.ru
** see copyright notice in ./LICENCE
*/

#pragma once

#include <QObject>
#include <QString>
#include <QByteArray>
#include <QCryptographicHash>
#include <QUrl>
#include <QJSValue>
#include <QQmlEngine>
#include <QJsEngine>
#include <QUuid>
#include <QDebug>

class StringUtils : public QObject
{
    Q_OBJECT
    Q_ENUMS(HashAlgorithm)

    Q_DISABLE_COPY(StringUtils)

public:
    static QObject* provider(QQmlEngine*, QJSEngine* jsengine) { return new StringUtils(jsengine); }
    StringUtils(QJSEngine* engine) { this->engine = engine; }
    ~StringUtils() { }

    enum HashAlgorithm
    {
#ifndef QT_CRYPTOGRAPHICHASH_ONLY_SHA1
        Md4,
        Md5,
#endif
        Sha1 = 2,
#ifndef QT_CRYPTOGRAPHICHASH_ONLY_SHA1
        Sha224,
        Sha256,
        Sha384,
        Sha512,
        Sha3_224,
        Sha3_256,
        Sha3_384,
        Sha3_512
#endif
    };

signals:

public slots:
    QString toHex(const QString& text) { return QString(text.toUtf8().toHex()); }
    QString fromHex(const QString& text) { return QString(QByteArray::fromHex(text.toUtf8())); }
    QString toBase64(const QString& text) { return QString(text.toUtf8().toBase64()); }
    QString fromBase64(const QString& text) { return QString(QByteArray::fromBase64(text.toUtf8())); }
    QString toHash(const QString& text, HashAlgorithm algorithm) { return QString(QCryptographicHash::hash(text.toUtf8(), (QCryptographicHash::Algorithm)algorithm)); }

    QJSValue parseURL(const QString& text)
    {
        QUrl url(text);
        QJSValue result = engine->newObject();
        result.setProperty("authority", QJSValue(url.authority()));
        result.setProperty("fileName", QJSValue(url.fileName()));
        result.setProperty("fragment", QJSValue(url.fragment()));
        result.setProperty("host", QJSValue(url.host()));
        result.setProperty("password", QJSValue(url.password()));
        result.setProperty("path", QJSValue(url.path()));
        result.setProperty("port", QJSValue(url.port()));
        result.setProperty("query", QJSValue(url.query()));
        result.setProperty("scheme", QJSValue(url.scheme()));
        result.setProperty("url", QJSValue(url.url()));
        result.setProperty("userName", QJSValue(url.userName()));
        result.setProperty("userInfo", QJSValue(url.userInfo()));
        return result;
    }

    QString newGUID() { return QUuid::createUuid().toString(); }

private:
    QJSEngine* engine = nullptr;
};

/*
** httpclient.h by undwad
** QNetworkAccessManager binding to qml for making async http requests
**
** https://github.com/undwad/qmlxmpp mailto:undwad@mail.ru
** see copyright notice in ./LICENCE
*/

#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QJSValue>
#include <QJSValueIterator>
#include <QQmlEngine>
#include <QQmlContext>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QHttpPart>
#include <QFile>
#include <QMimeType>
#include <QMimeDatabase>
#include <QDebug>

class HTTPClient : public QNetworkAccessManager
{
    Q_OBJECT

    Q_ENUMS(NetworkAccessibility)
    Q_ENUMS(RequestPriority)

    Q_PROPERTY (QString prefix MEMBER prefix)
    Q_PROPERTY (NetworkAccessibility networkAccessible READ getNetworkAccessible)

    Q_DISABLE_COPY(HTTPClient)

public:
    HTTPClient()
    {
        QObject::connect(this, &QNetworkAccessManager::sslErrors, this, [this](QNetworkReply * reply, const QList<QSslError> & errors)
        {
            QList<QString> strings;
            for(auto& error : errors)
                strings.append(error.errorString());
            emit sslErrors(strings);
            reply->ignoreSslErrors();
        });
    }

    ~HTTPClient() { }

    enum NetworkAccessibility { UnknownAccessibility = -1, NotAccessible = 0, Accessible = 1 };

    enum RequestPriority { HighPriority, NormalPriority, LowPriority };

signals:
    void sslErrors(QList<QString> errors);

public slots:
    NetworkAccessibility getNetworkAccessible() const { return (NetworkAccessibility)QNetworkAccessManager::networkAccessible(); }
    void clearAccessCache() { QNetworkAccessManager::clearAccessCache(); }

    void get(RequestPriority priority, const QString& url, const QJSValue& headers, const QJSValue& callback)
    {
        processReply(QNetworkAccessManager::get(NetworkRequest(prefix + url, headers, priority)), callback);
    }

    void post(RequestPriority priority, const QString& url, const QJSValue& headers, const QJSValue& body, const QJSValue& callback)
    {
        processReply(QNetworkAccessManager::post(NetworkRequest(prefix + url, headers, priority), body.toString().toUtf8()), callback);
    }

    void put(RequestPriority priority, const QString& url, const QJSValue& headers, const QJSValue& body, const QJSValue& callback)
    {
        processReply(QNetworkAccessManager::put(NetworkRequest(prefix + url, headers, priority), body.toString().toUtf8()), callback);
    }

    void deleteResource(RequestPriority priority, const QString& url, const QJSValue& headers, const QJSValue& callback)
    {
        processReply(QNetworkAccessManager::deleteResource(NetworkRequest(prefix + url, headers, priority)), callback);
    }

    void upload(RequestPriority priority, const QString& url, const QJSValue& headers, const QString& path, const QJSValue& callback)
    {
        QHttpMultiPart* multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

        QMimeType mime = mimeDatabase.mimeTypeForFile(path);

        QHttpPart imagePart;
        imagePart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant(mime.name()));
        imagePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"image\""));

        QFile* file = new QFile(path);
        file->open(QIODevice::ReadOnly);
        imagePart.setBodyDevice(file);
        file->setParent(multiPart);

        multiPart->append(imagePart);

        QNetworkReply* reply = QNetworkAccessManager::post(NetworkRequest(prefix + url, headers, priority), multiPart);
        multiPart->setParent(reply);
        processReply(reply, callback);
    }

private:
    QString prefix;
    QMimeDatabase mimeDatabase;

    class NetworkRequest : public QNetworkRequest
    {
    public:
        NetworkRequest(const QString& url, const QJSValue& headers, RequestPriority priority)
        {
            setUrl(url);
            setPriority((QNetworkRequest::Priority)priority);
            QJSValueIterator iterator(headers);
            while(iterator.hasNext())
            {
                iterator.next();
                setRawHeader(iterator.name().toLatin1(), iterator.value().toString().toLatin1());
            }
        }
    };

    typedef void (QNetworkReply::*error_signal)(QNetworkReply::NetworkError code);

    void processReply(QNetworkReply* reply, const QJSValue& callback)
    {
        QObject::connect(reply, (error_signal)&QNetworkReply::error, this, [=](QNetworkReply::NetworkError)
        {
            QJSValueList args;
            args.append(QJSValue());
            args.append(reply->errorString());
            const_cast<QJSValue&>(callback).call(args);
            reply->deleteLater();
        });
        QObject::connect(reply, &QNetworkReply::finished, this, [=]()
        {
            QJSValueList args;
            QJSValue headers = QQmlEngine::contextForObject(this)->engine()->newObject();
            for(auto& pair : reply->rawHeaderPairs())
                headers.setProperty(QString::fromLatin1(pair.first).toLower(), QString::fromLatin1(pair.second));
            args.append(headers);
            args.append(QJSValue(QString::fromUtf8(reply->readAll())));
            const_cast<QJSValue&>(callback).call(args);
            reply->deleteLater();
        });
    }
};


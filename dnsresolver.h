#pragma once

#include <QQuickItem>
#include <QHostInfo>

class DNSResolver : public QObject
{
    Q_OBJECT

    Q_PROPERTY (QString host READ getHost WRITE setHost)
    Q_PROPERTY (QList<QString> addresses READ getAddresses)
    Q_PROPERTY (QString error READ getError)

    Q_DISABLE_COPY(DNSResolver)

public:
    DNSResolver() {}
    ~DNSResolver() {}

    QString getHost() const { return host; }
    QList<QString> getAddresses() const { return addresses; }
    QString getError() const { return error; }

    void setHost(const QString& host)
    {
        this->host = host;
        resolve();
    }

signals:
    void failed();
    void resolved();

private slots:
    void lookedup(const QHostInfo& host)
    {
        if(QHostInfo::NoError == host.error())
        {
            foreach (const QHostAddress &address, host.addresses())
                addresses.push_back(address.toString());
            emit resolved();
        }
        else
        {
            error = host.errorString();
            emit failed();
        }
    }

public slots:
    void resolve()
    {
        addresses.clear();
        QHostInfo::lookupHost(host, this, SLOT(lookedup(QHostInfo)));
    }

private:
    QString host;
    QList<QString> addresses;
    QString error;
};



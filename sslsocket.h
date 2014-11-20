/*
** sslsocket.h by undwad
** QSslSocket binding to qml
** look ./XMPPClient.qml for usage example
**
** https://github.com/undwad/qmlxmpp mailto:undwad@mail.ru
** see copyright notice in ./LICENCE
*/

#pragma once

#include <QObject>
#include <QSslSocket>
#include <QSslConfiguration>
#include <QJSValue>
#include <QDebug>

class SSLSocket : public QSslSocket
{
    Q_OBJECT

    Q_ENUMS(SSLProtocol)
    Q_ENUMS(SocketOption)
    Q_ENUMS(SocketState)

    Q_PROPERTY (QString host MEMBER host)
    Q_PROPERTY (int port MEMBER port)
    Q_PROPERTY (int bytesAvailable READ bytesAvailable)
    Q_PROPERTY (bool isEncrypted READ isEncrypted)
    Q_PROPERTY (SSLProtocol protocol READ getProtocol WRITE setProtocol)
    Q_PROPERTY (SocketState state READ getState)
    Q_PROPERTY (QString error READ errorString)

    Q_DISABLE_COPY(SSLSocket)

public:
    SSLSocket() { }
    ~SSLSocket() { }

    enum SSLProtocol
    {
        SslV3,
        SslV2,
        TlsV1_0,
#if QT_DEPRECATED_SINCE(5,0)
        TlsV1 = TlsV1_0,
#endif
        TlsV1_1,
        TlsV1_2,
        AnyProtocol,
        TlsV1SslV3,
        SecureProtocols,
        UnknownProtocol = -1
    };

    enum SocketOption
    {
        LowDelayOption, // TCP_NODELAY
        KeepAliveOption, // SO_KEEPALIVE
        MulticastTtlOption, // IP_MULTICAST_TTL
        MulticastLoopbackOption, // IP_MULTICAST_LOOPBACK
        TypeOfServiceOption, //IP_TOS
        SendBufferSizeSocketOption,    //SO_SNDBUF
        ReceiveBufferSizeSocketOption  //SO_RCVBUF
    };

    enum SocketState
    {
        UnconnectedState,
        HostLookupState,
        ConnectingState,
        ConnectedState,
        BoundState,
        ListeningState,
        ClosingState
    };

    SSLProtocol getProtocol() { return (SSLProtocol)sslConfiguration().protocol(); }
    void setProtocol(SSLProtocol protocol)
    {
        QSslConfiguration cfg = sslConfiguration();
        cfg.setProtocol((QSsl::SslProtocol)protocol);
        setSslConfiguration(cfg);
    }

    SocketState getState() { return (SocketState)state(); }

signals:

public slots:

    void connect() { connectToHost(host, port); }

    void setSocketOption(SocketOption option, const QJSValue& value) { QSslSocket::setSocketOption((QAbstractSocket::SocketOption)option, value.toVariant()); }

    void disconnect() { disconnectFromHost(); }

    void abort() { QSslSocket::abort(); }

private slots:

private:
    QString host;
    int port;
};


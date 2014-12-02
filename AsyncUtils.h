/*
** stringutils.h by undwad
** some qt asynchronous utils binding to qml
** look ./utils.js for usage example
**
** https://github.com/undwad/qmlxmpp mailto:undwad@mail.ru
** see copyright notice in ./LICENCE
*/

#pragma once

#include <QObject>
#include <QJSValue>
#include <QQmlEngine>
#include <QJsEngine>
#include <QDebug>
#include <QTimer>

class AsyncUtils : public QObject
{
    Q_OBJECT

    Q_DISABLE_COPY(AsyncUtils)

public:
    static QObject* provider(QQmlEngine*, QJSEngine* jsengine) { return new AsyncUtils(jsengine); }
    AsyncUtils(QJSEngine* engine) { this->engine = engine; }
    ~AsyncUtils() { }

signals:

public slots:
    void defer(int msecs, const QJSValue& callback)
    {
        if(callback.isCallable())
        {
            QTimer* timer = new QTimer(this);
            timer->setSingleShot(true);
            connect(timer, &QTimer::timeout, [=]()
            {
                const_cast<QJSValue&>(callback).call();
                timer->deleteLater();
            });
            timer->start(msecs);
        }
    }

private:
    QJSEngine* engine = nullptr;
};

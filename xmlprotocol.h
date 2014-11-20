/*
** xmlprotocol.h by undwad
** xml based socket client binding to qml
** look ./XMPPClient.qml for usage example
**
** converts xml packets to/from java script objects for easy processing within qml
**
** <tag1 attr1="1" attr2="2">
**     <tag2 attr1="1" />
**     <tag3>value1</tag3>
** </tag1>
**
** is converted to
**
** {
**     $name: 'tag1',
**     attr1: '1',
**     attr2: '2',
**     $elements:
**     [
**         {
**             $name: 'tag2',
**             attr1: '1'
**         },
**         {
**             $name: 'tag3',
**             $value: 'value1'
**         }
**     ]
** }
**
** and can be also converted from
**
** {
**     $name: 'tag1',
**     attr1: '1',
**     attr2: '2',
**     tag2$: { attr1: '1' },
**     tag3$: 'value1'
** }
**
** https://github.com/undwad/qmlxmpp mailto:undwad@mail.ru
** see copyright notice in ./LICENCE
*/

#pragma once

#include <QObject>
#include <QAbstractSocket.h>
#include <QStack>
#include <QXmlStreamReader>
#include <QXmlStreamWriter>
#include <QJsonDocument>
#include <QList>
#include <QDebug>
#include <QJSValue>
#include <QJSValueIterator>
#include <QQmlEngine>
#include <QQmlContext>
#include <QQmlListProperty>

#include "sslsocket.h"

class XMLProtocol : public QObject, QXmlStreamReader
{
    Q_OBJECT

    Q_PROPERTY (SSLSocket* socket READ getSocket)
    Q_PROPERTY(QQmlListProperty<QObject> children READ getChildren)
    Q_PROPERTY (QList<QString> opentags MEMBER opentags)
    Q_PROPERTY (QString error MEMBER error_)

    Q_CLASSINFO("DefaultProperty", "children")

    Q_DISABLE_COPY(XMLProtocol)

public:
    XMLProtocol()
    {
        setNamespaceProcessing(false);
        QObject::connect(socket, &SSLSocket::readyRead, this, &XMLProtocol::onRead);
    }

    ~XMLProtocol() { }

    SSLSocket* getSocket() { return socket; }

    QQmlListProperty<QObject> getChildren() { return QQmlListProperty<QObject>(this, children); }

signals:
    void error();
    void connected();
    void encrypted();
    void received(const QJSValue& object);
    void disconnected();

public slots:
    bool send(const QJSValue& object, bool close = true)
    {
        if(socket)
        {
            QString text;
            QXmlStreamWriter xml(&text);
            object2xml(object, xml, close);
            if(!close) text += '>';
            socket->write(text.toUtf8());
            return true;
        }
        else error_ = "socket not set";
        return false;
    }

    void reset()
    {
        clear();
        setDevice(socket);
    }

private slots:
    void onRead()
    {
        while(!atEnd())
            switch(readNext())
            {
                case QXmlStreamReader::StartElement:
                {
                    if(object.isObject()) stack.push(object);
                    object = QQmlEngine::contextForObject(this)->engine()->newObject();
                    object.setProperty("$name", QJSValue(qualifiedName().toString()));
                    for(auto& attribute : attributes())
                        object.setProperty(attribute.qualifiedName().toString(), QJSValue(attribute.value().toString()));
                    if(opentags.contains(qualifiedName().toString()))
                    {
                        emit received(object);
                        clear();
                    }
                    break;
                }
                case QXmlStreamReader::Characters:
                {
                    if(!isWhitespace())
                        object.setProperty("$value", QJSValue(text().toString()));
                    break;
                }
                case QXmlStreamReader::EndElement:
                {
                    if(stack.empty())
                    {
                        if(!object.isObject())
                            object = QJSValue(qualifiedName().toString());
                        emit received(object);
                        clear();
                    }
                    else
                    {
                        QJSValue parent = stack.pop();
                        if(!parent.hasProperty("$elements"))
                            parent.setProperty("$elements", QQmlEngine::contextForObject(this)->engine()->newArray());
                        QJSValue elements = parent.property("$elements");
                        elements.setProperty(elements.property("length").toInt(), object);
                        object = parent;
                    }
                    break;
                }
                case QXmlStreamReader::Invalid:
                {
                    if(QXmlStreamReader::PrematureEndOfDocumentError != QXmlStreamReader::error())
                    {
                        error_ = errorString();
                        emit error();
                    }
                    break;
                }
            }
    }

private:
    SSLSocket* socket = new SSLSocket();
    QList<QString> opentags;
    QString error_;
    QJSValue object;
    QStack<QJSValue> stack;
    QList<QObject*> children;

    void clear()
    {
        while(!stack.empty())
            stack.pop();
        object = QJSValue();
    }

    void object2xml(const QJSValue& object, QXmlStreamWriter& xml, bool close = true)
    {
        xml.writeStartElement(object.property("$name").toString());
        {
            QJSValueIterator attributes(object);
            while(attributes.hasNext())
            {
                attributes.next();
                QString key = attributes.name();
                if(!key.startsWith('$') && !key.endsWith('$'))
                    xml.writeAttribute(key, attributes.value().toString());
            }
        }
        if(object.hasProperty("$value"))
            xml.writeCharacters(object.property("$value").toString());
        if(object.hasProperty("$elements"))
        {
            QJSValueIterator elements(object.property("$elements"));
            while(elements.hasNext())
            {
                elements.next();
                object2xml(elements.value(), xml);
            }
        }
        {
            QJSValueIterator attributes(object);
            while(attributes.hasNext())
            {
                attributes.next();
                QString key = attributes.name();
                if(!key.startsWith('$') && key.endsWith('$'))
                {
                    QString name = key.left(key.length() - 1);
                    if(attributes.value().isObject())
                    {
                        attributes.value().setProperty("$name", name);
                        object2xml(attributes.value(), xml);
                    }
                    else
                    {
                        xml.writeStartElement(name);
                        xml.writeCharacters(attributes.value().toString());
                        xml.writeEndElement();
                    }
                }
            }
        }
        if(close)
            xml.writeEndElement();
    }
};


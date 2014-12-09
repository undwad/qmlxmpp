/*
** regtypes.h by undwad
** qml types registration
**
** https://github.com/undwad/qmlxmpp mailto:undwad@mail.ru
** see copyright notice in ./LICENCE
*/

#pragma once

#include "asyncutils.h"
#include "stringutils.h"
#include "dnsresolver.h"
#include "sslsocket.h"
#include "xmlprotocol.h"
#include "httpclient.h"

void registerTypes()
{
    // @uri atnix.web
    qmlRegisterSingletonType<StringUtils>("atnix.web", 1, 0, "StringUtils", StringUtils::provider);
    qmlRegisterSingletonType<AsyncUtils>("atnix.web", 1, 0, "AsyncUtils", AsyncUtils::provider);
    qmlRegisterType<DNSResolver>("atnix.web", 1, 0, "DNSResolver");
    qmlRegisterType<SSLSocket>("atnix.web", 1, 0, "SSLSocket");
    qmlRegisterType<XMLProtocol>("atnix.web", 1, 0, "XMLProtocol");
    qmlRegisterType<HTTPClient>("atnix.web", 1, 0, "HTTPClient");
}

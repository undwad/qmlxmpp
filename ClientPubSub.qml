import QtQuick 2.0

ClientXMPP
{
    property string pubsubjid

    function buildNodeConfig(node, config)
    {
        var result =
        {
            node: node,
            x$:
            {
                xmlns: 'jabber:x:data',
                type: 'submit',
                $elements:
                [
                    {
                        $name: 'field',
                        var: 'FORM_TYPE',
                        value$: 'http://jabber.org/protocol/pubsub#node_config'
                    }
                ]
            }
        }
        var elements = result.x$.$elements
        for(var key in config)
        {
            var element =
            {
                $name: 'field',
                var: key,
                $elements: []
            }
            var value = config[key]
            if('object' == typeof value)
            {
                for(var i in value)
                    element.$elements.push({ $name: 'value', $value: value[i] })
            }
            else
                element.$elements.push({ $name: 'value', $value: value })
            elements.push(element)
        }
        return result
    }

    function sendCreateNode(node, config, callback)
    {
        var message =
        {
            from: jid,
            to: pubsubjid,
            type: 'set',
            pubsub$:
            {
                xmlns: 'http://jabber.org/protocol/pubsub',
                create$: { node: node },
            }
        }
        if(config)
            message.pubsub$.configure$ = buildNodeConfig(node, config)
        return sendIQ(message, callback)
    }

    function sendGetNodeConfig(node, callback)
    {
        return sendIQ({
                          from: jid,
                          to: pubsubjid,
                          type: 'get',
                          pubsub$:
                          {
                              xmlns: 'http://jabber.org/protocol/pubsub#owner',
                              configure$: { node: node }
                          }
                      }, callback)
    }

    function sendSetNodeConfig(node, config, callback)
    {
        return sendIQ({
                          from: jid,
                          to: pubsubjid,
                          type: 'set',
                          pubsub$:
                          {
                              xmlns: 'http://jabber.org/protocol/pubsub#owner',
                              configure$: buildNodeConfig(node, config)
                          }
                      }, callback)
    }

    function sendDeleteNode(node, callback)
    {
        return sendIQ({
                          from: jid,
                          to: pubsubjid,
                          type: 'set',
                          pubsub$:
                          {
                              xmlns: 'http://jabber.org/protocol/pubsub#owner',
                              delete$: { node: node }
                          }
                      }, callback)
    }

    function sendGetNodeSubscriptions(node, callback)
    {
        return sendIQ({
                          from: jid,
                          to: pubsubjid,
                          type: 'set',
                          pubsub$:
                          {
                              xmlns: 'http://jabber.org/protocol/pubsub',
                              subscriptions$: { }
                          }
                      }, callback)
    }

    function sendSubscribeToNode(node, callback)
    {
        return sendIQ({
                          from: jid,
                          to: pubsubjid,
                          type: 'set',
                          pubsub$:
                          {
                              xmlns: 'http://jabber.org/protocol/pubsub',
                              subscribe$: { node: node, jid: jid }
                          }
                      }, callback)
    }

    function sendUnsubscribeFromNode(node, subid, callback)
    {
        return sendIQ({
                          from: jid,
                          to: pubsubjid,
                          type: 'set',
                          pubsub$:
                          {
                              xmlns: 'http://jabber.org/protocol/pubsub',
                              unsubscribe$: { node: node, jid: jid, subid: subid }
                          }
                      }, callback)
    }

}

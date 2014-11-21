import QtQuick 2.0

XMPPClient
{
    property string pubsubjid

    function sendCreateNode(node, callback)
    {
        return sendIQ({
                          from: jid,
                          to: pubsubjid,
                          type: 'set',
                          pubsub$:
                          {
                              xmlns: 'http://jabber.org/protocol/pubsub',
                              create$: { node: node }
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
}

/*
** utils.js by undwad
** some useful javascript extensions
**
** https://github.com/undwad/qmlxmpp mailto:undwad@mail.ru
** see copyright notice in ./LICENCE
*/

String.prototype.toHex = function() { return StringUtils.toHex(this) }
String.prototype.fromHex = function() { return StringUtils.fromHex(this) }
String.prototype.toBase64 = function() { return StringUtils.toBase64(this) }
String.prototype.fromBase64 = function() { return StringUtils.fromBase64(this) }
String.prototype.toHash = function(algorithm) { return StringUtils.toHash(this, algorithm || StringUtils.Md5) }
String.prototype.parseURL = function() { return StringUtils.parseURL(this) }

function toPrettyString(object) { return JSON.stringify(object, null, '\t') }
function prettyPrint(object) { print(toPrettyString(object)) }

function toObject(array, key)
{
    var object = {}
    for(var i in array)
    {
        var item = array[i]
        object[item[key]] = item
    }
    return object
}






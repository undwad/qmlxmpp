String.prototype.toHex = function() { return StringUtils.toHex(this) }
String.prototype.fromHex = function() { return StringUtils.fromHex(this) }
String.prototype.toBase64 = function() { return StringUtils.toBase64(this) }
String.prototype.fromBase64 = function() { return StringUtils.fromBase64(this) }
String.prototype.toHash = function(algorithm) { return StringUtils.toHash(this, algorithm || StringUtils.Md5) }
String.prototype.parseURL = function() { return StringUtils.parseURL(this) }

Object.prototype.stringify = function() { return JSON.stringify(this, null, '\t') }
Object.prototype.print = function() { print(this.stringify()) }

Array.prototype.toObject = function(key)
{
    var object = {}
    for(var i in this)
    {
        var item = this[i]
        object[item[key]] = item
    }
    return object
}





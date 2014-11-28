/*
** utils.js by undwad
** some useful javascript utils
**
** https://github.com/undwad/qmlxmpp mailto:undwad@mail.ru
** see copyright notice in ./LICENCE
*/

function toPrettyString(object) { return JSON.stringify(object, null, '\t') }
function prettyPrint(object) { print(toPrettyString(object)) }

function toObject(key, array)
{
    var object = {}
    for(var i in array)
    {
        var item = array[i]
        object[item[key]] = item
    }
    return object
}

function getNestedValue()
{
    var args = [].slice.call(arguments, 0)
    var object = args.shift()
    var arg = args[0]
    if('function' == typeof arg) object = arg(object)
    else if(arg in object) object = object[arg]
    else object = undefined
    if(object && args.length > 1)
    {
        args[0] = object
        return getNestedValue.apply(null, args)
    }
    return object
}


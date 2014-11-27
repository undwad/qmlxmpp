/*
** utils.js by undwad
** some useful javascript utils
**
** https://github.com/undwad/qmlxmpp mailto:undwad@mail.ru
** see copyright notice in ./LICENCE
*/

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

function hasElementName(object, name) { return name in toObject(object.$elements || [], '$name') }

function firstElementNameOrDefault(object, defname) { return '$elements' in object && object.$elements.length > 0 ? object.$elements[0].$name : defname }



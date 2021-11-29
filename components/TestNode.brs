sub init()
    m.top.setFocus(true)
    data = objectToJson(createObject("roSGNode", "TestNode"))
    ? parseJson(data)
end sub

function objectToJson(inputObj as Object) as String
    if (type(inputObj) = "roArray")
        data = []
        for each item in inputObj
            data.push(objectToJson(item))
        end for
        return formatJson(data)
    else if (type(inputObj) = "roAssociativeArray")
        obj = {}
        for each item in inputObj.items()
            obj.addReplace(item.key, objectToJson(item.value))
        end for
        return formatJson(obj)
    else if (type(inputObj) = "roSGNode")
        nodeFields = inputObj.getFields()

        if (nodeFields.id = Invalid OR len(nodeFields.id) = 0)
            nodeFields.addReplace("id", inputObj.subType())
        end if

        for each item in nodeFields.items()
            key = item.key
            value = item.value

            if (type(value) = "roSGNode")
                nodeFields.addReplace(key, objectToJson(value))
            end if
        end for

        if (inputObj.getChildCount() > 0)
            if (NOT nodeFields.doesExist("childNodes"))
                nodeFields.addReplace("childNodes", [])
            end if
            
            for each node in inputObj.getChildren(-1, 0)
                nodeFields["childNodes"].push(objectToJson(node))
            end for
        end if

        return formatJson(nodeFields)
    else
        return formatJson(inputObj)
    end if
end function
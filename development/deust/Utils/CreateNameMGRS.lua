--[[
---

## CreateNameMGRS(prefix, coord)

### Briefing

This function will combine a given string and coordinates. This function is oriented to be used in other functions or classes where

> ### **Parameters**
>
> |     Name        |             Type               |                 Description                          |
> |:---------------:|:------------------------------:|:-----------------------------------------------------|
> |     prefix      |            String              | Text that will be combined with the MGRS coordinates |
> |     coord       |     Core.Point#COORDINATE [^1] | Moose object that contains the MGRS coordinates      |

> ### **Return**
>
> |     Name        |             Type               |                       Description                            |
> |:---------------:|:------------------------------:|:-------------------------------------------------------------|
> |     output      |            String              | Combination of the basic MGRS coordinates and the given text |

> ### **Example**
>
>> Input: `CreateNameMGRS("TEST", COORDINATE:New(00079977, 0, -00079253))`
>
>> Output: `CQ47_TEST`

### *References*

[^1]: https://flightcontrol-master.github.io/MOOSE_DOCS/Documentation/Core.Point.html
[Core.Point#COORDINATE](https://flightcontrol-master.github.io/MOOSE_DOCS/Documentation/Core.Point.html)

---
]]
--


function CreateNameMGRS(prefix, coord)
    -- ANCHOR: Input validation
    local invalidInput = false

    if type(prefix) ~= "string" then
        invalidInput = true
    end
    if type(coord) ~= "table" or coord.ClassName ~= "COORDINATE" then
        invalidInput = true
    end

    -- ANCHOR: Start point
    if not invalidInput then
        local mgrs = {}
        for value in string.gmatch(coord:GetName(), "%S+") do
            table.insert(mgrs, value)
        end
        local output = mgrs[3] .. string.sub(mgrs[4], 1, 1) .. string.sub(mgrs[5], 1, 1) .. "_" .. prefix
        return output
    else
        env.error("Deust CreateNameMGRS: Invalid Input")
    end
end

deust.utils.CreateNameMGRS = true

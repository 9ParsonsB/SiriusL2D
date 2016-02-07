--Class definitions
local Classes = {}
local Objects = {}
local ObjectCounts = {}

Class = {}

--Copies table
function Class.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Class.deepcopy(orig_key)] = Class.deepcopy(orig_value)
        end
        setmetatable(copy, Class.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--Creates new object from class
Class.__call = function (class, ...)
    local object = Class.deepcopy(class)

    --Call constructor with parameters
    if type(class.Create) == "function" then class.Create(object, ...) end  

    --Store object
    local name = class.GetType()
    Objects[name][ObjectCounts[name]] = object
    ObjectCounts[name] = ObjectCounts[name] + 1--]]

    --Store object as base
    local baseName = class.GetBaseType()
    if baseName then
       Objects[baseName][ObjectCounts[baseName]] = object
       ObjectCounts[baseName] = ObjectCounts[baseName] + 1
    end

    return object
end

--Creates a new class
function Class.New(name, base)    
    local c = setmetatable({}, Class)

    --Copies base class elements into class
    if base then for k, v in pairs(base) do c[k] = v end end

    --Type info
    c.GetType = function () return name end
    c.GetBaseType = function () 
        if base then return base:GetType() end
        return nil
    end

    --Store class definition and create room for objects
    Classes[name] = c
    Objects[name] = setmetatable({}, { __mode = 'v' })
    ObjectCounts[name] = 0

    return c
end

function Class.GetObjectCount(name)
    local count = 0
    if Objects[name] then
        for k,v in pairs(Objects[name]) do count = count + 1 end
    end
    return count
end

function Class.GetObjects(name)
    if Objects[name] then return Objects[name] end
    return nil
end
-- simSurfRec lua type-checking wrapper
-- (this file is automatically generated: do not edit)
require 'checkargs'

local simSurfRec=require('simSurfRec')

__initFunctions=__initFunctions or {}
table.insert(__initFunctions, function()
    local function wrapFunc(funcName,wrapperGenerator)
        _G['simSurfRec'][funcName]=wrapperGenerator(_G['simSurfRec'][funcName])
    end

end)

return simSurfRec

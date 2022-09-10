-- Log function
function GoatHighlighter:Log(msg)
    msg = tostring(msg)
    BLT:Log(LogLevel.INFO, "[Goat Highlighter] "..msg)
end

-- Default configuration
function GoatHighlighter:DefaultConfig()
    return {
        active = false,
        lang_index = 1
    }
end

--------------------------------------------------------------------------------
-- Set up config interface

function GoatHighlighter:loadConfig()
    local file = io.open(self.configPath, 'r')
    if file then
        self.config = json.decode(file:read("a"))
        file:close()
    else
        self:reset()
    end
end

function GoatHighlighter:save()
    if not self.config then return end
    local file = io.open(self.configPath, 'w')
    file:write(json.encode(self.config))
    file:close()
end

function GoatHighlighter:reset()
    self.config = self:DefaultConfig()
    self:save()
end

--------------------------------------------------------------------------------
-- Auxiliary functions

local function tableHasKey(table, key)
    return table ~= nil and key ~= nil and table[key] ~= nil
end

-- Core Getter
function GoatHighlighter:getConfig(key)
    if not tableHasKey(self:DefaultConfig(), key) then
        self:Log("Wrong key passed to getConfig('"..tostring(key).."')")
        return
    elseif not self.config then
        self:loadConfig()
    elseif self.config[key] == nil then
        self.config[key] = self:DefaultConfig()[key]
    end

    return self.config[key]
end

-- Core Setter
function GoatHighlighter:setConfig(key, value)
    if not self.config then
        self:loadConfig()
    end
    if not tableHasKey(self:DefaultConfig(), key) then
        self:Log("Wrong key passed to setConfig('"..tostring(key).."', '"..tostring(value).."')")
        return
    elseif value ~= nil then
        self.config[key] = value
    end

    return self.config[key]
end

--------------------------------------------------------------------------------
-- Getters/Setters

function GoatHighlighter:Active(value)
    return self:setConfig("active", value)
end
function GoatHighlighter:LanguageIndex(value)
    return tonumber(self:setConfig("lang_index", value))
end
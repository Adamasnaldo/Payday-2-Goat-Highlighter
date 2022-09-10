-- Global mod configurations
_G.GoatHighlighter = _G.GoatHighlighter or {}
GoatHighlighter.path = GoatHighlighter.path or ModPath
GoatHighlighter.configPath = GoatHighlighter.configPath or SavePath .. "/GoatHighlighter.txt"

function GoatHighlighter:Require(path)
    dofile(string.format("%s%s", self.path, path .. ".lua"))
end

GoatHighlighter:Require("menu/core")
GoatHighlighter:Require("menu/localization")

--------------------------------------------------------------------------------
-- Actual function to show outlines

function GoatHighlighter:showGoats(unit)
    if not (managers and managers.mission) then return end -- Shouldn't happen, but oh well

    local element_id = 100672 -- "show_goats" element

    -- Search for the element in all mission scripts
    for script_name, script in pairs(managers.mission:scripts() or {}) do
        local element = script:element(element_id)
        if element then
            element:on_executed(unit)
        else
            -- This code should be unreachable, something must've gone wrong
            self:Log("Couldn't find element with id "..tostring(element_id))
        end
    end
end

--------------------------------------------------------------------------------
-- Setup Menu

Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_GoatHighlighter", function(menu_manager)
    local function getBoolItemValue(item)
        return tostring(item:value()) == "on" and true or false
    end
    local function getMultipleChoiceItemValue(item)
        return tonumber(item:value())
    end

    --set up mod option menu
    function MenuCallbackHandler:GoatHighlighter_refocus()
        GoatHighlighter:populate_menu()
    end

    --change language
    function MenuCallbackHandler:GoatHighlighter_changeLanguage(item)
        GoatHighlighter:LanguageIndex(getMultipleChoiceItemValue(item))
    end

    function MenuCallbackHandler:GoatHighlighter_toggleActive(item)
        local value = GoatHighlighter:Active(getBoolItemValue(item))
        if value then GoatHighlighter:showGoats() end
    end

    function MenuCallbackHandler:GoatHighlighter_save()
        GoatHighlighter:save()
    end

    GoatHighlighter:loadConfig()
    MenuHelper:LoadFromJsonFile(GoatHighlighter.path.."/menu/Menu.json", GoatHighlighter, GoatHighlighter.config)
end)



GoatHighlighter.populated_languages_menu = false -- used to create the language selection menu
GoatHighlighter.default_language_code = BLTLocalization.default_language_code or "en"

--------------------------------------------------------------------------------
-- Load all loc files

function GoatHighlighter:load_languages()
    -- Clear languages
    self._languages = {}

    -- Add all localisation files
    local loc_files = file.GetFiles(self.path.."/loc/")
    for i, file_name in ipairs(loc_files) do
        local language = string.gsub(file_name, ".json", "")
        table.insert(self._languages, language)
    end

    -- Sort languages alphabetically by code to ensure we always have the same order (default comes first)
    table.sort(self._languages, function(a, b)
        if a == self.default_language_code then
            return true
        end
        if b == self.default_language_code then
            return false
        end
        return a < b
    end)
end
function GoatHighlighter:languages()
    return self._languages
end

GoatHighlighter:load_languages()

--------------------------------------------------------------------------------
-- Get current language

function GoatHighlighter:Language(value)
    local index = value
    if value ~= nil then
        index = 1
        for i, lang in ipairs(self:languages()) do
            if lang == value then
                index = i
                break
            end
        end
    end

    return self:languages()[self:LanguageIndex(index)]
end

--------------------------------------------------------------------------------
-- Create language selection menu node

function GoatHighlighter:populate_menu()
    if self.populated_languages_menu then
        -- Already populated
        return
    end

    -- Loop through all menu items until we find this mod's
    local menu_item = MenuHelper:GetMenu("id_goathighlighter_options") or {_items = {}}
    for _, item in pairs(menu_item._items) do
        if item._parameters and item._parameters.name == "id_goathighlighter_select_language" then

            -- Add an entry for each language
            for i, lang in ipairs(self:languages()) do
                item:add_option(
                    CoreMenuItemOption.ItemOption:new(
                        {
                            _meta = "option",
                            text_id = managers.localization:text("goathighlighter_language_"..lang),
                            value = i,
                            localize = false
                        }
                    )
                )
            end

            item:set_value(self:LanguageIndex())    -- Set language used to current language
            break
        end
    end
    self.populated_languages_menu = true    -- To run only once
end

--------------------------------------------------------------------------------
-- Load languages once the game's localization manager has been created

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_GoatHighlighter", function(loc)
    local language = GoatHighlighter:Language() or "definitelynotafile"
    loc:load_localization_file(GoatHighlighter.path.."loc/"..language..".json")
end)
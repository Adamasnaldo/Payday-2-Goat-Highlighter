Hooks:PostHook(PlayerManager, "spawned_player", "GoatHighlighter_PlayerManager_spawned_player", function (self, id, unit)
    if managers.job:current_level_id() ~= "peta" -- Goat Simulator level id
        or id ~= 1 -- If you remove this line, remove the argument on the 'showGoats' function below
        or not (GoatHighlighter and GoatHighlighter:Active()) then -- Check if mod was loaded and is active

        return
    end

    GoatHighlighter:showGoats(unit)
end)
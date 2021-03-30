local disconnect_table = {}

-- Sort players into disconnect table
ListenToGameEvent("npc_first_spawn",function(kv)
	local hero = EntIndexToHScript(kv.entindex)


	if (not hero:IsRealHero()) then return end

    disconnect_table[hero:GetTeamNumber()] = disconnect_table[hero:GetTeamNumber()] or {}
    table.insert(disconnect_table[hero:GetTeamNumber()], hero:GetPlayerOwnerID())

end, self)

-- Bruh Timer
ListenToGameEvent("game_rules_state_game_in_progress", function()
    Timers:CreateTimer(0, function()
        EmitGlobalSound("bruh")
        
        for team, players in pairs(disconnect_table) do
            local playerID = players[math.random(#players)]
            GameRules:SendCustomMessage("Goodbye "..PlayerResource:GetPlayerName(playerID), 0, 0)
        end
    end)
end, nil)
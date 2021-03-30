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
        
        local disconnect_table_clone = deepcopy(disconnect_table)
        for i=1,math.min(BUTTINGS.PLAYER_PER_TEAM_DISCONNECT, 5) do
            for team, players in pairs(disconnect_table_clone) do
                local table_index = math.random(#players)
                local playerID = players[table_index]
                GameRules:SendCustomMessage("Goodbye "..PlayerResource:GetPlayerName(playerID), 0, 0)
                SendToServerConsole("kickid " .. playerID+1)

                table.remove(players, table_index)
            end
        end

        return BUTTINGS.DISCONNECT_INTERVAL
    end)
end, nil)
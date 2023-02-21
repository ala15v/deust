--[[
- @brief        This function will search, in the start of the mission, any destroyed static with the given prefix and it will repair it if there are enought crates with the given prefix close to the static
-
- @example      StaticRepair("factory", "repairCrate", 5, 500, "blue")
-
- @param        stPrefix        <String>        This is the prefix of the structures that should be repaired
- @param        cratePrefix     <String>        This is the prefix of the repair crates that will be used to repair the statics
- @param        crates          <Integer>       This is the number of crates needed to repair one structure
- @param        range           <Integer>       This is the radius of the area in meter where the where repair crates will be searched
- @param        coalition       <String>        This is the coalition name of the structures and crates
-
- @see          https://flightcontrol-master.github.io/MOOSE_DOCS/Documentation/Core.Zone.html
- @see          https://flightcontrol-master.github.io/MOOSE_DOCS/Documentation/Core.Set.html
- @see          https://flightcontrol-master.github.io/MOOSE_DOCS/Documentation/Core.SpawnStatic.html
]]--

-- TODO: Add more logs

function StaticRepair(stPrefix, cratePrefix, crates, range, coalition)
    -- Statics database
    local DBObject = SET_STATIC:New()
    DBObject:FilterCoalitions(coalition)
    DBObject:FilterPrefixes(stPrefix)
    DBObject:FilterOnce()

    -- Loop to find destroyed statics
    for _, static in pairs(DBObject:GetSet()) do
        if not static:IsAlive() then
            -- Creating scan zone
            local scanZone = ZONE_RADIUS:New("scanzone" .. static:GetName(), static:GetVec2(), range)

            -- Crates in zone database
            local DBCrate = SET_STATIC:New()
            DBCrate:FilterCoalitions(coalition)
            DBCrate:FilterZones({ scanZone })
            DBCrate:FilterPrefixes(cratePrefix)
            DBCrate:FilterOnce()

            -- Checking minimun amount required
            if DBCrate:Count() >= crates then
                local removedCrates = 0
                -- Loop to remove used crates
                for _, crate in pairs(DBCrate:GetSet()) do
                    if removedCrates < crates then -- This condition prevents deleating more crates than necessary
                        crate:Destroy() -- Remove the crates used to repair
                        removedCrates = removedCrates + 1
                    end
                end

                static:Destroy() -- First remove the destroyed structure
                static:ReSpawn() -- Then respawn the structure
                env.info("Deust StaticRepair: Repaired the structure with name, " ..
                    static:GetName())   -- TODO: Use deustlog
            end
        end
    end
end

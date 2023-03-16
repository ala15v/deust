function TotalWar:GenerateRandomReaction(ZoneType)
    local ZoneType = ZoneType
    local Chief = self.Chief
    local ResourceListEmpty, ResourceEmpty, ResourceEmptyInf
    local ResourceListOccupied, ResourceOccupied, ResourceOccupiedInf

    if ZoneType == "StrategicZone" then
        ResourceListEmpty, ResourceEmptyInf = Chief:CreateResource(AUFTRAG.Type.ONGUARD, 1, 2,
            GROUP.Attribute.GROUND_INFANTRY)
        Chief:AddToResource(ResourceListEmpty, AUFTRAG.Type.PATROLZONE, 1, 2,
            GROUP.Attribute.GROUND_IFV)
        Chief:AddToResource(ResourceListEmpty, AUFTRAG.Type.ONGUARD, 0, 2,
            GROUP.Attribute.GROUND_TRUCK)
        if UTILS.Randomize(100, 1, 0, 100) > 50 then
            Chief:AddToResource(ResourceListEmpty, AUFTRAG.Type.ONGUARD, 0, 2,
                GROUP.Attribute.GROUND_AAA)
        end

        -- Resource Infantry Bravo is transported by up to 2 APCs.
        Chief:AddTransportToResource(ResourceEmptyInf, 1, 2, { GROUP.Attribute.GROUND_TRUCK })


        ResourceListOccupied, ResourceOccupiedInf = Chief:CreateResource(AUFTRAG.Type.ONGUARD, 1, 1,
            GROUP.Attribute.GROUND_INFANTRY)
        if UTILS.Randomize(100, 1, 0, 100) > 60 then
            -- We also add ARTY missions with at least one and at most two assets. We additionally require these to be MLRS groups (and not howitzers).
            Chief:AddToResource(ResourceListOccupied, AUFTRAG.Type.ARTY, 0, 2)
        end
        -- Add at least one RECON mission that uses UAV type assets.
        Chief:AddToResource(ResourceListOccupied, AUFTRAG.Type.RECON, 0, 1, GROUP.Attribute.AIR_UAV)
        if UTILS.Randomize(100, 1, 0, 100) > 70 then
            Chief:AddToResource(ResourceListOccupied, AUFTRAG.Type.ONGUARD, 0, 1,
                GROUP.Attribute.GROUND_TANK)
        end
        Chief:AddToResource(ResourceListOccupied, AUFTRAG.Type.PATROLZONE, 1, 2,
            GROUP.Attribute.GROUND_IFV)
        --Chief:AddToResource(ResourceListOccupied, AUFTRAG.Type.CASENHANCED, 0, 1)

        -- Resource Infantry Bravo is transported by up to 2 APCs.
        Chief:AddTransportToResource(ResourceOccupiedInf, 1, 2, { GROUP.Attribute.GROUND_TRUCK })
    elseif ZoneType == "SamSite" then
        ResourceListEmpty, ResourceEmpty = Chief:CreateResource(AUFTRAG.Type.ONGUARD, 1, 2,
            GROUP.Attribute.GROUND_IFV)
        Chief:AddToResource(ResourceListEmpty, AUFTRAG.Type.ONGUARD, 0, 2,
            GROUP.Attribute.GROUND_TRUCK)
        Chief:AddToResource(ResourceListEmpty, AUFTRAG.Type.ONGUARD, 1, 2,
            GROUP.Attribute.GROUND_AAA)
        Chief:AddToResource(ResourceListEmpty, AUFTRAG.Type.ONGUARD, 1, 2,
            GROUP.Attribute.GROUND_SAM)


        ResourceListOccupied, ResourceOccupied = Chief:CreateResource(AUFTRAG.Type.ONGUARD, 1, 1,
            GROUP.Attribute.GROUND_IFV)
        if UTILS.Randomize(100, 1, 0, 100) > 60 then
            -- We also add ARTY missions with at least one and at most two assets. We additionally require these to be MLRS groups (and not howitzers).
            Chief:AddToResource(ResourceListOccupied, AUFTRAG.Type.ARTY, 0, 2)
        end
        -- Add at least one RECON mission that uses UAV type assets.
        Chief:AddToResource(ResourceListOccupied, AUFTRAG.Type.RECON, 0, 1, GROUP.Attribute.AIR_UAV)
        --Chief:AddToResource(ResourceListOccupied, AUFTRAG.Type.CASENHANCED, 0, 1)
    elseif ZoneType == "CheckPoint" then
        ResourceListEmpty, ResourceEmptyInf = Chief:CreateResource(AUFTRAG.Type.ONGUARD, 1, 1,
            GROUP.Attribute.GROUND_INFANTRY)
        Chief:AddToResource(ResourceListEmpty, AUFTRAG.Type.ONGUARD, 1, 1,
            GROUP.Attribute.GROUND_APC)
        Chief:AddToResource(ResourceListEmpty, AUFTRAG.Type.ONGUARD, 0, 1,
            GROUP.Attribute.GROUND_TRUCK)
        if UTILS.Randomize(100, 1, 0, 100) > 50 then
            Chief:AddToResource(ResourceListEmpty, AUFTRAG.Type.ONGUARD, 0, 1,
                GROUP.Attribute.GROUND_AAA)
        end

        -- Resource Infantry Bravo is transported by up to 2 APCs.
        Chief:AddTransportToResource(ResourceEmptyInf, 1, 1, { GROUP.Attribute.GROUND_TRUCK })


        ResourceListOccupied, ResourceOccupiedInf = Chief:CreateResource(AUFTRAG.Type.ONGUARD, 1, 1,
            GROUP.Attribute.GROUND_INFANTRY)
        Chief:AddToResource(ResourceListOccupied, AUFTRAG.Type.ONGUARD, 1, 2,
            GROUP.Attribute.GROUND_APC)

        -- Resource Infantry Bravo is transported by up to 2 APCs.
        Chief:AddTransportToResource(ResourceOccupiedInf, 1, 1, { GROUP.Attribute.GROUND_TRUCK })
    elseif ZoneType == "SeaZone" then
        ResourceListEmpty, ResourceEmpty = Chief:CreateResource(AUFTRAG.Type.PATROLZONE, 1, 2,
            GROUP.Attribute.NAVAL_ARMEDSHIP)

        ResourceListOccupied, ResourceOccupied = Chief:CreateResource(AUFTRAG.Type.PATROLZONE, 1, 2,
            GROUP.Attribute.NAVAL_ARMEDSHIP)
    end

    return ResourceListEmpty, ResourceListOccupied
end

deust.TotalWar.RandomReaction = true

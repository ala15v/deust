function TotalWar:GenerateRandomReaction(ZoneType)
    local ZoneType = ZoneType
    local ResourceListEmpty, ResourceEmpty, ResourceEmptyInf
    local ResourceListOccupied, ResourceOccupied, ResourceOccupiedInf

    if ZoneType == "StrategicZone" then
        ResourceListEmpty, ResourceEmptyInf = self.Chief:CreateResource(AUFTRAG.Type.ONGUARD, 1, 2,
            GROUP.Attribute.GROUND_INFANTRY)
        self.Chief:AddToResource(ResourceListEmpty, AUFTRAG.Type.PATROLZONE, 1, 2,
            GROUP.Attribute.GROUND_IFV)
        self.Chief:AddToResource(ResourceListEmpty, AUFTRAG.Type.ONGUARD, 0, 2,
            GROUP.Attribute.GROUND_TRUCK)
        if UTILS.Randomize(100, 1, 0, 100) > 50 then
            self.Chief:AddToResource(ResourceListEmpty, AUFTRAG.Type.ONGUARD, 0, 2,
                GROUP.Attribute.GROUND_AAA)
        end

        -- Resource Infantry Bravo is transported by up to 2 APCs.
        self.Chief:AddTransportToResource(ResourceEmptyInf, 1, 2, { GROUP.Attribute.GROUND_TRUCK })


        ResourceListOccupied, ResourceOccupiedInf = self.Chief:CreateResource(AUFTRAG.Type.ONGUARD, 1, 1,
            GROUP.Attribute.GROUND_INFANTRY)
        if UTILS.Randomize(100, 1, 0, 100) > 60 then
            -- We also add ARTY missions with at least one and at most two assets. We additionally require these to be MLRS groups (and not howitzers).
            self.Chief:AddToResource(ResourceListOccupied, AUFTRAG.Type.ARTY, 0, 2)
        end
        -- Add at least one RECON mission that uses UAV type assets.
        self.Chief:AddToResource(ResourceListOccupied, AUFTRAG.Type.RECON, 0, 1, GROUP.Attribute.AIR_UAV)
        if UTILS.Randomize(100, 1, 0, 100) > 70 then
            self.Chief:AddToResource(ResourceListOccupied, AUFTRAG.Type.ONGUARD, 0, 1,
                GROUP.Attribute.GROUND_TANK)
        end
        self.Chief:AddToResource(ResourceListOccupied, AUFTRAG.Type.PATROLZONE, 1, 2,
            GROUP.Attribute.GROUND_IFV)
        --self.Chief:AddToResource(ResourceListOccupied, AUFTRAG.Type.CASENHANCED, 0, 1)

        -- Resource Infantry Bravo is transported by up to 2 APCs.
        self.Chief:AddTransportToResource(ResourceOccupiedInf, 1, 2, { GROUP.Attribute.GROUND_TRUCK })
    elseif ZoneType == "SamSite" then
        ResourceListEmpty, ResourceEmpty = self.Chief:CreateResource(AUFTRAG.Type.ONGUARD, 1, 2,
            GROUP.Attribute.GROUND_IFV)
        self.Chief:AddToResource(ResourceListEmpty, AUFTRAG.Type.ONGUARD, 0, 2,
            GROUP.Attribute.GROUND_TRUCK)
        self.Chief:AddToResource(ResourceListEmpty, AUFTRAG.Type.ONGUARD, 1, 2,
            GROUP.Attribute.GROUND_AAA)
        self.Chief:AddToResource(ResourceListEmpty, AUFTRAG.Type.ONGUARD, 1, 2,
            GROUP.Attribute.GROUND_SAM)


        ResourceListOccupied, ResourceOccupied = self.Chief:CreateResource(AUFTRAG.Type.ONGUARD, 1, 1,
            GROUP.Attribute.GROUND_IFV)
        if UTILS.Randomize(100, 1, 0, 100) > 60 then
            -- We also add ARTY missions with at least one and at most two assets. We additionally require these to be MLRS groups (and not howitzers).
            self.Chief:AddToResource(ResourceListOccupied, AUFTRAG.Type.ARTY, 0, 2)
        end
        -- Add at least one RECON mission that uses UAV type assets.
        self.Chief:AddToResource(ResourceListOccupied, AUFTRAG.Type.RECON, 0, 1, GROUP.Attribute.AIR_UAV)
        --self.Chief:AddToResource(ResourceListOccupied, AUFTRAG.Type.CASENHANCED, 0, 1)
    elseif ZoneType == "CheckPoint" then
        ResourceListEmpty, ResourceEmptyInf = self.Chief:CreateResource(AUFTRAG.Type.ONGUARD, 1, 1,
            GROUP.Attribute.GROUND_INFANTRY)
        self.Chief:AddToResource(ResourceListEmpty, AUFTRAG.Type.ONGUARD, 1, 1,
            GROUP.Attribute.GROUND_APC)
        self.Chief:AddToResource(ResourceListEmpty, AUFTRAG.Type.ONGUARD, 0, 1,
            GROUP.Attribute.GROUND_TRUCK)
        if UTILS.Randomize(100, 1, 0, 100) > 50 then
            self.Chief:AddToResource(ResourceListEmpty, AUFTRAG.Type.ONGUARD, 0, 1,
                GROUP.Attribute.GROUND_AAA)
        end

        -- Resource Infantry Bravo is transported by up to 2 APCs.
        self.Chief:AddTransportToResource(ResourceEmptyInf, 1, 1, { GROUP.Attribute.GROUND_TRUCK })


        ResourceListOccupied, ResourceOccupiedInf = self.Chief:CreateResource(AUFTRAG.Type.ONGUARD, 1, 1,
            GROUP.Attribute.GROUND_INFANTRY)
        self.Chief:AddToResource(ResourceListOccupied, AUFTRAG.Type.ONGUARD, 1, 2,
            GROUP.Attribute.GROUND_APC)

        -- Resource Infantry Bravo is transported by up to 2 APCs.
        self.Chief:AddTransportToResource(ResourceOccupiedInf, 1, 1, { GROUP.Attribute.GROUND_TRUCK })
    elseif ZoneType == "SeaZone" then
        ResourceListEmpty, ResourceEmpty = self.Chief:CreateResource(AUFTRAG.Type.PATROLZONE, 1, 2,
            GROUP.Attribute.NAVAL_ARMEDSHIP)

        ResourceListOccupied, ResourceOccupied = self.Chief:CreateResource(AUFTRAG.Type.PATROLZONE, 1, 2,
            GROUP.Attribute.NAVAL_ARMEDSHIP)
    end

    return ResourceListEmpty, ResourceListOccupied
end

deust.TotalWar.RandomReaction = true

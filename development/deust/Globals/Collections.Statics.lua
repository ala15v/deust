deust.Collections.Statics = {}
deust.Collections.Groups = {}

deust.Collections.Statics.FARP_Invisible = {
    ["category"] = "Heliports",
    ["shape_name"] = "invisiblefarp",
    ["country"] = "USA",
    ["type"] = "Invisible FARP",
    ["heliport_callsign_id"] = 1,
    ["heliport_modulation"] = 0,
    ["rate"] = 100,
    ["y"] = -00285950,
    ["x"] = 00075901,
    ["name"] = "templateFOB",
    ["heliport_frequency"] = "127.5",
    ["heading"] = 0,
    ["clone"] = true
}


deust.Collections.Statics.FARP_Ammo = {
    ["category"] = "Fortifications",
    ["shape_name"] = "SetkaKP",
    ["type"] = "FARP Ammo Dump Coating",
    ["country"] = "USA",
    ["rate"] = 50,
    ["y"] = -00285950,
    ["x"] = 00075801,
    ["name"] = "templateFOBAmmo",
    ["heading"] = 0,
}

deust.Collections.Statics.FARP_Fuel = {
    ["category"] = "Fortifications",
    ["shape_name"] = "GSM Rus",
    ["type"] = "FARP Fuel Depot",
    ["country"] = "USA",
    ["rate"] = 20,
    ["y"] = -00285950,
    ["x"] = 00075701,
    ["name"] = "templateFOBFuel",
    ["heading"] = 0,
}

deust.Collections.Statics.FARP_Tent = {
    ["category"] = "Fortifications",
    ["shape_name"] = "PalatkaB",
    ["type"] = "FARP Tent",
    ["country"] = "USA",
    ["y"] = -00285950,
    ["x"] = 00075601,
    ["name"] = "templateFOBTent",
    ["heading"] = 0,
}

deust.Collections.Statics.SoldierM4 = {
    ["effectPreset"] = "1",
    ["category"] = "Infantry",
    ["effectTransparency"] = 1,
    ["type"] = "Soldier M4",
    ["country"] = "USA",
    ["rate"] = 1,
    ["y"] = -00285950,
    ["x"] = 00075501,
    ["name"] = "templateFOBSoldier",
    ["heading"] = 0,
}



deust.Collections.Groups.FARP_Repair = {
    ["country"] = "USA",
    ["category"] = "GROUND_UNIT",
    ["name"] = "templateFOBRepairGP",
    ["y"] = -00285950,
    ["x"] = 00075401,
    ["units"] =
    {
        [1] =
        {
            ["skill"] = "Average",
            ["coldAtStart"] = false,
            ["type"] = "M 818",
             ["name"] = "Suelo-2-1",
            ["heading"] = 0,
            ["playerCanDrive"] = false,
        },
    },
}


deust.fatcow.SpawnFOB = SPAWNSTATIC:NewFromTemplate(deust.Collections.Statics.FARP_Invisible, country.id.USA)
deust.fatcow.SpawnFuel = SPAWNSTATIC:NewFromTemplate(deust.Collections.Statics.FARP_Ammo, country.id.USA)
deust.fatcow.SpawnAmmo = SPAWNSTATIC:NewFromTemplate(deust.Collections.Statics.FARP_Fuel, country.id.USA)
deust.fatcow.SpawnTent = SPAWNSTATIC:NewFromTemplate(deust.Collections.Statics.FARP_Tent, country.id.USA)
deust.fatcow.SpawnSoldier = SPAWNSTATIC:NewFromTemplate(deust.Collections.Statics.SoldierM4, country.id.USA)
deust.fatcow.SpawnRepair = SPAWN:NewFromTemplate(deust.Collections.Groups.FARP_Repair, "templateFOBRepairGP")
deust.fatcow.SpawnRepair:InitCountry(country.id.USA)
deust.fatcow.SpawnRepair:InitCategory(Group.Category.GROUND)
deust.fatcow.SpawnRepair:InitCoalition(coalition.side.BLUE)
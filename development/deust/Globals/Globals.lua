-- Remembers
-- Set a trigger after main scripts setting this variable with correct path:
--  STTS.DIRECTORY = "G:\\JUEGOS\\DCS SimpleRadio"

deust = {}
deust.SRS = false
deust.SRS_Directory = nil
deust.SRS_Tactical = "231"
deust.SRS_Modulation = "AM"
deust.SRS_Volume = "1.0"
deust.SRS_Callsign = "ALA15V"
deust.SRS_Coalition = 2 -- 2 blue, 1 red
deust.SRS_Gender = "female"
deust.SRS_Language = "es-ES"
deust.SRS_Speed = 0
deust.G2ADispatcher = {}
deust.G2ADispatcher.SpotterPrefix = 'RedSpotter'
deust.G2ADispatcher.ChasePursuitGroups = {}
deust.G2ADispatcher.AutocargoChasePursuitGroups = {}
deust.G2ADispatcher.ChasingGroups = {}
deust.G2ADispatcher.ChasingGroupsPrefix = 'ChasePursuitGroup'

deust.G2GDispatcher = {}
deust.G2GDispatcher.ChasingGroups = {}
deust.G2GDispatcher.GroundSpotterPrefix = 'GSpotter'
deust.G2GDispatcher.GroundChasingGroupPrefix = 'GChaser'
deust.G2GDispatcher.GroundAutocargoChasingCarrierPrefix = 'G2GCargoChaser'
deust.G2GDispatcher.SuicideBombPrefix = 'SuicideBomb'
deust.G2GDispatcher.DetectionRange = 5000
deust.G2GDispatcher.FriendliesRange = 5000
deust.G2GDispatcher.DetectionRefresh = 30
deust.G2GDispatcher.AnticipationSeconds = 30
deust.G2GDispatcher.InterceptSpeed = 40
deust.G2GDispatcher.ThreatDistance = 100

deust.Autocargo = {}
deust.Autocargo.CarrierPrefix = 'Autocargo'
deust.AutocargoAndChaser = {}
deust.AutocargoAndChaser.CarrierPrefix = 'ChaserAutocargo'
deust.Autocargo.CargoSuffix = '_Cargo'
deust.Supression = {}
deust.Supression.GroupPrefix = 'deust Supression'
deust.Supression.RandomRouteGroupPrefix = 'deust Supression RRoute'
deust.RandomRoute = {}
deust.RandomRoute.Prefix = 'deust Supression RRoute'

-- Fat Cow detection
deust.fatcow = {}
deust.fatcow.groupName = 'FatcowGroup1-1'
deust.fatcow.EscortGroupName = 'FatcowEscortGroup'
deust.fatcow.EscortGroup = nil
deust.fatcow.farp_statics = {}
deust.fatcow.dead = false
-- TODO: temporal antes que se creen las unidades desde cero. Así evitamos que rompa
deust.fatcow.SpawnFOB = ( STATIC:FindByName("templateFOB", false) and SPAWNSTATIC:NewFromStatic( "templateFOB", country.id.USA ) or nil )
deust.fatcow.SpawnFuel = ( STATIC:FindByName("templateFOBFuel", false) and SPAWNSTATIC:NewFromStatic("templateFOBFuel", country.id.USA) or nil )
deust.fatcow.SpawnAmmo = ( STATIC:FindByName("templateFOBAmmo", false) and SPAWNSTATIC:NewFromStatic("templateFOBAmmo", country.id.USA) or nil )
deust.fatcow.SpawnTent = ( STATIC:FindByName("templateFOBTent", false) and SPAWNSTATIC:NewFromStatic("templateFOBTent", country.id.USA) or nil )
deust.fatcow.SpawnSoldier = ( STATIC:FindByName("templateFOBSoldier", false) and SPAWNSTATIC:NewFromStatic("templateFOBSoldier", country.id.USA) or nil )
deust.fatcow.SpawnRepair = 'templateFOBRepairGP'

-- SECTION: Utils
deust.utils = {}
deust.utils.StaticRepair = false
deust.utils.CreateNameMGRS = false
-- !SECTION


-- SECTION: Economy
deust.Economy = {}
deust.Economy.EconomyDB = {}
deust.Economy.TransactionDB = {}
deust.Economy.Main = false
deust.Economy.Methods = false
deust.Economy.Save = false
deust.Economy.Transactions = false
-- !SECTION

-- SECTION: TotalWar
deust.TotalWar = {}
deust.TotalWar.StrategicZones = {}
-- !SECTION
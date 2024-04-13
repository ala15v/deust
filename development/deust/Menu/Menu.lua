-------------------
-- CUSTOM MENUS  --
-------------------
MenuALA15VBlue = MENU_COALITION:New( coalition.side.BLUE, 'ALA15V Blue' )
MenudeustManagement = MENU_COALITION:New( coalition.side.BLUE, 'deust Menu', MenuALA15VBlue )
FatCowCurrentPosition = MENU_COALITION_COMMAND:New(coalition.side.BLUE, 'FatCow Position', MenudeustManagement, deust.fatcow.getPosition, {})
FotCowEstimatedTime = MENU_COALITION_COMMAND:New(coalition.side.BLUE, 'FatCow ETA', MenudeustManagement, deust.fatcow.ETAtoLanding, {})
FotCowLZCoords = MENU_COALITION_COMMAND:New(coalition.side.BLUE, 'FatCow LZ Coords', MenudeustManagement, deust.fatcow.GetLLDDM, {})


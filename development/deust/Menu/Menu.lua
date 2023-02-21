-------------------
-- CUSTOM MENUS  --
-------------------
MenudeustManagement = MENU_COALITION:New( coalition.side.BLUE, 'deust Menu' )
FatCowCurrentPosition = MENU_COALITION_COMMAND:New(coalition.side.BLUE, 'FatCow Position', MenudeustManagement, deust.fatcow.getPosition, {})
FotCowEstimatedTime = MENU_COALITION_COMMAND:New(coalition.side.BLUE, 'FatCow ETA', MenudeustManagement, deust.fatcow.ETAtoLanding, {})
FotCowLZCoords = MENU_COALITION_COMMAND:New(coalition.side.BLUE, 'FatCow LZ Coords', MenudeustManagement, deust.fatcow.GetLLDDM, {})


---@diagnostic disable: need-check-nil
-- Build a Static Unified File or Dynamic Load to go on developing
-- Thanks to DCS Moose, it is fully based on their building script
-- DCS MOOSE reference: https://github.com/FlightControl-Master

local deustDynamicOrStatic = arg[1] -- usually S (static)
local deustCommitHash = arg[2] -- usually LOCAL (it will be calculated)
local deustDevelopmentPath = arg[3] -- usually directory where modules files are located
local deustSetupPath = arg[4] -- support scripts location
local deustTargetPath = arg[5] -- output directory, build/

print ("Building deust...")
print( "deust (D)ynamic (S)tatic  : " .. deustDynamicOrStatic )
print( "Commit Hash ID            : " .. deustCommitHash )
print( "deust development path    : " .. deustDevelopmentPath )
print( "deust setup path          : " .. deustSetupPath )
print( "deust target path         : " .. deustTargetPath )

local deustModulesFilePath =  deustDevelopmentPath .. "/Modules.lua"
local LoaderFilePath = deustTargetPath .. "/deust.lua"

print( "Reading deust source list : " .. deustModulesFilePath )

local LoaderFile = io.open( LoaderFilePath, "w" )

local deustLoaderPath
if deustDynamicOrStatic == "D" then
    deustLoaderPath = deustSetupPath .. "/deust_Dynamic_Loader.lua"
elseif deustDynamicOrStatic == "S" then
    deustLoaderPath = deustSetupPath .. "/deust_Static_Loader.lua"
else
    print( string.format("ERROR: first parameter not recognized - %s", deustDynamicOrStatic))
end

local deustLoader = io.open( deustLoaderPath, "r" )
local deustLoaderText = deustLoader:read( "*a" )
deustLoader:close()

if deustDynamicOrStatic == "D" then
  -- calculate local path
  local cwd = io.popen"cd":read'*l'
  cwd = cwd:gsub("\\", "/")
  LoaderFile:write( string.format("local _deust_BASE_PATH = '%s/development/'\r\n", cwd) )
end

local commit = io.popen("git describe --always --tags", "r"):read()
LoaderFile:write( string.format("env.info('*** deust Running Git Information: %s ***')\n", commit) )

LoaderFile:write( deustLoaderText )

local deustSourcesFile = io.open( deustModulesFilePath, "r" )
local deustSource = deustSourcesFile:read("*l")

while( deustSource ) do
    if deustSource ~= "" then
      deustSource = string.match( deustSource,  "deust/(.+)'" )
      local deustFilePath = deustDevelopmentPath .. "/deust/" .. deustSource
      if deustDynamicOrStatic == "D" then
        print( "Load dynamic: " .. deustFilePath )
      end
      if deustDynamicOrStatic == "S" then
        print( "Load static: " .. deustFilePath )        
        local deustSourceFile = io.open( deustFilePath, "r" )
        local deustSourceFileText = deustSourceFile:read( "*a" )
        deustSourceFile:close()
        LoaderFile:write( deustSourceFileText )
      end
    end
    deustSource = deustSourcesFile:read("*l")
  end

if deustDynamicOrStatic == "D" then
    LoaderFile:write( "BASE:TraceOnOff( true )\n" )
end
if deustDynamicOrStatic == "S" then
    LoaderFile:write( "BASE:TraceOnOff( false )\n" )
end

LoaderFile:write( "env.info( '*** deust INCLUDE END *** ' )\n" )

deustSourcesFile:close()
LoaderFile:close()

-- generate assert file for your dcs mission
local cwd = io.popen"cd":read'*l'

if deustDynamicOrStatic == "S" then
    print()
    print('Ready to add deust.lua on your DO SCRIPT trigger START MISSION')
    print()
    print(string.format('File located on %s\\build\\deust.lua', cwd))
    print()
else
    cwd = cwd:gsub("\\", "\\\\")
    print()
    print('Copy this string and add to your mission as DO SCRIPT trigger a START MISSION after MOOSE load:')
    print()
    print(string.format("assert(loadfile('%s\\\\build\\\\deust.lua'))()", cwd))
    print()
    print('***')
    print('WARNING: Remember desantized your MissionScripting.lua')
    print('***')
end

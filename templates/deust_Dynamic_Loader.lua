env.info( '*** DEUST DYNAMIC INCLUDE START *** ' )

local base = _G

__deust = {}

__deust.Include = function( IncludeFile )
	if not __deust.Includes[ IncludeFile ] then
		__deust.Includes[IncludeFile] = IncludeFile
		local f = assert( base.loadfile( _deust_BASE_PATH .. IncludeFile ) )
		if f == nil then
			error ("deust: Could not load unified file " .. IncludeFile )
		else
			env.info( "deust: " .. IncludeFile .. " dynamically loaded." )
			return f()
		end
	end
end

__deust.Includes = {}
__deust.Include( 'Modules.lua' )

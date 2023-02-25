------------------------
-- START Random Route --
------------------------
SetRandomSupressionRGroups = SET_GROUP:New():FilterPrefixes( deust.Supression.RandomRouteGroupPrefix ):FilterOnce()
SetRandomSupressionRGroups:ForEachGroup(
    function( MooseGroup )
        local route = MooseGroup:GetTaskRoute()
        if #route > 1 then
            MooseGroup:PatrolRouteRandom(60, 'Cone')
        end
    end
)

SetRandomRGroups = SET_GROUP:New():FilterPrefixes( deust.RandomRoute.Prefix ):FilterOnce()
SetRandomRGroups:ForEachGroup(
    function( MooseGroup )
        local route = MooseGroup:GetTaskRoute()
        if #route > 1 then
            MooseGroup:PatrolRouteRandom(60, 'Cone')
        end
    end
)
--##################--
-- END Random Route --
--##################--


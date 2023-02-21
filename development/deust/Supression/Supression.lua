----------------------
-- START Supression --
----------------------

local GroupsSupressables = {}
SetSupressionGroups = SET_GROUP:New()
    :FilterPrefixes( deust.Supression.GroupPrefix )
    :FilterOnce()

SetSupressionGroups:ForEachGroup(
function( MooseGroup )
    GroupsSupressables[MooseGroup.GroupName] = SUPPRESSION:New( MooseGroup )
    GroupsSupressables[MooseGroup.GroupName]:Fallback( true )
    GroupsSupressables[MooseGroup.GroupName]:Takecover ( true )
    GroupsSupressables[MooseGroup.GroupName]:__Start(5)
end
)

--################--
-- END Supression --
--################--


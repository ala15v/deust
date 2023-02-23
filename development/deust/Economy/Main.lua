-- ANCHOR: Class declaration
Economy = {
    ClassName = "Economy",
    Alias = nil,
    Coalition = nil,
    Funds = 0,
    Industry = {},
    DefenseBudget = 0, -- percent
    SaveFile = nil,
    Running = false
}

-- ANCHOR: Constructor
function Economy:New(alias, coalition)
    -- Input validation
    local invalidInput = false

    if type(alias) ~= "string" then
        invalidInput = true
    end
    if type(coalition) ~= "string" then
        invalidInput = true
    end

    if not invalidInput then
        self.Alias = alias
        self.Coalition = string.lower(coalition) -- converting value to lower case


        -- SECTION: FSM Transitions
        -- Start State.
        self:SetStartState("NotReadyYet")

        -- Add FSM transitions.
        --                 From State   -->   Event        -->     To State
        self:AddTransition("NotReadyYet", "Load", "Loaded") -- Load the warehouse state from scatch.
        -- !SECTION
    else
        env.error("Deust Economy.New(): Invalid Input")
    end
end

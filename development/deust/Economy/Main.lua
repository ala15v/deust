-- ANCHOR: Class declaration
Economy = {
    ClassName = "Economy",
    Alias = nil,
    Coalition = nil,
    Funds = 0,
    Industry = {},
    DefenseBudget = 0, -- percent
    SavePath = lfs.writedir() .. "Economy\\",
    SaveFile = nil,
    Running = false
}

-- ANCHOR: Constructor
function Economy:New(alias, coalition)
    -- Input validation
    local invalidInput = false

    -- Inherit everthing from FSM class.
    local self = BASE:Inherit(self, FSM:New()) -- #Economy

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
        --                 From State   -->         Event        -->     To State
        self:AddTransition("NotReadyYet", "Load", "Loaded") -- Load the Economy state from scatch.
        self:AddTransition("Stopped", "Load", "Loaded") -- Load the Economy state stopped state.

        self:AddTransition("NotReadyYet", "Start", "Running") -- Start the Economy from scratch.
        self:AddTransition("Loaded", "Start", "Running") -- Start the Economy when loaded from disk.

        self:AddTransition("*", "Stop", "Stopped") -- Stop the Economy.
        self:AddTransition("Running", "Pause", "Paused") -- Pause the processing of new requests.
        self:AddTransition("Paused", "Unpause", "Running") -- Unpause the Economy. Queued requests are processed again.

        self:AddTransition({ "Paused", "Stopped" }, "Save", "*") -- Save the Economy state to disk.
        -- !SECTION
    else
        env.error("Deust Economy.New(): Invalid Input")
    end
end

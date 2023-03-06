-- ANCHOR: Class declaration
Economy = {
    ClassName = "Economy",
    uid = nil,
    Alias = nil,
    Coalition = nil,
    Funds = 0,
    PreAuthorized = 0,
    TransactionsQueue = {},
    TransactionsDelay = 30,
    SavePath = lfs.writedir() .. "Economy", -- C:\Users\<user>\Saved Games\DCS.openbeta\Economy -- NOTE: Path must exist
    SaveFile = nil,
    AutoSave = nil,
    LogHeader = ""
}

-- ANCHOR: Constructor
-- TODO: Add logs
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
        self.uid = #deust.Economy.EconomyDB + 1
        self.LogHeader = string.format("Economy %s | ", self.Alias)
        self.Coalition = string.lower(coalition) -- converting value to lower case
        self.SaveFile = string.format("%s_Account.lua", self.Alias)


        -- SECTION: FSM Transitions
        -- Start State.
        self:SetStartState("NotReadyYet")

        -- Add FSM transitions.
        --                 From State   -->         Event        -->     To State
        self:AddTransition("NotReadyYet", "Load", "Loaded")          -- Load the Economy state from scatch.
        self:AddTransition("Stopped", "Load", "Loaded")              -- Load the Economy state stopped state.

        self:AddTransition("NotReadyYet", "Start", "Running")        -- Start the Economy from scratch.
        self:AddTransition("Loaded", "Start", "Running")             -- Start the Economy when loaded from disk.

        self:AddTransition("*", "Stop", "Stopped")                   -- Stop the Economy.
        self:AddTransition("Running", "Pause", "Paused")             -- Pause the processing of new requests.
        self:AddTransition("Paused", "Unpause", "Running")           -- Unpause the Economy. Queued requests are processed again.

        self:AddTransition({ "Paused", "Stopped" }, "Save", "*")     -- Save the Economy state to disk.

        self:AddTransition("*", "AddTransaction", "*")               -- Add transaction to the queue.
        self:AddTransition("*", "CheckTransactions", "*")            -- Check transactions in the queue.
        self:AddTransition("Running", "ProcessSelfTransaction", "*") -- Process the next transaction in the queue.
        self:AddTransition("Running", "ProcessTransaction", "*")     -- Process the next transaction in the queue.
        -- !SECTION

        table.insert(deust.Economy.EconomyDB, self)     -- Inserting the new class into the main Economy DataBase
        return self
    end
    env.error("Deust Economy.New(): Invalid Input")
    return false
end

function Economy:onleaveNotReadyYet(From, Event, To)
    -- Checking all components are loaded
    local Main = deust.Economy.Main
    local Methods = deust.Economy.Methods
    local Transactions = deust.Economy.Transactions
    local Save = deust.Economy.Save
    -- Not many modules for now.... They are coming ;)

    -- TODO: Add logs
    return (Main and Methods and Transactions and Save) -- If FALSE it will stop the transition
end

function Economy:onafterStart(From, Event, To)
    self:__CheckTransactions(self.TransactionsDelay)
    if self.AutoSave then
        self:__Pause(self.AutoSave, true)
    end
end

function Economy:onafterPause(From, Event, To, Save)
    if Save then
        self:Save()
    end
end

function Economy:onafterUnpause(From, Event, To)
    if self.AutoSave then
        self:__Pause(self.AutoSave, true)
    end
end

function Economy:onbeforeCheckTransactions(From, Event, To)
    -- TODO: filter invalid transactions in the queue
    --local TransactionFSMstate=self.TransactionsQueue[1]:GetState()
end

function Economy:onafterCheckTransactions(From, Event, To)
    local nTransactions = #self.TransactionsQueue

    if nTransactions > 0 then
        local nextTransaction = self.TransactionsQueue[1]
        if nextTransaction.From and nextTransaction.To then
            self:__ProcessTransaction(1, nextTransaction)
        else
            self:__ProcessSelfTransaction(1, nextTransaction)
        end
    end

    self:__CheckTransactions(self.TransactionsDelay)
end

deust.Economy.Main = true

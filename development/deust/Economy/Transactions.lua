-- SECTION: Class Transaction
-- ANCHOR: Class declaration
Transaction = {
    ClassName = "Transaction",
    uid = nil,
    From = nil, -- #Economy
    To = nil,   -- #Economy
    Ammount = 0,
    Comment = nil,
    LogHeader = ""
}

-- ANCHOR: Constructor
function Transaction:New(From, To, Ammount, Comment)
    local From = From
    local To = To
    local Ammount = tonumber(Ammount)
    local Comment = Comment

    -- Inherit everthing from FSM class.
    local self = BASE:Inherit(self, FSM:New()) -- #Economy

    -- ANCHOR: Input validation
    if type(From) ~= "nil" then -- if nil it is selftransaction
        if type(From) ~= "table" then
            return false
        end
    end
    if type(To) ~= "nil" then -- if nil it is selftransaction
        if type(To) ~= "table" then
            return false
        end
    end
    if not Ammount then
        return false
    end
    if type(Comment) ~= "nil" then -- nil is valid
        if type(Comment) ~= "string" then
            return false
        end
    end
    if not (From or To) then -- must be a source or a destination
        return false
    end
    if From and To then
        if From.uid == To.uid then -- source and destination can not be the same object
            return false
        end
    end

    -- ANCHOR: After validation
    self.uid = #deust.Economy.TransactionDB + 1
    self.From = From
    self.To = To
    self.Ammount = Ammount
    self.Comment = Comment
    self.LogHeader = string.format("Transaction %s | ", self.uid)

    -- SECTION: FSM Transitions
    -- Start State.
    self:SetStartState("None")

    -- Add FSM transitions.
    --                 From State   -->         Event        -->     To State
    self:AddTransition("None", "PreAuthorize", "PreAuthorized")            -- Declare the Transaction as PreAuthorized.

    self:AddTransition("PreAuthorized", "Approve", "Completed")            -- Declare the Transaction as Completed.
    self:AddTransition({ "None", "PreAuthorized" }, "Cancel", "Cancelled") -- Declare the Transaction as Cancelled.
    -- !SECTION

    table.insert(deust.Economy.TransactionDB, self) -- Inserting the new class into the main Transaction DataBase
    return self
end

-- !SECTION

function Economy:onbeforeAddTransaction(From, Event, To, Transaction)
    local source = Transaction.From
    local destination = Transaction.To

    if destination and destination.uid == self.uid then
        -- Always preauthorized if the Economy object is receiving the transition
        return true
    end

    if source and source.uid == self.uid then
        local ammount = Transaction.Ammount
        local funds = self:GetFunds()
        local preAuthorized = self:GetPreAuthorized()
        local minFunds = preAuthorized + ammount

        -- Check the PreAuthorized value is not bigger than the funds available
        if funds >= minFunds then
            return true
        end
    end

    Transaction:Cancel("Invalid transition") -- If the transition is not added to the queue it should be cancelled
    return false
end

function Economy:onafterAddTransaction(From, Event, To, Transaction)
    local source = Transaction.From

    Transaction:PreAuthorize() -- FSM is wonderful
    table.insert(self.TransactionsQueue, Transaction)
    if source and source.uid == self.uid then
        self:IncreasePreAuthorized(Transaction.Ammount) -- if the Economy is the source of the transition the preauthorized values is increased
    end
end

function Economy:onbeforeProcessSelfTransaction(From, Event, To, Transaction)
    local source = Transaction.From
    local destination = Transaction.To

    if source then
        return self:DecreaseFunds(Transaction.Ammount)
    end
    if destination then
        return self:IncreaseFunds(Transaction.Ammount)
    end

    return false
end

function Economy:onafterProcessSelfTransaction(From, Event, To, Transaction)
    local source = Transaction.From

    if source and source.uid == self.uid then
        self:DecreasePreAuthorized(Transaction.Ammount) -- if the Economy is the source of the transition the preauthorized values is decreased
    end
    self:DeleteQueueItem(Transaction, self.TransactionsQueue)
    Transaction:Approve()
end

function Economy:onbeforeProcessTransaction(From, Event, To, Transaction)
    local source = Transaction.From
    local destination = Transaction.To

    if source and source.uid == self.uid then
        return self:DecreaseFunds(Transaction.Ammount)
    end
    if destination and destination.uid == self.uid then
        return self:IncreaseFunds(Transaction.Ammount)
    end

    return false
end

function Economy:onafterProcessTransaction(From, Event, To, Transaction)
    local source = Transaction.From
    local destination = Transaction.To

    if destination and destination.uid == self.uid then
        Transaction:Approve()
    end
    if source and source.uid == self.uid then
        local Transaction = Transaction

        function Transaction:onafterCancel(From, Event, To, Comment)
            --TODO
        end

        self:DecreasePreAuthorized(Transaction.Ammount) -- if the Economy is the source of the transition the preauthorized values is decreased
        destination:AddTransaction(Transaction)
    end
    self:DeleteQueueItem(Transaction, self.TransactionsQueue)
end

deust.Economy.Transactions = true

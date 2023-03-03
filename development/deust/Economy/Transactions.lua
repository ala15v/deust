-- SECTION: Class Transaction
-- ANCHOR: Class declaration
Transaction = {
    ClassName = "Transaction",
    From = nil, -- #Economy
    To = nil,   -- #Economy
    Ammount = 0,
    Comment = nil,
    LogHeader = ""
}

-- ANCHOR: Constructor
function Transaction:New(From, To, Ammount, Requester, Comment)
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

    -- ANCHOR: After validation
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

    return self
end

-- !SECTION

function Economy:onbeforeAddTransaction(From, Event, To, Transaction)
    local ammount = Transaction.Ammount
    local funds = self:GetFunds()
    local preAuthorized = self:GetPreAuthorized()
    local minFunds = preAuthorized + ammount


    -- Check the PreAuthorized value is not bigger than the funds available
    if funds >= minFunds then
        return true
    end
    return false
end

function Economy:onafterAddTransaction(From, Event, To, Transaction)
    Transaction:PreAuthorize()
    table.insert(self.TransactionsQueue, Transaction)
end

function Economy:onbeforeProcessSelfTransaction(From, Event, To, Transaction)
    if Transaction.From then
        return self:Decrease(Transaction.Ammount)
    end
    if Transaction.To then
        return self:Increase(Transaction.Ammount)
    end

    return false
end

function Economy:onafterProcessSelfTransaction(From, Event, To, Transaction)
    Transaction:Approve()
    Economy:DeleteQueueItem(Transaction, self.TransactionsQueue)
end

deust.Economy.Transactions = true

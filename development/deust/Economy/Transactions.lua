-- SECTION: Class Transaction
-- ANCHOR: Class declaration
Transaction = {
    ClassName = "Transaction",
    From = nil, -- #Economy
    To = nil, -- #Economy
    Ammount = 0,
    Comment = nil,
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

    -- SECTION: FSM Transitions
    -- Start State.
    self:SetStartState("None")

    -- Add FSM transitions.
    --                 From State   -->         Event        -->     To State
    self:AddTransition("None", "PreAuthorize", "PreAuthorized") -- Load the Economy state from scatch.

    self:AddTransition("PreAuthorized", "Approve", "Completed") -- Start the Economy from scratch.
    self:AddTransition({ "None", "PreAuthorized" }, "Cancel", "Cancelled") -- Stop the Economy.
    -- !SECTION

    return self
end

-- !SECTION

function Economy:onbeforeAddTransaction(From, Event, To, Transaction)
    local Transaction = Transaction


    -- Check the PreAuthorized value is not bigger than the funds available
    if self.Funds >= self.PreAuthorized + Ammount then
        return true
    end
    return false
end

deust.Economy.Transactions = true

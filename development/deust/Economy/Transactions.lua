-- SECTION: Class Transaction
Transaction = {
    From = nil, -- #Economy
    To = nil, -- #Economy
    Ammount = 0,
    Requester = nil, -- #ClassID?
    Comment = nil,
    Callback = nil -- #Function
}

function Transaction:New(From, To, Ammount, Requester, Comment, Callback)
    local From = From
    local To = To
    local Ammount = tonumber(Ammount)
    local Requester = Requester
    local Comment = Comment
    local Callback = Callback

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
    -- TODO: Requester check
    if type(Comment) ~= "nil" then -- nil is valid
        if type(Comment) ~= "string" then
            return false
        end
    end
    if type(Callback) ~= "nil" then -- nil is valid
        if type(Callback) ~= "function" then -- REVIEW: does this type exist?
            return false
        end
    end

    -- ANCHOR: After validation
    self.From = From
    self.To = To
    self.Ammount = Ammount
    self.Requester = Requester
    self.Comment = Comment
    self.Callback = Callback
end

-- !SECTION

function Economy:onbeforeAddTransaction(From, Event, To, FromEconomy, ToEconomy, Ammount, Requester, Comment, Callback)
    local FromEconomy = FromEconomy
    local ToEconomy = ToEconomy
    local Ammount = tonumber(Ammount)
    local Requester = Requester
    local Comment = Comment
    local Callback = Callback


    -- ANCHOR: Input validation
    if type(FromEconomy) ~= "nil" then -- if nil it is selftransaction
        if type(FromEconomy) ~= "table" then
            return false
        end
    end
    if type(ToEconomy) ~= "nil" then -- if nil it is selftransaction
        if type(ToEconomy) ~= "table" then
            return false
        end
    end
    if not Ammount then
        return false
    end
    -- TODO: Requester check
    if type(Comment) ~= "nil" then -- nil is valid
        if type(Comment) ~= "string" then
            return false
        end
    end
    if type(Callback) ~= "nil" then -- nil is valid
        if type(Callback) ~= "function" then -- REVIEW: does this type exist?
            return false
        end
    end
    -- Check the PreAuthorized value is not bigger than the funds available
    if self.Funds >= self.PreAuthorized + Ammount then
        return true
    end
    return false
end

deust.Economy.Transactions = true
function Economy:SetFunds(value)
    local value = tonumber(value) -- REVIEW: If value is not a number or can not be converted it should return false

    if value then
        self.Funds = value

        return true
    end
    return false -- Shouldn't be necessary an else condition
end

function Economy:GetFunds()
    return tonumber(self.Funds)
end

function Economy:SetPreAuthorized(value)
    local value = tonumber(value) -- REVIEW: If value is not a number or can not be converted it should return false

    if value then
        self.PreAuthorized = value

        return true
    end
    return false -- Shouldn't be necessary an else condition
end

function Economy:GetPreAuthorized()
    return tonumber(self.PreAuthorized)
end

function Economy:SetTransactionsDelay(seconds)
    local seconds = tonumber(seconds) -- REVIEW: If value is not a number or can not be converted it should return false

    if seconds then
        self.TransactionsDelay = seconds

        return true
    end
    return false -- Shouldn't be necessary an else condition
end

function Economy:GetTransactionsDelay()
    return tonumber(self.TransactionsDelay)
end

deust.Economy.Methods = true

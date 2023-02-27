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


deust.Economy.Methods = true
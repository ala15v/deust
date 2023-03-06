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

function Economy:IncreaseFunds(value)
    local value = tonumber(value) -- Checking if the value is number
    local currentFunds = self:GetFunds()

    if currentFunds and value then -- Checking the previous values are okay
        local newAmmount = currentFunds + value
        return self:SetFunds(newAmmount) -- Returns true if the new ammount is set
    end

    return false
end

function Economy:DecreaseFunds(value)
    local value = tonumber(value) -- Checking if the value is number
    local currentFunds = self:GetFunds()

    if currentFunds and value then -- Checking the previous values are okay
        local newAmmount = currentFunds - value
        return self:SetFunds(newAmmount) -- Returns true if the new ammount is set
    end

    return false
end

function Economy:IncreasePreAuthorized(value)
    local value = tonumber(value) -- Checking if the value is number
    local currentPreAuthorized = self:GetPreAuthorized()

    if currentPreAuthorized and value then -- Checking the previous values are okay
        local newAmmount = currentPreAuthorized + value
        return self:SetPreAuthorized(newAmmount) -- Returns true if the new ammount is set
    end

    return false
end

function Economy:DecreasePreAuthorized(value)
    local value = tonumber(value) -- Checking if the value is number
    local currentPreAuthorized = self:GetPreAuthorized()

    if currentPreAuthorized and value then -- Checking the previous values are okay
        local newAmmount = currentPreAuthorized - value
        return self:SetPreAuthorized(newAmmount) -- Returns true if the new ammount is set
    end

    return false
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

-- Delete object from a table
function Economy:DeleteQueueItem(qitem, queue)
  self:F({qitem=qitem, queue=queue})

  for i=1,#queue do
    local _item=queue[i] --#Economy.Queueitem
    if _item.uid==qitem.uid then
      self:T(self.LogHeader..string.format("Deleting queue item id=%d.", qitem.uid))
      table.remove(queue,i)
      break
    end
  end
end

function Economy:SetSavePath(value)
    if type(value) == "string" then
        self.SavePath = value
        return true
    end
    return false
end

function Economy:SetSaveFile(value)
    if type(value) == "string" then
        self.SaveFile = value
        return true
    end
    return false
end

function Economy:SetAutoSave(value)
    local value = tonumber(value)
    
    if value then
        self.AutoSave = value
        return true
    end
    return false
end

deust.Economy.Methods = true

function Economy:onafterSave(From, Event, To, SavePath, SaveFile)
    local SavePath = SavePath or self.SavePath
    local SaveFile = SaveFile or self.SaveFile
    local Funds = self:GetFunds()

    local result = UTILS.SaveToFile(SavePath, SaveFile, Funds)

    if result then
        self:I(self.LogHeader .. "Changes saved")
    else
        self:E(self.LogHeader .. "Something went wrong saving the progress")
    end

    self:Unpause()  -- This will only happens if the from state is paused. Thanks FSM :)
end

function Economy:onbeforeLoad(From, Event, To, SavePath, SaveFile)
    local SavePath = SavePath or self.SavePath
    local SaveFile = SaveFile or self.SaveFile

    local exists = UTILS.CheckFileExists(SavePath, SaveFile) -- Check if the file exists and reading is possible

    if exists then
        self:I(self.LogHeader .. "Save file found and readable")
    else
        self:E(self.LogHeader .. "Save file was not found or is not readable")
    end

    return exists
end

function Economy:onafterLoad(From, Event, To, SavePath, SaveFile)
    local SavePath = SavePath or self.SavePath
    local SaveFile = SaveFile or self.SaveFile

    local _, fileContent = UTILS.LoadFromFile(SavePath, SaveFile)
    local savedFunds = tonumber(fileContent[1])

    if savedFunds then
        self:SetFunds(savedFunds)
        self:I(self.LogHeader .. "Saved funds restored")
    else
        self:E(self.LogHeader .. "Something went wrong restoring the funds " .. { fileContent = fileContent })
    end
end

deust.Economy.Save = true

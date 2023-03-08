--[[

# Economy

This class performes as a bank. It offers methods and events to handle the movement of fictional money. To get the best experience, this class should be use in convination with other classes and functions. The class also offers a way to save in disk and restore the current state of the economy.

## Economy:New(alias)

It initiate a new instance of the class Economy

> ### **Parameters**
>
> |         Name            |       Type        |         Options         |                                     Description                                         |
> |:-----------------------:|:-----------------:|:-----------------------:|:----------------------------------------------------------------------------------------|
> |         alias           |       String      |                         | This is the name that the object will be known by                                       |

> ### **Return**
>
> |     Name        |             Type               |                       Description                            |
> |:---------------:|:------------------------------:|:-------------------------------------------------------------|
> |     Economy      |            Table              | New instance of the class Economy                            |

> ### **Example**
>
>> Input: `MyEconomy = Economy:New("OP_Bank")`

## Economy:SetFunds(value)

It set the funds available. It should be only used during the creation to set the initial ammount of funds.

> ### **Parameters**
>
> |         Name            |       Type        |                                     Description                                         |
> |:-----------------------:|:-----------------:|:----------------------------------------------------------------------------------------|
> |         value           |      Integer      | This is the ammount of money that will be available                                     |

> ### **Return**
>
> |     Name        |             Type               |                       Description                            |
> |:---------------:|:------------------------------:|:-------------------------------------------------------------|
> |                 |            Boolean             | It returns true if the process went well                     |

> ### **Example**
>
>> Input: `MyEconomy:SetFunds(3200)`

## Economy:IncreaseFunds(value)

It increases the funds available. It will take the current funds and add the given ammount.

> ### **Parameters**
>
> |         Name            |       Type        |                                     Description                                         |
> |:-----------------------:|:-----------------:|:----------------------------------------------------------------------------------------|
> |         value           |      Integer      | This is the ammount of money that will be added to the current ammount of funds         |

> ### **Return**
>
> |     Name        |             Type               |                       Description                            |
> |:---------------:|:------------------------------:|:-------------------------------------------------------------|
> |                 |            Boolean             | It returns true if the process went well                     |

> ### **Example**
>
>> Input: `MyEconomy:IncreaseFunds(200)`

## Economy:DecreaseFunds(value)

It decreases the funds available. It will take the current funds and subtract the given ammount.

> ### **Parameters**
>
> |         Name            |       Type        |                                     Description                                         |
> |:-----------------------:|:-----------------:|:----------------------------------------------------------------------------------------|
> |         value           |      Integer      | This is the ammount of money that will be subtracted to the current ammount of funds    |

> ### **Return**
>
> |     Name        |             Type               |                       Description                            |
> |:---------------:|:------------------------------:|:-------------------------------------------------------------|
> |                 |            Boolean             | It returns true if the process went well                     |

> ### **Example**
>
>> Input: `MyEconomy:DecreaseFunds(200)`

## Economy:SetTransactionsDelay(seconds)

It set the ammount of seconds between the processing of each transaction.

> ### **Parameters**
>
> |         Name            |       Type        |    Default    |                                     Description                                             |
> |:-----------------------:|:-----------------:|:-------------:|:--------------------------------------------------------------------------------------------|
> |        seconds          |      Integer      |     `30`      | This is the ammount of seconds that the class will wait before process the next transaction |

> ### **Return**
>
> |     Name        |             Type               |                       Description                            |
> |:---------------:|:------------------------------:|:-------------------------------------------------------------|
> |                 |            Boolean             | It returns true if the process went well                     |

> ### **Example**
>
>> Input: `MyEconomy:SetTransactionsDelay(60)`

## Economy:SetSavePath(value)

It set the path where the file with the current state will be saved. The path must exist.

> ### **Parameters**
>
> |         Name            |       Type        |                           Default                           |                                     Description                                             |
> |:-----------------------:|:-----------------:|:-----------------------------------------------------------:|:--------------------------------------------------------------------------------------------|
> |        value            |      String       |     `C:\Users\<user>\Saved Games\DCS.openbeta\Economy`      | This is the path where the file with the current state will be saved                        |

> ### **Return**
>
> |     Name        |             Type               |                       Description                            |
> |:---------------:|:------------------------------:|:-------------------------------------------------------------|
> |                 |            Boolean             | It returns true if the process went well                     |

> ### **Example**
>
>> Input: `MyEconomy:SetSavePath("C:\\folder\\")`

## Economy:SetSaveFile(value)

It set the file name where the current state will be saved.

> ### **Parameters**
>
> |         Name            |       Type        |           Default              |                                     Description                                             |
> |:-----------------------:|:-----------------:|:------------------------------:|:--------------------------------------------------------------------------------------------|
> |        value            |      String       |     `<Alias>_Account.lua`      | This is the file name where the current state will be saved                                 |

> ### **Return**
>
> |     Name        |             Type               |                       Description                            |
> |:---------------:|:------------------------------:|:-------------------------------------------------------------|
> |                 |            Boolean             | It returns true if the process went well                     |

> ### **Example**
>
>> Input: `MyEconomy:SetSaveFile("OP_Bank.lua")`

## Economy:SetAutoSave(value)

It set the ammount of seconds between each auto save. If nil, the autosave is disabled.

> ### **Parameters**
>
> |         Name            |       Type        |                                     Description                                             |
> |:-----------------------:|:-----------------:|:--------------------------------------------------------------------------------------------|
> |        value            |      Integer      | This is the ammount of seconds between each auto save                                       |

> ### **Return**
>
> |     Name        |             Type               |                       Description                            |
> |:---------------:|:------------------------------:|:-------------------------------------------------------------|
> |                 |            Boolean             | It returns true if the process went well                     |

> ### **Example**
>
>> Input: `MyEconomy:SetAutoSave(300)`

## Economy:Load()

This load the previous state from the save file. This method must be called before the `:Start()` method.

> ### **Example**
>
>> Input: `MyEconomy:Load()`

## Economy:Start()

This starts the normal work of the object.

> ### **Example**
>
>> Input: `MyEconomy:Start()`

> ### **Example**
>
> Using a delay of 5 seconds
>
>> Input: `MyEconomy:__Start(5)`

## Economy:AddTransaction(Transaction)

It adds to the transaction queue a new transaction.

> ### **Parameters**
>
> |         Name            |       Type        |                                     Description                                             |
> |:-----------------------:|:-----------------:|:--------------------------------------------------------------------------------------------|
> |     Transaction         |       Table       | This is the Transaction object that will be added to the queue                              |

> ### **Example**
>
>> Input: `MyEconomy:AddTransaction(Transaction)`

> ### **Example**
>
> Using a delay of 5 seconds
>
>> Input: `MyEconomy:__AddTransaction(5, Transaction)`

]]--


-- ANCHOR: Class declaration
Economy = {
    ClassName = "Economy",
    uid = nil,
    Alias = nil,
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
function Economy:New(alias)
    -- Input validation
    local invalidInput = false

    -- Inherit everthing from FSM class.
    local self = BASE:Inherit(self, FSM:New()) -- #Economy

    if type(alias) ~= "string" then
        invalidInput = true
    end

    if not invalidInput then
        self.Alias = alias
        self.uid = #deust.Economy.EconomyDB + 1
        self.LogHeader = string.format("Economy %s | ", self.Alias)
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
    
    self.I(self.LogHeader .. "STARTED")
end

function Economy:onafterStop(From, Event, To)
    self.I(self.LogHeader .. "STOPPED")
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

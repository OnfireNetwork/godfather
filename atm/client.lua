local atms = {
    {129146, 77939, 1576}
}

local Dialog = ImportPackage("dialogui")

local startMenu = Dialog.create("ATM", "Choose an action", "Deposit", "Withdraw", "Exit")
local depositMenu = Dialog.create("Deposit", "Balance: {balance} $", "Deposit", "Cancel")
Dialog.addTextInput(depositMenu, "Amount")
Dialog.setVariable(depositMenu, "balance", 0)
local withdrawMenu = Dialog.create("Withdraw", "Balance: {balance} $", "Withdraw", "Cancel")
Dialog.addTextInput(withdrawMenu, "Amount")
Dialog.setVariable(withdrawMenu, "balance", 0)

local function isDigit(letter)
    local digits = "0123456789"
    for i=1,#digits do
        if digits[i] == letter then
            return true
        end
    end
    return false
end

local function parseAmount(source)
    for i=1,#source do
        if not isDigit(source[i]) then
            return nil
        end
    end
    return tonumber(source)
end

AddEvent("OnKeyPress", function(key)
    if key ~= "E" then
        return
    end
    local x, y, z = GetPlayerLocation()
    for i=1,#atms do
        if GetDistance3D(x, y, z, atms[i][1], atms[i][2], atms[i][3]) < 100 then
            Dialog.show(startMenu)
            return
        end
    end
end)

AddEvent("OnDialogSubmit", function(dialog, button, amount)
    if dialog == startMenu then
        if button == 1 then
            Dialog.setVariable(depositMenu, "balance", GetPlayerPropertyValue(GetPlayerId(), "balance"))
            Dialog.show(depositMenu)
            return
        end
        if button == 2 then
            Dialog.setVariable(withdrawMenu, "balance", GetPlayerPropertyValue(GetPlayerId(), "balance"))
            Dialog.show(withdrawMenu)
            return
        end
        return
    end
    if dialog == depositMenu then
        if button == 1 then
            local a = parseAmount(amount)
            if a == nil then
                AddPlayerChat("You entered an invalid amount!")
                return
            end
            CallRemoteEvent("ATMDeposit", a)
        else
            Dialog.show(startMenu)
        end
        return
    end
    if dialog == withdrawMenu then
        if button == 1 then
            local a = parseAmount(amount)
            if a == nil then
                AddPlayerChat("You entered an invalid amount!")
                return
            end
            CallRemoteEvent("ATMWithdraw", a)
        else
            Dialog.show(startMenu)
        end
        return
    end
end)
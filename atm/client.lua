Dialog = Dialog or ImportPackage("dialogui")

local atms = {
    {129146, 77939, 1576},
    {-181957.5625, -40253.48046875, 1163.1500244141}
}

local startMenu = Dialog.create("ATM", "Choose an action", "Deposit", "Withdraw", "Exit")
local depositMenu = Dialog.create("Deposit", "Balance: {balance} $", "Deposit", "Cancel")
Dialog.addTextInput(depositMenu, 1, "Amount")
Dialog.setVariable(depositMenu, "balance", 0)
local withdrawMenu = Dialog.create("Withdraw", "Balance: {balance} $", "Withdraw", "Cancel")
Dialog.addTextInput(withdrawMenu, 1, "Amount")
Dialog.setVariable(withdrawMenu, "balance", 0)

local function parseAmount(source)
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
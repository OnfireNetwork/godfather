Dialog = Dialog or ImportPackage("dialogui")
_ = _ or function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local atms = {
    {129146, 77939, 1576},
    {-181957.5625, -40253.48046875, 1163.1500244141}
}

local startMenu
local depositMenu
local withdrawMenu

AddEvent("OnTranslationReady", function()
    startMenu = Dialog.create(_("atm"), nil, _("deposit"), _("withdraw"), _("cancel"))
    depositMenu = Dialog.create(_("deposit"), _("balance")..": {balance} $", _("deposit"), _("cancel"))
    Dialog.addTextInput(depositMenu, 1, _("amount"))
    Dialog.setVariable(depositMenu, "balance", 0)
    withdrawMenu = Dialog.create(_("withdraw"), _("balance")..": {balance} $", _("withdraw"), _("cancel"))
    Dialog.addTextInput(withdrawMenu, 1, _("amount"))
    Dialog.setVariable(withdrawMenu, "balance", 0)
end)

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
                AddPlayerChat(_("invalid_amount"))
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
                AddPlayerChat(_("invalid_amount"))
                return
            end
            CallRemoteEvent("ATMWithdraw", a)
        else
            Dialog.show(startMenu)
        end
        return
    end
end)
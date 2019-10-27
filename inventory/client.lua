Dialog = Dialog or ImportPackage("dialogui")

local inventoryMenu = Dialog.create("Inventory", nil, "Use", "Give", "Close")
Dialog.addSelect(inventoryMenu, 1, nil, 7, "Drill", "Hamburger", "Beer")

local trunkMenu = Dialog.create("Trunk", nil, "Close")
Dialog.addSelect(trunkMenu, 1, "Player", 7, "Drill", "Hamburger", "Beer")
Dialog.setButtons(trunkMenu, 1, "Store")
Dialog.addSelect(trunkMenu, 2, "Trunk", 7, "Beer", "Beer", "Beer", "Beer", "Beer", "Beer", "Beer", "Beer", "Beer")
Dialog.setButtons(trunkMenu, 2, "Get Out")

AddEvent("OnKeyPress", function(key)
    if key ~= "I" then
        return
    end
    if IsShiftPressed() then
        Dialog.show(trunkMenu)
    else
        Dialog.show(inventoryMenu)
    end
end)
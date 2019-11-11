local cardealers = {
    {}
}

local spawned_cardealers = {}

AddEvent("OnPackageStart", function()
    for i=1, #cardealers do
        local cardealer = CreateNPC(3, cardealers[i][1], cardealers[i][2], cardealers[i][3], cardealers[i][4])
        table.insert(spawned_cardealers, cardealer)
    end
end)

AddEvent("OnPackageStop", function()
    for i=1, #spawned_cardealers do
        local dealer = spawned_cardealers[i]
        if dealer ~= nil and IsValidNPC(dealer) then
            DestroyNPC(dealer)
        end
    end
end)
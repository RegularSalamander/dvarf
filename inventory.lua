inventory = {
    hand = {},
    stockpile = {},
    map = {}
}

inventoryTotal = {
    hand = {ore = 0, gem = 0},
    stockpile = {ore = 0, gem = 0},
    map = {ore = 0, gem = 0}
}

function zeroInventory()
    for i, v in pairs(inventory) do
        inventory[i].ore = {}
        for j = 1, ORE_SPRITE_COLS do
            inventory[i].ore[j] = 0
        end

        inventory[i].gem = {}
        for j = 1, GEM_SPRITE_COLS * 3 do
            inventory[i].gem[j] = 0
        end
    end

    inventoryTotal.hand = {ore = 0, gem = 0}
    inventoryTotal.stockpile = {ore = 0, gem = 0}
    inventoryTotal.map = {ore = 0, gem = 0}
end

function countInventory()
    zeroInventory()

    --count map
    for x = 1, MAP_WIDTH do
        for y = 1, MAP_HEIGHT do
            local t = getTile(x, y)
            if t then
                if t.ore then
                    inventory.map.ore[t.ore + 1] = inventory.map.ore[t.ore + 1] + 1
                    inventoryTotal.map.ore = inventoryTotal.map.ore + 1
                end
                if t.gem then
                    inventory.map.gem[t.gem + 1] = inventory.map.gem[t.gem + 1] + 1
                    inventoryTotal.map.gem = inventoryTotal.map.gem + 1
                end
            end
        end
    end

    --count stockpile
    local sp = objects.interactables[1] --will this always work?
    for i = 1, #sp.contents.ore do
        for j = 1, #sp.contents.ore[i] do
            if sp.contents.ore[i][j] >= 0 then
                inventory.stockpile.ore[sp.contents.ore[i][j] + 1] = inventory.stockpile.ore[sp.contents.ore[i][j] + 1] + 1
                inventoryTotal.stockpile.ore = inventoryTotal.stockpile.ore + 1
            end
        end
    end
    for i = 1, #sp.contents.gem do
        for j = 1, #sp.contents.gem[i] do
            if sp.contents.gem[i][j] >= 0 then
                inventory.stockpile.gem[sp.contents.gem[i][j] + 1] = inventory.stockpile.gem[sp.contents.gem[i][j] + 1] + 1
                inventoryTotal.stockpile.gem = inventoryTotal.stockpile.gem + 1
            end
        end
    end

    --count hand
    local t = objects.player.trailing
    while t do
        if t.ore then
            inventory.hand.ore[t.ore + 1] = inventory.hand.ore[t.ore + 1] + 1
            inventoryTotal.hand.ore = inventoryTotal.hand.ore + 1
        elseif t.gem then
            inventory.hand.gem[t.gem + 1] = inventory.hand.gem[t.gem + 1] + 1
            inventoryTotal.hand.gem = inventoryTotal.hand.gem + 1
        end
        t = t.trailing
    end
end

function moveItem(it, from, to)

end
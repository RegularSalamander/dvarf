--this file is only for debugging and viewing world generation

function mapView_draw()
    for x = 1, MAP_WIDTH do
        for y = 1, MAP_HEIGHT do
            local t = getTile(x, y)
            if t then
                if t.hp > 0 then
                    love.graphics.setColor(COLORS["stone" .. t.stonetype .. "light"])
                    
                    if t.rock then
                        love.graphics.setColor(COLORS.black)
                    elseif t.gem then
                        love.graphics.setColor(COLORS["gem" .. ((t.gem % GEM_SPRITE_COLS) + 1)])
                    elseif t.ore then
                        love.graphics.setColor(COLORS["ore" .. (t.ore + 1)])
                    end
                else
                    love.graphics.setColor(COLORS.dark)
                end
            end

            love.graphics.rectangle("fill", x, y, 1, 1)
        end
    end

    --show map inventory
    for i = 1, ORE_SPRITE_COLS do
        love.graphics.setColor(COLORS["ore" .. i])
        love.graphics.print(ORE_NAMES[i], MAP_WIDTH + 20, 20*i)
        love.graphics.print(inventory.map.ore[i], MAP_WIDTH + 90, 20*i)
    end

    for i = 1, GEM_SPRITE_COLS * 3 do
        love.graphics.setColor(COLORS["gem" .. ((i-1) % GEM_SPRITE_COLS + 1)])
        love.graphics.print(GEM_NAMES[i], MAP_WIDTH + 160, 20*i)
        love.graphics.print(inventory.map.gem[i], MAP_WIDTH + 240, 20*i)
    end
end
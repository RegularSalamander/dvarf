--this file is only for debugging and viewing world generation

function mapView_draw()
    for x = 1, MAP_WIDTH do
        for y = 1, MAP_HEIGHT do
            local t = getTile(x, y)
            if t then
                if t.hp > 0 then
                    love.graphics.setColor(COLORS["stone" .. t.stonetype .. "light"])
                    if t.gem > -1 then
                        love.graphics.setColor(COLORS["gem" .. (t.gem + 1)])
                    elseif t.ore > -1 then
                        love.graphics.setColor(COLORS["ore" .. (t.ore + 1)])
                    end
                else
                    love.graphics.setColor(COLORS.dark)
                end
            end

            love.graphics.rectangle("fill", x, y, 1, 1)
        end
    end
end
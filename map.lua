local tiles = {}

function generateMap()
    for x = 1, MAP_WIDTH do
        tiles[x] = {}
        for y = 1, MAP_HEIGHT do
            tiles[x][y] = tile:new(x, y)
        end
    end
end

function getTile(x, y)
    if x < 1 or y < 1 or x > MAP_WIDTH or y > MAP_HEIGHT then
        return nil
    end
    return tiles[x][y]
end

function damageTile(x, y)
    local t = getTile(x, y)

    if t then
        t:damage(1)
    end
end

function drawMap()
    for x = 1, MAP_WIDTH do
        for y = 1, MAP_HEIGHT do
            if getTile(x, y) then
                tiles[x][y]:draw()
            end
        end
    end
end
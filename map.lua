local tiles = {}

function generateMap()
    for x = 1, MAP_WIDTH do
        tiles[x] = {}
        for y = 1, MAP_HEIGHT do
            tiles[x][y] = tile:new(x, y)
        end
    end

    tiles[10][10].hp = 0

    for x = 1, MAP_WIDTH do
        for y = 1, MAP_HEIGHT do
            local t = getTile(x, y)
            if t then
                t:updateSprite()
            end
        end
    end
end

function getTile(x, y)
    if x < 1 or y < 1 or x > MAP_WIDTH or y > MAP_HEIGHT then
        return nil
    end
    return tiles[x][y]
end

function isWall(x, y)
    local t = getTile(x, y)
    if t then
        return t.hp > 0
    else
        return true
    end
end

function updateAround(x, y)
    for i = x-1, x+1 do
        for j = y-1, y+1 do
            local t = getTile(i, j)
            if t then
                t:updateSprite()
            end
        end
    end
end

function damageTile(x, y)
    local t = getTile(x, y)

    if t then
        t:damage(1)
        if t.hp <= 0 then
            updateAround(x, y)
        end
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
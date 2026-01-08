local tiles = {}

function generateMap()
    for x = 1, MAP_WIDTH do
        tiles[x] = {}
        for y = 1, MAP_HEIGHT do
            --create tile
            tiles[x][y] = tile:new(x, y)

            --stone bands
            tiles[x][y].stonetype = constrain(5 - math.floor((y + math.random()*MAP_BAND_SCATTER*2 - MAP_BAND_SCATTER) / MAP_BAND_SIZE), 1, 5)
            tiles[x][y].maxhp = 5 * math.pow(STONE_LAYER_MULTIPLIER, tiles[x][y].stonetype - 1)
            tiles[x][y].hp = tiles[x][y].maxhp

            --space under mountain
            local bottomHeight = math.floor(
                love.math.noise(x * MAP_BOTTOM_FREQ) * 2*MAP_BOTTOM_AMP + MAP_BOTTOM_SPACE + MAP_BOTTOM_AMP +
                -1 * math.pow(MAP_BOTTOM_CURVE * (x - MAP_WIDTH/2), 2)
            )
            if y > bottomHeight - 1 then
                tiles[x][y].hp = 0
            end
            if y == bottomHeight then
                tiles[x][y].hp = math.floor(tiles[x][y].maxhp/2)
            end

            if math.random() < MAP_GEM_CHANCE then
                tiles[x][y].gem = randint(0, GEM_SPRITE_COLS - 1)
            elseif math.random() < MAP_ORE_CHANCE then
                tiles[x][y].ore = randint(0, ORE_SPRITE_COLS - 1)
            end
        end
    end

    --update tile sprites
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

function blinkTile(x, y)
    local t = getTile(x, y)

    if t then
        t:blink()
    end
end

function damageTile(x, y, amt)
    local t = getTile(x, y)

    if t then
        t:damage(amt)
        if t.hp <= 0 then
            updateAround(x, y)
            if t.ore then
                table.insert(objects.items, item:new(x, y, {ore = t.ore}))
            elseif t.gem then
                table.insert(objects.items, item:new(x, y, {gem = t.gem}))
            end
        end
    end
end

function drawMap()
    local startX = math.floor(cameraX/TILE_SIZE)
    local startY = math.floor(cameraY/TILE_SIZE)

    for x = startX, startX + 40 do
        for y = startY, startY + 23 do
            if getTile(x, y) then
                tiles[x][y]:draw()
            end
        end
    end
end
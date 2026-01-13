local tiles = {}

local discoverQueue = {}

function generateMap()
    local randOffsetX = math.random() * 10 - 5
    local randOffsetY = math.random() * 10 - 5

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
                love.math.noise(x * MAP_BOTTOM_FREQ + randOffsetX) * 2*MAP_BOTTOM_AMP + MAP_BOTTOM_SPACE + MAP_BOTTOM_AMP +
                -1 * math.pow(MAP_BOTTOM_CURVE * (x - MAP_WIDTH/2), 2)
            )
            if y > bottomHeight - 1 then
                tiles[x][y].hp = 0
            end
            if y == bottomHeight then
                tiles[x][y].hp = math.floor(tiles[x][y].maxhp/2)
            end
            if y > bottomHeight + 2 then
                tiles[x][y].floor = false
            end
        end
    end

    --populate with ores, gems, and rocks
    for band = 0, 4 do
        -- normal ore (Copper, Titanium, Gold, Mythril, Abyssum)
        for i = 1, MAP_STAND_ORE_PER_BAND do
            local randx = randint(2, MAP_WIDTH - 1)
            local randy = randint(band * MAP_BAND_SIZE, (band + 1) * MAP_BAND_SIZE) + 1
            tiles[randx][randy].ore = 8 - 2*band
        end
        -- higher ore (Iron, Silver, Chromium, Arcanite, Celestium)
        for i = 1, MAP_HIGH_ORE_PER_BAND do
            local randx = randint(2, MAP_WIDTH - 1)
            local randy = randint(band * MAP_BAND_SIZE, (band + 1) * MAP_BAND_SIZE) + 1
            tiles[randx][randy].ore = 8 - 2*band + 1
        end
        -- low ores (lower than the current band's level, skewed toward lower ores)
        if band < 4 then
            for i = 1, MAP_LOW_ORE_PER_BAND do
                local randx = randint(2, MAP_WIDTH - 1)
                local randy = randint(band * MAP_BAND_SIZE, (band + 1) * MAP_BAND_SIZE) + 1
                local maxOre = 8 - 2*band
                local minOre = 2 - 0.5*band
                tiles[randx][randy].ore = math.floor(math.pow(math.random(), MAP_LOW_ORE_SKEW) * (maxOre - minOre) + minOre)
            end
        end

        local gemsInBand = MAP_GEM_START * math.pow(MAP_GEM_INCREASE, 4 - band)
        for i = 1, gemsInBand do
            local randx = randint(2, MAP_WIDTH - 1)
            local randy = randint(band * MAP_BAND_SIZE, (band + 1) * MAP_BAND_SIZE) + 1
            local maxGem = math.floor(map(band, 4, 0, MAP_BEST_GEM, GEM_SPRITE_COLS * 3))
            if tiles[randx][randy].ore == nil then
                tiles[randx][randy].gem = math.floor(math.pow(math.random(), MAP_GEM_SKEW) * maxGem)
            end
        end

        local rocksInBand = MAP_ROCK_START * math.pow(MAP_ROCK_INCREASE, 4 - band)
        for i = 1, rocksInBand do
            local randx = randint(2, MAP_WIDTH - 1)
            local randy = randint(band * MAP_BAND_SIZE, (band + 1) * MAP_BAND_SIZE) + 1
            local maxGem = math.floor(map(band, 4, 0, MAP_BEST_GEM, GEM_SPRITE_COLS * 3))
            if tiles[randx][randy].ore == nil and tiles[randx][randy].gem == nil then
                tiles[randx][randy].rock = true
            end
        end
    end

    for x = 1, MAP_WIDTH do
        for y = 1, MAP_HEIGHT do
            if love.math.noise(x * MAP_POCKET_FREQ + randOffsetX, y * MAP_POCKET_FREQ + randOffsetY) > MAP_POCKET_THRESH then
                tiles[x][y].hp = 0
                tiles[x][y].ore = nil
                tiles[x][y].gem = nil
                tiles[x][y].rock = false
            elseif tiles[x][y].hp > 0 and love.math.noise(x * MAP_DENSE_FREQ - randOffsetX, y * MAP_DENSE_FREQ + randOffsetY) > MAP_DENSE_THRESH then
                tiles[x][y].stonetype = math.min(tiles[x][y].stonetype + 1, 5)
                tiles[x][y].hp = 5 * math.pow(STONE_LAYER_MULTIPLIER, tiles[x][y].stonetype - 1)
                tiles[x][y].maxhp = tiles[x][y].hp
                if tiles[x][y].ore then
                    tiles[x][y].ore = math.min(tiles[x][y].ore + 1, ORE_SPRITE_COLS-1)
                elseif tiles[x][y].gem then
                    tiles[x][y].gem = math.min(tiles[x][y].gem + 1, GEM_SPRITE_COLS-1)
                end
            end
        end
    end

    --remove everything from predamaged tiles (like the bottom row)
    for x = 1, MAP_WIDTH do
        for y = 1, MAP_HEIGHT do
            if tiles[x][y].hp < tiles[x][y].maxhp then
                tiles[x][y].ore = nil
                tiles[x][y].gem = nil
                tiles[x][y].rock = false
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

function discoverAround(x, y)
    local t = getTile(x, y)
    if t and t.hp <= 0 and not t.discovered then
        t.discovered = true

        for i = x-1, x+1 do
            for j = y-1, y+1 do
                if i ~= x or j ~= y then
                    table.insert(discoverQueue, {i, j})
                end
            end
        end
    end
end

function discoverNext()
    local len = #discoverQueue
    if len > 0 then
        for i = 1, len do
            discoverAround(discoverQueue[1][1], discoverQueue[1][2])
            table.remove(discoverQueue, 1)
        end

        return true
    end
    
    return false
end

function damageTile(x, y, amt)
    local t = getTile(x, y)

    if t then
        t:damage(amt)
        if t.hp <= 0 then
            updateAround(x, y)
            discoverAround(x, y)
            if t.ore then
                table.insert(objects.items, item:new(x, y, {ore = t.ore}))
            elseif t.gem then
                table.insert(objects.items, item:new(x, y, {gem = t.gem}))
            end
            t.ore = nil
            t.gem = nil
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
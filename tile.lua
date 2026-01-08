tile = class:new()

function tile:init(x, y)
    self.pos = {x=x, y=y}
    
    self.hp = 1
    self.maxhp = 1

    self.stonetype = 1

    self.ore = -1
    self.gem = -1

    self.blinking = false
    
    self.neighborIdx = 0
end

function tile:blink()
    self.blinking = true
end

function tile:damage(amt)
    self.hp = self.hp - amt
    self.blinking = false
end

function tile:updateSprite()
    -- neighbors in a clockwise ring starting with the top edge
    local neighbors = {false, false, false, false, false, false, false, false}
    
    -- edges
    if isWall(self.pos.x, self.pos.y-1) then neighbors[1] = true end
    if isWall(self.pos.x+1, self.pos.y) then neighbors[3] = true end
    if isWall(self.pos.x, self.pos.y+1) then neighbors[5] = true end
    if isWall(self.pos.x-1, self.pos.y) then neighbors[7] = true end

    -- corners
    if neighbors[1] and neighbors[3] and isWall(self.pos.x+1, self.pos.y-1) then neighbors[2] = true end
    if neighbors[3] and neighbors[5] and isWall(self.pos.x+1, self.pos.y+1) then neighbors[4] = true end
    if neighbors[5] and neighbors[7] and isWall(self.pos.x-1, self.pos.y+1) then neighbors[6] = true end
    if neighbors[7] and neighbors[1] and isWall(self.pos.x-1, self.pos.y-1) then neighbors[8] = true end

    self.neighborIdx = 0
    for i = #neighbors, 1, -1 do
        self.neighborIdx = self.neighborIdx * 2
        if neighbors[i] then self.neighborIdx = self.neighborIdx + 1 end
    end

    -- self.neighborIdx = 1
end

function tile:draw()
    love.graphics.setColor(1, 1, 1, 1)
    if self.hp > 0 then
        local quadpos = {x=blobMap[self.neighborIdx].x, y=blobMap[self.neighborIdx].y}

        quadpos.y = quadpos.y + 7 * self.stonetype
        quadpos.x = quadpos.x + 7 * math.floor((self.maxhp - self.hp) / self.maxhp * 5)

        love.graphics.draw(
            images.wall,
            love.graphics.newQuad(
                quadpos.x * TILE_SIZE,
                quadpos.y * TILE_SIZE,
                TILE_SIZE, TILE_SIZE,
                TILE_SIZE * WALL_SPRITE_COLS, TILE_SIZE * WALL_SPRITE_ROWS
            ),
            self.pos.x * TILE_SIZE,
            self.pos.y * TILE_SIZE
        )

        if self.ore >= 0 then
            love.graphics.draw(
                images.ore,
                love.graphics.newQuad(
                    self.ore * TILE_SIZE,
                    0,
                    TILE_SIZE, TILE_SIZE,
                    TILE_SIZE * ORE_SPRITE_COLS, TILE_SIZE
                ),
                self.pos.x * TILE_SIZE,
                self.pos.y * TILE_SIZE
            )
        elseif self.gem >= 0 then
            love.graphics.draw(
                images.gem,
                love.graphics.newQuad(
                    self.gem * TILE_SIZE,
                    0,
                    TILE_SIZE, TILE_SIZE,
                    TILE_SIZE * GEM_SPRITE_COLS, TILE_SIZE
                ),
                self.pos.x * TILE_SIZE,
                self.pos.y * TILE_SIZE
            )
        end

        if self.blinking then
            love.graphics.draw(
                images.wall,
                love.graphics.newQuad(
                    quadpos.x * TILE_SIZE,
                    (quadpos.y % 7) * TILE_SIZE,
                    TILE_SIZE, TILE_SIZE,
                    TILE_SIZE * WALL_SPRITE_COLS, TILE_SIZE * WALL_SPRITE_ROWS
                ),
                self.pos.x * TILE_SIZE,
                self.pos.y * TILE_SIZE
            )
        end
    else
        love.graphics.draw(images.floor, self.pos.x * TILE_SIZE, self.pos.y * TILE_SIZE)
    end
end
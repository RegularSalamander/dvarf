player = class:new()

function player:init(x, y)
    self.pos = {x=x, y=y}
    self.nextPos = {x=x, y=y}
    self.frame = 0

    self.dir = 1

    self.state = PSTATE.idle
end

function player:control()
    if self.state == PSTATE.idle then
        local action = false

        if controls.up > 0 then
            self.nextPos = {x = self.pos.x, y = self.pos.y - 1}
            action = true
        end
        if controls.down > 0 then
            self.nextPos = {x = self.pos.x, y = self.pos.y + 1}
            action = true
        end
        if controls.left > 0 then
            self.dir = -1
            self.nextPos = {x = self.pos.x - 1, y = self.pos.y}
            action = true
        end
        if controls.right > 0 then
            self.dir = 1
            self.nextPos = {x = self.pos.x + 1, y = self.pos.y}
            action = true
        end

        if action then
            if isWall(self.nextPos.x, self.nextPos.y) then
                self.state = PSTATE.mining
                blinkTile(self.nextPos.x, self.nextPos.y)
            else
                self.state = PSTATE.moving
            end
        end
    end
end

function player:update()
    if self.state == PSTATE.moving then
        self.frame = self.frame + 1
        if self.frame >= PLAYER_MOVE_FRAMES then
            self.pos.x = self.nextPos.x
            self.pos.y = self.nextPos.y
            
            self.frame = PLAYER_COOLDOWN_FRAMES - PLAYER_MOVECOOL_FRAMES
            self.state = PSTATE.cooldown
        end
    elseif self.state == PSTATE.mining then
        self.frame = self.frame + 1
        if self.frame >= PLAYER_MINE_FRAMES then
            damageTile(self.nextPos.x, self.nextPos.y, 1)
            
            self.frame = 0
            self.state = PSTATE.cooldown
        end
    elseif self.state == PSTATE.cooldown then
        self.frame = self.frame + 1
        if self.frame >= PLAYER_COOLDOWN_FRAMES then
            self.frame = 0
            self.state = PSTATE.idle
        end
    end
end

function player:draw()
    love.graphics.setColor(1, 1, 1, 1)

    if self.state == PSTATE.moving then
        local drawx = map(self.frame, 0, PLAYER_MOVE_FRAMES, self.pos.x, self.nextPos.x)
        local drawy = map(self.frame, 0, PLAYER_MOVE_FRAMES, self.pos.y, self.nextPos.y)

        love.graphics.draw(
            images.player,
            love.graphics.newQuad(
                PLAYER_WIDTH, 0,
                PLAYER_WIDTH, PLAYER_HEIGHT,
                PLAYER_WIDTH * 2, PLAYER_HEIGHT
            ),
            drawx * TILE_SIZE + PLAYER_WIDTH/2, drawy * TILE_SIZE, --x, y
            0, --r
            self.dir, 1, --sx, sy
            PLAYER_WIDTH/2, 0 --ox, oy
        )
    elseif self.state == PSTATE.mining then
        love.graphics.draw(
            images.player,
            love.graphics.newQuad(
                PLAYER_WIDTH, 0,
                PLAYER_WIDTH, PLAYER_HEIGHT,
                PLAYER_WIDTH * 2, PLAYER_HEIGHT
            ),
            self.pos.x * TILE_SIZE + PLAYER_WIDTH/2, self.pos.y * TILE_SIZE, --x, y
            0, --r
            self.dir, 1, --sx, sy
            PLAYER_WIDTH/2, 0 --ox, oy
        )
    elseif self.state == PSTATE.idle or self.state == PSTATE.cooldown then
        love.graphics.draw(
            images.player,
            love.graphics.newQuad(
                0, 0,
                PLAYER_WIDTH, PLAYER_HEIGHT,
                PLAYER_WIDTH * 2, PLAYER_HEIGHT
            ),
            self.pos.x * TILE_SIZE + PLAYER_WIDTH/2, self.pos.y * TILE_SIZE, --x, y
            0, --r
            self.dir, 1, --sx, sy
            PLAYER_WIDTH/2, 0 --ox, oy
        )
    end
end
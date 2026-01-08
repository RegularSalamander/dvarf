player = class:new()

function player:init(x, y)
    self.pos = {x=x, y=y}
    self.nextPos = {x=x, y=y}
    self.drawPos = {x=x, y=y}

    self.dir = 1

    self.state = PSTATE.idle
    self.frame = 0
    
    self.damage = 1
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
    self.drawPos.x = self.pos.x * TILE_SIZE
    self.drawPos.y = self.pos.y * TILE_SIZE

    if self.state == PSTATE.moving then
        self.drawPos.x = map(self.frame, 0, PLAYER_MOVE_FRAMES, self.pos.x, self.nextPos.x) * TILE_SIZE
        self.drawPos.y = map(self.frame, 0, PLAYER_MOVE_FRAMES, self.pos.y, self.nextPos.y) * TILE_SIZE

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
            damageTile(self.nextPos.x, self.nextPos.y, self.damage)
            
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

    local jumping = 0

    if self.state == PSTATE.moving or self.state == PSTATE.mining then
        jumping = 1
    end

    love.graphics.draw(
        images.player,
        love.graphics.newQuad(
            jumping * PLAYER_WIDTH, 0,
            PLAYER_WIDTH, PLAYER_HEIGHT,
            PLAYER_WIDTH * 2, PLAYER_HEIGHT
        ),
        self.drawPos.x + PLAYER_WIDTH/2, self.drawPos.y, --x, y
        0, --r
        self.dir, 1, --sx, sy
        PLAYER_WIDTH/2, 0 --ox, oy
    )
end
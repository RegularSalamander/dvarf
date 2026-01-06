player = class:new()

function player:init(x, y)
    self.pos = {x=x, y=y}
    self.nextPos = {x=x, y=y}
    self.frame = 0

    self.state = PSTATE.idle
end

function player:control()
    if self.state == PSTATE.idle then
        if controls.up > 0 then
            self.nextPos = {x = self.pos.x, y = self.pos.y - 1}
            if isWall(self.pos.x, self.pos.y - 1) then
                self.state = PSTATE.mining
            else
                self.state = PSTATE.moving
            end
        end
        if controls.down > 0 then
            self.nextPos = {x = self.pos.x, y = self.pos.y + 1}
            if isWall(self.pos.x, self.pos.y + 1) then
                self.state = PSTATE.mining
            else
                self.state = PSTATE.moving
            end
        end
        if controls.left > 0 then
            self.nextPos = {x = self.pos.x - 1, y = self.pos.y}
            if isWall(self.pos.x - 1, self.pos.y) then
                self.state = PSTATE.mining
            else
                self.state = PSTATE.moving
            end
        end
        if controls.right > 0 then
            self.nextPos = {x = self.pos.x + 1, y = self.pos.y}
            if isWall(self.pos.x + 1, self.pos.y) then
                self.state = PSTATE.mining
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
            
            self.frame = 0
            self.state = PSTATE.cooldown
        end
    elseif self.state == PSTATE.mining then
        self.frame = self.frame + 1
        if self.frame >= PLAYER_MINE_FRAMES then
            damageTile(self.nextPos.x, self.nextPos.y)
            
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
    if self.state ~= PSTATE.idle then
        love.graphics.setColor(1, 0, 0, 1)
    end

    if self.state == PSTATE.moving then
        local x = map(self.frame, 0, PLAYER_MOVE_FRAMES, self.pos.x, self.nextPos.x)
        local y = map(self.frame, 0, PLAYER_MOVE_FRAMES, self.pos.y, self.nextPos.y)

        love.graphics.rectangle("fill", x * TILE_SIZE, y * TILE_SIZE, PLAYER_WIDTH, PLAYER_HEIGHT)
    else
        love.graphics.rectangle("fill", self.pos.x * TILE_SIZE, self.pos.y * TILE_SIZE, PLAYER_WIDTH, PLAYER_HEIGHT)
    end
end
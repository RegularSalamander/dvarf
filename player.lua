player = class:new()

function player:init(x, y)
    self.pos = {x = x, y = y}
    self.nextPos = {x = x, y = y}
    self.drawPos = {x = x * TILE_SIZE, y = y * TILE_SIZE}

    self.dir = 1

    self.state = STATE.idle
    self.frame = 0
    
    self.damage = 1
    self.holdLimit = 3

    self.trailing = nil
end

function player:control()
    if self.state == STATE.idle then
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
                self.state = STATE.mining
                blinkTile(self.nextPos.x, self.nextPos.y)
            elseif interactableAt(self.nextPos.x, self.nextPos.y) then
                self.state = STATE.interacting
                local i = interactableAt(self.nextPos.x, self.nextPos.y)
                i:func()
            else
                self.state = STATE.moving
                if self.trailing then
                    self.trailing:move(self.pos.x, self.pos.y)
                end
            end
        end
    end
end

function player:update()
    self.drawPos.x = self.pos.x * TILE_SIZE
    self.drawPos.y = self.pos.y * TILE_SIZE

    if self.state == STATE.moving then
        self.frame = self.frame + 1

        self.drawPos.x = math.floor(map(self.frame, 0, PLAYER_MOVE_FRAMES, self.pos.x, self.nextPos.x) * TILE_SIZE)
        self.drawPos.y = math.floor(map(self.frame, 0, PLAYER_MOVE_FRAMES, self.pos.y, self.nextPos.y) * TILE_SIZE)

        if self.frame >= PLAYER_MOVE_FRAMES then
            self.pos.x = self.nextPos.x
            self.pos.y = self.nextPos.y
            
            self.state = STATE.cooldown
            self.frame = PLAYER_COOLDOWN_FRAMES - PLAYER_MOVECOOL_FRAMES

            --pick up items
            local it = itemAt(self.pos.x, self.pos.y)
            if it then
                if self.trailing then
                    if self.trailing.num < self.holdLimit then
                        local t = self.trailing
                        self.trailing = it
                        it.trailing = t
                        it.held = true
                        it.num = t.num + 1
                    else
                        local t = self.trailing
                        t:dropEnd()
                        self.trailing = it
                        it.trailing = t
                        it.held = true
                        it.num = t.num + 1
                    end
                else
                    self.trailing = it
                    it.held = true
                    it.num = 1
                end
            end
        end
    elseif self.state == STATE.mining then
        self.frame = self.frame + 1
        if self.frame >= PLAYER_MINE_FRAMES then
            damageTile(self.nextPos.x, self.nextPos.y, self.damage)
            
            self.state = STATE.cooldown
            self.frame = 0
        end
    elseif self.state == STATE.interacting then
        self.frame = self.frame + 1
        if self.frame >= PLAYER_INTERACT_FRAMES then
            self.state = STATE.cooldown
            self.frame = 0
        end
    elseif self.state == STATE.cooldown then
        self.frame = self.frame + 1
        if self.frame >= PLAYER_COOLDOWN_FRAMES then
            self.state = STATE.idle
            self.frame = 0
        end
    end
end

function player:draw()
    love.graphics.setColor(1, 1, 1, 1)

    local jumping = 0

    if self.state == STATE.moving or self.state == STATE.mining or self.state == STATE.interacting then
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
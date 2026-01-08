item = class:new()

function item:init(x, y, opts)
    self.pos = {x = x, y = y}
    self.nextPos = {x = x, y = y}
    self.drawPos = {x = x * TILE_SIZE, y = y * TILE_SIZE}

    self.frame = 0
    self.maxFrames = PLAYER_MOVE_FRAMES
    self.state = STATE.idle
    self.alive = true

    self.trailing = nil
    self.held = false

    for i, v in pairs(opts) do
        self[i] = v
    end
end

function item:move(x, y, maxFrames)
    if x == self.pos.x and y == self.pos.y then
        return
    end

    self.pos.x = map(self.frame, 0, self.maxFrames, self.pos.x, self.nextPos.x)
    self.pos.y = map(self.frame, 0, self.maxFrames, self.pos.y, self.nextPos.y)

    if self.trailing then
        self.trailing:move(self.pos.x, self.pos.y, maxFrames)
    end
    
    if maxFrames then
        self.maxFrames = maxFrames
    end

    self.state = STATE.moving
    self.frame = 0

    self.nextPos.x = x
    self.nextPos.y = y
end

function item:update()
    if self.state == STATE.moving then
        self.frame = self.frame + 1

        self.drawPos.x = math.floor(map(self.frame, 0, PLAYER_MOVE_FRAMES, self.pos.x, self.nextPos.x) * TILE_SIZE)
        self.drawPos.y = math.floor(map(self.frame, 0, PLAYER_MOVE_FRAMES, self.pos.y, self.nextPos.y) * TILE_SIZE)

        if self.frame >= self.maxFrames then
            self.pos.x = self.nextPos.x
            self.pos.y = self.nextPos.y

            self.state = STATE.idle
            self.frame = 0
        end
    end
end

function item:draw()
    if self.ore then
        love.graphics.draw(
            images.ore,
            love.graphics.newQuad(
                self.ore * TILE_SIZE,
                0,
                TILE_SIZE, TILE_SIZE,
                TILE_SIZE * ORE_SPRITE_COLS, TILE_SIZE
            ),
            self.drawPos.x,
            self.drawPos.y
        )
    elseif self.gem then
        love.graphics.draw(
            images.gem,
            love.graphics.newQuad(
                self.gem * TILE_SIZE,
                0,
                TILE_SIZE, TILE_SIZE,
                TILE_SIZE * GEM_SPRITE_COLS, TILE_SIZE
            ),
            self.drawPos.x,
            self.drawPos.y
        )
    end
end

function itemAt(x, y)
    for i = 1, #objects.items do
        if not objects.items[i].held and objects.items[i].pos.x == x and objects.items[i].pos.y == y then
            return objects.items[i]
        end
    end

    return nil
end
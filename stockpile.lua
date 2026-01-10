stockpile = interactable:new()

function stockpile:init()
    self.quad = {x = 30, y = 240, w = 6, h = 6}
    self.func = function()
        if objects.player.trailing then
            local t = objects.player.trailing
            self:addItem(t)
            t.held = false
            t.alive = false
            if t.trailing then
                t.trailing:move(t.pos.x, t.pos.y)
                objects.player.trailing = t.trailing
            else
                objects.player.trailing = nil
            end
        end
    end

    self.contents = {
        ore = {},
        gem = {}
    }

    for i = 1, STOCKPILE_STACKS do
        self.contents.ore[i] = {}
    end
    for i = 1, STOCKPILE_STACKS do
        self.contents.gem[i] = {}
    end

    self.dropping = false
    self.frame = 0
    self.droppingOre = nil
    self.droppingGem = nil
    self.dropFrom = {x=0, y=0}
    self.dropTo = {x=0, y=0}
end

function stockpile:addItem(it)
    self.dropping = true
    self.dropFrom = {
        x = it.pos.x * TILE_SIZE,
        y = it.pos.y * TILE_SIZE
    }

    if it.ore then
        local tests = 0
        local i = 0
        repeat
            i = randint(1, STOCKPILE_STACKS)
            tests = tests + 1
        until #self.contents.ore[i] < 4 * STOCKPILE_STACK_HEIGHT or tests > STOCKPILE_RANDOM_TESTS

        table.insert(self.contents.ore[i], -it.ore - 1)

        self.droppingOre = it.ore
        self.dropTo = {
            x = self.quad.x * TILE_SIZE + PILE_SIZE * i,
            y = (self.quad.y + self.quad.h - 1) * TILE_SIZE
        }
    elseif it.gem then
        local tests = 0
        local i = 0
        repeat
            i = randint(1, STOCKPILE_STACKS)
            tests = tests + 1
        until #self.contents.gem[i] < 4 * STOCKPILE_STACK_HEIGHT or tests > STOCKPILE_RANDOM_TESTS

        table.insert(self.contents.gem[i], -it.gem - 1)

        self.droppingGem = it.gem
        self.dropTo = {
            x = self.quad.x * TILE_SIZE + PILE_SIZE * i,
            y = (self.quad.y + self.quad.h - 3.5) * TILE_SIZE
        }
    end
end

function stockpile:update()
    if self.dropping then
        self.frame = self.frame + 1

        if self.frame >= STOCKPILE_FRAMES then
            self.dropping = false
            self.frame = 0
            self.droppingOre = nil
            self.droppingGem = nil

            --set all positive
            for i = 1, #self.contents.ore do
                for j = 1, #self.contents.ore[i] do
                    if self.contents.ore[i][j] < 0 then
                        self.contents.ore[i][j] = -self.contents.ore[i][j] - 1
                    end
                end
            end
            for i = 1, #self.contents.gem do
                for j = 1, #self.contents.gem[i] do
                    if self.contents.gem[i][j] < 0 then
                        self.contents.gem[i][j] = -self.contents.gem[i][j] - 1
                    end
                end
            end
        end
    end
end

function stockpile:drawPart(xp, yp, xw, yw)
    love.graphics.draw(
        images.stockpile,
        love.graphics.newQuad(xp * TILE_SIZE, yp * TILE_SIZE, TILE_SIZE, TILE_SIZE, TILE_SIZE*3, TILE_SIZE*3),
        xw * TILE_SIZE, yw * TILE_SIZE
    )
end

function stockpile:draw()
    love.graphics.setColor(1, 1, 1, 1)
    
    --corners
    self:drawPart(0, 0, self.quad.x, self.quad.y)
    self:drawPart(2, 0, self.quad.x + self.quad.w - 1, self.quad.y)
    self:drawPart(0, 2, self.quad.x, self.quad.y + self.quad.h - 1)
    self:drawPart(2, 2, self.quad.x + self.quad.w - 1, self.quad.y + self.quad.h - 1)

    --sides
    for x = 1, self.quad.w - 2 do
        self:drawPart(1, 0, self.quad.x + x, self.quad.y)
        self:drawPart(1, 2, self.quad.x + x, self.quad.y + self.quad.h - 1)
    end
    for y = 1, self.quad.h - 2 do
        self:drawPart(0, 1, self.quad.x, self.quad.y + y)
        self:drawPart(2, 1, self.quad.x + self.quad.w - 1, self.quad.y + y)
    end

    --middle
    for x = 1, self.quad.w - 2 do
        for y = 1, self.quad.h - 2 do
            self:drawPart(1, 1, self.quad.x + x, self.quad.y + y)
        end
    end

    --piles of ore
    for p = 1, STOCKPILE_STACKS do
        local pilex = self.quad.x * TILE_SIZE + PILE_SIZE * p
        local piley = (self.quad.y + self.quad.h - 1) * TILE_SIZE
        for i = 0, #self.contents.ore[p] - 1 do
            if i % 4 == 0 and i > 0 then
                piley = piley - PILE_SIZE
            end
            if i % (4*STOCKPILE_STACK_HEIGHT) == 0 and i > 0 then
                piley = (self.quad.y + self.quad.h - 1) * TILE_SIZE
            end

            if self.contents.ore[p][i + 1] >= 0 then
                love.graphics.draw(
                    images.orepile,
                    love.graphics.newQuad(
                        (i % 4) * PILE_SIZE, self.contents.ore[p][i + 1] * PILE_SIZE,
                        PILE_SIZE, PILE_SIZE,
                        4 * PILE_SIZE, PILE_SIZE * ORE_SPRITE_COLS
                    ),
                    pilex,
                    piley
                )
            end
        end
    end

    --piles of gems
    for p = 1, STOCKPILE_STACKS do
        local pilex = self.quad.x * TILE_SIZE + PILE_SIZE * p
        local piley = (self.quad.y + self.quad.h - 3.5) * TILE_SIZE
        for i = 0, #self.contents.gem[p] - 1 do
            if i % 4 == 0 and i > 0 then
                piley = piley - PILE_SIZE
            end
            if i % (4*STOCKPILE_STACK_HEIGHT) == 0 and i > 0 then
                piley = (self.quad.y + self.quad.h - 3.5) * TILE_SIZE
            end

            if self.contents.gem[p][i + 1] >= 0 then
                love.graphics.draw(
                    images.gempile,
                    love.graphics.newQuad(
                        (i % 4) * PILE_SIZE, (self.contents.gem[p][i + 1] % GEM_SPRITE_COLS) * PILE_SIZE,
                        PILE_SIZE, PILE_SIZE,
                        4 * PILE_SIZE, PILE_SIZE * GEM_SPRITE_COLS
                    ),
                    pilex,
                    piley
                )
            end
        end
    end

    --draw moving item
    if self.dropping then
        local drawx = map(self.frame, 0, STOCKPILE_FRAMES, self.dropFrom.x, self.dropTo.x) + TILE_SIZE/2
        local drawy = map(self.frame, 0, STOCKPILE_FRAMES, self.dropFrom.y, self.dropTo.y) + TILE_SIZE/2
        local drawScl = map(self.frame, 0, STOCKPILE_FRAMES, 1, STOCKPILE_ITEM_SCL)

        if self.droppingOre then
            love.graphics.draw(
                images.ore,
                love.graphics.newQuad(
                    self.droppingOre * TILE_SIZE, 0,
                    TILE_SIZE, TILE_SIZE,
                    TILE_SIZE * ORE_SPRITE_COLS, TILE_SIZE
                ),
                drawx, drawy,
                0,
                drawScl, drawScl,
                TILE_SIZE/2, TILE_SIZE/2
            )
        elseif self.droppingGem then
            love.graphics.draw(
                images.gem,
                love.graphics.newQuad(
                    (self.droppingGem % GEM_SPRITE_COLS) * TILE_SIZE, 0,
                    TILE_SIZE, TILE_SIZE,
                    TILE_SIZE * GEM_SPRITE_COLS, TILE_SIZE
                ),
                drawx, drawy,
                0,
                drawScl, drawScl,
                TILE_SIZE/2, TILE_SIZE/2
            )
        end
        -- love.graphics.rectangle("fill", drawx, drawy, 10, 10)
    end
end
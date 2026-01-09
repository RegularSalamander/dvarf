stockpile = interactable:new()

function stockpile:init()
    self.quad = {x = 30, y = 240, w = 6, h = 6}
    self.func = function()
        if objects.player.trailing then
            local t = objects.player.trailing
            t.held = false
            t.alive = false
            if t.ore then
                table.insert(self.contents.ore, t.ore)
            elseif t.gem then
                table.insert(self.contents.gem, t.gem)
            end
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
    local pilex = self.quad.x * TILE_SIZE + PILE_SIZE
    local piley = (self.quad.y + self.quad.h - 1) * TILE_SIZE
    for i = 0, #self.contents.ore - 1 do
        if i % 4 == 0 and i > 0 then
            piley = piley - PILE_SIZE
        end
        if i % (4*STOCKPILE_ORE_HEIGHT) == 0 and i > 0 then
            piley = (self.quad.y + self.quad.h - 1) * TILE_SIZE
            pilex = pilex + PILE_SIZE
        end
        if i % (4*STOCKPILE_ORE_HEIGHT*STOCKPILE_ORE_STACKS) == 0 and i > 0 then
            pilex = self.quad.x * TILE_SIZE + PILE_SIZE
            piley = (self.quad.y + self.quad.h - 1) * TILE_SIZE
        end
        
        love.graphics.draw(
            images.orepile,
            love.graphics.newQuad(
                (i % 4) * PILE_SIZE, self.contents.ore[i + 1] * PILE_SIZE,
                PILE_SIZE, PILE_SIZE,
                4 * PILE_SIZE, PILE_SIZE * ORE_SPRITE_COLS
            ),
            pilex,
            piley
        )
    end
    
    --piles of gems
    local pilex = self.quad.x * TILE_SIZE + PILE_SIZE*2.5
    local piley = (self.quad.y + self.quad.h - 1) * TILE_SIZE - PILE_SIZE*5
    for i = 0, #self.contents.gem - 1 do
        if i % 4 == 0 and i > 0 then
            piley = piley - PILE_SIZE
        end
        if i % (4*STOCKPILE_GEM_HEIGHT) == 0 and i > 0 then
            piley = (self.quad.y + self.quad.h - 1) * TILE_SIZE - PILE_SIZE*5
            pilex = pilex + PILE_SIZE
        end
        if i % (4*STOCKPILE_GEM_HEIGHT*STOCKPILE_GEM_STACKS) == 0 and i > 0 then
            pilex = self.quad.x * TILE_SIZE + PILE_SIZE*2.5
            piley = (self.quad.y + self.quad.h - 1) * TILE_SIZE - PILE_SIZE*5
        end
        
        love.graphics.draw(
            images.gempile,
            love.graphics.newQuad(
                (i % 4) * PILE_SIZE, self.contents.gem[i + 1] * PILE_SIZE,
                PILE_SIZE, PILE_SIZE,
                4 * PILE_SIZE, PILE_SIZE * GEM_SPRITE_COLS
            ),
            pilex,
            piley
        )
    end
end
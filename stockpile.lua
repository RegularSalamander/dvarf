stockpile = interactable:new()

function stockpile:init()
    self.quad = {x = 30, y = 240, w = 6, h = 6}
    self.func = function()
        if objects.player.trailing then
            local t = objects.player.trailing
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
end
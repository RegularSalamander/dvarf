tile = class:new()

function tile:init(x, y)
    self.pos = {x=x, y=y}
    self.hp = 1
end

function tile:damage(amt)
    self.hp = self.hp - amt
end

function tile:draw()
    if self.hp > 0 then
        love.graphics.setColor(102/255, 57/255, 49/255)
    else
        love.graphics.setColor(69/255, 40/255, 60/255)
    end

    love.graphics.rectangle("fill", self.pos.x * TILE_SIZE, self.pos.y * TILE_SIZE, TILE_SIZE, TILE_SIZE)
end
tile = class:new()

function tile:init(x, y)
    self.pos = {x=x, y=y}
    self.hp = 1
end

function tile:damage(amt)
    self.hp = self.hp - amt
end

function tile:draw()
    love.graphics.setColor(1, 1, 1, 1)
    if self.hp > 0 then
        love.graphics.draw(images.wall, self.pos.x * TILE_SIZE, self.pos.y * TILE_SIZE)
    else
        love.graphics.draw(images.floor, self.pos.x * TILE_SIZE, self.pos.y * TILE_SIZE)
    end
end
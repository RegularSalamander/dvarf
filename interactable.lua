interactable = class:new()

function interactable:init(x, y, w, h)
    self.quad = {x=x, y=y, w=w, h=h}
    self.func = function() end
end

function interactable:contains(x, y)
    return (
        x >= self.quad.x and x < self.quad.x + self.quad.w and
        y >= self.quad.y and y < self.quad.y + self.quad.h
    )
end

function interactable:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", self.quad.x * TILE_SIZE, self.quad.y * TILE_SIZE, self.quad.w * TILE_SIZE, self.quad.h * TILE_SIZE)
end

function interactableAt(x, y)
    for i = 1, #objects.interactables do
        if objects.interactables[i]:contains(x, y) then
            return objects.interactables[i]
        end
    end

    return nil
end
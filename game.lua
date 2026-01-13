function game_load()
    --[[
        For controls:
        0 means just released
        1 means just pressed
        positive means frames the button has been held down for
        negative means frames since the button was last released
    ]]
    controls = {
        left = 0,
        right = 0,
        up = 0,
        down = 0,
        z = 0,
        x = 0
    }

    cameraX = 0
    cameraY = 0

    objects = {}
    objects.player = player:new(math.floor(MAP_WIDTH/2), MAP_BOTTOM_SPACE + MAP_BOTTOM_AMP*2 + 3)
    objects.items = {}
    objects.interactables = {stockpile:new()}

    generateMap()
    discoverAround(objects.player.pos.x, objects.player.pos.y)
end

function game_update()
    objects.player:control()
    objects.player:update()

    cameraX = objects.player.drawPos.x + PLAYER_WIDTH/2 - CAMERA_WIDTH/2
    cameraY = objects.player.drawPos.y + PLAYER_HEIGHT/2 - CAMERA_HEIGHT/2

    cameraX = constrain(cameraX, TILE_SIZE, TILE_SIZE + MAP_WIDTH*TILE_SIZE - CAMERA_WIDTH)
    cameraY = constrain(cameraY, TILE_SIZE, TILE_SIZE + MAP_HEIGHT*TILE_SIZE - CAMERA_HEIGHT)

    for i = 1, #objects.items do
        objects.items[i]:update()
    end
    for i = #objects.items, 1, -1 do
        if not objects.items[i].alive then
            table.remove(objects.items, i)
        end
    end

    for i = 1, #objects.interactables do
        if objects.interactables[i].update then
            objects.interactables[i]:update()
        end
    end

    for k, v in pairs(controls) do
        if v > 0 then
            controls[k] = v + 1
        else
            controls[k] = v - 1
        end
    end
end


function game_keypressed(key, scancode, isrepeat)
    if isrepeat then return end
    if controls[scancode] then controls[scancode] = 1 end

    if scancode == "z" then
        objects.player.damage = objects.player.damage * PLAYER_DAMAGE_MULTIPLIER
    end
end

function game_keyreleased(key, scancode, isrepeat)
    if isrepeat then return end
    if controls[scancode] then controls[scancode] = 0 end
end

function game_draw()
    --draw to gameCanvas
    love.graphics.setCanvas{gameCanvas, stencil=true}

    love.graphics.setStencilTest()
    love.graphics.setColor(34/255, 32/255, 52/255, 1)
    love.graphics.rectangle("fill", 0, 0, CAMERA_WIDTH, CAMERA_HEIGHT)

    love.graphics.push()
    love.graphics.translate(-cameraX, -cameraY)

    generateLights()
    applyLightingStencils()

    love.graphics.setColor(1, 1, 1, 1)
    drawMap()

    for i = 1, #objects.items do
        objects.items[i]:draw()
    end

    for i = 1, #objects.interactables do
        objects.interactables[i]:draw()
    end

    love.graphics.setStencilTest()
    objects.player:draw()

    love.graphics.pop()

    love.graphics.print(love.timer.getFPS(), 10, 10)

    love.graphics.setCanvas()
end
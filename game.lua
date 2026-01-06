local mouseX = 0
local mouseY = 0

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

    generateMap()
end

function game_update()
    local w, h = love.graphics.getDimensions()
    local scl = math.min(w/CAMERA_WIDTH, h/CAMERA_HEIGHT)

    mouseX, mouseY = love.mouse.getPosition()
    mouseX = mouseX / scl
    mouseY = mouseY / scl

    local xpos = math.floor(mouseX / TILE_SIZE)
    local ypos = math.floor(mouseY / TILE_SIZE)

    damageTile(xpos, ypos)


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

    generateLights()
    applyLightingStencils()

    love.graphics.setColor(1, 1, 1, 1)
    drawMap()

    love.graphics.setStencilTest()
    love.graphics.print(controls.up, 10, 10)

    love.graphics.setCanvas()
end
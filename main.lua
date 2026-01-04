require("variables")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")
    love.window.setMode(CAMERA_WIDTH * DEFAULT_PIXEL_SCALE, CAMERA_HEIGHT * DEFAULT_PIXEL_SCALE, {vsync = false, msaa = 0, highdpi = true})
    love.window.setTitle("Dvarf")

    gameCanvas = love.graphics.newCanvas(CAMERA_WIDTH, CAMERA_HEIGHT)

    --checkerboard setup
    checker = love.graphics.newCanvas()
    love.graphics.setCanvas(checker)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, CAMERA_WIDTH, CAMERA_HEIGHT)
    love.graphics.setColor(1, 1, 1, 1)
    for x = 0, CAMERA_WIDTH do
        for y = 0, CAMERA_HEIGHT do
            if (x+y)%2 == 0 then
                love.graphics.rectangle("fill", x, y, 1, 1)
            end
        end
    end

    love.graphics.setCanvas()
end

function love.update()

end

function love.draw()
    love.graphics.setCanvas(gameCanvas)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(checker)

    local w, h = love.graphics.getDimensions()
    local scl = math.min(w/CAMERA_WIDTH, h/CAMERA_HEIGHT)

    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gameCanvas, 0, 0, 0, scl, scl)
end
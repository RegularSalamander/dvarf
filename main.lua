require("variables")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")
    love.window.setMode(CAMERA_WIDTH * DEFAULT_PIXEL_SCALE, CAMERA_HEIGHT * DEFAULT_PIXEL_SCALE, {vsync = false, msaa = 0, highdpi = true})
    love.window.setTitle("Dvarf")

    gameCanvas = love.graphics.newCanvas(CAMERA_WIDTH, CAMERA_HEIGHT)
end

function love.update()

end

function love.draw()
    love.graphics.setCanvas(gameCanvas)
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.line(0, 0, CAMERA_WIDTH, CAMERA_HEIGHT)

    local w, h = love.graphics.getDimensions()
    local scl = math.min(w/CAMERA_WIDTH, h/CAMERA_HEIGHT)

    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gameCanvas, 0, 0, 0, scl, scl)
end
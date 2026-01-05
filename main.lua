require("class")
require("variables")

require("tile")
require("map")
require("lighting")

local mouseX = 0
local mouseY = 0

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")
    love.window.setMode(CAMERA_WIDTH * DEFAULT_PIXEL_SCALE, CAMERA_HEIGHT * DEFAULT_PIXEL_SCALE, {vsync = false, msaa = 0, highdpi = true})
    love.window.setTitle("Dvarf")

    gameCanvas = love.graphics.newCanvas(CAMERA_WIDTH, CAMERA_HEIGHT)

    generateMap()
end

function love.update()
    local w, h = love.graphics.getDimensions()
    local scl = math.min(w/CAMERA_WIDTH, h/CAMERA_HEIGHT)

    mouseX, mouseY = love.mouse.getPosition()
    mouseX = mouseX / scl
    mouseY = mouseY / scl
end

function love.draw()
    --draw to gameCanvas
    love.graphics.setCanvas{gameCanvas, stencil=true}

    love.graphics.setStencilTest()
    love.graphics.setColor(34/255, 32/255, 52/255, 1)
    love.graphics.rectangle("fill", 0, 0, CAMERA_WIDTH, CAMERA_HEIGHT)

    generateLights()
    applyLightingStencils()

    love.graphics.setColor(1, 1, 1, 1)
    drawMap()

    --draw gameCanvas to screen
    love.graphics.setCanvas()
    love.graphics.setStencilTest()

    local w, h = love.graphics.getDimensions()
    local scl = math.min(w/CAMERA_WIDTH, h/CAMERA_HEIGHT)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gameCanvas, 0, 0, 0, scl, scl)
end

function love.mousepressed(x, y, button, istouch, presses)
    --damage tile when clicked for debugging
    local w, h = love.graphics.getDimensions()
    local scl = math.min(w/CAMERA_WIDTH, h/CAMERA_HEIGHT)

    local xpos = math.floor(x / scl / TILE_SIZE)
    local ypos = math.floor(y / scl / TILE_SIZE)

    damageTile(xpos, ypos)
end
require("class")
require("variables")

require("blobMap")
require("tile")
require("map")
require("lighting")

require("game")

local gameState = ""

function setGameState(newState)
    gameState = newState
    if _G[gameState .. "_load"] then
        _G[gameState .. "_load"]()
    end
end

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")
    love.window.setMode(CAMERA_WIDTH * DEFAULT_PIXEL_SCALE, CAMERA_HEIGHT * DEFAULT_PIXEL_SCALE, {vsync = true, msaa = 0, highdpi = true})
    love.window.setTitle("Dvarf")

    images = {}
    images.lightmask = love.graphics.newImage("assets/lightmask.png")
    images.wall = love.graphics.newImage("assets/wall.png")
    images.floor = love.graphics.newImage("assets/floor.png")

    gameCanvas = love.graphics.newCanvas(CAMERA_WIDTH, CAMERA_HEIGHT)

    setGameState("game")
end

function love.update()
    if _G[gameState .. "_update"] then
        _G[gameState .. "_update"]()
    end
end

function love.draw()
    if _G[gameState .. "_draw"] then
        _G[gameState .. "_draw"]()
    end

    --draw gameCanvas to screen
    love.graphics.setCanvas()
    love.graphics.setStencilTest()

    local w, h = love.graphics.getDimensions()
    local scl = math.min(w/CAMERA_WIDTH, h/CAMERA_HEIGHT)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gameCanvas, 0, 0, 0, scl, scl)
end

function love.keypressed(key, scancode, isrepeat)
    if _G[gameState .. "_keypressed"] then
        _G[gameState .. "_keypressed"](key, scancode, isrepeat)
    end
end

function love.keyreleased(key, scancode, isrepeat)
    if _G[gameState .. "_keyreleased"] then
        _G[gameState .. "_keyreleased"](key, scancode, isrepeat)
    end
end
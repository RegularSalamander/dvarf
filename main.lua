require("variables")

local mask_shader = love.graphics.newShader[[
   vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
      if (Texel(texture, texture_coords).rgb == vec3(0.0)) {
         // a discarded pixel wont be applied as the stencil.
         discard;
      }
      return vec4(1.0);
   }
]]

local mouseX = 0
local mouseY = 0

local circlePos = {}

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")
    love.window.setMode(CAMERA_WIDTH * DEFAULT_PIXEL_SCALE, CAMERA_HEIGHT * DEFAULT_PIXEL_SCALE, {vsync = false, msaa = 0, highdpi = true})
    love.window.setTitle("Dvarf")

    gameCanvas = love.graphics.newCanvas(CAMERA_WIDTH, CAMERA_HEIGHT)

    createCheckerMask()
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
    -- love.graphics.setCanvas{gameCanvas}

    

    love.graphics.setCanvas{gameCanvas, stencil=true}

    love.graphics.setStencilTest()
    love.graphics.setColor(34/255, 32/255, 52/255, 1)
    love.graphics.rectangle("fill", 0, 0, CAMERA_WIDTH, CAMERA_HEIGHT)

    circlePos = {
        {0, 0},
        {mouseX, mouseY}
    }

    love.graphics.stencil(largeCircleStencil, "replace", 1, false)
    love.graphics.stencil(checkerStencil, "increment", 1, true)
    love.graphics.stencil(smallCircleStencil, "replace", 2, true)
    love.graphics.setStencilTest("greater", 1)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, CAMERA_WIDTH, CAMERA_HEIGHT)

    --draw gameCanvas to screen
    love.graphics.setCanvas()
    love.graphics.setStencilTest()

    local w, h = love.graphics.getDimensions()
    local scl = math.min(w/CAMERA_WIDTH, h/CAMERA_HEIGHT)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gameCanvas, 0, 0, 0, scl, scl)
end

function createCheckerMask()
    checkerMask = love.graphics.newCanvas(CAMERA_WIDTH, CAMERA_HEIGHT)

    love.graphics.setCanvas(checkerMask)
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

function checkerStencil()
    love.graphics.setShader(mask_shader)
    love.graphics.draw(checkerMask)
    love.graphics.setShader()
end

function smallCircleStencil()
    for i = 1, #circlePos do
        love.graphics.circle("fill", circlePos[i][1], circlePos[i][2], TILE_SIZE*3)
    end
end

function largeCircleStencil()
    for i = 1, #circlePos do
        love.graphics.circle("fill", circlePos[i][1], circlePos[i][2], TILE_SIZE*5)
    end
end
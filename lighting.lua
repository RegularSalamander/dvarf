local mask_shader = love.graphics.newShader[[
   vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
      if (Texel(texture, texture_coords).rgb == vec3(0.0)) {
         // a discarded pixel wont be applied as the stencil.
         discard;
      }
      return vec4(1.0);
   }
]]

local lightPos = {}
local checkerMask

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
    for i = 1, #lightPos do
        love.graphics.circle("fill", lightPos[i][1], lightPos[i][2], SMALL_LIGHT_SIZE)
    end
end

function largeCircleStencil()
    for i = 1, #lightPos do
        love.graphics.circle("fill", lightPos[i][1], lightPos[i][2], LARGE_LIGHT_SIZE)
    end
end

function generateLights()
    lightPos = {}
    for x = 1, MAP_WIDTH do
        for y = 1, MAP_HEIGHT do
            if getTile(x, y).hp <= 0 then
                table.insert(lightPos, {x*TILE_SIZE + TILE_SIZE/2, y*TILE_SIZE + TILE_SIZE/2})
            end
        end
    end
end

function applyLightingStencils()
    if checkerMask == nil then
        createCheckerMask()
    end

    love.graphics.stencil(largeCircleStencil, "replace", 1, false)
    love.graphics.stencil(checkerStencil, "increment", 1, true)
    love.graphics.stencil(smallCircleStencil, "replace", 2, true)
    love.graphics.setStencilTest("greater", 1)
end
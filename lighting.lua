local mask_shader = love.graphics.newShader[[
   vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
      if (Texel(texture, texture_coords).rgb == vec3(0.0)) {
         // a discarded pixel wont be applied as the stencil.
         discard;
      }
      return vec4(1.0);
   }
]]

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

function applyLightingStencils()
    if checkerMask == nil then
        createCheckerMask()
    end

    love.graphics.stencil(largeCircleStencil, "replace", 1, false)
    love.graphics.stencil(checkerStencil, "increment", 1, true)
    love.graphics.stencil(smallCircleStencil, "replace", 2, true)
    love.graphics.setStencilTest("greater", 1)
end
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

function maskStencil()
    love.graphics.setShader(mask_shader)
    for i = 1, #lightPos do
        love.graphics.draw(images.lightmask, lightPos[i][1], lightPos[i][2])
    end
    love.graphics.setShader()
end

function generateLights()
    lightPos = {}
    for x = 1, MAP_WIDTH do
        for y = 1, MAP_HEIGHT do
            if getTile(x, y).hp <= 0 then
                table.insert(lightPos, {(x - 4) * TILE_SIZE, (y - 4) * TILE_SIZE})
            end
        end
    end
end

function applyLightingStencils()
    love.graphics.stencil(maskStencil, "increment", 1, true)
    love.graphics.setStencilTest("greater", 0)
end
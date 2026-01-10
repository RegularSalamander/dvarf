CAMERA_WIDTH = 320
CAMERA_HEIGHT = 180

DEFAULT_PIXEL_SCALE = 4

TILE_SIZE = 8
LIGHT_MARGIN = 4

MAP_WIDTH = 75
MAP_HEIGHT = 250

MAP_BOTTOM_SPACE = MAP_HEIGHT - 25
MAP_BOTTOM_AMP = 5
MAP_BOTTOM_FREQ = 0.1
MAP_BOTTOM_CURVE = 0.1

MAP_BAND_SIZE = math.floor((MAP_BOTTOM_SPACE + MAP_BOTTOM_AMP*2) / 5)
MAP_BAND_SCATTER = 5

MAP_HIGH_ORE_PER_BAND = 15
MAP_STAND_ORE_PER_BAND = 30
MAP_LOW_ORE_PER_BAND = 20
MAP_LOW_ORE_SKEW = 2

MAP_GEM_START = 15
MAP_GEM_INCREASE = 1.2
MAP_BEST_GEM = 7
MAP_GEM_SKEW = 1.5

PLAYER_WIDTH = 8
PLAYER_HEIGHT = 8

PLAYER_MOVE_FRAMES = 12
PLAYER_MINE_FRAMES = 12
PLAYER_INTERACT_FRAMES = 12
PLAYER_COOLDOWN_FRAMES = 10
PLAYER_MOVECOOL_FRAMES = 3

STATE = {
    idle = 1,
    moving = 2,
    mining = 3,
    interacting = 4,
    cooldown = 5
}

STONE_LAYER_MULTIPLIER = 2
PLAYER_DAMAGE_MULTIPLIER = math.sqrt(1.75)

WALL_SPRITE_COLS = 7 * 5
WALL_SPRITE_ROWS = 7 * 6
GEM_SPRITE_COLS = 7
ORE_SPRITE_COLS = 10

PILE_SIZE = 4
STOCKPILE_WIDTH = 6
STOCKPILE_HEIGHT = 6
STOCKPILE_STACKS = 10
STOCKPILE_STACK_HEIGHT = 5
STOCKPILE_RANDOM_TESTS = 100
STOCKPILE_FRAMES = PLAYER_INTERACT_FRAMES
STOCKPILE_ITEM_SCL = 0.5

COLORS = {
    stone1light = {102, 57, 49},
    stone1dark = {69, 40, 60},
    stone2light = {89, 86, 82},
    stone2dark = {50, 60, 57},
    stone3light = {48, 96, 130},
    stone3dark = {63, 63, 116},
    stone4light = {118, 66, 138},
    stone4dark = {69, 40, 60},
    stone5light = {138, 111, 48},
    stone5dark = {82, 75, 36},
    dark = {34, 32/355, 52},
    gem1 = {215, 123, 186},
    gem2 = {91, 110, 225},
    gem3 = {153, 229, 80},
    gem4 = {251, 242, 54},
    gem5 = {217, 160, 102},
    gem6 = {217, 87, 99},
    gem7 = {255, 255, 255},
    ore1 = {138, 111, 48},
    ore2 = {105, 106, 106},
    ore3 = {143, 151, 74},
    ore4 = {155, 173, 183},
    ore5 = {251, 242, 54},
    ore6 = {203, 219, 252},
    ore7 = {106, 190, 48},
    ore8 = {99, 155, 255},
    ore9 = {63, 63, 116},
    ore10 = {215, 123, 186}
}

for k, v in pairs(COLORS) do
    for j = 1, 3 do
        COLORS[k][j] = COLORS[k][j] / 255
    end
end
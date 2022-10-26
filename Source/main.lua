import 'CoreLibs/graphics'
import 'Player'
import 'Enemy'
import 'Level'

gfx = playdate.graphics

local title = gfx.image.new('Images/title')
local titlepress = gfx.image.new('Images/titlepress')
local tiles = gfx.imagetable.new('Images/Loderunner')
local stencil = gfx.image.new(400, 240)
local level = Level(tiles)
local player = Player(tiles)

local GameState =
{
    Menu = 1,
    Score = 2,
    Fade = 3,
    Play = 4,
    Over = 5
}

local gameLevel = 1
local gameTicks = 0
local gameState = GameState.Menu

local gameStateHandlers = {}

gameStateHandlers[GameState.Menu] =
    function()
        gfx.setBackgroundColor(gfx.kColorBlack)
        gfx.clear()

        title:draw(95, 30)
        titlepress:draw(135, 185)

        if playdate.buttonJustReleased(playdate.kButtonA) then
            gameState = GameState.Score
            gameTicks = 0
        end
    end

gameStateHandlers[GameState.Score] =
    function()
        gfx.setBackgroundColor(gfx.kColorBlack)
        gfx.clear()

        if gameTicks > 0 then
            level:load(gameLevel)
            level:setPlayer(player)
            gameState = GameState.Fade
            gameTicks = 0
        end
    end

gameStateHandlers[GameState.Fade] =
    function()
        gfx.setBackgroundColor(gfx.kColorBlack)
        gfx.clear()

        if gameTicks < 110 then
            gfx.setColor(gfx.kColorBlack)
            gfx.fillRect(0, 0, 400, 240)
            gfx.lockFocus(stencil)
                gfx.fillRect(0, 0, 400, 240)
                gfx.setColor(gfx.kColorWhite)
                gfx.fillCircleAtPoint(200, 120, gameTicks * 2)
            gfx.unlockFocus()

            gfx.setStencilImage(stencil)
--            level:draw()
            gfx.sprite.update()
            gfx.clearStencil()
        else
            player:automaticAnimation(true)
            
            if playdate.getButtonState() ~= 0 then
                gameState = GameState.Play
                gameTicks = 0
            end

            gfx.sprite.update()
        end
    end

gameStateHandlers[GameState.Play] =
    function()
        gfx.clear()
        level:update()
        gfx.sprite.update()
    end

gfx.sprite.setBackgroundDrawingCallback(
    function()
        level:draw(0,0)
    end
)

function playdate.update()
    gameStateHandlers[gameState]()
    gameTicks += 1
end
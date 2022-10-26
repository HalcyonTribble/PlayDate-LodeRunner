import 'CoreLibs/object'
import 'CoreLibs/sprites'

class("AnimatedSprite").extends(playdate.graphics.sprite)

-- Constructor
function AnimatedSprite:init(imageTable)
    AnimatedSprite.super.init(self)

    self.flipped = false            -- Whether the sprite is drawn flipped or not
    self.animationStates = {}       -- Animation information
    self.currentState = ""          -- Current animation
    self.imageTable = imageTable    -- Image table holding sprites
    self.animating = true           -- Automatic animation
    self.tickCount = 0
    self.currentTileIndex = 1
end

function AnimatedSprite:playAnimation(name, flip)
    if flip == nil then flip = false end
    if self.currentState == name and self.flipped == flip then return end

    self.currentState = name
    self.tickCount = 0
    self.currentTileIndex = 1
    self.flipped = flip
    self.animating = true

    self:updateImage()
end

function AnimatedSprite:automaticAnimation(auto)
    self.animating = auto
end

function AnimatedSprite:addAnimation(animation, tileList, speed)
    self.animationStates[animation] = 
    {
        tiles = tileList,
        speed = speed
    }
end

function AnimatedSprite:updateImage()
    local state = self.animationStates[self.currentState]

    if self.flipped then
        self:setImage(self.imageTable:getImage(state.tiles[self.currentTileIndex]), "flipX")
    else
        self:setImage(self.imageTable:getImage(state.tiles[self.currentTileIndex]))
    end

    self:setImageDrawMode(playdate.graphics.kDrawModeBlackTransparent)
end

-- Called when playdate.graphics.sprite.update is called
function AnimatedSprite:update(force)
    if self.animating == false and force ~= true then return end

    local state = self.animationStates[self.currentState]

    self.tickCount += 1

    if self.tickCount == state.speed then
        self.tickCount = 0

        self.currentTileIndex += 1

        if self.currentTileIndex > #state.tiles then
            self.currentTileIndex = 1
        end

        self:updateImage()
    end
end

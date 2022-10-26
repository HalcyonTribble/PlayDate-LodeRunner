import 'AnimatedSprite'

class("Player").extends(AnimatedSprite)

function Player:init(tileMap)
    Player.super.init(self, tileMap)

    self:addAnimation("idle", {19, 20}, 10)
    self:addAnimation("walk", {1, 2, 3, 4}, 2)
    self:addAnimation("fall", {5, 6, 7, 8}, 2)
    self:addAnimation("climb", {9, 10, 11, 12}, 2)
    self:addAnimation("rope", {13, 14, 15, 16}, 2)
    self:addAnimation("start", { 1, 40 }, 10)
    self:playAnimation("start")
    self:automaticAnimation(false)
    self:setCenter(0.0, 0.0)
    self:add()

    self.falling = false
    self.swinging = false
end
import 'AnimatedSprite'

class("Enemy").extends(AnimatedSprite)

function Enemy:init(tileMap)
    Enemy.super.init(self, tileMap)

    self:addAnimation("idle", {19, 20}, 10)
    self:addAnimation("walk", {1, 2, 3, 4}, 2)
    self:addAnimation("fall", {5, 6, 7, 8}, 4)
    self:addAnimation("climb", {9, 10, 11, 12}, 4)
    self:addAnimation("rope", {13, 14, 15, 16}, 4)
    self:addAnimation("start", { 1, 40 }, 10)
    self:playAnimation("start")
    self:setCenter(0.0, 0.0)
    self:add()
end
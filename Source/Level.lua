import 'CoreLibs/graphics'

class("Level").extends("Object")

local TileType =
{
    Solid = 34,
    Diggable = 33,
    Ladder = 36,
    Rope = 35,
    Empty = 40
}

local TileHeight = 16
local TileWidth = 8

local function tileFromPos(x, y)
    return (x // TileWidth) + 1, (y // TileHeight) + 1
end

local function solidTile(tile)
    return tile == TileType.Solid or tile == TileType.Diggable
end

function Level:init(imageTable)
    self.lodeLocations = {}
    self.enemyLocations = {}
    self.spawnLocations = {}
    self.playerStartLocation = { x=88, y=16 }
    self.lodes = {}
    self.enemies = {}
    self.player = nil
    self.map = playdate.graphics.tilemap.new()
    self.map:setImageTable(imageTable)
end

function Level:setTiles(data, size)
    self.map:setTiles(data, size)
end

function Level:setPlayer(player)
    self.player = player
    self.player:moveTo(self.playerStartLocation["x"], self.playerStartLocation["y"])
end

function Level:draw()
    self.map:draw(0, 0)
end

function Level:movePlayerLeft()
end

function Level:movePlayerRight()
end

function Level:movePlayerUp()
end

function Level:movePlayerDown()
end

function Level:updatePlayer()
    if self.player.falling then
        -- Get the player's location
        local x, y = self.player:getPosition()

        -- Adjust the location down one row
        y += 1

        -- Get the map tile at the new location
        local tile = self.map:getTileAtPosition(tileFromPos(x, y + TileHeight))

        -- Check the tile to see if the player stops falling
        if solidTile(tile) then
            self.player:playAnimation("idle")
            self.player.falling = false
        else
            tile = self.map:getTileAtPosition(tileFromPos(x, y))

            if tile == TileType.Rope and y % TileHeight == 0 then
                self.player:playAnimation("rope")
                self.player:automaticAnimation(false)
                self.player.falling = false
                self.player.swinging = true
            end
        end

        -- Move player to new location
        self.player:moveTo(x, y)
    elseif playdate.buttonIsPressed(playdate.kButtonLeft) then
        local x,y = self.player:getPosition()
        x -= 1
        local tile = self.map:getTileAtPosition(tileFromPos(x, y))
        if self.player.swinging then
            if tile == TileType.Rope or x % 8 > 5 then
                self.player:playAnimation("rope")
                self.player:automaticAnimation(false)
                self.player:update(true)
                self.player:moveTo(x, y)
                return
            else
                self.player.swinging = false
            end
        end

        if solidTile(tile) then 
            self.player:playAnimation("idle")
        elseif tile == TileType.Rope then
            if x % 8 <= 5 then
                self.player.swinging = true
                self.player:playAnimation("rope")
                self.player:automaticAnimation(false)
            end
            self.player:moveTo(x, y)
        else
            floor = self.map:getTileAtPosition(tileFromPos(x, y + 17))
            if floor == TileType.Empty and x % 8 > 5 then
                x = math.floor(x / 8) * 8
                self.player.falling = true
                self.player:playAnimation("fall")
            else
                self.player:playAnimation("walk")
            end
            self.player:moveTo(x, y)
        end
    elseif playdate.buttonIsPressed(playdate.kButtonRight) then
        local x,y = self.player:getPosition()
        x += 1
        local tile = self.map:getTileAtPosition(tileFromPos(x + 8, y))
        if self.player.swinging then
            if tile == TileType.Rope or x % 8 <= 5 then
                self.player:playAnimation("rope", true)
                self.player:automaticAnimation(false)
                self.player:update(true)
                self.player:moveTo(x, y)
                return
            else
                self.player.swinging = false
            end
        end

        if solidTile(tile) then 
            self.player:playAnimation("idle")
        elseif tile == TileType.Rope and x % 8 > 5 then
            self.player.swinging = true
            self.player:playAnimation("rope", true)
            self.player:automaticAnimation(false)
            self.player:moveTo(x, y)
        else
            floor = self.map:getTileAtPosition(tileFromPos(x + 8, y + 17))
            if floor == TileType.Empty and x % 8 > 5 then
                x = math.ceil(x / 8) * 8
                self.player.falling = true
                self.player:playAnimation("fall", true)
            else
                self.player:playAnimation("walk", true)
            end
            self.player:moveTo(x, y)
        end
    elseif playdate.buttonIsPressed(playdate.kButtonUp) then
        self.player:playAnimation("climb")
    elseif playdate.buttonIsPressed(playdate.kButtonDown) then
        if self.player.swinging then
            local x, y = self.player:getPosition()
            local left = self.map:getTileAtPosition(tileFromPos(x, y + 17))
            local right = self.map:getTileAtPosition(tileFromPos(x + 8, y + 17))

            if solidTile(left) or solidTile(right) then
                -- don't fall
            else
                self.player:moveTo(x, y + 1)
                self.player.falling = true
                self.player.swinging = false
                self.player:playAnimation("fall", true)
            end
        end
    elseif playdate.buttonIsPressed(playdate.kButtonA) then
        self.player:playAnimation("rope")
    elseif playdate.buttonIsPressed(playdate.kButtonB) then
        self.player:playAnimation("rope", true)
    else
        if self.player.swinging == false then
            self.player:playAnimation("idle")
        end
    end
end

function Level:updateEnemies()
end

function Level:updateHoles()
end

function Level:update()
    self:updatePlayer()
    self:updateEnemies()
    -- check collisions
    self:updateHoles()
end

function Level:load(levelNum)
    local data = {
        34, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 34,
        34, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 34,
        34, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 36, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 34,
        34, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 36, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 34,
        34, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 36, 40, 40, 40, 40, 40, 40, 40, 40, 40, 33, 33, 36, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 36, 33, 33, 34,
        34, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 36, 40, 40, 40, 40, 40, 40, 40, 40, 40, 33, 33, 36, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 36, 40, 40, 34,
        34, 33, 33, 33, 33, 36, 33, 33, 33, 33, 33, 33, 33, 40, 40, 40, 40, 40, 40, 40, 40, 40, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 36, 33, 33, 33, 33, 33, 33, 33, 33, 33, 34,
        34, 40, 40, 40, 40, 36, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 36, 40, 40, 40, 40, 40, 40, 40, 40, 40, 34,
        34, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 36, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 36, 40, 40, 40, 40, 40, 40, 40, 40, 40, 34,
        34, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 36, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 36, 40, 40, 40, 40, 40, 40, 40, 40, 40, 34,
        34, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 36, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 36, 40, 40, 40, 40, 40, 40, 40, 40, 40, 34,
        34, 40, 40, 40, 40, 40, 36, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 33, 33, 33, 33, 33, 33, 33, 33, 33, 36, 34,
        34, 40, 40, 40, 40, 40, 36, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 36, 34,
        34, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 34,
        34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34
    }
    
    self.map:setTiles(data, 50)
end

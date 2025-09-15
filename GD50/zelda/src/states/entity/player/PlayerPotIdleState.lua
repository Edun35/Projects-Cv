--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerPotIdleState = Class{__includes = EntityIdleState}
function PlayerPotIdleState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon
end

function PlayerPotIdleState:enter(param)
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0   
    self.entity:changeAnimation('pot-idle-' .. self.entity.direction)
end

function PlayerPotIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('potwalk')
    end
  
    if love.keyboard.wasPressed('return') then
        for k, object in pairs(self.dungeon.currentRoom.projectiles) do
            if object.state == 'held' then
                object.direction = self.entity.direction
                object.state = 'thrown'
                table.insert(self.dungeon.currentRoom.projectiles, object)
                object.thrown = true
            end
        end
        self.entity:changeState('idle')
    end
end
--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{__includes = GameObject}

function Projectile:init(def, x, y, direction)
    self.distance = 0
    self.max = 64
    self.direction = direction or nil
    self.destroyed = false
    GameObject.init(self, def, x, y)
end

function Projectile:update(dt)
    if self.state == 'thrown' then
        self:onThrow(dt)
    end
    GameObject.update(self, dt)
end

function Projectile:render(adjacentOffsetX, adjacentOffsetY)
    GameObject.render(self, adjacentOffsetX, adjacentOffsetY)
end

function Projectile:onThrow(dt)
    -- boundary checking on all sides, allowing us to avoid collision detection on tiles
    if self.direction == 'left' then
        self.x = self.x - 60 * dt
        self.distance = self.distance + 60 * dt
        if self.distance > self.max then
            self.state = 'broken'
            self.destroyed = true
        end

        if self.x <= MAP_RENDER_OFFSET_X + TILE_SIZE then 
            self.x = MAP_RENDER_OFFSET_X + TILE_SIZE
            self.state = 'broken'
            self.destroyed = true
        end
    elseif self.direction == 'right' then
        self.x = self.x + 60 * dt
        self.distance = self.distance + 60 * dt
        if self.distance > self.max then
            self.state = 'broken'
            self.destroyed = true
        end
    
        if self.x + self.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 then
            self.x = VIRTUAL_WIDTH - TILE_SIZE * 2 - self.width
            self.state = 'broken'
            self.destroyed = true
        end
    elseif self.direction == 'up' then
        self.y = self.y - 60 * dt
        self.distance = self.distance + 60 * dt
        if self.distance > self.max then
            self.state = 'broken'
            self.destroyed = true
        end

        if self.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height / 2 then 
            self.y = MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height / 2
            self.state = 'broken'
            self.destroyed = true
        end
    elseif self.direction == 'down' then
            self.y = self.y + 60 * dt
            self.distance = self.distance + 60 * dt
        if self.distance > self.max then
            self.state = 'broken'
            self.destroyed = true
        end
    
        local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) 
            + MAP_RENDER_OFFSET_Y - TILE_SIZE
    
        if self.y + self.height >= bottomEdge then
            self.y = bottomEdge - self.height
            self.state = 'broken'
            self.destroyed = true
        end
    end
end

PlayerLiftState = Class{__includes = BaseState}

function PlayerLiftState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite; negated in render function of state
    self.player.offsetY = 5
    self.player.offsetX = 0

    -- create hitbox based on where the player is and facing
    local direction = self.player.direction
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    if direction == 'left' then
        hitboxWidth = 8
        hitboxHeight = 16
        hitboxX = self.player.x - hitboxWidth
        hitboxY = self.player.y + 2
    elseif direction == 'right' then
        hitboxWidth = 8
        hitboxHeight = 16
        hitboxX = self.player.x + self.player.width
        hitboxY = self.player.y + 2
    elseif direction == 'up' then
        hitboxWidth = 16
        hitboxHeight = 8
        hitboxX = self.player.x
        hitboxY = self.player.y - hitboxHeight
    else
        hitboxWidth = 16
        hitboxHeight = 8
        hitboxX = self.player.x
        hitboxY = self.player.y + self.player.height
    end

    -- separate hitbox for the player's sword; will only be active during this state
    self.liftHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)

    -- sword-left, sword-up, etc
    self.player:changeAnimation('lift-' .. self.player.direction)
end

function PlayerLiftState:enter(params)
    
    -- restart sword swing sound for rapid swinging
    gSounds['sword']:stop()
    gSounds['sword']:play()

    -- restart sword swing animation
    self.player.currentAnimation:refresh()
end

function PlayerLiftState:update(dt)

    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if object.type == 'pot' then
            if not (self.liftHitbox.x + self.liftHitbox.width < object.x or self.liftHitbox.x > object.x + object.width or
            self.liftHitbox.y + self.liftHitbox.height < object.y or self.liftHitbox.y > object.y + object.height) then
                if self.player.currentAnimation.timesPlayed > 0 then
                    self.player.currentAnimation.timesPlayed = 0
                    object.state = 'held'
                    table.insert(self.dungeon.currentRoom.projectiles, object)
                    table.remove(self.dungeon.currentRoom.objects, k)
                    self.player:changeState('potidle')
                end
            end 
        end
    end

    -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end

    -- allow us to change into this state afresh if we swing within it, rapid swinging
    if love.keyboard.wasPressed('enter') then
        self.player:changeState('lift')
    end
end

function PlayerLiftState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    --
    -- debug for player and hurtbox collision rects VV
    --

    --[[love.graphics.setColor(255, 0, 255, 255)
    love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    love.graphics.rectangle('line', self.liftHitbox.x, self.liftHitbox.y,
     self.liftHitbox.width, self.liftHitbox.height)
    love.graphics.setColor(255, 255, 255, 255)]]--
end
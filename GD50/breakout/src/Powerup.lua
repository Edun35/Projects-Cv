Powerup = Class{}

function Powerup:init(type, x, y)
    self.x = x
    self.y = y

    self.width = 16
    self.height = 16

    self.dy = 30
    self.dx = 0

    self.type = type
    self.inplay = true
end

function Powerup:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end

    -- if the above aren't true, they're overlapping
    return true
end

function Powerup:update(dt)
  if self.y < VIRTUAL_HEIGHT then
    self.y = self.y + self.dy * dt
  end

end

function Powerup:render()
  if self.inplay then
    love.graphics.draw(gTextures['main'], gFrames['powerup'][self.type],
        self.x, self.y)
  end
end

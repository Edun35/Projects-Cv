--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class{}

function Tile:init(x, y, color, variety, shiny)
    
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety
    self.shiny =  shiny 
    self.shinytable = { rate = nil, opacity = 180/255}
end

function Tile:render(x, y)
    
    -- draw shadow
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)

    -- draw tile itself
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)  

    -- draw shiny
    if self.shiny then
        love.graphics.setColor(255, 255, 255, self.shinytable.opacity)
        love.graphics.rectangle('fill', (self.gridX - 1) * 32 + (VIRTUAL_WIDTH - 270),(self.gridY - 1) * 32 + 18, 24, 24, 4)
  
        --flashing
        if not self.shinytable.timer then
  
          self.shinytable.rate = Timer.tween(2,
          {
            [self.shinytable] = {opacity = 0 }
          })
          :finish(function()
            Timer.tween(2,
            {
              [self.shinytable] = {opacity = 180/255}
            })
            :finish(function()
              self.shinytable.rate = nil
            end)
          end)
  
        end
      end 
end
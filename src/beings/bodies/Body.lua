local Apply = require 'lib.apply'

local Body = class('Body'):include(Apply)

function Body:initialize(map, mx, my)
  self.senses = {}
  self.map = map
  self.x, self.y = map:toWorldCentered(mx, my)
  self.solid  = true
  self.walker = true
  self.class:addInstance(self)
end

function Body:destroy()
  self.class:removeInstance(self)
end

function Body:getPosition()
  return self.x, self.y
end

function Body:getContainingCell()
  return self.map:getCell(self.x, self.y)
end

function Body:update(wishes, dt)
  self:sense()
end

function Body:sense()
  self.senses.x = self.x
  self.senses.y = self.y
  self.senses.sight = {}
  Body:applyMethod('getPerceivedBy', self)
end

function Body:getPerceivedBy(perceiver)
  local x0,y0 = self.map:toGrid(perceiver.x, perceiver.y)
  local x1,y1 = self.map:toGrid(self.x, self.y)

  if self.map:los(x0,y0,x1,y1) then
    perceiver.senses.sight[self] = {x=self.x, y=self.y}
  end
end


return Body

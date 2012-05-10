local anim8      = require 'lib.anim8'

local Media      = require 'src.media'
local MobileBody = require 'src.beings.bodies.mobile_body'

local FlyerBody = class('FlyerBody', MobileBody)

local spriteW, spriteH = 32, 32

local function loadAnimations(self)
  self.image  = Media.images.sprite
  local g = anim8.newGrid(spriteW, spriteH, self.image:getWidth(), self.image:getHeight())
  self.animations = {
    fly = {
      up    = anim8.newAnimation('loop', g('2-9,1'), 0.08),
      right = anim8.newAnimation('loop', g('2-9,2'), 0.08),
      down  = anim8.newAnimation('loop', g('2-9,3'), 0.08),
      left  = anim8.newAnimation('loop', g('2-9,4'), 0.08)
    }
  }
end

function FlyerBody:initialize(map,x,y,speed)
  MobileBody.initialize(self, map,x,y,16,8)
  self.walker = false
  self.facing = "down"
  self.speed  = speed

  loadAnimations(self)
end

function FlyerBody:draw()
  local x, y = math.floor(self.x), math.floor(self.y)
  self:getCurrentAnimation():draw(self.image, x-spriteW/2, y-26)
end

function FlyerBody:getCurrentAnimation()
  return self.animations.fly[self.facing]
end

function FlyerBody:update(wishes, dt)
  MobileBody.update(self, wishes, dt)

  local prevFacing = self.facing

  self:prepareMove(wishes)

  local anim = self:getCurrentAnimation()
  if prevFacing == self.facing then
    anim:update(dt)
  else
    anim:gotoFrame(1)
  end

  self:move(dt)
end

return FlyerBody

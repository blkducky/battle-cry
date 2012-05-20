local camera   = require 'lib.camera'

local Player   = require 'src.beings.Player'
local Follower = require 'src.beings.Follower'
local Ptero    = require 'src.beings.Ptero'
local Being    = require 'src.beings.Being'
local Map      = require 'src.world.Map'

local Game = require 'src.game.Game'
local Play = Game:addState('Play')

local map
local player

function Play:enteredState()
  map    = Map:new()
  camera.setBoundary(map:getBoundary())
  player = Player:new(map, 100, 100)
  Follower:new(map, player.body, 580,450)
  Ptero:new(map, player.body, 300, 100)
end

function Play:exitedState()
  map, player = nil, nil
  Being:destroyAll()
end

function Play:draw()
  camera.draw(function()
    map:draw(camera.getViewport())
    Being:drawAll()
  end)
end

function Play:update(dt)
  Being:updateAll(dt)
  camera.lookAt(player.body.x, player.body.y)
end

function Play:escape()
  self:gotoState("MainMenu")
end

return Play

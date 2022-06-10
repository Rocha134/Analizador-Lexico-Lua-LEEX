
Player = Class{}

function Player:init()
    self.gridx = 5
    self.gridy = 9
    self.gridz = 1
    self.music1 = love.audio.newSource("sounds/8-Bit-Puzzler.mp3", "static")
    self.music2 = love.audio.newSource("sounds/Puzzle-Game_Looping.mp3", "static")
    self.music1:setLooping(true)
    self.music1:play()
    self.moveffect = love.audio.newSource("sounds/mover.wav", "static")
    self.moveffect:setVolume(0.2)
end


function Player:move(dx, dy, level)
    report = level:statusReport(player.gridx + dx, player.gridy + dy, player.gridz)
    if report == "free" then
        self.gridx = self.gridx + dx
        self.gridy = self.gridy + dy
        level.layout[self.gridx][self.gridy][self.gridz] = "main"
        level.layout[self.gridx - dx][self.gridy - dy][self.gridz] = "empty"
        self.moveffect:play()
    elseif report == "movable" then
        if level:push(player.gridx + dx, player.gridy + dy, player.gridz, dx, dy, 0) then
            self.gridx = self.gridx + dx
            self.gridy = self.gridy + dy
            level.layout[self.gridx][self.gridy][self.gridz] = "main"
            level.layout[self.gridx - dx][self.gridy - dy][self.gridz] = "empty"
            self.moveffect:play()
        end
    end
end

--function Player:render()
    --love.graphics.draw(self.model, VIRTUAL_WIDTH/2 + 21*(self.gridx-self.gridz) - 21*(self.gridy-self.gridz), 50 + 12*(self.gridx-self.gridz) + 12 *(self.gridy-self.gridz))
--end
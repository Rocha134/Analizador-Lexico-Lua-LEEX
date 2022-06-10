
Level = Class{}

require "Switch"

function Level:init(mapx, mapy, mapz)
    self.sprites= {
    main = love.graphics.newImage("graphics/isometric_pixel_0121.png"),
    floor = love.graphics.newImage("graphics/isometric_pixel_0087.png"),
    rock = love.graphics.newImage("graphics/isometric_pixel_0022.png"),
    wall = love.graphics.newImage("graphics/isometric_pixel_0025.png"),
    goal = love.graphics.newImage("graphics/isometric_pixel_0098.png"),
    switch = love.graphics.newImage("graphics/isometric_pixel_0021.png"),
    piston = love.graphics.newImage("graphics/isometric_pixel_0024.png")
    }
    self.layout = {}
    MAPXMAX = mapx
    MAPYMAX = mapy
    MAPZMAX = mapz
    self.switches = {}
    self.pistons = {}
    self.sounds = {}
end

function Level:newSwitch(x, y, z, key)
    for i = 1, 10 do
        if self.switches[i] == nil then
            self.switches[i] = Switch(x, y, z, key)
            break
        end
    end
end

function Level:newPiston(x, y, z, code)
    dx = 0
    dy = 0
    dz = 0
    --Code is in format dir/key, 2 each
    if code:sub(1, 1) == "+" then
        magnitude = 1
    elseif  code:sub(1, 1) == "-" then
        magnitude = -1
    end
    --Direction
    if code:sub(2, 2) == "x" then
        dx = magnitude
    elseif code:sub(2, 2) == "y" then
        dy = magnitude
    elseif code:sub(2, 2) == "z" then
        dz = magnitude
    end
    --Key
    key = code:sub(3, 4)

    for i = 1, 10 do
        if self.pistons[i] == nil then
            self.pistons[i] = Piston(x, y, z, dx, dy, dz, key)
            break
        end
    end
end

function Level:CheckSwitches(player)
    for i = 1, 10 do
        if self.switches[i] == nil then
            break
        end
        playerup = player.gridx == self.switches[i].x and player.gridy == self.switches[i].y and player.gridz == self.switches[i].z + 1
        if self.layout[self.switches[i].x][self.switches[i].y][self.switches[i].z + 1] ~= "empty" or playerup then
            self:ActivateSwitches(self.switches[i].key)
        else
            self:DeactivateSwitches(self.switches[i].key)
        end
    end
end

function Level:ActivateSwitches(key)
    for i = 1, 10 do
        if self.pistons[i] == nil then
            break
        end
        if self.pistons[i].key == key then
            if self:push(self.pistons[i].x, self.pistons[i].y, self.pistons[i].z, self.pistons[i].dx, self.pistons[i].dy, self.pistons[i].dz) then
                if self.layout[self.pistons[i].x][self.pistons[i].y][self.pistons[i].z + 1] == "rock" then
                    self.layout[self.pistons[i].x][self.pistons[i].y][self.pistons[i].z] = "rock"
                    self.layout[self.pistons[i].x][self.pistons[i].y][self.pistons[i].z + 1] = "empty"
                else
                    self.layout[self.pistons[i].x][self.pistons[i].y][self.pistons[i].z] = "empty"
                end
                self.layout[self.pistons[i].x + self.pistons[i].dx][self.pistons[i].y + self.pistons[i].dy][self.pistons[i].z + self.pistons[i].dz] = "piston"
            end
        end
    end
end

function Level:DeactivateSwitches(key)
    for i = 1, 10 do
        if self.pistons[i] == nil then
            break
        end
        if self.pistons[i].key == key then
            if self:push(self.pistons[i].x + self.pistons[i].dx, self.pistons[i].y + self.pistons[i].dy, self.pistons[i].z + self.pistons[i].dz, -self.pistons[i].dx, -self.pistons[i].dy, -self.pistons[i].dz) then
                if self.layout[self.pistons[i].x + self.pistons[i].dx][self.pistons[i].y + self.pistons[i].dy][self.pistons[i].z + self.pistons[i].dz + 1] == "rock" then
                    self.layout[self.pistons[i].x + self.pistons[i].dx][self.pistons[i].y + self.pistons[i].dy][self.pistons[i].z + self.pistons[i].dz] = "rock"
                    self.layout[self.pistons[i].x + self.pistons[i].dx][self.pistons[i].y + self.pistons[i].dy][self.pistons[i].z + self.pistons[i].dz + 1] = "empty"
                else
                    self.layout[self.pistons[i].x + self.pistons[i].dx][self.pistons[i].y + self.pistons[i].dy][self.pistons[i].z + self.pistons[i].dz] = "empty"
                end
                self.layout[self.pistons[i].x][self.pistons[i].y][self.pistons[i].z] = "piston"
            end
        end
    end
end


function Level:statusReport(x, y, z)
    if x >= 0 and x <= MAPXMAX and y >= 0 and y <= MAPYMAX and z >= 0 and z <= MAPZMAX then
        if self.layout[x][y][z] == "empty" and self.layout[x][y][z - 1] ~= "empty" then
            return "free"
        elseif self.layout[x][y][z] == "rock" then
            return "movable"
        elseif self.layout[x][y][z] == "empty" then
            return "usable"
        else
            return "no"
        end
    else
        return "no"
    end
end

function Level:push(x, y, z, dx, dy, dz)
    if self:statusReport(x + dx, y + dy, z + dz) == "free" then
        self.layout[x + dx][y + dy][z + dz] = self.layout[x][y][z]
        self.layout[x][y][z] = "empty"
        return true
    elseif self:statusReport(x + dx, y + dy, z + dz) == "movable" then
        if self:push(x + dx, y + dy, z + dz, dx, dy, dz) then
            self.layout[x + dx][y + dy][z + dz] = self.layout[x][y][z]
            self.layout[x][y][z] = "empty"
            return true
        else
            return false
        end
    elseif self:statusReport(x + dx, y + dy, z + dz) == "usable" then
        return true
    elseif self:statusReport(x + dx, y + dy, z + dz) == "no" then
        return false
    end        
end


function Level:render(player)
    for z = 0, MAPZMAX do
        for x = 0, MAPXMAX do
            for y = 0, MAPYMAX do
                if self.layout[x][y][z] ~= "empty" then
                    love.graphics.draw(self.sprites[self.layout[x][y][z]], VIRTUAL_WIDTH/2 + 21*(x-z) - 21*(y-z), 50 + 12*(x-z) + 12 *(y-z))
                end
                --if x == player.gridx and y == player.gridy and z == player.gridz then
                  --  player:render()
                --end
            end
        end
    end
end

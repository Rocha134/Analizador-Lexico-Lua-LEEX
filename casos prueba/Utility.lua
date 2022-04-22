
local ID_EMPTY = "e"
local ID_MAIN = "m"
local ID_FLOOR = "f"
local ID_WALL = "w"
local ID_ROCK = "r"
local ID_GOAL = "g"
local ID_SWITCH = "s"
local ID_PISTON = "p"
local ID_LINESKIP = "0"
local ID_PLANESKIP = "1"

require "Level"
require "Switch"
require "Piston"

function Convert(code, maxx, maxy, maxz, player)
    local alevel = Level(maxx, maxy, maxz)
    for x = 0, maxx do
        alevel.layout[x] = {}
        for y = 0, maxy do
            alevel.layout[x][y] = {}
            for z = 0, maxz do
                alevel.layout[x][y][z] = "empty"
            end
        end
    end
    tempx = 0
    tempy = 0
    tempz = 0
    for i = 1, #code do
        local c = code:sub(i, i)
        if c == ID_FLOOR then
            alevel.layout[tempx][tempy][tempz] = "floor"
            tempx = tempx + 1
        elseif c == ID_MAIN then
            alevel.layout[tempx][tempy][tempz] = "main"
            player.gridx = tempx
            player.gridy = tempy
            player.gridz = tempz
            tempx = tempx + 1
        elseif c == ID_WALL then
            alevel.layout[tempx][tempy][tempz] = "wall"
            tempx = tempx + 1
        elseif c == ID_ROCK then
            alevel.layout[tempx][tempy][tempz] = "rock"
            tempx = tempx + 1
        elseif c == ID_GOAL then
            alevel.layout[tempx][tempy][tempz] = "goal"
            tempx = tempx + 1 
        elseif c == ID_SWITCH then
            alevel.layout[tempx][tempy][tempz] = "switch"
            alevel:newSwitch(tempx, tempy, tempz, code:sub(i + 1, i + 2))
            tempx = tempx + 1
        elseif c == ID_PISTON then
            alevel.layout[tempx][tempy][tempz] = "piston"
            alevel:newPiston(tempx, tempy, tempz, code:sub(i + 1, i + 4))
            tempx = tempx + 1
        elseif c == ID_EMPTY then
            alevel.layout[tempx][tempy][tempz] = "empty"
            tempx = tempx + 1
        elseif c == ID_LINESKIP then
            tempy = tempy + 1
            tempx = 0
        elseif c == ID_PLANESKIP then
            tempx = 0
            tempy = 0
            tempz = tempz + 1
        end
    end
    return alevel
end
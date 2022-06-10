--Game made by Iker Guerrero on 06/10/2020 for CS50
Class = require "class"
push = require "push"

require "Level"
require "Player"
require "Utility"
require "levels"
require "Switch"

WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

VIRTUAL_WIDTH =  640
VIRTUAL_HEIGHT = 360

player = Player()

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')
    bigfont = love.graphics.newFont('font.ttf', 20)
    smallfont = love.graphics.newFont("font.ttf", 15)
    giantfont = love.graphics.newFont("font.ttf", 30)

    finished = false
    currentlevel = 1
    loadlevel(currentlevel)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = true,
        resizable = true,
        vsync = true
    })

    love.window.setTitle('Block')
end


function loadlevel(num)
    if num == 1 then
        level = Convert(LevelA1, 9, 9, 3, player)
    elseif num == 2 then
        level = Convert(LevelA2, 5, 7, 2, player)
    elseif num == 3 then
        level = Convert(LevelA3, 9, 9, 3, player)
    elseif num == 4 then
        level = Convert(LevelA4, 8, 8, 3, player)
    elseif num == 5 then
        level = Convert(LevelA5, 10, 11, 4, player)
    else
        level = Convert(Testlevel, 9, 9, 4, player)
        finished = true
    end
end

function love.update()
    if not finished then
        if hasWon()then
            currentlevel = currentlevel + 1
            loadlevel(currentlevel)
        end
    end
    level:CheckSwitches(player)
end

function hasWon()
    if level.layout[player.gridx][player.gridy][player.gridz - 1] == "goal" then
        return true
    else
        return false
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "up" or key == "w" then 
        player:move(-1, 0, level)
    elseif  key == "down" or key == "s" then 
        player:move(1, 0, level)
    elseif  key == "left" or key == "a" then 
        player:move(0, 1, level)
    elseif  key == "right" or key == "d" then 
        player:move(0, -1, level)
    elseif key == "r" then
        loadlevel(currentlevel)
    end

end


function love.draw()
    push:apply("start")
    switch1 = Switch(0,0,0,"Hola")
    if not finished then
        love.graphics.setFont(bigfont)
        love.graphics.print("Level " .. tostring(currentlevel), 45, 15)
        love.graphics.setFont(smallfont)
        love.graphics.print("Press R to restart", 10, 35)
    else
        love.graphics.setFont(giantfont)
        love.graphics.print("Thanks for playing", VIRTUAL_WIDTH/2 - 150, 100)
        love.graphics.setFont(smallfont)
        love.graphics.print("Press Esc to exit", VIRTUAL_WIDTH/2 - 80, 150)
    end
    level:render(player)

    push:apply("end")
end
Bullet = Object:extend()

local explosionSFX = love.audio.newSource("assets/audio/cannon_exp.mp3", "static")
explosionSFX:setVolume(0.2)


function Bullet:new(x, y)
    self.image = love.graphics.newImage("assets/cannon_ball.png")
    self.x = x
    self.y = y
    self.originalY = y
    self.speed = 250
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end



function Bullet:update(dt)
    -- Moves bullet up or down depending on the original Y position, need to adjust tho   
    if self.originalY > 300 then
        self.y = self.y - self.speed * dt
    else
        self.y = self.y + self.speed * dt
    end
    

    --Remove bullet when it exits the screen
    if self.y > love.graphics.getHeight() then
        self.dead = true
    elseif self.y < 0 then
        self.dead = true
    end
end

function Bullet:draw()
    love.graphics.draw(self.image, self.x, self.y)
end
--obj = enemy, obj2 = player
function Bullet:checkCollision(obj, obj2)
    local self_left = self.x
    local self_right = self.x + self.width
    local self_top = self.y
    local self_bottom = self.y +self.height

    local obj_left = obj.x
    local obj_right = obj.x + obj.width
    local obj_top = obj.y
    local obj_bottom = obj.y + obj.height

    local obj_left2 = obj2.x
    local obj_right2 = obj2.x + obj2.width
    local obj_top2 = obj2.y
    local obj_bottom2 = obj2.y + obj2.height

    if self_right > obj_left
    and self_left < obj_right
    and self_bottom > obj_top
    and self_top < obj_bottom then
        explosionSFX:play()
        Enemydmg = Enemydmg + 1
        self.dead = true
    end

    if self_right > obj_left2
    and self_left < obj_right2
    and self_bottom > obj_top2
    and self_top < obj_bottom2 then
        explosionSFX:play()
        Playerdmg = Playerdmg + 1
        self.dead = true
    end
end

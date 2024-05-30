Enemy = Object:extend()

function Enemy:new()
    self.image = love.graphics.newImage("assets/enemy/enemy_ship1.png")
    self.x = 325
    self.y = 500
    self.speed = 100
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function Enemy:update(dt)
    self.x = self.x + self.speed *dt

    local window_width = love.graphics.getWidth()

    if self.x < 0 then
        self.x = 0
        self.speed = -self.speed
    elseif self.x + self.width > window_width then
        self.x = window_width - self.width
        self.speed = -self.speed
    end
end

function Enemy:draw()
    if Enemydmg < 2 then
        love.graphics.draw(self.image, self.x, self.y)
    elseif Enemydmg >= 2 and Enemydmg < 5 then
        love.graphics.draw(love.graphics.newImage("assets/enemy/enemy_ship2.png"), self.x, self.y)
    elseif Enemydmg >= 5 and Enemydmg < 10 then
        love.graphics.draw(love.graphics.newImage("assets/enemy/enemy_ship3.png"), self.x, self.y)
    elseif Enemydmg == 10 then
        love.graphics.draw(love.graphics.newImage("assets/enemy/enemy_ship4.png"), self.x, self.y)
    end

    local window_width = love.graphics.getWidth()

    if self.x < 0 then
        self.x = 0
    elseif self.x + self.width > window_width then
        self.x = window_width - self.width
    end
end

function Enemy:fire()
    local cannonSFX = love.audio.newSource("assets/audio/cannonball.mp3", "static")
    cannonSFX:setVolume(0.4)
    cannonSFX:play()
    table.insert(listOfBullets, Bullet(self.x + (self.width / 2), self.y - self.height))
end

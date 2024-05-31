Player = Object:extend()

function Player:new()
    self.image = love.graphics.newImage("assets/player/player_ship1.png")
    self.x = 320
    self.y = 200
    self.speed = 150
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function Player:update(dt)
    if love.keyboard.isDown("a") then
        self.x = self.x - self.speed * dt
    elseif love.keyboard.isDown("d") then
        self.x = self.x + self.speed * dt
    elseif love.keyboard.isDown("w") then
        self.y = self.y - self.speed * dt
    elseif love.keyboard.isDown("s") then
        self.y = self.y + self.speed * dt
    end

    local window_width = love.graphics.getWidth()

    if self.y < 0 then
        self.y = 0
    elseif self.y >= 320 then
        self.y = 320
    end

    if self.x <=0 then 
        self.x = 0
    elseif self.x >= window_width - self.width then
        self.x = window_width - self.width
    end

end

function Player:draw()
    if Playerdmg < 2 then
        love.graphics.draw(self.image, self.x, self.y)
    elseif Playerdmg >= 2 and Playerdmg < 5 then
        love.graphics.draw(love.graphics.newImage("assets/player/player_ship2.png"), self.x, self.y)
    elseif Playerdmg >= 5 and Playerdmg < 10 then
        love.graphics.draw(love.graphics.newImage("assets/player/player_ship3.png"), self.x, self.y)
    elseif Playerdmg == 10 then
        love.graphics.draw(love.graphics.newImage("assets/player/player_ship4.png"), self.x, self.y)
    end
end

function Player:keyPressed(key)
    local cannonSFX = love.audio.newSource("assets/audio/cannonball.mp3", "static")
    cannonSFX:setVolume(0.4)
	if key == "space" then
        cannonSFX:play()
		table.insert(listOfBullets, Bullet(self.x + (self.width / 2), self.y + self.height))
	end
end
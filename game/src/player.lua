Player = Object:extend()

function Player:new()
    self.image = love.graphics.newImage("assets/player_ship1.png")
    self.x = 320
    self.y = 200
    self.speed = 200
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function Player:update(dt)
    if love.keyboard.isDown("left") then
        self.x = self.x - self.speed * dt
    elseif love.keyboard.isDown("right") then
        self.x = self.x + self.speed * dt
    elseif love.keyboard.isDown("up") then
        self.y = self.y - self.speed * dt
    elseif love.keyboard.isDown("down") then
        self.y = self.y + self.speed * dt
    end

    local window_height = love.graphics.getWidth()

    if self.y < 0 then
        self.y = 0
    elseif self.y + self.width > window_height then
        self.y = window_height - self.width
    end


end

function Player:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Player:keyPressed(key)
	if key == "space" then
		table.insert(listOfBullets, Bullet(self.x, self.y))
	end
end
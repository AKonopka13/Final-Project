Items = Object:extend()

--make table of images for Items to pull from randomly
local items_list = {
    love.graphics.newImage("assets/items/dinghy.png"), love.graphics.newImage("assets/items/wood.png"), 
    love.graphics.newImage("assets/items/barrel1.png"), love.graphics.newImage("assets/items/barrel2.png"),
    love.graphics.newImage("assets/items/bomb.png"), love.graphics.newImage("assets/items/chest1.png"), 
    love.graphics.newImage("assets/items/dinghy2.png")}
--New items
function Items:new()
    self.image = items_list[love.math.random(1, #items_list)]
    self.x = love.graphics.getWidth()
    self.y = love.math.random(0, love.graphics.getHeight())
    self.speed = 100
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function Items:update(dt)
    self.x = self.x - self.speed * dt

    -- when item exits screen reset
    if self.x < 0 then
        self.dead = true
    end
end

function Items:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Items:checkCollision(obj)
    local self_left = self.x
    local self_right = self.x + self.width
    local self_top = self.y
    local self_bottom = self.y +self.height

    local obj_left = obj.x
    local obj_right = obj.x + obj.width
    local obj_top = obj.y
    local obj_bottom = obj.y + obj.height

    if self_right > obj_left
    and self_left < obj_right
    and self_bottom > obj_top
    and self_top < obj_bottom then
        Playerdmg = Playerdmg + 1
        self.dead = true 
    end
end

function Items:spawnItem()
    table.insert(listOfItems, Items(self.x, self.y))
end

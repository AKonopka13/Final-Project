local IS_DEBUG = os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" and arg[2] == "debug"
if IS_DEBUG then
	require("lldebugger").start()

	function love.errorhandler(msg)
		error(msg, 2)
	end
end
--Globals
listOfBullets ={}
listOfItems = {}
Playerdmg = 0
Enemydmg = 0
--Locals
local background
local background_scroll
local background_x
local player
local enemy
local items
local timer = 0
local player_timer = 0
local enemy_timer = 0

function love.load()
	--Requires Here
	Object = require "lib.classic"
	require "src.player"
	require "src.enemy"
	require "src.bullet"
	require "src.items"

	--Background 
	background = love.graphics.newImage("assets/background.jpg")
	background_scroll = 100
	background_x = 0

	--Classes
	player = Player()
	enemy = Enemy()
	items = Items()
	listOfBullets = {}
	listOfItems = {}

end

function love.update(dt)
	--item timer 
	timer = timer + dt
	--Relod timers
	player_timer = player_timer + dt
	enemy_timer = enemy_timer + dt
	--Update background scrolling
	background_x = background_x - background_scroll * dt
	if background_x + love.graphics.getWidth() < 0 then
		background_x = background_x + love.graphics.getWidth()
	end
	--Update Player and Enemy
	player:update(dt)
	enemy:update(dt)
	--Enemy fire
	if enemy_timer > 7 then
		enemy:fire()
		enemy_timer = 0
	end
	-- Update Items
	if timer > 5 then
		items:spawnItem()
		timer = 0
	end
	for i,v in ipairs(listOfItems) do
		v:update(dt)
		v:checkCollision(player)

		if v.dead then
			table.remove(listOfItems, i)
		end
	end
	--Update Bullets
	for i,v in ipairs(listOfBullets) do
		v:update(dt)
		v:checkCollision(enemy, player)
		
		if v.dead then
			table.remove(listOfBullets, i)
		end
	end
end

function love.draw()
	--Draw 2 backgrounds for scrolling effect
	love.graphics.draw(background, background_x, 0)
	love.graphics.draw(background, background_x + love.graphics.getWidth(), 0)
	-- Draw Player and Enemy
	player:draw()
	enemy:draw()
	--Draw Bullets
	for i,v in ipairs(listOfBullets) do
		v:draw()
	end
	--Draw Items
	for i,v in ipairs(listOfItems) do
		v:draw()
	end
	

	-- Debugging	
	love.graphics.print("Player Coordinates: (" .. math.floor(player.x) .. ", " .. math.floor(player.y) .. ")", 10, 10) 
	love.graphics.print("Timer:" .. timer, 25, 25)
	love.graphics.print("Player Timer:" .. player_timer, 25, 40)
	love.graphics.print("Enemy Timer:" .. enemy_timer, 25, 55)
end

function love.keypressed(key)
	if player_timer > 5 then
		player:keyPressed(key)
		player_timer = 0
	end
end





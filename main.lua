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
local song = love.audio.newSource("assets/audio/background_music.mp3", "stream")
song:setLooping(true)
song:setVolume(0.5)

local backgroundSFX = love.audio.newSource("assets/audio/sea_waves.mp3", "stream")
backgroundSFX:setLooping(true)
backgroundSFX:setVolume(0.1)

local font = love.graphics.newFont("assets/TradeWinds-Regular.ttf", 25)
local background = love.graphics.newImage("assets/background.jpg")
local menu_background = love.graphics.newImage("assets/menu_background.jpg")
local background_scroll = 100
local background_x = 0
local timer = 0
local player_timer = 0
local enemy_timer = 0
local MAXSCORE = 10
--Classes
local player
local game
local enemy
local items
--Functions
local restart
local menu
local gameOver

function love.load()
	song:play()
	backgroundSFX:play()
	--Requires Here
	Object = require "lib.classic"
	require "src.player"
	require "src.enemy"
	require "src.bullet"
	require "src.items"
	require "src.gamestate"
	
	--Classes
	game = Game()
	player = Player()
	enemy = Enemy()
	items = Items()
	listOfBullets = {}
	listOfItems = {}

end

function love.update(dt)
	if game.state.running then
		--Timers 
		timer = timer + dt
		player_timer = player_timer + dt
		if player_timer > 5 then
			player_timer = 5
		end
		enemy_timer = enemy_timer + dt
		--Update background scrolling
		background_x = background_x - background_scroll * dt
		if background_x + love.graphics.getWidth() < 0 then
			background_x = background_x + love.graphics.getWidth()
		end
	
		player:update(dt)
		enemy:update(dt)
		--Enemy reload
		if enemy_timer > 7 then
			enemy:fire()
			enemy_timer = 0
		end
		-- Item Spawner
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
		--Check for gameover
		if gameOver() then
			gameOver()
		end
	end
end

function love.draw()
	love.graphics.setFont(font)
	local fireimg = love.graphics.newImage("assets/fire.png")
	local fireimg2 = love.graphics.newImage("assets/fire2.png")
	if game.state.running then
		love.graphics.draw(background, background_x, 0)
		love.graphics.draw(background, background_x + love.graphics.getWidth(), 0)
		love.graphics.draw(fireimg2, 40, 40)

		if player_timer == 5 then
			love.graphics.draw(fireimg, 40, 40)
			love.graphics.setColor(0, 0, 0)
				love.graphics.print("FIRE!", 40, 120)
			love.graphics.setColor(1, 1, 1)
		end
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
		--love.graphics.print("Timer:" .. timer, 25, 25)
		--love.graphics.print("Player Timer:" .. player_timer, 25, 40)
		--love.graphics.print("Enemy Timer:" .. enemy_timer, 25, 55)
	elseif game.state.menu then
		backgroundSFX:pause()
		menu()
	end

	if gameOver() then
		backgroundSFX:pause()
		gameOver()
	end
end

function love.keypressed(key)
	if game.state.running then
		if key == "space" then
			if player_timer >= 5 then
				player:keyPressed(key)
				player_timer = 0
			end
		end	
		if key == "escape" then
			backgroundSFX:pause()
			game:changeGameState("menu")
		end
	elseif game.state.menu then
		if key == "space" then
			game:changeGameState("running")
			backgroundSFX:play()
		end
		if key == "escape" then
			love.event.quit()
		end
	end
	if game.state.gameover then
		if key == "space" then
			restart()
		elseif key == "escape" then
			love.event.quit()
		end
	end
end

function menu()
	song:setVolume(0.2)

	love.graphics.draw(menu_background, 0, 0)
	love.graphics.setColor(0, 0, 0)
		love.graphics.print("Controls", love.graphics.getWidth()/2 - 100, love.graphics.getHeight()/4 - 35)
		love.graphics.print("Movement: WASD\nFire: SPACE\nPause: ESCAPE", love.graphics.getWidth()/3 , love.graphics.getHeight()/4)
		love.graphics.print("Press Space to start\nPress Escape to quit", love.graphics.getWidth()/ 3, love.graphics.getHeight()/4 + 250)
	love.graphics.setColor(1, 1, 1)
end

function gameOver()
	local player_score = Enemydmg
	local enemy_score = Playerdmg
	
	if player_score == MAXSCORE or enemy_score == MAXSCORE then
		local player_ship = love.graphics.newImage("assets/player/player_ship1.png")
		local enemy_ship = love.graphics.newImage("assets/enemy/enemy_ship1.png")
		local shipX = player_ship:getWidth()

		love.graphics.draw(menu_background, 0, 0)
		love.graphics.draw(player_ship, love.graphics.getWidth()/2 - 100 - (shipX / 2), love.graphics.getHeight()/4 + 100)
		love.graphics.draw(enemy_ship, love.graphics.getWidth()/2 + 100 - (shipX / 2), love.graphics.getHeight()/4 + 100)
		love.graphics.setColor(0, 0, 0)
		if player_score == MAXSCORE then
			love.graphics.print("WINNER", love.graphics.getWidth()/2 - 50, love.graphics.getHeight()/4)
			love.graphics.print(player_score, love.graphics.getWidth()/2 - 100, love.graphics.getHeight()/4 + 50)
			love.graphics.print(enemy_score, love.graphics.getWidth()/2 + 100, love.graphics.getHeight()/4 + 50)
			love.graphics.print("Press Space to restart", love.graphics.getWidth()/3, love.graphics.getHeight()/4 + 250)
			love.graphics.print("Press Escape to quit", love.graphics.getWidth()/3, love.graphics.getHeight()/4 + 300)
		elseif enemy_score == MAXSCORE then
			love.graphics.print("SUNK", love.graphics.getWidth()/2 - 50, love.graphics.getHeight()/4)
			love.graphics.print(player_score, love.graphics.getWidth()/2 - 100, love.graphics.getHeight()/4 + 50)
			love.graphics.print(enemy_score, love.graphics.getWidth()/2 + 100, love.graphics.getHeight()/4 + 50)
			love.graphics.print("Press Space to restart", love.graphics.getWidth()/3, love.graphics.getHeight()/4 + 250)
			love.graphics.print("Press Escape to quit", love.graphics.getWidth()/3, love.graphics.getHeight()/4 + 300)	
		end
		love.graphics.setColor(1, 1, 1)
		game:changeGameState("gameover")
		return true
		else
		return false
	end
end

function restart()
	Playerdmg, Enemydmg = 0, 0
	timer, player_timer, enemy_timer = 0, 0, 0
	love.load()
	game:changeGameState("running")
end




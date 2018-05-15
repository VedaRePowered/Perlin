local player = {}
local players = {}
local currentPlayer = ""

function player.movePlayer(delta)

	local sneek, run, jump, left, right = input.getPlayerInput()
	local playerX, playerY = player.getPlayerPos()
	local playerVX, playerVY = player.getPlayerVelocity()

	local speed = 100
	local maxSpeed = 20
	local deceliration = 100

	if sneek then
		speed = 100
		maxSpeed = 5
	elseif run then
		speed = 50
		maxSpeed = 40
	end

	if left and not right then
		playerVX = playerVY - speed * delta
	elseif right and not left then
		playerVX = playerVY + speed * delta
	else
		if playerVX > 0 then
			playerVX = playerVX - deceliration * delta
		end
		if playerVX < 0 then
			playerVX = playerVX + deceliration * delta
		end
	end

	if playerVX > maxSpeed then
		playerVX = maxSpeed
	end
	if playerVX < maxSpeed*-1 then
		playerVX = maxSpeed*-1
	end

	playerX = playerX + playerVX

	player.setVelocity(playerVX, playerVY)
	player.playerGoTo(playerX, playerY)

end

function player.getCurrentPlayer()
	return currentPlayer
end

function player.setCurrentPlayer(name)
	if players[name] then
		currentPlayer = name
	else
		misc.warning("attempt to switch surrent player to \'" .. name .. "\' whitch does not exist")
	end
end

function player.newPlayer(name)
	local player = {
		id = #players + 1,
		name = misc.generateName(2),
		x = 0,
		y = 0,
		vx = 0,
		vy = 0
	}
	if name then
		players[name] = player
		players[name]["name"] = name
	else
		players[player.id] = player
	end
end

function player.playerGoTo(x, y)
	if players[currentPlayer] then
		players[currentPlayer]["x"], players[currentPlayer]["y"] = x, y
	else
		misc.warning("attempt to move non-existent player \'" .. currentPlayer .. "\'")
	end
end

function player.setVelocity(x, y)
	if players[currentPlayer] then
		players[currentPlayer]["vx"], players[currentPlayer]["vy"] = x, y
	else
		misc.warning("attempt to set the velocity of non-existent player \'" .. currentPlayer .. "\'")
	end
end

function player.getPlayerPos()
	local x, y = 0, 0
	if players[currentPlayer] then
		x, y = players[currentPlayer]["x"], players[currentPlayer]["y"]
	else
		misc.warning("attempt to get position of non-existent player \'" .. currentPlayer .. "\', returning x:0 y:0")
	end
	return x, y
end

function player.getPlayerVelocity()
	local vx, vy = 0, 0
	if players[currentPlayer] then
		vx, vy = players[currentPlayer]["vx"], players[currentPlayer]["vy"]
	else
		misc.warning("attempt to get velocity of non-existent player \'" .. currentPlayer .. "\', returning vx:0 vy:0")
	end
	return vx, vy
end

return player

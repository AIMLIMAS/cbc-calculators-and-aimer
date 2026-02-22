--Takes Data
file = io.open("cannondata.txt","r")

cx = file:read("l")
cy = file:read("l")
cz = file:read("l")
space = file:read("l")
tx = file:read("l")
ty = file:read("l")
tz = file:read("l")
space = file:read("l")
gp = file:read("l")
gy = file:read("l")
space = file:read("l")
face = file:read("l")

--convert data
cx = tonumber(cx)
cy = tonumber(cy)
cz = tonumber(cz)
tx = tonumber(tx)
ty = tonumber(ty)
tz = tonumber(tz)
gp = tostring(gp)
gy = tostring(gy)

if cx ~= nil and cy ~= nil and cz ~= nil then
    print("Cannon Position is avail")
    capos = true
else
    print("Cannon Position Unavail")
    capos = false
end
-------------------------------------------------------
local pitchcon = peripheral.wrap(gp)
local yawcon = peripheral.wrap(gy)

local rad = math.rad
local deg = math.deg
local atan2 = math.atan2
local sqrt = math.sqrt

-- CONFIG
local GRAVITY = 0.23   -- BULLET GRAVITY
local PROJECTILE_SPEED = 50  -- PROJECTILE SPEED

-- Get coordinates
function getCPos()
    print("Cannon X:")
    cx = tonumber(io.read())

    print("Cannon Y:")
    cy = tonumber(io.read())

    print("Cannon Z:")
    cz = tonumber(io.read())
end

if capos == true then
    print("Using Cannon Data")
else
    getCPos()
end

print("Target Position new/old")
oandn = io.read()
oandn = string.lower(oandn)

function getTPos()
    print("Target X:")
    tx = io.read()

    print("Target Y:")
    ty = io.read()

    print("Target Z:")
    tz = io.read()

    print("Direction n/s/e/w")
    face = io.read()
end

if oandn == "new" then
    getTPos()
elseif oandn == "old" then
    print("Using old Target Pos")
else
    error("JUST FUCKING CHOOSE")
end

-- delta x, delta y, and delta z
dx = tx - cx
dy = ty - cy
dz = tz - cz

-- horizontal distance
local horizontal_distance = sqrt(dx^2 + dz^2)

-- YAW (horizontal rotation)
local yaw = deg(atan2(dz, dx))

-- PITCH (vertical angle using projectile formula)
local v = PROJECTILE_SPEED
local g = GRAVITY
local d = horizontal_distance
local h = dy

-- rumus persamaan balistik
local inside = v^4 - g * (g * d^2 + 2 * h * v^2)

if inside < 0 then
    print("Target unreachable")
    return
end

local root = sqrt(inside)

-- 2 different pitch(Low Arc & High Arc)
local pitch_low = deg(math.atan((v^2 - root) / (g * d)))
local pitch_high = deg(math.atan((v^2 + root) / (g * d)))

if pitch_high > 45 then
    pitch_high_com = "TO SHORT"
elseif pitch_high < 20 then
    pitch_high_com = "USE LOW ARC INSTEAD"
else
    pitch_high_com = "UNREACHABLE"
end

-- Output
print("===== SOLUTION =====")
print("Yaw:", yaw)
print("Low Arc Pitch:", pitch_low)
print("(HIGHLY ON EXPERIMENTAL)High Arc Pitch:", pitch_high, " ", pitch_high_com)

-- Calculate yaw

if face == "n" then
    yaw = yaw + 90
elseif face == "s" then
    yaw = yaw - 90
elseif face == "e" then
    yaw = yaw - 0
elseif face == "w" then
    yaw = yaw - 180
else
    error("not a valid direction")
end

-- calculate shot
pitchlow = pitch_low * 13.8
yawc = yaw * 7.7
print(pitchlow)

if yaw >= 0 then
    xrot = 0 - 1
else
    xrot = 0 + 1
end

if pitch_low >= 0 then
    yrot = 0 + 1
else
    yrot = 0 - 1
end
--2 sec pause
sleep(2)
-- cannon aimed
pitchcon.rotate(pitchlow,yrot)
yawcon.rotate(yawc,xrot)

-- Input to make it go back to original position
while redstone.getInput("right") == false do
    sleep(0.3)
    if redstone.getInput("right") == true then
        print("ending operation")
        pitchcon.rotate(pitchlow,-yrot)
        yawcon.rotate(yawc,-xrot)
    end
end

outfile = io.open("cannondata", "w+")

outfile:write(cx)
outfile:write("\n")
outfile:write(cy)
outfile:write("\n")
outfile:write(cz)
outfile:write("\n")
outfile:write("\n")
outfile:write(tx)
outfile:write("\n")
outfile:write(ty)
outfile:write("\n")
outfile:write(tz)
outfile:write("\n")
outfile:write("\n")
outfile:write(gp)
outfile:write("\n")
outfile:write(gy)
outfile:write("\n")
outfile:write("\n")
outfile:write(face)

outfile:close()

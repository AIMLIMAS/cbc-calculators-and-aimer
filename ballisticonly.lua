-- Simple Ballistic Calculator (Clean Version)

local rad = math.rad
local deg = math.deg
local atan2 = math.atan2
local sqrt = math.sqrt

-- CONFIG (change if needed)
local GRAVITY = 0.05   -- game gravity
local PROJECTILE_SPEED = 50  -- initial speed

-- Get coordinates
print("Cannon X:")
local cx = tonumber(io.read())

print("Cannon Y:")
local cy = tonumber(io.read())

print("Cannon Z:")
local cz = tonumber(io.read())

print("Target X:")
local tx = tonumber(io.read())

print("Target Y:")
local ty = tonumber(io.read())

print("Target Z:")
local tz = tonumber(io.read())

-- Calculate differences
local dx = tx - cx
local dy = ty - cy
local dz = tz - cz

-- Horizontal distance
local horizontal_distance = sqrt(dx^2 + dz^2)

-- YAW (horizontal rotation)
local yaw = deg(atan2(dz, dx))

-- PITCH (vertical angle using projectile formula)
local v = PROJECTILE_SPEED
local g = GRAVITY
local d = horizontal_distance
local h = dy

-- Ballistic equation
local inside = v^4 - g * (g * d^2 + 2 * h * v^2)

if inside < 0 then
    print("Target unreachable")
    return
end

local root = sqrt(inside)

-- Two possible angles (low arc & high arc)
local pitch_low = deg(math.atan((v^2 - root) / (g * d)))
local pitch_high = deg(math.atan((v^2 + root) / (g * d)))

-- Output
print("===== SOLUTION =====")
print("Yaw:", yaw)
print("Low Arc Pitch:", pitch_low)
print("High Arc Pitch:", pitch_high)
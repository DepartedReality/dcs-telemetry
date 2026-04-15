-- DRSM Telemetry — Core module
-- Collects: acceleration, angular velocity, velocity, orientation,
--           altitude (AGL + MSL), true airspeed, model time.

local M = {}

function M.collect(aircraft_name, ac_data)
    local r = {}

    -- Acceleration (body-frame G forces)
    local acc = Export.LoGetAccelerationUnits()
    if acc then
        r.acc = { acc.z, acc.x, acc.y }
    end

    -- Angular velocity (body-frame rad/s)
    local ang = Export.LoGetAngularVelocity()
    if ang then
        r.ang_vel = { ang.z, ang.x, ang.y }
    end

    -- Velocity (global frame m/s — Python converts to local)
    local vel = Export.LoGetVectorVelocity()
    if vel then
        r.vel = { vel.z, vel.x, vel.y }
    end

    -- Orientation (radians, already converted to DRSM convention)
    local pitch, bank, yaw = Export.LoGetADIPitchBankYaw()
    if pitch then
        r.pitch = pitch
        r.roll  = bank
        r.yaw   = -yaw   -- negate for DRSM convention
    end

    -- Altitude AGL (metres)
    local alt = Export.LoGetAltitudeAboveGroundLevel()
    if alt then r.alt_agl = alt end

    -- Altitude MSL (metres) — from self-data
    local obj = Export.LoGetSelfData()
    if obj and obj.LatLongAlt then
        r.alt_msl = obj.LatLongAlt.Alt or 0
    end

    -- True airspeed (m/s)
    local tas = Export.LoGetTrueAirSpeed()
    if tas then r.tas = tas end

    -- Model / simulation time
    r.t = Export.LoGetModelTime()

    return r
end

return M

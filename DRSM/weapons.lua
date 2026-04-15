-- DRSM Telemetry — Weapons module
-- Collects: cumulative counters for cannon rounds fired, weapon releases
--           (missiles, bombs, rockets), and flare/chaff releases.
-- Detection method: track previous-frame counts; decrease = release event,
--           then increment cumulative counters sent to DRSM.

local M = {}

-- Per-frame state (persists across frames, reset on sim start/stop)
local prev_shells       = nil
local prev_flares       = nil
local prev_chaff        = nil
local prev_stations     = {}   -- [station_idx] = { level1 = int, count = int }

-- Cumulative release counters (reset on sim start/stop)
local cannon_rounds_fired = 0
local missiles_released = 0
local bombs_released    = 0
local rockets_released  = 0
local flares_released   = 0
local chaff_released_total = 0

function M.reset()
    prev_shells   = nil
    prev_flares   = nil
    prev_chaff    = nil
    prev_stations = {}
    cannon_rounds_fired = 0
    missiles_released  = 0
    bombs_released     = 0
    rockets_released   = 0
    flares_released    = 0
    chaff_released_total = 0
end

function M.collect(aircraft_name, ac_data)
    local r = {}

    -- ----------------------------------------------------------------
    -- Cannon tracking → cumulative counter
    -- ----------------------------------------------------------------
    local payload = Export.LoGetPayloadInfo()
    if payload then
        -- Sum shells across all cannons
        local shells = 0
        if payload.Cannon then
            for _, cannon in pairs(payload.Cannon) do
                shells = shells + (cannon.shells or 0)
            end
        end
        if prev_shells and shells < prev_shells then
            cannon_rounds_fired = cannon_rounds_fired + (prev_shells - shells)
        end
        prev_shells = shells
        r.cannon_rounds_fired = cannon_rounds_fired

        -- -----------------------------------------------------------------
        -- Weapon station release detection → cumulative counters
        -- level1: 1 = Missile, 2 = Bomb, 3 = NURS (Rocket), 4 = Gun pod
        -- -----------------------------------------------------------------
        local cur_stations = {}
        if payload.Stations then
            for idx, station in pairs(payload.Stations) do
                local w = station.weapon
                local cnt = station.count or 0
                if w and cnt > 0 then
                    cur_stations[idx] = { level1 = w.level1 or 0, count = cnt }
                end
            end
        end
        -- Compare to previous frame and increment cumulative counters
        for idx, prev in pairs(prev_stations) do
            local cur = cur_stations[idx]
            if not cur or cur.count < prev.count then
                local delta = prev.count - (cur and cur.count or 0)
                local wtype = prev.level1
                if     wtype == 1 then missiles_released = missiles_released + delta
                elseif wtype == 2 then bombs_released    = bombs_released + delta
                elseif wtype == 3 then rockets_released  = rockets_released + delta
                else                    missiles_released = missiles_released + delta  -- fallback
                end
            end
        end
        prev_stations = cur_stations
        r.missiles_released = missiles_released
        r.bombs_released    = bombs_released
        r.rockets_released  = rockets_released
    end

    -- ----------------------------------------------------------------
    -- Flare / chaff tracking → cumulative counters
    -- ----------------------------------------------------------------
    local snares = Export.LoGetSnares()
    if snares then
        local flares = snares.flare or 0
        local chaff  = snares.chaff or 0
        if prev_flares and flares < prev_flares then
            flares_released = flares_released + (prev_flares - flares)
        end
        if prev_chaff and chaff < prev_chaff then
            chaff_released_total = chaff_released_total + (prev_chaff - chaff)
        end
        prev_flares = flares
        prev_chaff  = chaff
        r.flares_released = flares_released
        r.chaff_released  = chaff_released_total
    end

    return r
end

return M

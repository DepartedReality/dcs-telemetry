-- DRSM Telemetry — Gear module
-- Collects: per-gear landing gear positions [left, nose, right] 0–1
--           via external-model draw arguments.

local M = {}

-- Default draw-arg indices: left main, nose, right main
-- Override per-aircraft in aircraft_data.lua via gear_args = {L, N, R}
local DEFAULT_GEAR_ARGS = { 4, 1, 6 }

function M.collect(aircraft_name, ac_data)
    local r = {}
    local args = ac_data.gear_args or DEFAULT_GEAR_ARGS

    local left  = Export.LoGetAircraftDrawArgumentValue(args[1])
    local nose  = Export.LoGetAircraftDrawArgumentValue(args[2])
    local right = Export.LoGetAircraftDrawArgumentValue(args[3])

    if left or nose or right then
        r.gear_left  = left  or 0
        r.gear_nose  = nose  or 0
        r.gear_right = right or 0
    end

    return r
end

return M

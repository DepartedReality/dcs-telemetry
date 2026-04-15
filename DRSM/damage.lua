-- DRSM Telemetry — Damage module
-- Collects: cumulative structural damage (sum of draw-arg values).
-- Each aircraft defines its damage_vars in aircraft_data.lua.

local M = {}

function M.reset()
end

function M.collect(aircraft_name, ac_data)
    local r = {}
    local vars = ac_data.damage_vars
    if not vars or #vars == 0 then
        return r
    end

    -- Sum all damage draw-arg values (0.0 = intact, 1.0 = destroyed)
    local total = 0
    for i = 1, #vars do
        local val = Export.LoGetAircraftDrawArgumentValue(vars[i])
        if val then total = total + val end
    end
    r.damage_total = total

    return r
end

return M

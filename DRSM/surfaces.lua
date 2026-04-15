-- DRSM Telemetry — Surfaces module
-- Collects: flaps, speedbrakes, canopy, overall landing gear (from LoGetMechInfo),
--           afterburner L/R (draw args 28/29).

local M = {}

function M.collect(aircraft_name, ac_data)
    local r = {}

    -- Mechanical info (flaps, gear total, speedbrakes, canopy)
    local mech = Export.LoGetMechInfo()
    if mech then
        if mech.flaps       then r.flaps       = mech.flaps.value       or 0 end
        if mech.speedbrakes  then r.speedbrakes  = mech.speedbrakes.value  or 0 end
        if mech.canopy       then r.canopy       = mech.canopy.value       or 0 end
        if mech.gear         then r.gear         = mech.gear.value         or 0 end
    end

    -- Afterburner L/R (draw arguments 28 = left, 29 = right, range 0–1)
    local ab_l = Export.LoGetAircraftDrawArgumentValue(28)
    local ab_r = Export.LoGetAircraftDrawArgumentValue(29)
    if ab_l or ab_r then
        r.afterburner = { ab_l or 0, ab_r or 0 }
    end

    return r
end

return M

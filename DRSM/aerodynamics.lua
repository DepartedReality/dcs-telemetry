-- DRSM Telemetry — Aerodynamics module
-- Collects: AOA, sideslip, IAS, Mach, wind, stall warning, shake amplitude.

local M = {}

function M.collect(aircraft_name, ac_data)
    local r = {}

    -- Angle of attack (radians)
    local aoa = Export.LoGetAngleOfAttack()
    if aoa then r.aoa = aoa end

    -- Angle of sideslip (radians)
    local aos = Export.LoGetAngleOfSideSlip()
    if aos then r.aos = aos end

    -- Indicated airspeed (m/s)
    local ias = Export.LoGetIndicatedAirSpeed()
    if ias then r.ias = ias end

    -- Mach number
    local mach = Export.LoGetMachNumber()
    if mach then r.mach = mach end

    -- Wind velocity (global frame m/s — same mapping as velocity)
    local w = Export.LoGetVectorWindVelocity()
    if w then
        r.wind = { w.z, w.x, w.y }
    end

    -- Cockpit shake amplitude (may not exist on all builds)
    local ok_shake, shake = pcall(Export.LoGetShakeAmplitude)
    if ok_shake and shake then r.shake = shake end

    -- Stall warning from MCP state
    local mcp = Export.LoGetMCPState()
    if mcp then
        if mcp.StallSignalization or mcp.StallWarning then
            r.stall = 1
        else
            r.stall = 0
        end
    end

    return r
end

return M

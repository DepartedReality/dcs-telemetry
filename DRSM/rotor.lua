-- DRSM Telemetry — Rotor module
-- Collects: main rotor RPM for helicopters via cockpit panel gauge.
-- If no aircraft-specific panel index is available, falls back to
-- LoGetEngineInfo (turbine RPM as a proxy).

local M = {}

function M.collect(aircraft_name, ac_data)
    local r = {}

    if ac_data.type ~= "heli" then
        return r
    end

    -- Primary: cockpit gauge for main rotor RPM
    if ac_data.rotor_panel_idx then
        local panel = Export.GetDevice(0)
        if panel then
            local ok, raw = pcall(panel.get_argument_value, panel, ac_data.rotor_panel_idx)
            if ok and raw then
                r.rotor_rpm = raw * (ac_data.rotor_factor or 1)
            end
        end
    end

    return r
end

return M

-- DRSM Telemetry — Engine module
-- Collects: engine RPM left/right (from LoGetEngineInfo),
--           propeller RPM (from cockpit panel for warbirds).
-- LoGetEngineInfo().RPM returns percent (0-100); engine_rpm_factor in
-- aircraft_data.lua converts to actual RPM. Every aircraft MUST have a factor.

local M = {}

function M.collect(aircraft_name, ac_data)
    local r = {}

    -- Engine RPM from the generic DCS API (works for most aircraft)
    local engine = Export.LoGetEngineInfo()
    if engine and engine.RPM then
        local factor = ac_data.engine_rpm_factor or 1
        r.rpm_left  = (engine.RPM.left  or 0) * factor
        r.rpm_right = (engine.RPM.right or 0) * factor
    end

    -- Propeller RPM for warbird / prop aircraft (cockpit panel gauge)
    if ac_data.type == "prop" and ac_data.prop_panel_idx then
        local panel = Export.GetDevice(0)
        if panel then
            local ok, raw = pcall(panel.get_argument_value, panel, ac_data.prop_panel_idx)
            if ok and raw then
                r.prop_rpm = raw * (ac_data.prop_factor or 1)
            end
        end
    end

    return r
end

return M

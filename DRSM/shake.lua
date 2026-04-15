-- DRSM Telemetry — Shake module
-- Collects: per-aircraft cockpit panel shake from cockpit instrument args.
-- These give richer vibration data than the generic LoGetShakeAmplitude().
-- When shake_args are defined, sends panel_shake as an array of values (0–1).
-- Falls back to LoGetShakeAmplitude() if no per-aircraft args are available.

local M = {}

function M.collect(aircraft_name, ac_data)
    local r = {}
    local args = ac_data.shake_args
    if not args or #args == 0 then
        return r
    end

    local panel = Export.GetDevice(0)
    if not panel then
        return r
    end

    local vals = {}
    local has_data = false
    for i = 1, #args do
        local ok, raw = pcall(panel.get_argument_value, panel, args[i])
        if ok and raw then
            vals[i] = raw
            if raw ~= 0 then has_data = true end
        else
            vals[i] = 0
        end
    end

    if has_data then
        r.panel_shake = vals
    end

    return r
end

return M

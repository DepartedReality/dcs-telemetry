-- DRSM Telemetry — Orchestrator
-- Loads configuration + all telemetry modules, manages the UDP socket,
-- calls each module's collect() per frame inside pcall, merges results
-- into a single JSON object, and sends it over UDP.

-- Resolve module directory (this file lives in Scripts/Hooks/DRSM/)
local src = debug.getinfo(1, "S").source
local drsm_dir = src:match("@(.+[\\/])") or (lfs.writedir() .. [[Scripts\Hooks\DRSM\]])

local config        = dofile(drsm_dir .. "config.lua")
local aircraft_db   = dofile(drsm_dir .. "aircraft_data.lua")
local core          = dofile(drsm_dir .. "core.lua")
local aerodynamics  = dofile(drsm_dir .. "aerodynamics.lua")
local engine        = dofile(drsm_dir .. "engine.lua")
local rotor         = dofile(drsm_dir .. "rotor.lua")
local gear          = dofile(drsm_dir .. "gear.lua")
local surfaces      = dofile(drsm_dir .. "surfaces.lua")
local weapons       = dofile(drsm_dir .. "weapons.lua")
local damage        = dofile(drsm_dir .. "damage.lua")
local shake         = dofile(drsm_dir .. "shake.lua")

local M = {}

-- Socket reference (created in start, closed in stop)
local socket_lib = nil
local udp = nil

-- Ordered module list — core first for timing data
local modules = { core, aerodynamics, engine, rotor, gear, surfaces, weapons, damage, shake }

-- =====================================================================
-- Minimal JSON encoder (DCS Lua 5.1 has no built-in JSON)
-- Handles: number, string, boolean, sequential table (array of numbers)
-- =====================================================================
local format = string.format
local concat = table.concat

local function json_encode(t)
    local parts = {}
    local n = 0
    for k, v in pairs(t) do
        local ev        -- encoded value
        local tv = type(v)
        if tv == "number" then
            -- NaN safety; integer vs float formatting
            if v ~= v then
                ev = "0"
            elseif v == math.floor(v) and math.abs(v) < 1e15 then
                ev = format("%d", v)
            else
                ev = format("%.7g", v)
            end
        elseif tv == "string" then
            ev = '"' .. v:gsub('[\\"]', '\\%0') .. '"'
        elseif tv == "boolean" then
            ev = v and "true" or "false"
        elseif tv == "table" then
            -- Encode as JSON array of numbers
            local arr = {}
            for i = 1, #v do
                local x = v[i]
                if type(x) == "number" then
                    if x ~= x then arr[i] = "0"
                    else arr[i] = format("%.7g", x)
                    end
                end
            end
            ev = "[" .. concat(arr, ",") .. "]"
        end
        if ev then
            n = n + 1
            parts[n] = '"' .. k .. '":' .. ev
        end
    end
    return "{" .. concat(parts, ",") .. "}"
end

-- =====================================================================
-- Lifecycle hooks (called by DRSM_Telemetry.lua hook)
-- =====================================================================

function M.start()
    -- LuaSocket paths (DCS ships its own copy)
    package.path  = package.path  .. ";.\\LuaSocket\\?.lua"
    package.cpath = package.cpath .. ";.\\LuaSocket\\?.dll"

    socket_lib = require("socket")
    udp = socket_lib.udp()
    udp:settimeout(0)
    udp:setpeername(config.ip, config.port)

    -- Reset stateful modules
    weapons.reset()
    damage.reset()

    if config.log then
        log.write("DRSM", log.INFO, format("UDP target %s:%d  (v%d)", config.ip, config.port, config.version))
    end
end

function M.frame()
    if not udp then return end

    -- Self-data gate — nil before the player enters a cockpit
    local obj = Export.LoGetSelfData()
    if not obj then return end

    local name    = obj.Name
    local ac_data = aircraft_db[name] or {}

    -- Seed result with protocol version + aircraft name
    local result = { v = config.version, name = name }

    -- Collect from each module (pcall isolates failures)
    for i = 1, #modules do
        local ok, data = pcall(modules[i].collect, name, ac_data)
        if ok and data then
            for k, v in pairs(data) do
                result[k] = v
            end
        elseif config.log and not ok then
            log.write("DRSM", log.WARNING, "Module error: " .. tostring(data))
        end
    end

    -- JSON-encode and send
    local payload = json_encode(result)
    local ok_send, err = pcall(udp.send, udp, payload)
    if not ok_send and config.log then
        log.write("DRSM", log.WARNING, "UDP send error: " .. tostring(err))
    end
end

function M.stop()
    if udp then
        udp:close()
        udp = nil
    end
    weapons.reset()
    damage.reset()
end

return M

-- DRSM DCS Telemetry Export Script
-- JSON key-value protocol over UDP
-- Copy to: C:\Users\<USERNAME>\Saved Games\DCS\Scripts\Hooks\
-- Module folder DRSM\ must be alongside this file in Scripts\Hooks\DRSM\

-- Resolve the Hooks directory via lfs.writedir() (guaranteed available in DCS)
local hooks_dir = lfs.writedir() .. [[Scripts\Hooks\]]
local drsm_dir  = hooks_dir .. [[DRSM\]]

log.write("DRSM", log.INFO, "Loading DRSM modules from: " .. drsm_dir)

-- Load the orchestrator via dofile (require is unreliable in DCS Hooks sandbox)
local load_ok, drsm = pcall(dofile, drsm_dir .. "init.lua")
if not load_ok then
    log.write("DRSM", log.ERROR,
        "Failed to load DRSM modules from " .. drsm_dir .. " — " .. tostring(drsm))
    return  -- graceful degradation: DCS keeps running, no telemetry
end

log.write("DRSM", log.INFO, "DRSM modules loaded successfully")

-- Register DCS user callbacks -----------------------------------------------
local callbacks = {}

function callbacks.onSimulationStart()
    log.write("DRSM", log.INFO, "=====================================")
    log.write("DRSM", log.INFO, "STARTING DRSM TELEMETRY")

    log.write("DRSM", log.INFO, "=====================================")
    local ok, err = pcall(drsm.start)
    if not ok then
        log.write("DRSM", log.ERROR, "start() failed: " .. tostring(err))
    end
end

function callbacks.onSimulationFrame()
    drsm.frame()
end

function callbacks.onSimulationStop()
    local ok, err = pcall(drsm.stop)
    if not ok then
        log.write("DRSM", log.ERROR, "stop() failed: " .. tostring(err))
    end
    log.write("DRSM", log.INFO, "DRSM Telemetry export stopped")
end

DCS.setUserCallbacks(callbacks)

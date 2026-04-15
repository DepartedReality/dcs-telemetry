-- Per-aircraft lookup tables for DRSM Telemetry
--
-- Fields:
--   type             "heli" | "prop" | "jet"
--   rotor_panel_idx  cockpit arg index for main-rotor RPM gauge (heli only)
--   rotor_factor     gauge_value × factor = rotor RPM (heli only)
--   prop_panel_idx   cockpit arg index for propeller RPM gauge (prop only)
--   prop_factor      gauge_value × factor = propeller RPM (prop only)
--   shake_args       {int, …} cockpit arg indices for panel shake (0–1 each)
--   damage_vars      {int, …} draw-arg indices for structural damage
--   gear_args        {left, nose, right} draw-arg indices for per-gear positions
--
-- Adding a new aircraft = add one entry. No code changes required.

return {
    -- =====================================================================
    -- HELICOPTERS
    -- rotor_panel_idx / rotor_factor: cockpit gauge → main rotor RPM
    -- engine_rpm_factor: LoGetEngineInfo().RPM returns PERCENT (0-100);
    --   multiply by this factor to get actual RPM.
    -- =====================================================================
    ["Mi-8MT"] = {
        type             = "heli",
        rotor_panel_idx  = 42,
        rotor_factor     = 220,
        shake_args       = {264, 265, 282},
        damage_vars      = {53, 81, 115, 116, 213, 214},
    },
    ["UH-1H"] = {
        type             = "heli",
        rotor_panel_idx  = 123,
        rotor_factor     = 324,        -- 100% gauge = 324 RPM main rotor
        engine_rpm_factor = 66,        -- LoGetEngineInfo returns %; 100% N2 = 6600 RPM
        shake_args       = {264, 265, 282},
        damage_vars      = {53, 81, 213, 214},
    },
    ["Ka-50"] = {
        type             = "heli",
        rotor_panel_idx  = 52,
        rotor_factor     = 100,
        damage_vars      = {53, 65, 81, 213, 214, 226},
    },
    ["Ka-50_3"] = {
        type             = "heli",
        rotor_panel_idx  = 52,
        rotor_factor     = 100,
        damage_vars      = {53, 65, 81, 213, 214, 226},
    },
    ["SA342M"] = {
        type             = "heli",
        rotor_panel_idx  = 52,
        rotor_factor     = 100,
    },
    ["SA342L"] = {
        type             = "heli",
        rotor_panel_idx  = 52,
        rotor_factor     = 100,
    },
    ["SA342Mistral"] = {
        type             = "heli",
        rotor_panel_idx  = 52,
        rotor_factor     = 100,
    },
    ["SA342Minigun"] = {
        type             = "heli",
        rotor_panel_idx  = 52,
        rotor_factor     = 100,
    },
    ["Mi-24P"] = {
        type             = "heli",
        rotor_panel_idx  = 42,
        rotor_factor     = 253,
        damage_vars      = {53, 81, 115, 116, 213, 214},
    },
    ["AH-64D_BLK_II"] = {
        type             = "heli",
        shake_args       = {820, 821, 822, 823, 824},
    },
    -- Panel data TBD — LoGetEngineInfo fallback used
    ["UH-60L"]     = { type = "heli" },
    ["UH-60L_DAP"] = { type = "heli" },
    ["OH58D"]      = { type = "heli" },
    ["CH-47Fbl1"]  = { type = "heli" },
    ["OH-6A"]      = { type = "heli" },

    -- =====================================================================
    -- PROPELLER / WARBIRD AIRCRAFT
    -- prop_panel_idx / prop_factor: cockpit gauge → propeller RPM
    -- shake_args: cockpit instrument vibration arg indices
    -- =====================================================================
    ["P-51D"] = {
        type            = "prop",
        prop_panel_idx  = 23,
        prop_factor     = 4500,
        redline_rpm     = 3000,
        shake_args      = {181, 180, 189},
        damage_vars     = {53, 65, 81},
    },
    ["P-51D-30-NA"] = {
        type            = "prop",
        prop_panel_idx  = 23,
        prop_factor     = 4500,
        redline_rpm     = 3000,
        shake_args      = {181, 180, 189},
        damage_vars     = {53, 65, 81},
    },
    ["TF-51D"] = {
        type            = "prop",
        prop_panel_idx  = 23,
        prop_factor     = 4500,
        redline_rpm     = 3000,
        shake_args      = {181, 180, 189},
        damage_vars     = {53, 65, 81},
    },
    ["FW-190D9"] = {
        type            = "prop",
        prop_panel_idx  = 47,
        prop_factor     = 1,       -- arg 47 already outputs usable RPM fraction
        redline_rpm     = 2700,
        shake_args      = {205, 204, 206},
    },
    ["FW-190A8"] = {
        type            = "prop",
        prop_panel_idx  = 47,
        prop_factor     = 1,       -- arg 47 already outputs usable RPM fraction
        redline_rpm     = 2700,
        shake_args      = {205, 204, 206},
    },
    ["Bf-109K-4"] = {
        type            = "prop",
        prop_panel_idx  = 29,
        prop_factor     = 1,       -- arg 29 already outputs usable RPM fraction
        redline_rpm     = 2800,
        shake_args      = {146, 147, 148},
    },
    ["SpitfireLFMkIX"] = {
        type            = "prop",
        redline_rpm     = 3000,
        shake_args      = {144, 143, 142},
    },
    ["SpitfireLFMkIXCW"] = {
        type            = "prop",
        redline_rpm     = 3000,
        shake_args      = {144, 143, 142},
    },
    ["MosquitoFBMkVI"] = {
        type            = "prop",
        redline_rpm     = 3000,
    },
    ["I-16"] = {
        type            = "prop",
        redline_rpm     = 1800,
    },
    ["C-130J"] = {
        type            = "prop",
    },

    -- =====================================================================
    -- JETS
    -- Most jets use LoGetEngineInfo directly — entries here carry metadata,
    -- optional damage_vars, and shake_args only.
    -- =====================================================================
    ["FA-18C_hornet"] = {
        type        = "jet",
        damage_vars = {65, 135, 136, 213, 214},
    },
    ["F-16C_50"] = {
        type        = "jet",
        damage_vars = {65, 135, 213, 214},
    },
    ["F-14A-135-GR"] = {
        type        = "jet",
        damage_vars = {65, 135, 136, 213, 214},
    },
    ["F-14B"] = {
        type        = "jet",
        damage_vars = {65, 135, 136, 213, 214},
    },
    ["F-15ESE"] = {
        type        = "jet",
        damage_vars = {65, 135, 136, 213, 214},
    },
    ["F-4E-45MC"] = {
        type        = "jet",
    },
    ["A-10C"] = {
        type        = "jet",
        damage_vars = {65, 135, 136, 213, 214},
    },
    ["A-10C_2"] = {
        type        = "jet",
        damage_vars = {65, 135, 136, 213, 214},
    },
    ["AV8BNA"] = {
        type        = "jet",
        damage_vars = {65, 135, 213, 214},
    },
    ["M-2000C"] = {
        type        = "jet",
        shake_args  = {181, 180, 189},
    },
    ["F-86F Sabre"]  = { type = "jet" },
    ["MiG-21Bis"]    = { type = "jet" },
    ["MiG-15bis"]    = { type = "jet" },
    ["MiG-29A"]      = { type = "jet" },
    ["MiG-29G"]      = { type = "jet" },
    ["MiG-29S"]      = { type = "jet" },
    ["Su-25"]        = { type = "jet" },
    ["Su-25T"]       = { type = "jet" },
    ["Su-27"]        = { type = "jet" },
    ["Su-33"]        = { type = "jet" },
    ["J-11A"]        = { type = "jet" },
    ["F-15C"]        = { type = "jet" },
    ["A-10A"]        = { type = "jet" },
    ["L-39C"]        = { type = "jet" },
    ["L-39ZA"]       = { type = "jet" },
    ["F-5E"]         = { type = "jet" },
    ["F-5E-3"]       = { type = "jet" },
    ["AJS37"]        = { type = "jet" },
    ["JF-17"]        = { type = "jet" },
    ["Mirage-F1CE"]  = { type = "jet" },
    ["Mirage-F1EE"]  = { type = "jet" },
    ["Mirage-F1BE"]  = { type = "jet" },
    ["A-4E-C"]       = { type = "jet" },
    ["MB-339"]       = { type = "jet" },
    ["MB-339A"]      = { type = "jet" },
    ["MB-339APAN"]   = { type = "jet" },

    -- FC3 2025 variants
    ["F-5E-3_FC"]    = { type = "jet" },
    ["F-86F_FC"]     = { type = "jet" },
    ["MiG-15bis_FC"] = { type = "jet" },
}

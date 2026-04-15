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
        rotor_factor     = 192,        -- Mi-8 main rotor: ~192 RPM nominal
        engine_rpm_factor = 125,       -- TV2-117A free turbine output: ~12,500 RPM
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
        rotor_factor     = 240,        -- Ka-50 coaxial rotor: ~235-240 RPM
        engine_rpm_factor = 83,        -- VK-2500 free turbine: ~8,300 RPM
        damage_vars      = {53, 65, 81, 213, 214, 226},
    },
    ["Ka-50_3"] = {
        type             = "heli",
        rotor_panel_idx  = 52,
        rotor_factor     = 240,        -- Ka-50_3 coaxial rotor: ~235-240 RPM
        engine_rpm_factor = 83,        -- VK-2500 free turbine: ~8,300 RPM
        damage_vars      = {53, 65, 81, 213, 214, 226},
    },
    ["SA342M"] = {
        type             = "heli",
        rotor_panel_idx  = 52,
        rotor_factor     = 394,        -- SA342 Gazelle main rotor: ~387-394 RPM
        engine_rpm_factor = 60,        -- Astazou XIV output shaft: ~6,000 RPM
    },
    ["SA342L"] = {
        type             = "heli",
        rotor_panel_idx  = 52,
        rotor_factor     = 394,        -- SA342 Gazelle main rotor: ~387-394 RPM
        engine_rpm_factor = 60,        -- Astazou XIV output shaft: ~6,000 RPM
    },
    ["SA342Mistral"] = {
        type             = "heli",
        rotor_panel_idx  = 52,
        rotor_factor     = 394,        -- SA342 Gazelle main rotor: ~387-394 RPM
        engine_rpm_factor = 60,        -- Astazou XIV output shaft: ~6,000 RPM
    },
    ["SA342Minigun"] = {
        type             = "heli",
        rotor_panel_idx  = 52,
        rotor_factor     = 394,        -- SA342 Gazelle main rotor: ~387-394 RPM
        engine_rpm_factor = 60,        -- Astazou XIV output shaft: ~6,000 RPM
    },
    ["Mi-24P"] = {
        type             = "heli",
        rotor_panel_idx  = 42,
        rotor_factor     = 240,        -- Mi-24P main rotor: ~240 RPM
        engine_rpm_factor = 150,       -- TV3-117 free turbine: ~15,000 RPM
        damage_vars      = {53, 81, 115, 116, 213, 214},
    },
    ["AH-64D_BLK_II"] = {
        type             = "heli",
        engine_rpm_factor = 209,       -- T700-GE-701C output shaft: ~20,900 RPM
        shake_args       = {820, 821, 822, 823, 824},
    },
    -- Panel data TBD — LoGetEngineInfo fallback used
    ["UH-60L"]     = { type = "heli", engine_rpm_factor = 209 },  -- T700-GE-701C: ~20,900 RPM
    ["UH-60L_DAP"] = { type = "heli", engine_rpm_factor = 209 },  -- T700-GE-701C: ~20,900 RPM
    ["OH58D"]      = { type = "heli", engine_rpm_factor = 60 },   -- T703-AD-700A: ~6,016 RPM
    ["CH-47Fbl1"]  = { type = "heli", engine_rpm_factor = 150 },  -- T55-GA-714A: ~15,000 RPM
    ["OH-6A"]      = { type = "heli", engine_rpm_factor = 60 },   -- T63-A-5A: ~6,000 RPM

    -- =====================================================================
    -- PROPELLER / WARBIRD AIRCRAFT
    -- prop_panel_idx / prop_factor: cockpit gauge → propeller RPM
    -- shake_args: cockpit instrument vibration arg indices
    -- =====================================================================
    ["P-51D"] = {
        type            = "prop",
        prop_panel_idx  = 23,
        prop_factor     = 4500,        -- Merlin V-1650-7 direct drive; gauge scaled 0–4500
        redline_rpm     = 3000,        -- Packard Merlin: max 3,000 RPM
        engine_rpm_factor = 30,        -- 100% = 3,000 RPM
        shake_args      = {181, 180, 189},
        damage_vars     = {53, 65, 81},
    },
    ["P-51D-30-NA"] = {
        type            = "prop",
        prop_panel_idx  = 23,
        prop_factor     = 4500,        -- Merlin V-1650-7 direct drive; gauge scaled 0–4500
        redline_rpm     = 3000,        -- Packard Merlin: max 3,000 RPM
        engine_rpm_factor = 30,        -- 100% = 3,000 RPM
        shake_args      = {181, 180, 189},
        damage_vars     = {53, 65, 81},
    },
    ["TF-51D"] = {
        type            = "prop",
        prop_panel_idx  = 23,
        prop_factor     = 4500,        -- Merlin V-1650-7 direct drive; gauge scaled 0–4500
        redline_rpm     = 3000,        -- Packard Merlin: max 3,000 RPM
        engine_rpm_factor = 30,        -- 100% = 3,000 RPM
        shake_args      = {181, 180, 189},
        damage_vars     = {53, 65, 81},
    },
    ["FW-190D9"] = {
        type            = "prop",
        prop_panel_idx  = 47,
        prop_factor     = 1,       -- arg 47 already outputs usable RPM fraction
        redline_rpm     = 2700,        -- Jumo 213A: max 3,250 RPM; prop max via reduction ~2,700
        engine_rpm_factor = 27,        -- 100% = 2,700 RPM
        shake_args      = {205, 204, 206},
    },
    ["FW-190A8"] = {
        type            = "prop",
        prop_panel_idx  = 47,
        prop_factor     = 1,       -- arg 47 already outputs usable RPM fraction
        redline_rpm     = 2700,        -- BMW 801D-2: max ~2,700 RPM
        engine_rpm_factor = 27,        -- 100% = 2,700 RPM
        shake_args      = {205, 204, 206},
    },
    ["Bf-109K-4"] = {
        type            = "prop",
        prop_panel_idx  = 29,
        prop_factor     = 1,       -- arg 29 already outputs usable RPM fraction
        redline_rpm     = 2800,        -- DB 605: max ~2,800 RPM
        engine_rpm_factor = 28,        -- 100% = 2,800 RPM
        shake_args      = {146, 147, 148},
    },
    ["SpitfireLFMkIX"] = {
        type            = "prop",
        redline_rpm     = 3000,        -- Merlin 66: max 3,000 RPM
        engine_rpm_factor = 30,        -- 100% = 3,000 RPM
        shake_args      = {144, 143, 142},
    },
    ["SpitfireLFMkIXCW"] = {
        type            = "prop",
        redline_rpm     = 3000,        -- Merlin 66: max 3,000 RPM
        engine_rpm_factor = 30,        -- 100% = 3,000 RPM
        shake_args      = {144, 143, 142},
    },
    ["MosquitoFBMkVI"] = {
        type            = "prop",
        redline_rpm     = 3000,        -- Merlin 25: max 3,000 RPM
        engine_rpm_factor = 30,        -- 100% = 3,000 RPM
    },
    ["I-16"] = {
        type            = "prop",
        redline_rpm     = 1800,        -- M-62 radial: max ~1,800 RPM
        engine_rpm_factor = 18,        -- 100% = 1,800 RPM
    },
    ["C-130J"] = {
        type            = "prop",
        engine_rpm_factor = 10,        -- T56 turboprop via reduction gearbox: ~1,020 RPM
    },

    -- =====================================================================
    -- JETS
    -- engine_rpm_factor: LoGetEngineInfo().RPM returns PERCENT (0-100);
    --   multiply by this factor to get actual turbine RPM (N2 spool).
    -- =====================================================================
    ["FA-18C_hornet"] = {
        type              = "jet",
        engine_rpm_factor = 160,       -- F404-GE-402: ~16,000 RPM
        damage_vars       = {65, 135, 136, 213, 214},
    },
    ["F-16C_50"] = {
        type              = "jet",
        engine_rpm_factor = 145,       -- F110-GE-129: ~14,500 RPM
        damage_vars       = {65, 135, 213, 214},
    },
    ["F-14A-135-GR"] = {
        type              = "jet",
        engine_rpm_factor = 120,       -- TF30-P-414A: ~12,000 RPM
        damage_vars       = {65, 135, 136, 213, 214},
    },
    ["F-14B"] = {
        type              = "jet",
        engine_rpm_factor = 145,       -- F110-GE-400: ~14,500 RPM
        damage_vars       = {65, 135, 136, 213, 214},
    },
    ["F-15ESE"] = {
        type              = "jet",
        engine_rpm_factor = 145,       -- F110-GE-129: ~14,500 RPM
        damage_vars       = {65, 135, 136, 213, 214},
    },
    ["F-4E-45MC"] = {
        type              = "jet",
        engine_rpm_factor = 120,       -- J79-GE-17: ~12,000 RPM
    },
    ["A-10C"] = {
        type              = "jet",
        engine_rpm_factor = 160,       -- TF34-GE-100: ~16,000 RPM
        damage_vars       = {65, 135, 136, 213, 214},
    },
    ["A-10C_2"] = {
        type              = "jet",
        engine_rpm_factor = 160,       -- TF34-GE-100A: ~16,000 RPM
        damage_vars       = {65, 135, 136, 213, 214},
    },
    ["AV8BNA"] = {
        type              = "jet",
        engine_rpm_factor = 150,       -- F402-RR-408 (Pegasus): ~15,000 RPM
        damage_vars       = {65, 135, 213, 214},
    },
    ["M-2000C"] = {
        type              = "jet",
        engine_rpm_factor = 145,       -- SNECMA M53-P2: ~14,500 RPM
        shake_args        = {181, 180, 189},
    },
    ["F-86F Sabre"]  = { type = "jet", engine_rpm_factor = 80 },   -- J47-GE-27: ~7,950 RPM
    ["MiG-21Bis"]    = { type = "jet", engine_rpm_factor = 115 },  -- R-25-300: ~11,470 RPM
    ["MiG-15bis"]    = { type = "jet", engine_rpm_factor = 115 },  -- VK-1: ~11,500 RPM
    ["MiG-29A"]      = { type = "jet", engine_rpm_factor = 135 },  -- RD-33: ~13,500 RPM
    ["MiG-29G"]      = { type = "jet", engine_rpm_factor = 135 },  -- RD-33: ~13,500 RPM
    ["MiG-29S"]      = { type = "jet", engine_rpm_factor = 135 },  -- RD-33: ~13,500 RPM
    ["Su-25"]        = { type = "jet", engine_rpm_factor = 135 },  -- R-95Sh: ~13,500 RPM
    ["Su-25T"]       = { type = "jet", engine_rpm_factor = 135 },  -- R-195: ~13,500 RPM
    ["Su-27"]        = { type = "jet", engine_rpm_factor = 130 },  -- AL-31F: ~13,000 RPM
    ["Su-33"]        = { type = "jet", engine_rpm_factor = 130 },  -- AL-31F-3: ~13,000 RPM
    ["J-11A"]        = { type = "jet", engine_rpm_factor = 130 },  -- AL-31F: ~13,000 RPM
    ["F-15C"]        = { type = "jet", engine_rpm_factor = 145 },  -- F100-PW-220: ~14,500 RPM
    ["A-10A"]        = { type = "jet", engine_rpm_factor = 160 },  -- TF34-GE-100: ~16,000 RPM
    ["L-39C"]        = { type = "jet", engine_rpm_factor = 160 },  -- AI-25TL: ~16,000 RPM
    ["L-39ZA"]       = { type = "jet", engine_rpm_factor = 160 },  -- AI-25TL: ~16,000 RPM
    ["F-5E"]         = { type = "jet", engine_rpm_factor = 165 },  -- J85-GE-21B: ~16,500 RPM
    ["F-5E-3"]       = { type = "jet", engine_rpm_factor = 165 },  -- J85-GE-21B: ~16,500 RPM
    ["AJS37"]        = { type = "jet", engine_rpm_factor = 130 },  -- RM8B (Volvo): ~13,000 RPM
    ["JF-17"]        = { type = "jet", engine_rpm_factor = 140 },  -- RD-93: ~14,000 RPM
    ["Mirage-F1CE"]  = { type = "jet", engine_rpm_factor = 140 },  -- SNECMA Atar 9K-50: ~14,000 RPM
    ["Mirage-F1EE"]  = { type = "jet", engine_rpm_factor = 140 },  -- SNECMA Atar 9K-50: ~14,000 RPM
    ["Mirage-F1BE"]  = { type = "jet", engine_rpm_factor = 140 },  -- SNECMA Atar 9K-50: ~14,000 RPM
    ["A-4E-C"]       = { type = "jet", engine_rpm_factor = 120 },  -- J52-P-8A: ~12,000 RPM
    ["MB-339"]       = { type = "jet", engine_rpm_factor = 140 },  -- Viper Mk 632: ~14,000 RPM
    ["MB-339A"]      = { type = "jet", engine_rpm_factor = 140 },  -- Viper Mk 632: ~14,000 RPM
    ["MB-339APAN"]   = { type = "jet", engine_rpm_factor = 140 },  -- Viper Mk 632: ~14,000 RPM

    -- FC3 2025 variants
    ["F-5E-3_FC"]    = { type = "jet", engine_rpm_factor = 165 },  -- J85-GE-21B: ~16,500 RPM
    ["F-86F_FC"]     = { type = "jet", engine_rpm_factor = 80 },   -- J47-GE-27: ~7,950 RPM
    ["MiG-15bis_FC"] = { type = "jet", engine_rpm_factor = 115 },  -- VK-1: ~11,500 RPM
}

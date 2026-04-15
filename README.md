# DRSM DCS World Telemetry Export

A Lua-based telemetry export script for [DCS World](https://www.digitalcombatsimulator.com/)
that streams real-time flight data over UDP as JSON. Built for
[DR Sim Manager](https://docs.departedreality.com/dr-sim-manager) but usable by any application that
can receive UDP packets.

**Protocol version**: 2  
**Transport**: UDP · JSON · one packet per simulation frame  
**Default endpoint**: `127.0.0.1:4135`

## Features

- Real-time motion, orientation, and acceleration data
- Per-aircraft cockpit shake / vibration values
- Engine RPM, rotor RPM, and propeller RPM
- Landing gear, flaps, speedbrakes, canopy, and afterburner positions
- Weapons fire and countermeasure deployment counters
- Structural damage tracking
- Modular design — each telemetry category is a separate Lua file
- Data-driven aircraft support via `aircraft_data.lua` (no code changes needed)

## Installation

1. Copy `DRSM_Telemetry.lua` **and** the `DRSM/` folder to:
   ```
   %USERPROFILE%\Saved Games\DCS\Scripts\Hooks\
   ```
   Your folder structure should look like:
   ```
   Scripts\Hooks\
   ├── DRSM_Telemetry.lua
   └── DRSM\
       ├── init.lua
       ├── config.lua
       ├── aircraft_data.lua
       ├── core.lua
       ├── aerodynamics.lua
       ├── engine.lua
       ├── rotor.lua
       ├── gear.lua
       ├── surfaces.lua
       ├── weapons.lua
       ├── damage.lua
       └── shake.lua
   ```
2. (Optional) Edit `DRSM/config.lua` to change the UDP destination or enable logging.
3. Launch DCS World. Telemetry starts automatically when you enter a cockpit.

## Configuration

Edit `DRSM/config.lua`:

| Key       | Default        | Description                           |
|-----------|----------------|---------------------------------------|
| `ip`      | `"127.0.0.1"`  | UDP destination address               |
| `port`    | `4135`          | UDP destination port                  |
| `version` | `2`             | Protocol version sent in each packet  |
| `log`     | `false`         | Per-frame DCS log output (noisy)      |

---

## Protocol Reference

The script sends a flat JSON object over UDP each simulation frame. All fields
are optional except the envelope fields (`v`, `name`, `t`). Fields are omitted
when the underlying DCS API returns `nil` or the module does not apply to the
current aircraft.

---

## Envelope

Always present on every packet.

| Key    | Type   | Description                                      |
|--------|--------|--------------------------------------------------|
| `v`    | number | Protocol version (currently `2`)                 |
| `name` | string | DCS internal aircraft name (e.g. `"FA-18C_hornet"`) |
| `t`    | number | Simulation model time in seconds                 |

---

## Core — Motion & Orientation

Source module: `DRSM/core.lua`

| Key       | Type      | Units          | Description                                |
|-----------|-----------|----------------|--------------------------------------------|
| `acc`     | array\[3] | G-forces       | Body-frame acceleration `[z, x, y]`        |
| `ang_vel` | array\[3] | rad/s          | Body-frame angular velocity `[z, x, y]`    |
| `vel`     | array\[3] | m/s            | Global-frame velocity `[z, x, y]`          |
| `pitch`   | number    | radians        | Pitch angle (nose up = positive)           |
| `roll`    | number    | radians        | Bank angle (right wing down = positive)    |
| `yaw`     | number    | radians        | Heading (negated for DRSM convention)      |
| `alt_agl` | number    | meters         | Altitude above ground level                |
| `alt_msl` | number    | meters         | Altitude mean sea level                    |
| `tas`     | number    | m/s            | True airspeed                              |

**Note:** The three-element arrays use DCS body-frame axes remapped as `[z, x, y]`.

---

## Aerodynamics

Source module: `DRSM/aerodynamics.lua`

| Key           | Type      | Units / Range | Description                                     |
|---------------|-----------|---------------|-------------------------------------------------|
| `aoa`         | number    | radians       | Angle of attack                                 |
| `aos`         | number    | radians       | Angle of sideslip                               |
| `ias`         | number    | m/s           | Indicated airspeed                              |
| `mach`        | number    | unitless      | Mach number                                     |
| `wind`        | array\[3] | m/s           | Wind velocity `[z, x, y]` (global frame)        |
| `shake`       | number    | 0.0–1.0       | Generic cockpit shake amplitude (fallback)       |
| `panel_shake` | array     | 0.0–1.0 each  | Per-aircraft cockpit shake values (preferred)    |
| `stall`       | number    | 0 or 1        | Stall warning flag                              |

When per-aircraft `shake_args` are defined in `aircraft_data.lua`, `panel_shake`
is sent instead of `shake`. Consumers should prefer `panel_shake` when present.

---

## Engine

Source module: `DRSM/engine.lua`

| Key         | Type   | Units   | Description                                        |
|-------------|--------|---------|----------------------------------------------------|
| `rpm_left`  | number | % or RPM | Left engine RPM (percent for most DCS aircraft)   |
| `rpm_right` | number | % or RPM | Right engine RPM                                  |
| `prop_rpm`  | number | RPM      | Propeller RPM (prop aircraft only, from cockpit gauge) |

For aircraft with `engine_rpm_factor` in `aircraft_data.lua`, the value is a
percentage (0–100). Multiply by the factor to get actual RPM.

---

## Rotor (Helicopters)

Source module: `DRSM/rotor.lua`

| Key         | Type   | Units | Description                                         |
|-------------|--------|-------|-----------------------------------------------------|
| `rotor_rpm` | number | RPM   | Main rotor RPM (from cockpit gauge × `rotor_factor`) |

Only present for helicopters with `rotor_panel_idx` in `aircraft_data.lua`.

---

## Landing Gear

Source module: `DRSM/gear.lua`

| Key          | Type   | Range   | Description                                |
|--------------|--------|---------|--------------------------------------------|
| `gear_left`  | number | 0.0–1.0 | Left main gear (0 = stowed, 1 = extended) |
| `gear_nose`  | number | 0.0–1.0 | Nose gear position                        |
| `gear_right` | number | 0.0–1.0 | Right main gear position                  |

Only present for aircraft with `gear_args` in `aircraft_data.lua`.

---

## Surfaces

Source module: `DRSM/surfaces.lua`

| Key           | Type      | Range   | Description                               |
|---------------|-----------|---------|-------------------------------------------|
| `flaps`       | number    | 0.0–1.0 | Flaps position                           |
| `speedbrakes` | number    | 0.0–1.0 | Speedbrakes position                     |
| `canopy`      | number    | 0.0–1.0 | Canopy position (0 = closed, 1 = open)   |
| `gear`        | number    | 0.0–1.0 | Overall landing gear position            |
| `afterburner` | array\[2] | 0.0–1.0 | Afterburner position `[left, right]`     |

---

## Weapons

Source module: `DRSM/weapons.lua`

All values are **cumulative counters** that reset when the simulation
starts or stops. Detected by frame-to-frame decreases in DCS payload state.

| Key                   | Type   | Description                              |
|-----------------------|--------|------------------------------------------|
| `cannon_rounds_fired` | number | Total cannon rounds fired                |
| `missiles_released`   | number | Total missiles (A2A + A2G) released      |
| `bombs_released`      | number | Total bombs released                     |
| `rockets_released`    | number | Total unguided rockets (NURS) released   |
| `flares_released`     | number | Total flares deployed                    |
| `chaff_released`      | number | Total chaff bundles dispensed            |

---

## Damage

Source module: `DRSM/damage.lua`

| Key            | Type   | Range  | Description                                  |
|----------------|--------|--------|----------------------------------------------|
| `damage_total` | number | 0.0+   | Sum of structural damage draw-arg values     |

A value of 0 means fully intact. The value can exceed 1.0 when multiple
structural components are damaged simultaneously.

---

## Example Packet

```json
{
  "v": 2,
  "name": "FA-18C_hornet",
  "t": 1234.56,
  "acc": [0.2, 0.1, -1.0],
  "ang_vel": [0.05, -0.02, 0.01],
  "vel": [100.0, 50.0, -5.0],
  "pitch": 0.0872,
  "roll": 0.1745,
  "yaw": 0.0,
  "alt_agl": 5000.0,
  "alt_msl": 5500.0,
  "tas": 250.0,
  "aoa": 0.05,
  "aos": 0.01,
  "ias": 240.0,
  "mach": 0.8,
  "wind": [5.0, 2.0, 0.0],
  "panel_shake": [0.12, 0.08, 0.05],
  "stall": 0,
  "rpm_left": 85.5,
  "rpm_right": 85.5,
  "afterburner": [0.0, 0.0],
  "flaps": 0.0,
  "speedbrakes": 0.5,
  "canopy": 0.0,
  "gear": 1.0,
  "gear_left": 1.0,
  "gear_nose": 1.0,
  "gear_right": 1.0,
  "cannon_rounds_fired": 45,
  "missiles_released": 2,
  "bombs_released": 0,
  "rockets_released": 0,
  "flares_released": 5,
  "chaff_released": 10,
  "damage_total": 0.15
}
```

---

## Adding Aircraft Support

Add an entry to `DRSM/aircraft_data.lua`. No code changes are needed.

```lua
["MyAircraft"] = {
    type             = "jet",          -- "jet" | "prop" | "heli"
    shake_args       = {264, 265},     -- cockpit arg indices for panel vibration
    damage_vars      = {53, 81},       -- draw-arg indices for structural damage
    gear_args        = {6, 1, 4},      -- draw-arg indices: left, nose, right
    -- Helicopters only:
    -- rotor_panel_idx  = 42,
    -- rotor_factor     = 220,
    -- Props only:
    -- prop_panel_idx   = 15,
    -- prop_factor      = 2700,
    -- Optional (percent→RPM conversion):
    -- engine_rpm_factor = 66,
},
```

To find the correct cockpit argument indices and draw-arg numbers for an
aircraft, use the DCS ModelViewer or community documentation for the module.

---

## Contributing

Contributions are welcome — especially new aircraft entries in `aircraft_data.lua`.

1. Fork the repository
2. Add your aircraft entry
3. Test in DCS and DRSM or other UDP listener
4. Open a pull request

---

## License

MIT License — see [LICENSE](LICENSE) for details.

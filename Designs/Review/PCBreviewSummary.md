# PCB Design Review – Action Items

This document summarizes feedback from the Discord PCB design review and converts it into a structured action checklist prior to fabrication.

---

# 🚨 High Priority (Fix Before Ordering Boards)

## 1️⃣ Add Series Capacitors on Analog Inputs

### Affected Signals

* Thermistor input network (associated with `Rin1` and related divider components)
* I2C signal path (as discussed in review)

### Action

* Add ~10nF capacitor **in series** with each thermistor line.
* Add series capacitor on I2C line if still required after signal integrity review.

### Why

* Reduces high-frequency noise coupling into ADC.
* Prevents unwanted signal ringing or EMI injection.
* Improves measurement stability on thermistor readings.

### Where to Start

* Review the divider formed by `Rin1` and thermistor.

* Simulate cutoff frequency:

  [
  f_c = \frac{1}{2\pi R C}
  ]

* Confirm filter bandwidth does not interfere with ADC sampling rate.

---

## 2️⃣ Verify 5V Reference for Thermistor Divider

### Affected Components

* Thermistor voltage divider (including `Rin1`)
* ADC input pin on MCU

### Action

* Confirm 5V reference is:

  * Stable
  * Within ADC allowable input range
* Ensure no scenario exists where ADC sees > Vref.

### Why

* Unstable reference introduces measurement drift.
* ADC overvoltage risks MCU damage.

---

## 3️⃣ WQFN Footprint Verification (Critical)

### Affected Component

* WQFN IC (exact refdes per schematic)

### Action

* Cross-check footprint against datasheet:

  * Pad width/length
  * Exposed pad size
  * Thermal pad vias
* Confirm stencil paste reduction settings.

### Why

* Incorrect WQFN footprints are a common assembly failure point.
* Exposed pad mis-sizing causes:

  * Floating IC
  * Cold joints
  * Thermal issues

### Where to Start

* Compare PCB footprint dimensions directly against manufacturer mechanical drawing.
* Validate in 3D viewer.

---

# ⚠️ Medium Priority (Should Be Fixed Before Fab)

## 4️⃣ Resolve All ERC Warnings

### Action

* Clear all:

  * Unconnected pins
  * Power flag warnings
  * Passive-to-passive errors

### Why

ERC warnings often reveal:

* Floating nets
* Missing pull-ups
* Improper power definitions

Do **not** ignore warnings unless intentionally documented.

---

## 5️⃣ Decoupling Capacitor Placement

### Affected Components

* MCU
* WQFN IC
* Any analog ICs

### Action

* Move each decoupling capacitor:

  * Within a few mm of VCC pin
  * Direct via to ground plane

### Why

Poor placement:

* Increases loop inductance
* Reduces noise suppression
* Causes unstable power rails

---

## 6️⃣ Grounding Strategy Review

### Action

* Confirm:

  * Solid ground plane
  * No unnecessary ground splits
  * Clean return paths for thermistor and ADC lines

### Why

Improper ground routing:

* Injects digital noise into analog signals
* Creates ground bounce
* Degrades measurement precision

---

## 7️⃣ Trace Width Verification

### Affected Nets

* 5V rail
* High-current outputs (if applicable)

### Action

* Confirm trace width supports expected current.
* Validate thermal relief settings on high-current pads.

### Why

Undersized traces:

* Cause voltage drop
* Overheat
* Fail under load

---

# 🛠 Manufacturing & DFM Improvements

## 8️⃣ Add Test Points

### Recommended Test Points

* 5V
* GND
* SDA
* SCL
* Thermistor ADC input

### Why

Speeds up:

* Bring-up
* Debug
* Production testing

---

## 9️⃣ Silkscreen Improvements

### Action

* Increase reference designator readability.
* Add polarity markings where needed.
* Clearly label connectors.

### Why

Improves assembly reliability and reduces mistakes.

---

# 🧪 Pre-Fabrication Checklist

Before sending to fab:

* [ ] All ERC warnings cleared or documented
* [ ] All DRC violations cleared
* [ ] WQFN footprint verified against datasheet
* [ ] Thermistor filter bandwidth calculated
* [ ] Trace widths validated
* [ ] 3D viewer inspection completed
* [ ] BOM values double-checked
* [ ] Series capacitors added to thermistor lines
* [ ] Decoupling caps placed adjacent to IC pins

---

# 🚀 Bring-Up Order (Recommended)

1. **Power Rail Validation**

   * Verify 5V rail first.
   * Check for shorts.

2. **MCU Programming**

   * Confirm boot and clock stability.

3. **I2C Validation**

   * Scope SDA/SCL.
   * Confirm clean edges and proper pull-ups.

4. **Thermistor Verification**

   * Check ADC raw readings.
   * Compare against expected resistance/temperature curve.

---

# 📌 Suggested Process Improvements

* Require second-person schematic review before layout freeze.
* Always verify QFN footprints manually.
* Never ignore ERC warnings without written justification.
* Maintain a reusable “Pre-Fab Checklist” for future revisions.

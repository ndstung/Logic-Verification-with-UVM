# FFT and Slicing Block for an OFDM System

## Overview
This project implements a 128-point FFT block and a slicing unit for an OFDM (Orthogonal Frequency-Division Multiplexing) communication system. It decodes complex waveforms into frequency bins and extracts binary data from specific tones.

The design meets the following specifications:
- **128-point FFT** for complex signals.
- **24 data tones**, each coded as 2 bits.
- Synchronization tones in **bins 55 and 57** for full-scale reference.

---

## Features
1. **128-Point Complex FFT**:
   - Processes signed 16-bit inputs in 1.15 fixed-point format.
   - Converts time-domain signals into frequency bins.

2. **Slicing Block**:
   - Maps frequency bin magnitudes to 2-bit binary values.
   - Decodes energy levels into `00`, `01`, `10`, or `11`.

3. **Data Format**:
   - **Input**: 16-bit real and imaginary parts.
   - **Output**: 48-bit binary data for 24 tones.

---

## Specifications
1. **Input Data**:
   - Real and imaginary parts in 1.15 fixed-point format.
   - Range: ±1 (normalized).

2. **Output Data**:
   - 48 bits per FFT block (2 bits per tone for 24 tones).
   - Energy levels:
     - `00`: 0% (<25% of full scale)
     - `01`: 33% (≥25% and <50%)
     - `10`: 66% (≥50% and <75%)
     - `11`: 100% (≥75%)

3. **Synchronization Tones**:
   - Fixed tones in bins 55 and 57 for full-scale reference.

4. **Module Ports**:

   | **Port Name** | **Direction** | **Bits** | **Description**                   |
   |---------------|---------------|----------|-----------------------------------|
   | `Clk`         | Input         | 1        | Positive edge system clock.       |
   | `Reset`       | Input         | 1        | Active-high asynchronous reset.   |
   | `PushIn`      | Input         | 1        | Data present on input.            |
   | `FirstData`   | Input         | 1        | Indicates the first FFT block.    |
   | `DinR`        | Input         | 16       | Real part of input (1.15 fixed-point). |
   | `DinI`        | Input         | 16       | Imaginary part of input (1.15 fixed-point). |
   | `PushOut`     | Output        | 1        | Data present on output.           |
   | `DataOut`     | Output        | 48       | Decoded 48-bit output.            |

---

## Design Flow
1. **Input Processing**:
   - Accepts complex signals (real and imaginary parts) in fixed-point format.
   - Applies a 128-point FFT to convert time-domain data to frequency bins.

2. **Slicing**:
   - Evaluates magnitudes of frequency bins (4–52).
   - Categorizes energy levels into binary values based on full-scale reference.

3. **Output Data**:
   - Produces 48-bit binary data for every FFT block.
   - Data corresponds to 24 tones with 2 bits per tone.

---

## Challenges and Solutions
1. **Precision**:
   - Managed fixed-point arithmetic for accurate FFT results.

2. **Synchronization**:
   - Utilized bins 55 and 57 to establish full-scale reference levels.

3. **Energy Mapping**:
   - Implemented robust slicing logic for consistent decoding.

---

## How to Use
1. **Setup**:
   - Integrate the module into your OFDM communication system.
   - Provide 128-point complex waveform input via `DinR` and `DinI`.

2. **Run**:
   - Connect `Clk` and `Reset` signals.
   - Use `PushIn` and `FirstData` to manage input flow.

3. **Extract Output**:
   - Read 48-bit binary data from `DataOut` for each FFT block.

---

## Future Enhancements
- Support for larger FFT sizes (e.g., 256 or 512 points).
- Dynamic tone mapping for enhanced system flexibility.
- Optimization of fixed-point arithmetic for reduced latency.

---

## License
This project is licensed under the MIT License. Contributions and feedback are welcome!

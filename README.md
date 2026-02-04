AHB-to-APB Bridge (Verilog)

Overview

This project implements an AHB-to-APB bridge in Verilog HDL, enabling seamless communication between high-performance AHB masters and low-power APB peripherals. The design follows the AMBA specification and focuses on correctness, protocol compliance, and verification.

Features

Fully synthesizable RTL implementation of AHB-to-APB bridge. Supports AHB transfers and converts them into APB transactions. Handles address, data, and control signal translation. Designed with protocol timing and handshaking requirements in mind.

Verification

Developed a self-checking Verilog testbench. Simulated multiple read/write scenarios. Verified protocol compliance using waveform analysis. Ensured correct APB setup, enable, and access phases.

Tools & Technologies

Language: Verilog HDL
Simulation: ModelSim 
Protocols: AMBA AHB, AMBA APB

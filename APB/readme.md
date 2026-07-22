# APB Slave Verification Environment (SystemVerilog)

A class-based, self-checking verification environment for an APB slave, written in plain SystemVerilog. This project focuses on verifying APB read/write functionality, wait-state handling, error conditions, and functional coverage using constrained-random stimulus.

## DUT Overview

The APB slave contains:

- 256-word memory
- APB FSM (IDLE → SETUP → ACCESS)
- Configurable wait states (`PWDATA[3:2]`)
- `PREADY` generation
- `PSLVERR` generation for invalid addresses

## Verification Environment

The Generator creates constrained-random transactions and pushes them to the Driver over a mailbox. The Driver drives them into the DUT through a virtual interface using clocking blocks, following the SETUP → ACCESS → wait-for-PREADY → IDLE sequence. The Monitor passively samples completed transfers off the same interface, forwards them to the Scoreboard, and feeds the same data to Coverage.

**Components**

- **Generator** – Generates constrained-random APB transactions with separate valid and invalid address constraints.
- **Driver** – Drives APB transactions through a virtual interface using clocking blocks.
- **Monitor** – Passively samples completed transactions and forwards them to the scoreboard while collecting coverage.
- **Scoreboard** – Maintains a reference memory model and compares DUT read data with expected values.
- **Coverage** – Measures functional coverage for reads/writes, address regions, and cross coverage.

## Features Verified

- APB read and write operations
- Wait-state handling (`PREADY`)
- Invalid address detection (`PSLVERR`)
- Randomized valid and invalid transactions
- Self-checking scoreboard
- Functional coverage with cross coverage
  
## Output 
<img width="1920" height="1080" alt="Screenshot 2026-07-22 100005" src="https://github.com/user-attachments/assets/1f0fcb93-3287-472b-a3c3-43e00e176ea2" />
<img width="1920" height="1080" alt="Screenshot 2026-07-22 100017" src="https://github.com/user-attachments/assets/2990971a-0dad-49f9-8769-d04f5b77a43b" />
<img width="1920" height="1080" alt="Screenshot 2026-07-22 100027 - Copy" src="https://github.com/user-attachments/assets/f4e997f8-80e5-4f8b-93e4-bd3a62a29496" />




## Simulation

Verified using QuestaSim on EDA Playground with a class-based SystemVerilog testbench.

<img width="1920" height="1080" alt="Screenshot 2026-07-22 093307" src="https://github.com/user-attachments/assets/e8cd568a-0439-4511-849c-5d84306686eb" />
<img width="1920" height="1080" alt="Screenshot 2026-07-22 091039" src="https://github.com/user-attachments/assets/9da77ff9-0a44-43b4-accf-95d2ad6fe1dc" />



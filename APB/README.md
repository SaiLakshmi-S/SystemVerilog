# APB Slave: Design and Verification in SystemVerilog
 
I built an APB slave with a small internal memory, then wrote a testbench from scratch (no UVM) to try to break it. It checks the data, the error response, the protocol and the timing.
 
## Timing-Checked APB Slave: Verifying Data, Errors and Every Wait State
 
- **Timing is checked, not just data.** The monitor counts the wait states in every transfer, and the scoreboard fails the transfer if the count doesn't match `WAIT_COUNT`. A slave that returns the right data too early or too late is still caught.
- **The error path gets real testing.** The address bus is 8 bits (256 locations), but I kept the memory depth at 128. The upper half is invalid on purpose, and about 15% of fully random addresses land there to exercise `PSLVERR`.
- **Back-to-back transfers are driven for real.** Each transaction picks 0, 1 or 2 idle cycles. With 0, the driver goes straight into the next setup phase without dropping `PSEL`.
- **The protocol is watched all the time.** Six assertions sit inside the interface, next to the signals they check. Two cover properties show whether wait states and back-to-back transfers actually happened.
- **Boundaries are targeted first.** Directed tests hit the first and last valid addresses (`0x00`, `0x7F`) and the first and last invalid ones (`0x80`, `0xFF`). Coverage has a separate bin for each.
## The design
 
| Parameter    | Default | Meaning                   |
|--------------|---------|---------------------------|
| `DW`         | 32      | Data width                |
| `AW`         | 8       | Address width             |
| `DEPTH`      | 128     | Memory words              |
| `WAIT_COUNT` | 2       | Wait states per transfer  |
 
With the default settings, one transfer takes 4 clock cycles:
 
```
Setup  ->  Wait  ->  Wait  ->  Complete (PREADY = 1)
```
 
- Addresses `0x00` to `0x7F` are valid. Writes are stored and reads return the stored data.
- Addresses `0x80` to `0xFF` raise `PSLVERR`. Writes are ignored and reads return 0.
- `PRESETn` is an active-low asynchronous reset that clears the memory.
- `WDATA` and `RDATA` are the spec's `PWDATA` and `PRDATA`.
## The testbench
 
```
generator --> driver --> interface <--> DUT
                             |
                          monitor --> scoreboard
                                  --> coverage
```
 
| File             | What it does |
|------------------|--------------|
| `DUT.sv`         | The APB slave |
| `interface.sv`   | Signals, clocking blocks and assertions |
| `transaction.sv` | One APB transfer, with random constraints |
| `generator.sv`   | 10 directed and 100 random transfers |
| `driver.sv`      | Resets the DUT and drives the bus |
| `monitor.sv`     | Picks up completed transfers |
| `scoreboard.sv`  | Compares them with a reference memory |
| `coverage.sv`    | Tracks operation, address, error response and their crosses |
| `environment.sv` | Connects everything |
| `top.sv`         | Clock, DUT, watchdog timer and waveform dump |
 
### Assertions
 
1. An access phase must come after a setup phase.
2. A setup phase must be followed by an access phase.
3. Address, direction and write data must stay stable until the transfer completes.
4. `PREADY` goes high only in the access phase (my design's rule).
5. `PSLVERR` must match the address range.
6. `PENABLE` must drop after a transfer completes.

### Result

<img width="1818" height="516" alt="Screenshot 2026-11-27 202336" src="https://github.com/user-attachments/assets/51adde77-8cd5-4ec7-bcc6-c906e17e4dfc" />

<img width="687" height="215" alt="Screenshot 2026-11-27 202238" src="https://github.com/user-attachments/assets/53a5f74b-e10b-4958-bb27-642b920dc17c" />

# FIFO UVM-Based Verification

## Project Overview
This project involves the design and verification of a synchronous FIFO (First-In, First-Out) buffer, widely used in digital systems for data transfer between components operating at different clock rates or execution speeds. The design incorporates control signals like full, almost full, empty, and almost empty flags to manage data flow efficiently. Verification, conducted using Universal Verification Methodology (UVM), tested the FIFO's functionality under various conditions.

## FIFO design parameters
**FIFO_WIDTH**: DATA in/out and memory word width (default: 16).

**FIFO_DEPTH**: Memory depth (default: 8).

## FIFO Ports
     | Port        | Direction   | Function                                                                                                                                       |
     |-------------|-------------|------------------------------------------------------------------------------------------------------------------------------------------------|
     | data_in     | Input       | Write Data: The input data bus used when writing the FIFO                                                                                      |
     | wr_en       | Input       | Write Enable: If the FIFO is not full, asserting this signal causes data (on data_in) to be written into the FIFO                              |
     | rd_en       | Input       | Read Enable: If the FIFO is not empty, asserting this signal causes data (on data_out) to be read from the FIFO                                |
     | clk         | Input       | Clock signal                                                                                                                                   |
     | rst_in      | Input       | Active low asynchronous reset                                                                                                                  |
     | full        | Output      | Full Flag: When asserted, this combinational output signal indicates that the FIFO is full. Write requests are ignored when the FIFO is full.  |
     | almostfull  | Output      | Almost Full: When asserted, this combinational output signal indicates that only one more write can be performed before the FIFO is full.      |
     | empty       | Output      | Empty Flag: When asserted, this combinational output signal indicates that the FIFO is empty. Read requests are ignored when the FIFO is empty.|
     | almostempty | Output      | Almost Empty: When asserted, this output combinational signal indicates that only one more read can be performed before the FIFO goes to empty.|
     | overflow    | Output      | Overflow: This sequential output signal indicates that a write request (wr_en) was rejected because the FIFO is full.                          |
     | underflow   | Output      | Underflow: This sequential output signal Indicates that the read request (rd_en) was rejected because the FIFO is empty.                       |
     | wr_ack      | Output      | Write Acknowledge: This sequential output signal indicates that a write request (wr_en) has succeeded.                                         |
     | data_out    | Output      | Read Data: The sequential output data bus used when reading from the FIFO.                                                                     |

## Project Structure

The project includes the following components:

1. **Project Reports**:
   - `Shehab_Eldeen_FIFO_UVM_Project.pdf`: Contains the verification plan and testbench code.
   - `Project_Description.pdf`: Provides an overview of the FIFO design.

2. **Code Files**:
   - **Pre-Debug Design**:
      - `FIFO_before_debugging.v`: The FIFO design before debugging.
   - **Post-Debug Design**:
      - `FIFO.sv`: The finalized FIFO design under test (DUT).
   - **Shared Package**:
      - `shared_pkg.sv`: Contains shared data types, constants, and utilities used across the testbench.
   - **Interface**:
      - `FIFO_interface.sv`: Defines the interface connecting the testbench to the DUT and modports for the DUT and Golden model.
   - **Golden model**:
      - `FIFO_golden.sv`: A reference model for the FIFO design, used for comparison at scoreboard during verification to ensure correctness.
   - **FIFO Assertions**:
      - `FIFO_SVA.sv`: Contains SystemVerilog Assertions (SVA) to verify timing, protocol adherence, and other properties of the FIFO.
   - **FIFO UVM configuration class**:
      - `FIFO_config.sv`: A UVM configuration class used to store and pass testbench configurations to components in the UVM environment.
   - **FIFO Sequence item**:
      - `FIFO_seq_item.sv`: Defines the sequence item (transaction) class representing the data and control information to be sent to the FIFO.
   - **FIFO read only sequence**:
      - `FIFO_read_only_sequence.sv`: A UVM sequence focused on testing read operations only from the FIFO.
   - **FIFO write only sequence**:
      - `FIFO_write_only_sequence.sv`: A UVM sequence focused on testing write operations only to the FIFO.
   - **FIFO read write sequence**:
      - `FIFO_read_write_sequence.sv`: A UVM sequence that tests both read and write operations, ensuring proper FIFO functionality.
   - **FIFO reset sequence**:
      - `FIFO_rst_sequence.sv`: A UVM sequence to verify FIFO behavior during and after a reset condition.
   - **FIFO sequencer**:
      - `FIFO_sequencer.sv`: A UVM sequencer that controls the flow of sequence items (transactions) to the FIFO driver.
   - **FIFO driver**:
      - `FIFO_driver.sv`: A UVM driver that sends stimulus (sequence items) from the sequencer to the FIFO design through the interface.
   - **FIFO Monitor**:
      - `FIFO_monitor.sv`: A UVM monitor that observes the FIFO's input and output signals and collects data for checking and coverage..
   - **FIFO agent**:
      - `FIFO_agent.sv`: A UVM agent that encapsulates the driver, monitor, and sequencer, managing the overall interaction with the FIFO.
   - **FIFO coverage**:
      - `FIFO_coverage.sv`: Contains functional coverage points to ensure that all important test scenarios are covered.
   - **FIFO scoreboard**:
      - `FIFO_scoreboard.sv`: A UVM scoreboard that compares the actual output of the FIFO with the expected output to check data integrity.
   - **FIFO environment**:
      - `FIFO_env.sv`: The top-level UVM environment, instantiating the agents, coverage, and scoreboard to create a complete testbench.
    - **FIFO test**:
      - `FIFO_test.sv`: The UVM test file that defines different test scenarios, applying stimulus to verify FIFO functionality.
    - **FIFO top**:
      - `FIFO_top.sv`: The top-level module connecting the testbench and the FIFO RTL for simulation.

3. **Do File**:
   - `run.do`: A script for running the testbench and viewing the waveform in Questasim.

4. **Verification Plan**:
   - `FIFO (verification plan).xlsx`: Outlines the verification plan for the FIFO design.

## UVM Verification flow
### 2. Develop `sequence_item`
  - Randomize data inputs.
  - Create constraint blocks.

### 3. Create three sequences
  - Verify the design with the following sequences:
  - `write_only`
  - `read_only`
  - `reset`

### 4. Create `driver.sv` file
  - Establish a virtual interface between the driver and the real interface.
  - Assign data from the sequence item and pass it to the interface inputs.

### 5. Create `monitor.sv` file
  - Establish a virtual interface between the monitor and the real interface.
  - Assign data from the virtual interface and pass it to the monitor object via sequence item inputs and outputs.

### 6. Create `agent.sv` file
  - Obtain the configuration object from the database and pass it to the monitor and driver.
  - Establish a connection with the monitor to send data to the scoreboard and coverage collector.
  - Connect the sequencer to the driver.

### 7. Create `env.sv` file
  - Instantiate components such as the agent, scoreboard, and coverage collector.
  - Connect the agent to the scoreboard and coverage collector.

### 8. Create `test.sv` file
  - Get the virtual interface and pass it to the environment.
  - Instantiate sequence objects.
  - Instantiate the environment component.
  - Call the built-in function `raise_objection` to indicate the start of the test.
  - Run the sequence objects in the `run_phase` sequences.
- Call the built-in function `drop_objection` to indicate the end of the test.

## How to Run
1. Clone this repository.
2. Open Questasim and load the project.
3. Use the provided Do file (`run.do`) to run the testbench and visualize the waveform.

## Conclusion
The FIFO UVM Verification project successfully validated the functionality of the FIFO design under a variety of test conditions, including typical scenarios and edge cases like overflow and underflow. Utilizing the Universal Verification Methodology (UVM), the project ensured robust, reusable, and scalable verification. The UVM environment, consisting of agents, monitors, scoreboards, and coverage models, provided comprehensive verification, ensuring the FIFO design meets the required specifications for data integrity, timing, and performance. This verification effort guarantees the FIFO’s reliability for integration into larger digital systems.

### This project is **part** of Eng. Kareem Waseem's diploma.

## Contact Me!
- **Email:** shehabeldeen2004@gmail.com
- **LinkedIn:** [Shehab Eldeen](https://www.linkedin.com/in/shehabeldeen22)
- **GitHub:** [Shehab's GitHub](https://github.com/shehab-25)

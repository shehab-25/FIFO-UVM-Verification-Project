////////////////////////////////////////////////////////////////////////////////
// Name: Shehab Eldeen Khaled
// Course: Digital Verification using SV & UVM 
//
// Description: FIFO Interface 
// 
////////////////////////////////////////////////////////////////////////////////
import shared_pkg::*;

interface FIFO_interface(clk);
    input clk;
    logic [FIFO_WIDTH-1:0] data_in;
    logic rst_n, wr_en, rd_en;

    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic wr_ack_ref, overflow_ref;

    logic [FIFO_WIDTH-1:0] data_out_ref;
    logic full, empty, almostfull, almostempty, underflow;
    logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

    modport DUT (input data_in, wr_en, rd_en, clk, rst_n , output full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);

    modport golden (input data_in, wr_en, rd_en, clk, rst_n , output full_ref, empty_ref, almostfull_ref, almostempty_ref, wr_ack_ref, overflow_ref, underflow_ref, data_out_ref);

endinterface //FIFO_interface
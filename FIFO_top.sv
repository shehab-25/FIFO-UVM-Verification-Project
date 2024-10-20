import uvm_pkg::*;
import FIFO_test_pkg::*;
`include "uvm_macros.svh"

module FIFO_top ();
    logic clk;
    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    FIFO_interface FIFO_if(clk);
    FIFO FIFO_DUT(FIFO_if);
    FIFO_golden ref_model(FIFO_if);
    bind FIFO FIFO_SVA FIFO_SVA_INST(FIFO_if);

    initial begin
        uvm_config_db #(virtual FIFO_interface)::set(null , "uvm_test_top" , "FIFO_IF" , FIFO_if);
        run_test("FIFO_test");
    end

endmodule
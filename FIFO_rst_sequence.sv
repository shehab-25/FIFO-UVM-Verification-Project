package FIFO_rst_sequence_pkg;
    import shared_pkg::*;
    import FIFO_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_rst_sequence extends uvm_sequence #(FIFO_seq_item);
        `uvm_object_utils(FIFO_rst_sequence)
        FIFO_seq_item rst_seq;

        // constructor
        function new(string name = "FIFO_rst_sequence");
            super.new(name);
        endfunction

        task body ();
            rst_seq = FIFO_seq_item::type_id::create("rst_seq"); // create a sequence item
            start_item(rst_seq);
            rst_seq.rst_n = 0;
            rst_seq.wr_en = 1;
            rst_seq.rd_en = 0;
            rst_seq.data_in = 5;
            finish_item(rst_seq);
        endtask
    endclass
    
endpackage
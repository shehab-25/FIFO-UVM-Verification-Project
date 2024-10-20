package FIFO_write_only_sequence_pkg;
    import shared_pkg::*;
    import FIFO_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_write_only_sequence extends uvm_sequence #(FIFO_seq_item);
        `uvm_object_utils(FIFO_write_only_sequence)
        FIFO_seq_item write_only_seq;

        // constructor
        function new(string name = "FIFO_write_only_sequence");
            super.new(name);
        endfunction

        task body();
            repeat(1000) begin
                write_only_seq = FIFO_seq_item::type_id::create("write_only_seq"); // create a sequence item

                /////////////// Edit Constraints /////////////////
                //////////////////////////////////////////////////
                write_only_seq.constraint_mode(0);  // disable all constraints 
                write_only_seq.write_only.constraint_mode(1);  // enable write only constraint
                write_only_seq.reset_c.constraint_mode(1);   // enable reset constraint
                start_item(write_only_seq);
                assert(write_only_seq.randomize());
                finish_item(write_only_seq);
            end
        endtask
    endclass 
    
endpackage
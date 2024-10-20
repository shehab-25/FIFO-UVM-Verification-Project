package FIFO_read_write_sequence_pkg;
    import shared_pkg::*;
    import FIFO_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_read_write_sequence extends uvm_sequence #(FIFO_seq_item);
        `uvm_object_utils(FIFO_read_write_sequence)
        FIFO_seq_item read_write_seq;

        // constructor
        function new(string name = "FIFO_read_write_sequence");
            super.new(name);
        endfunction

        task body();
            repeat(1000) begin
                read_write_seq = FIFO_seq_item::type_id::create("read_write_seq"); // create a sequence item

                /////////////// Edit Constraints /////////////////
                //////////////////////////////////////////////////
                read_write_seq.constraint_mode(0);  // disable all constraints 
                read_write_seq.write_and_read.constraint_mode(1);  // enable read_write constraint
                read_write_seq.reset_c.constraint_mode(1);   // enable reset constraint
                start_item(read_write_seq);
                assert(read_write_seq.randomize());
                finish_item(read_write_seq);
            end
        endtask
    endclass 
    
endpackage
package FIFO_read_only_sequence_pkg;
    import shared_pkg::*;
    import FIFO_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_read_only_sequence extends uvm_sequence #(FIFO_seq_item);
        `uvm_object_utils(FIFO_read_only_sequence)
        FIFO_seq_item read_only_seq;

        // constructor
        function new(string name = "FIFO_read_only_sequence");
            super.new(name);
        endfunction

        task body();
            repeat(1000) begin
                read_only_seq = FIFO_seq_item::type_id::create("read_only_seq"); // create a sequence item

                /////////////// Edit Constraints /////////////////
                //////////////////////////////////////////////////
                read_only_seq.constraint_mode(0);  // disable all constraints 
                read_only_seq.read_only.constraint_mode(1);  // enable read only constraint
                read_only_seq.reset_c.constraint_mode(1);   // enable reset constraint
                start_item(read_only_seq);
                assert(read_only_seq.randomize());
                finish_item(read_only_seq);
            end
        endtask
    endclass 
    
endpackage
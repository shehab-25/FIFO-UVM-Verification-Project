package FIFO_seq_item_pkg;
    import shared_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_seq_item extends uvm_sequence_item;
        `uvm_object_utils(FIFO_seq_item)

        // Define signals of sequence items 
        rand logic [FIFO_WIDTH-1:0] data_in;
        rand logic rst_n, wr_en, rd_en;

        logic [FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow;
        logic wr_ack_ref, overflow_ref;

        logic [FIFO_WIDTH-1:0] data_out_ref;
        logic full, empty, almostfull, almostempty, underflow;
        logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

        // constructor
        function new(string name = "FIFO_seq_item");
            super.new(name);
        endfunction

        // print all inputs and outputs
        function string convert2string(); 
            return $sformatf("%s rst_n= %b , wr_en= %b , rd_en= %b , data_in= %0h , data_out = %0h, wr_ack = %0b, full = %0b, empty = %0b, underflow = %0b, almostempty = %0b, almostfull = %0b, overflow = %0b"
            ,super.convert2string(),rst_n,wr_en,rd_en,data_in,data_out,wr_ack,full,empty,underflow,almostempty,almostfull,overflow);
        endfunction

        // print inputs only 
        function string convert2string_stimulus();
            return $sformatf("rst_n= %b , wr_en= %b , rd_en= %b , data_in= %0h",rst_n,wr_en,rd_en,data_in);
        endfunction

        // print reference outputs 
        function string convert2string_ref();
            return $sformatf("data_out_ref= %0h, wr_ack_ref = %0b, full_ref = %0b, empty_ref = %0b, underflow_ref = %0b, almostempty_ref = %0b, almostfull_ref = %0b, overflow_ref = %0b"
            ,data_out_ref,wr_ack_ref,full_ref,empty_ref,underflow_ref,almostempty_ref,almostfull_ref,overflow_ref);
        endfunction

        /////////////// constraints ///////////////////
        ///////////////////////////////////////////////
        constraint reset_c {
            rst_n dist {1:=96 , 0:=4};
        }

        // write and read with different probabilities ==> for write_read sequence
        constraint write_and_read {
            wr_en dist {1:= WR_EN_ON_DIST , 0:= 100-WR_EN_ON_DIST};
            rd_en dist {1:= RD_EN_ON_DIST , 0:= 100-RD_EN_ON_DIST};
        }

        // only read constraint for read_only sequence
        constraint read_only {
            rd_en == 1;
            wr_en == 0;
        }

         // only write constraint for write_only sequence
        constraint write_only {
            rd_en == 0;
            wr_en == 1;
        }
    endclass 
endpackage
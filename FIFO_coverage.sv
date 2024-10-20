package FIFO_coverage_pkg;
    import shared_pkg::*;
    import uvm_pkg::*;
    import FIFO_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_coverage extends uvm_component;
        `uvm_component_utils(FIFO_coverage)
        uvm_analysis_export #(FIFO_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;
        FIFO_seq_item cov_seq_item;

        /////////////// covergroups ///////////////////////
        //////////////////////////////////////////////////
        covergroup write_read_cover;
            rst_cvg:          coverpoint cov_seq_item.rst_n;          //coverpoint for rst_n signal
            write_enable_cvg: coverpoint cov_seq_item.wr_en;          //coverpoint for write_en signal
            read_enable_cvg : coverpoint cov_seq_item.rd_en;          //coverpoint for read_en signal
            full_cvg:         coverpoint cov_seq_item.full;           //coverpoint for full flag output
            empty_cvg:        coverpoint cov_seq_item.empty;          //coverpoint for empty flag output
            almost_full_cvg:  coverpoint cov_seq_item.almostfull;     //coverpoint for almostfull flag output
            almost_empty_cvg: coverpoint cov_seq_item.almostempty;    //coverpoint for almostempty flag output
            write_ack_cvg:    coverpoint cov_seq_item.wr_ack;         //coverpoint for write_ack flag output
            overflow_cvg:     coverpoint cov_seq_item.overflow;       //coverpoint for overflow flag output
            underflow_cvg:    coverpoint cov_seq_item.underflow;      //coverpoint for underflow flag output

            write_read_full:        cross write_enable_cvg,read_enable_cvg,full_cvg{                     // cross between wr_en , rd_en , full
                //not important for full output if read_en = 1 (as full=1 may only when wr_en=1)
                ignore_bins full_read_en00 = binsof(read_enable_cvg) intersect {1} && binsof(full_cvg) intersect {1};
            }

            write_read_empty:       cross write_enable_cvg,read_enable_cvg,empty_cvg;               // cross between wr_en , rd_en , empty
            write_read_almost_full: cross write_enable_cvg,read_enable_cvg,almost_full_cvg;         // cross between wr_en , rd_en , almostfull
            write_read_almostempty: cross write_enable_cvg,read_enable_cvg,almost_empty_cvg;        // cross between wr_en , rd_en , almostempty

            write_read_wr_ack:      cross write_enable_cvg,read_enable_cvg,write_ack_cvg{            // cross between wr_en , rd_en , wr_ack
                //not important for wr_ack output if write_en = 0 (as wr_ack=1 only when wr_en=1)
                ignore_bins wr_ack_wr_en00 = binsof(write_enable_cvg) intersect {0} && binsof(write_ack_cvg) intersect {1};  
            }

            write_read_overflow:    cross write_enable_cvg,read_enable_cvg,overflow_cvg{             // cross between wr_en , rd_en , overflow
                //not important for overflow output if write_en = 0 (as overflow occurs only when wr_en=1)
                ignore_bins write_overflow00 = binsof(write_enable_cvg) intersect {0} && binsof(overflow_cvg) intersect {1};  
            }

            write_read_underflow:   cross write_enable_cvg,read_enable_cvg,underflow_cvg{            // cross between wr_en , rd_en , underflow
                //not important for underflow output if read_en = 0 (as underflow occurs only when rd_en=1)
                ignore_bins read_underflow00 = binsof(read_enable_cvg) intersect {0} && binsof(underflow_cvg) intersect {1};  
            }
        endgroup

        // constructor
        function new(string name = "FIFO_coverage" , uvm_component parent = null);
            super.new(name,parent);
            write_read_cover = new();
        endfunction

        // build_phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export",this);
            cov_fifo = new("cov_fifo",this);
        endfunction

        // connect_phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        // run_phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(cov_seq_item);
                write_read_cover.sample();
            end
        endtask 
    endclass
endpackage
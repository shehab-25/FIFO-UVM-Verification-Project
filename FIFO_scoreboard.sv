package FIFO_scoreboard_pkg;
    import shared_pkg::*;
    import uvm_pkg::*;
    import FIFO_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(FIFO_scoreboard)

    uvm_analysis_export #(FIFO_seq_item) sb_export;
    uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;
    FIFO_seq_item sb_seq_item;
    int correct_count = 0;
    int error_count = 0;
    
    // constructor
    function new(string name = "FIFO_scoreboard" , uvm_component parent = null);
        super.new(name,parent);
    endfunction
        
    //build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export",this);
        sb_fifo = new("sb_fifo",this);
    endfunction

    //connect_phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
    endfunction

    //run_phase
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            sb_fifo.get(sb_seq_item);

            //checking
            if (sb_seq_item.data_out != sb_seq_item.data_out_ref 
            || sb_seq_item.wr_ack != sb_seq_item.wr_ack_ref 
            || sb_seq_item.overflow != sb_seq_item.overflow_ref
            || sb_seq_item.underflow != sb_seq_item.underflow_ref
            || sb_seq_item.full != sb_seq_item.full_ref
            || sb_seq_item.empty != sb_seq_item.empty_ref
            || sb_seq_item.almostfull != sb_seq_item.almostfull_ref
            || sb_seq_item.almostempty != sb_seq_item.almostempty_ref) begin

                `uvm_error("run_phase" , $sformatf("comparison failed , transaction recieved by the DUT: %0s\n , while the correct outputs: %0s "
                ,sb_seq_item.convert2string() , sb_seq_item.convert2string_ref()));
                error_count++;
            end
            else begin
                correct_count++;
            end
        end
    endtask

    // report_phase
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase", $sformatf("Total successful transactions: %0d", correct_count), UVM_MEDIUM)
        `uvm_info("report_phase", $sformatf("Total failed transactions: %0d", error_count), UVM_MEDIUM)
    endfunction    
    endclass 
endpackage
package FIFO_test_pkg;
    import uvm_pkg::*;
    import shared_pkg::*;
    import FIFO_env_pkg::*;
    import FIFO_read_only_sequence_pkg::*;
    import FIFO_write_only_sequence_pkg::*;
    import FIFO_read_write_sequence_pkg::*;
    import FIFO_rst_sequence_pkg::*;
    import FIFO_config_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_test extends uvm_test;
        `uvm_component_utils(FIFO_test)
        FIFO_env env;
        virtual FIFO_interface FIFO_vif;
        FIFO_config FIFO_cfg;
        FIFO_rst_sequence rst_seq;
        FIFO_read_only_sequence rd_seq;
        FIFO_write_only_sequence wr_seq;
        FIFO_read_write_sequence rd_wr_seq;

        //constructor
        function new(string name = "FIFO_test" ,uvm_component parent = null);
            super.new(name,parent);
        endfunction 

        //build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = FIFO_env::type_id::create("env",this);
            FIFO_cfg = FIFO_config::type_id::create("FIFO_cfg",this);
            rst_seq = FIFO_rst_sequence::type_id::create("rst_seq",this);
            rd_seq = FIFO_read_only_sequence::type_id::create("rd_seq",this);
            wr_seq = FIFO_write_only_sequence::type_id::create("wr_seq",this);
            rd_wr_seq = FIFO_read_write_sequence::type_id::create("rd_wr_seq",this);

            if (!uvm_config_db #(virtual FIFO_interface)::get(this , "" , "FIFO_IF" , FIFO_cfg.FIFO_vif)) begin
                `uvm_fatal("build_phase" , "Test - unable to get the virtual interface of FIFO from uvm_config_db");
            end
            uvm_config_db #(FIFO_config)::set(this , "*" , "CFG" , FIFO_cfg);
        endfunction

        //run phase
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);

            //reset seq
            `uvm_info("run_phase", "reset_asserted" , UVM_LOW)
            rst_seq.start(env.agt.sqr);
            `uvm_info("run_phase" , "reset_deasserted" , UVM_LOW)

            //write_only sequence
            `uvm_info("run_phase", "stimulus generation started" , UVM_LOW)
            wr_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "stimulus generation ended" , UVM_LOW)

            //read_only sequence
            `uvm_info("run_phase", "stimulus generation started" , UVM_LOW)
            rd_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "stimulus generation ended" , UVM_LOW)

            // write_read sequence
            `uvm_info("run_phase", "stimulus generation started" , UVM_LOW)
            rd_wr_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "stimulus generation ended" , UVM_LOW)

            phase.drop_objection(this);
        endtask

    endclass
    
endpackage
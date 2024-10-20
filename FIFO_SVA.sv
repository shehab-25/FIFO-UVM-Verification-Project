import shared_pkg::*;

module FIFO_SVA (FIFO_interface.DUT FIFO_if);
    
	`ifdef FIFO_Assertions

	//immediate assertions (combinational outputs)
	always_comb begin
		if(!FIFO_if.rst_n) begin
			reset_ass: assert final((!FIFO_DUT.count) && (!FIFO_DUT.rd_ptr) && (!FIFO_DUT.wr_ptr))
			else $display("at time: %t , reset fails",$time);
		end
		full_ass:         assert final(FIFO_if.full == (FIFO_DUT.count == FIFO_DEPTH)? 1 : 0)         else $display("at time: %t , full fails",$time);
		empty_ass:        assert final(FIFO_if.empty == (FIFO_DUT.count == 0)? 1 : 0)                 else $display("at time: %t , empty fails",$time);
		almostfull_ass:   assert final(FIFO_if.almostfull == (FIFO_DUT.count == FIFO_DEPTH-1)? 1 : 0) else $display("at time: %t , almost full fails",$time);
		almost_empty_ass: assert final(FIFO_if.almostempty == (FIFO_DUT.count == 1)? 1 : 0 )          else $display("at time: %t , almost empty fails",$time);
	end

	//concurrent assertions 
	// full signal
	property full_inactive;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.full && FIFO_if.rd_en) |=> (!FIFO_if.full && $rose(FIFO_if.almostfull));
	endproperty

	property full_after_almostfull;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.almostfull && FIFO_if.wr_en && !FIFO_if.rd_en) |=> ($fell(FIFO_if.almostfull) && FIFO_if.full);
	endproperty

	// almost full signal
	property almostfull_from_full;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.full && FIFO_if.rd_en) |=> ($fell(FIFO_if.full) && $rose(FIFO_if.almostfull));
	endproperty

	property almostfull_inactive;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.almostfull && FIFO_if.rd_en && !FIFO_if.wr_en) |=> !FIFO_if.almostfull;
	endproperty

	// empty signal
	property empty_inactive;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.empty && FIFO_if.wr_en) |=> ($fell(FIFO_if.empty) && $rose(FIFO_if.almostempty));
	endproperty

	property empty_from_almostempty;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.almostempty && FIFO_if.rd_en && !FIFO_if.wr_en) |=> (FIFO_if.empty && $fell(FIFO_if.almostempty));
	endproperty

	// almost empty signal
	property almsotempty_inactive;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.almostempty && !FIFO_if.rd_en && FIFO_if.wr_en) |=> !FIFO_if.almostempty;
	endproperty

	property almsotempty_from_empty;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.empty && FIFO_if.wr_en && !FIFO_if.rd_en) |=> ($rose(FIFO_if.almostempty) && $fell(FIFO_if.empty));
	endproperty


	// overflow signal
	property overflow_ass;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.full && FIFO_if.wr_en) |=> FIFO_if.overflow;
	endproperty

	// underflow signal
	property underflow_ass;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.empty && FIFO_if.rd_en) |=> FIFO_if.underflow;
	endproperty

	// wr_ack signal
	property wr_ack_active;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (!FIFO_if.full && FIFO_if.wr_en) |=> FIFO_if.wr_ack;
	endproperty

	property wr_ack_inactive;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.full || !FIFO_if.wr_en) |=> !FIFO_if.wr_ack;
	endproperty

	// write pointer internal signal
	property wr_ptr_ass;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (!FIFO_if.full && FIFO_if.wr_en) |=> FIFO_DUT.wr_ptr == $past(FIFO_DUT.wr_ptr) + 1'b1;
	endproperty

	// read pointer internal signal
	property rd_ptr_ass;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (!FIFO_if.empty && FIFO_if.rd_en) |=> FIFO_DUT.rd_ptr == $past(FIFO_DUT.rd_ptr) + 1'b1;
	endproperty

	// counter internal signal
	property count_inc_ass;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.wr_en && !FIFO_if.full && !FIFO_if.rd_en) |=> FIFO_DUT.count == $past(FIFO_DUT.count) + 1'b1;
	endproperty

	property count_dec_ass;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (!FIFO_if.wr_en && FIFO_if.rd_en && !FIFO_if.empty) |=> FIFO_DUT.count == $past(FIFO_DUT.count) - 1'b1;
	endproperty

	property count_const_ass;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.wr_en && FIFO_if.rd_en && !FIFO_if.empty && !FIFO_if.full) |=> FIFO_DUT.count == $past(FIFO_DUT.count);
	endproperty


	// assert properties
	full_inactive_assert: assert property(full_inactive) else $display("at time %t : full inactive Fails",$time);
	full_after_almostfull_assert: assert property(full_after_almostfull) else $display("at time %t : full_after_almostfull Fails",$time);
	almostfull_from_full_assert: assert property(almostfull_from_full) else $display("at time %t : almostfull_from_full Fails",$time);
	almostfull_inactive_assert: assert property(almostfull_inactive) else $display("at time %t : almostfull_inactive Fails",$time);
	empty_inactive_assert: assert property(empty_inactive) else $display("at time %t : empty_inactive Fails",$time);
	empty_from_almostempty_assert: assert property(empty_from_almostempty) else $display("at time %t : empty_from_almostempty Fails",$time);
	almsotempty_inactive_assert: assert property(almsotempty_inactive) else $display("at time %t : almsotempty_inactive Fails",$time);
	almsotempty_from_empty_assert: assert property(almsotempty_from_empty) else $display("at time %t : almsotempty_from_empty Fails",$time);
	overflow_assert: assert property(overflow_ass) else $display("at time %t : overflow Fails",$time);
	underflow_assert: assert property(underflow_ass) else $display("at time %t : underflow Fails",$time);
	wr_ack_assert: assert property(wr_ack_active) else $display("at time %t : write ack Fails",$time);
	wr_ack_inactive_assert: assert property(wr_ack_inactive) else $display("at time %t : write ack Fails",$time);
	wr_ptr_assert: assert property(wr_ptr_ass) else $display("at time %t : write pointer Fails",$time);
	rd_ptr_assert: assert property(rd_ptr_ass) else $display("at time %t : read pointer Fails",$time);
	count_inc_assert: assert property(count_inc_ass) else $display("at time %t : counter increment Fails",$time);
	count_dec_assert: assert property(count_dec_ass) else $display("at time %t : counter decrement Fails",$time);
	count_const_assert: assert property(count_const_ass) else $display("at time %t : counter const Fails",$time);

	// cover properties
	full_inactive_cover: cover property(full_inactive);
	full_after_almostfull_cover: cover property(full_after_almostfull); 
	almostfull_from_full_cover: cover property(almostfull_from_full);
	almostfull_inactive_cover: cover property(almostfull_inactive);
	empty_inactive_cover: cover property(empty_inactive);
	empty_from_almostempty_cover: cover property(empty_from_almostempty);
	almsotempty_inactive_cover: cover property(almsotempty_inactive);
	almsotempty_from_empty_cover: cover property(almsotempty_from_empty); 
	overflow_cover: cover property (overflow_ass);
	underflow_cover: cover property (underflow_ass);
	wr_ack_cover: cover property(wr_ack_active);
	wr_ack_inactive_cover: cover property(wr_ack_inactive);
	wr_ptr_cover: cover property (wr_ptr_ass);
	rd_ptr_cover: cover property (rd_ptr_ass);
	count_inc_cover: cover property (count_inc_ass);
	count_dec_cover: cover property (count_dec_ass);
	count_const_cover: cover property (count_const_ass);
	`endif
endmodule
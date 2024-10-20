////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM 
//
// Description: FIFO Design (modified and fixed by Shehab Eldeen Khaled Mabrouk)
// 
////////////////////////////////////////////////////////////////////////////////
import shared_pkg::*;

module FIFO(FIFO_interface.DUT FIFO_if);
	
	localparam max_fifo_addr = $clog2(FIFO_DEPTH);

	reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

	reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
	reg [max_fifo_addr:0] count;

	// write operation
	always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
		if (!FIFO_if.rst_n) begin
			wr_ptr <= 0;
			FIFO_if.overflow <= 0;  //fix: overflow signal should be zero at reset
			FIFO_if.wr_ack <= 0;    //fix: write_ack signal should be zero at reset
		end
		else if (FIFO_if.wr_en && count < FIFO_DEPTH) begin
			mem[wr_ptr] <= FIFO_if.data_in;
			FIFO_if.wr_ack <= 1;
			wr_ptr <= wr_ptr + 1;
			FIFO_if.overflow <= 0;  //fix: due to FIFO is not full , so overflow should be zero
		end
		else begin 
			FIFO_if.wr_ack <= 0; 
			if (FIFO_if.full && FIFO_if.wr_en)
				FIFO_if.overflow <= 1;
			else
				FIFO_if.overflow <= 0;
		end
	end

	// read operation
	always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
		if (!FIFO_if.rst_n) begin
			rd_ptr <= 0;
			FIFO_if.underflow <= 0;   //fix: underflow signal should be zero at reset
			FIFO_if.data_out <= 0;    //fix: dataout signal should be zero at reset
		end
		else if (FIFO_if.rd_en && count != 0) begin
			FIFO_if.data_out <= mem[rd_ptr];
			rd_ptr <= rd_ptr + 1;
			FIFO_if.underflow <= 0;    //fix: due to FIFO is not empty , so underflow should be zero
		end

		else begin   //fix : underflow output is sequential output not combinational
			if (FIFO_if.rd_en && FIFO_if.empty) begin
				FIFO_if.underflow <= 1;       //fix
			end
			else begin
				FIFO_if.underflow <= 0;        //fix
			end
		end
	end

	always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
		if (!FIFO_if.rst_n) begin
			count <= 0;
		end
		else begin
			if (({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b11) && FIFO_if.full) begin 
                    count <= count-1;  //fix: when both wr_en and rd_en are high , and full=1 , only read operation will occur
            end
			else if (({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b11) && FIFO_if.empty) begin  //fix
                    count <= count+1; //fix: when both wr_en and rd_en are high , and empty=1 , only write operation will occur
            end
			else if (({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b11) && !FIFO_if.full && !FIFO_if.empty) begin  //fix
                    count <= count; //fix: when both wr_en and rd_en are high , and both empty=0 and full=0 , both operations (read,write) will occur
            end
			else if ( ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b10) && !FIFO_if.full) 
				count <= count + 1;
			else if ( ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b01) && !FIFO_if.empty)
				count <= count - 1;
		end
	end

	assign FIFO_if.full = (count == FIFO_DEPTH)? 1 : 0;
	assign FIFO_if.empty = (count == 0)? 1 : 0;
	assign FIFO_if.almostfull = (count == FIFO_DEPTH-1)? 1 : 0; //fix : almostfull signal is high when count=FIFO_DEPTH-1 not FIFO_DEPTH-2
	assign FIFO_if.almostempty = (count == 1)? 1 : 0;
endmodule
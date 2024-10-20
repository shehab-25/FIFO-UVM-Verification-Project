import shared_pkg::*;
module FIFO_golden (FIFO_interface.golden FIFO_if);

    reg [FIFO_WIDTH-1:0] fifo_queue [$];
    
    // Write operation
    always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
        if (!FIFO_if.rst_n) begin
            fifo_queue.delete();
            FIFO_if.wr_ack_ref <= 0;
            FIFO_if.overflow_ref <= 0;
        end
        else if (FIFO_if.wr_en && !FIFO_if.full_ref) begin
            fifo_queue.push_back(FIFO_if.data_in);
            FIFO_if.wr_ack_ref <= 1;
            FIFO_if.overflow_ref <= 0;
        end
        else begin
            FIFO_if.wr_ack_ref <= 0;
            if (FIFO_if.full_ref && FIFO_if.wr_en)
                FIFO_if.overflow_ref <= 1;
            else
                FIFO_if.overflow_ref <= 0;
        end
    end

    // Read operation
    always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
        if (!FIFO_if.rst_n) begin
            fifo_queue.delete();
            FIFO_if.underflow_ref <= 0;
            FIFO_if.data_out_ref <= 0;
        end
        else if (FIFO_if.rd_en && !FIFO_if.empty_ref) begin
            FIFO_if.data_out_ref <= fifo_queue.pop_front();
            FIFO_if.underflow_ref <= 0;
        end
        else begin
            if (FIFO_if.empty_ref && FIFO_if.rd_en)
                FIFO_if.underflow_ref <= 1;
            else 
                FIFO_if.underflow_ref <= 0;
        end
    end

    // combinational outputs 
    assign FIFO_if.full_ref = (fifo_queue.size() >= FIFO_DEPTH )? 1:0;
    assign FIFO_if.almostfull_ref = (fifo_queue.size() == FIFO_DEPTH-1)? 1:0;
    assign FIFO_if.empty_ref = (fifo_queue.size() == 0)? 1:0;
    assign FIFO_if.almostempty_ref = (fifo_queue.size() == 1)? 1:0;
endmodule
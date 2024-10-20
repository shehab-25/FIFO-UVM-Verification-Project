vlib work
vlog -f src_files.list +define+FIFO_Assertions +cover -covercells
vsim -voptargs=+acc work.FIFO_top -cover -classdebug -uvmcontrol=all
add wave /FIFO_top/FIFO_if/*
add wave -position insertpoint  \
sim:/FIFO_top/FIFO_DUT/wr_ptr \
sim:/FIFO_top/FIFO_DUT/rd_ptr \
sim:/FIFO_top/FIFO_DUT/count
add wave -position insertpoint  \
sim:/FIFO_top/FIFO_DUT/mem
coverage save FIFO_tb.ucdb -onexit
run -all
/////////////////////////////////////////////
// Module : spi_test.svh        
// Project : Fall 2020 project            
// Task : Creates the SPI top module
// Author : Project group-1 (EE273)         
/////////////////////////////////////////////
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "defs.svh"
`include "spi_interface.svh"
`include "spi_sequencer.svh"
`include "spi_sequence.svh"
`include "spi_driver.svh"
`include "spi_input_monitor.svh"
`include "spi_output_monitor.svh"
`include "spi_agent.svh"
`include "SPCR_decoder.svh"
`include "sclk_detector.svh"
`include "sclk_predictor.svh"
`include "predictor.svh"
`include "data_sampler.svh"
`include "spi_checker.svh"
`include "SPSR_decoder.svh"
`include "spi_environment.svh"
`include "spi_test.svh"
`include "spi_wrapper.svh"

module top();

spi_interface spi_inf();
spi_wrap dut(spi_inf.spi);

initial begin
	spi_inf.pclk = 0;
	//spi_inf.penable = 1'b0;
	forever #5 begin spi_inf.pclk = ~spi_inf.pclk; end
end

initial begin
	spi_inf.preset = 1'b0;
	spi_inf.penable = 1'b0;
	#20 spi_inf.preset = 1'b1; 
	    spi_inf.penable = 1'b0;
	#10 spi_inf.penable = 1'b1;
	#10 spi_inf.penable = 1'b0;
	#1550 spi_inf.penable = 1'b1;
	#10 spi_inf.penable = 1'b0;
	#1550 spi_inf.penable = 1'b1;
	#10 spi_inf.penable = 1'b0;
	#1550 spi_inf.penable = 1'b1;
	#10 spi_inf.penable = 1'b0;
	#1550 spi_inf.penable = 1'b1;
	#10 spi_inf.penable = 1'b0;
	#1550 spi_inf.penable = 1'b1;
	#10 spi_inf.penable = 1'b0;
	#1550 spi_inf.penable = 1'b1;
	#10 spi_inf.penable = 1'b0;
	#1550 spi_inf.penable = 1'b1;
	#10 spi_inf.penable = 1'b0;
	#1550 spi_inf.penable = 1'b1;
	#10 spi_inf.penable = 1'b0;
	#1550 spi_inf.penable = 1'b1;
	#10 spi_inf.penable = 1'b0;
	#1550 spi_inf.penable = 1'b1;
	#10 spi_inf.penable = 1'b0;
	#1550 spi_inf.penable = 1'b1;
	#10 spi_inf.penable = 1'b0;
	#1550 spi_inf.penable = 1'b1;
	#10 spi_inf.penable = 1'b0;
	#1550 spi_inf.penable = 1'b1;
	#10 spi_inf.penable = 1'b0;
	#1550 spi_inf.penable = 1'b1;
	#10 spi_inf.penable = 1'b0;
	#1550 spi_inf.penable = 1'b1;
	#10 spi_inf.penable = 1'b0;
	#1550 spi_inf.penable = 1'b1;
end 

initial begin
	uvm_config_db #(virtual spi_interface)::set(null, "", "spi_inf", spi_inf);
	run_test("spi_test");
end 

initial begin 
	$dumpfile("spi.vcd");
	$dumpvars;
end

endmodule : top

/////////////////////////////////////////////
// Module : sclk_detector.svh        
// Project : Fall 2020 project            
// Task : Creates the SPI scoreboard class 
// Author : Project group-1 (EE273)         
/////////////////////////////////////////////

//This scoreboard collects the SCLK and detects its rising and falling edge and sends it to data_sampler scoreboard
class sclk_detector extends uvm_scoreboard;
`uvm_component_utils(sclk_detector)

uvm_analysis_port #(reg) to_data_sampler_re_clk;
uvm_analysis_port #(reg) to_data_sampler_fe_clk;
uvm_analysis_port #(reg) to_data_sampler_MOSI;

uvm_tlm_analysis_fifo #(reg) from_output_monitor_sclk;
uvm_tlm_analysis_fifo #(reg) from_output_monitor_MOSI;

reg spi_clk, old_sclk;
reg edge_detected;
reg MOSI;


	function new (string name = "sclk_detector", uvm_component parent = null);
			super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		from_output_monitor_sclk = new("from_output_monitor_sclk", this);
		to_data_sampler_fe_clk = new("to_data_sampler_fe_clk", this);
		to_data_sampler_re_clk = new("to_data_sampler_re_clk", this);
		from_output_monitor_MOSI = new("from_output_monitor_MOSI", this);
		to_data_sampler_MOSI = new("to_data_sampler_MOSI", this);
	endfunction : build_phase
	
	virtual task run_phase(uvm_phase phase);
	old_sclk = 1'b0;
	edge_detected = 1'b0;
	spi_clk = 1'bx;
		forever begin
			from_output_monitor_sclk.get(spi_clk);
			from_output_monitor_MOSI.get(MOSI);
			if((old_sclk == 1'b0) && (spi_clk == 1'b1)) begin
				to_data_sampler_re_clk.write(1'b1);
				to_data_sampler_MOSI.write(MOSI);
			end
			else if((old_sclk == 1'b1) && (spi_clk == 1'b0)) begin
				to_data_sampler_fe_clk.write(1'b1);
				to_data_sampler_MOSI.write(MOSI); 
			end
			else begin 
				to_data_sampler_re_clk.write(1'b0);
				to_data_sampler_fe_clk.write(1'b0);
				to_data_sampler_MOSI.write(MOSI);
			end
			old_sclk = spi_clk;
		end
	endtask : run_phase
	
endclass : sclk_detector

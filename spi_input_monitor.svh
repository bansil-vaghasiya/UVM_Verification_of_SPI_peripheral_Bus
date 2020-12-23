/////////////////////////////////////////////
// Module : spi_input_monitor.svh        
// Project : Fall 2020 project            
// Task : Creates the SPI input monitor class 
// Author : Project group-1 (EE273)         
/////////////////////////////////////////////

class spi_input_monitor extends uvm_monitor;
`uvm_component_utils(spi_input_monitor)

uvm_analysis_port #(reg) to_predictor_penable;  //sending penable signal to predictor
uvm_analysis_port #(reg[15:0]) to_spcr_decoder_SPCR; //sending control register data to predictor
uvm_analysis_port #(reg[15:0]) to_predictor_pdata; //sending data to predictor

virtual spi_interface v_if;

	function new (string name = "spi_input_monitor", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		to_predictor_penable = new("to_predictor_penable", this);
		to_spcr_decoder_SPCR = new("to_spcr_decoder_SPCR", this);
		to_predictor_pdata = new("to_predictor_pdata", this);
		if(!uvm_config_db #(virtual spi_interface)::get(this, "*", "spi_inf", v_if))
				begin
				`uvm_fatal(get_type_name(), "Did not get the handle to virtual interface spi_interface")
				end
	endfunction : build_phase

	virtual task run_phase(uvm_phase phase);
		forever begin 
			@(posedge v_if.pclk) begin 
				to_predictor_penable.write(v_if.penable);
				to_spcr_decoder_SPCR.write(v_if.SPCR);
				to_predictor_pdata.write(v_if.pdata);
			end
		end
	endtask : run_phase

endclass : spi_input_monitor

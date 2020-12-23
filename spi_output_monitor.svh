/////////////////////////////////////////////
// Module : spi_output monitor.svh        
// Project : Fall 2020 project            
// Task : Creates the SPI output monitor class 
// Author : Project group-1 (EE273)         
/////////////////////////////////////////////

class spi_output_monitor extends uvm_monitor;
`uvm_component_utils(spi_output_monitor)

uvm_analysis_port #(reg) to_sclk_detector_SCLK; //sends SCLK value out from DUT
uvm_analysis_port #(reg) to_data_sampler_MOSI; //sends MOSI value out from DUT
uvm_analysis_port #(reg[7:0]) to_spsr_decoder_SR; //sends status register data out from DUT
uvm_analysis_port #(reg) to_data_sampler_PSEL; //sends slave select signal received from DUT 
uvm_analysis_port #(reg) to_data_sampler_TX_ready; //sends TX ready bit : indicated data sampling started
uvm_analysis_port #(reg) to_predictor_O_Data_Ready; //sends Data ready bit : indicates sampling done

	virtual spi_interface v_if;

	function new (string name = "spi_output_monitor", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		to_sclk_detector_SCLK = new("to_sclk_detector_SCLK", this);
		to_data_sampler_MOSI = new("to_data_sampler_MOSI", this);
		to_spsr_decoder_SR = new("to_spsr_decoder_SR", this);
		to_data_sampler_PSEL = new("to_data_sampler_PSEL", this);
		to_data_sampler_TX_ready = new("to_data_sampler_TX_ready", this);
		to_predictor_O_Data_Ready = new("to_predictor_O_Data_Ready", this);
		if(!uvm_config_db #(virtual spi_interface)::get(this, "*", "spi_inf", v_if))
				begin
				`uvm_fatal(get_type_name(), "Did not get the handle to virtual interface spi_interface")
				end
	endfunction : build_phase
	
	virtual task run_phase(uvm_phase phase);
		forever begin 
			@(posedge v_if.pclk && v_if.preset) begin
				to_sclk_detector_SCLK.write(v_if.Sclk);
				to_data_sampler_MOSI.write(v_if.MOSI);
				to_spsr_decoder_SR.write(v_if.SPSR);
				to_data_sampler_PSEL.write(v_if.psel);
				to_data_sampler_TX_ready.write(v_if.s_TX_ready);
				to_predictor_O_Data_Ready.write(v_if.O_Data_Ready);
			end
		end
	endtask : run_phase

endclass : spi_output_monitor

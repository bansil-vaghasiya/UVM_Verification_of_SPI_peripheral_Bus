////////////////////////////////////////////////////////
// Module : SPCR_decoder.svh        
// Project : Fall 2020 project            
// Task : Creates the SPI status register decoder class 
// Author : Project group-1 (EE273)         
////////////////////////////////////////////////////////

class SPSR_decoder extends uvm_scoreboard;
`uvm_component_utils(SPSR_decoder)

uvm_tlm_analysis_fifo #(reg[7:0]) from_output_monitor_SPSR;

reg [7:0] sr;
reg WCOL;
reg SPIF;
	function new (string name = "SPSR_decoder", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		from_output_monitor_SPSR = new("from_output_monitor_SPSR", this);
	endfunction : build_phase
	
	virtual task run_phase(uvm_phase phase);
	WCOL = 1'bx;
	SPIF = 1'bx;
	forever begin 
		from_output_monitor_SPSR.get(sr);
		WCOL = sr[6];
		SPIF = sr[7];
		if(sr[6] == 1'b1) begin 
			`uvm_error("SPSR_decoder", "Write Collision detected --------- PDATA changed during the data transfer")
		end

		if(sr[7] == 1'b1) begin
			`uvm_info("SPSR_decoder", $sformatf("Master has completed the data transfer"), UVM_HIGH)
		end
	end
	endtask : run_phase

endclass : SPSR_decoder

////////////////////////////////////////////////////////
// Module : SPCR_decoder.svh        
// Project : Fall 2020 project            
// Task : Creates the SPI control register decoder class 
// Author : Project group-1 (EE273)         
////////////////////////////////////////////////////////

class SPCR_decoder extends uvm_scoreboard;
`uvm_component_utils(SPCR_decoder)

uvm_tlm_analysis_fifo #(reg[15:0]) from_input_monitor_SPCR;

uvm_analysis_port #(reg) to_data_sampler_BitEnable;
uvm_analysis_port #(reg) to_data_sampler_cpha;
uvm_analysis_port #(reg) to_data_sampler_cpol;
uvm_analysis_port #(reg) to_data_sampler_MSTR;
uvm_analysis_port #(reg) to_data_sampler_LSBF;
uvm_analysis_port #(reg) to_data_sampler_SPIE;
uvm_analysis_port #(reg[3:0]) to_data_sampler_BITS;
uvm_analysis_port #(reg[4:0]) to_data_sampler_RX_cntr;
uvm_analysis_port #(reg[5:0]) to_sclk_predictor_Edges;

reg [15:0] cr;
reg BitEnable;
reg cpha, cpol;
reg MSTR;
reg LSBF;
reg SPIE;
reg [3:0] BITS;
reg [4:0] RX_cntr;
reg [5:0] Edges;



	function new (string name = "SPCR_decoder", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		from_input_monitor_SPCR = new("from_input_monitor_SPCR", this);
		to_data_sampler_BitEnable = new("to_data_sampler_BitEnable", this);
		to_data_sampler_cpha = new("to_data_sampler_cpha", this);
		to_data_sampler_cpol = new("to_data_sampler_cpol", this);
		to_data_sampler_MSTR = new("to_data_sampler_MSTR", this);
		to_data_sampler_LSBF = new("to_data_sampler_LSBF", this);
		to_data_sampler_SPIE = new("to_data_sampler_SPIE", this);
		to_data_sampler_BITS = new("to_data_sampler_BITS", this);
		to_data_sampler_RX_cntr = new("to_data_sampler_RX_cntr", this);
		to_sclk_predictor_Edges = new("to_sclk_predictor_Edges", this);
	endfunction : build_phase
	
	virtual task run_phase(uvm_phase phase);
	BitEnable = 1'bx;
	cpha = 1'bx;
	cpol = 1'bx;
	MSTR = 1'bx;
	LSBF = 1'bx;
	SPIE = 1'bx;
	BITS = 4'bx;
	RX_cntr = 5'bx;
	Edges = 6'bx;
	forever begin 
		from_input_monitor_SPCR.get(cr);
		//$display("SPCR : CR = %h, time = %4d", cr, $realtime);
		BitEnable = cr[2];
		{cpol, cpha} = cr[4:3];
		MSTR = cr[5];
		LSBF = cr[6];
		SPIE = cr[7];
		if(BitEnable == 1'b0) begin 
			BITS = 4'b1000;
			RX_cntr = 7;
			Edges = 8;
		end //if(BitEnable == 1'b0)
		else if(BitEnable == 1'b1) begin 
			case(cr[11:8]) inside
				8: begin BITS = 4'b1000; RX_cntr = 7;  Edges = 8; end
				9: begin BITS = 4'b1001; RX_cntr = 8; Edges = 9; end
				10: begin BITS = 4'b1010; RX_cntr = 9; Edges = 10; end
				11: begin BITS = 4'b1011; RX_cntr = 10; Edges = 11; end
				12: begin BITS = 4'b1100; RX_cntr = 11; Edges = 12; end
				13: begin BITS = 4'b1101; RX_cntr = 12; Edges = 13; end
				14: begin BITS = 4'b1110; RX_cntr = 13; Edges = 14; end
				15: begin BITS = 4'b1111; RX_cntr = 14; Edges = 15; end
				0: begin BITS = 4'b0000; RX_cntr = 15; Edges = 16; end
				default: begin BITS = 4'b1000; RX_cntr = 7; Edges = 8; end
			endcase
		end //else if(BitEnable == 1'b1)
		to_data_sampler_BitEnable.write(BitEnable); //writting BITENABLE data
		to_data_sampler_cpol.write(cpol); //writting CPOL data
		to_data_sampler_cpha.write(cpha); //writting CPHA data
		to_data_sampler_MSTR.write(MSTR); //writting MSTR data
		to_data_sampler_LSBF.write(LSBF); //writting LSBF data
		to_data_sampler_SPIE.write(SPIE); //writting SPIE data
		to_data_sampler_BITS.write(BITS); //writting BITS data
		to_data_sampler_RX_cntr.write(RX_cntr); //writting RX_cntr data
		to_sclk_predictor_Edges.write(Edges); //Writting Edges data
	end
	endtask : run_phase 
endclass : SPCR_decoder

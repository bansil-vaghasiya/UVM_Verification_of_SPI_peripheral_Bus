////////////////////////////////////////////////////////////
// Module : predictor.svh        
// Project : Fall 2020 project            
// Task : Creates the SPI predictor class -- reference model 
// Author : Project group-1 (EE273)         
////////////////////////////////////////////////////////////

//generate the expected data:
//to generate : need penable, pdata, cpha, TX_ready, RX_counter, sclk leading edge, sclk traling edge

class predictor extends uvm_scoreboard;
`uvm_component_utils(predictor)

uvm_tlm_analysis_fifo #(reg) from_input_monitor_penable; //to read the input valid signal
uvm_tlm_analysis_fifo #(reg[15:0]) from_input_monitor_pdata; //to read the input data
uvm_tlm_analysis_fifo #(reg) from_spcr_decoder_cpha; //to read the cpha data
uvm_tlm_analysis_fifo #(reg) from_output_monitor_TX_ready; //to read TX_ready signal : start sampling
uvm_tlm_analysis_fifo #(reg[4:0]) from_spcr_decoder_RX_cntr; //to read the RX_cntr value
uvm_tlm_analysis_fifo #(reg) from_sclk_predictor_sclk_leading_edge; //to read sclk rising edge
uvm_tlm_analysis_fifo #(reg) from_sclk_predictor_sclk_trailing_edge; //to read sclk falling edge
uvm_tlm_analysis_fifo #(reg) from_output_monitor_O_Data_Ready; // to read the Data ready signal

uvm_analysis_port #(reg[15:0]) to_checker_pdata_predicted; // to send predicted data

reg i_valid, i_valid_d;
reg [15:0] pdata_d, pdata_dd;
reg O_Data_Ready;
reg [4:0] TX_cntr, S_TX_cntr;
reg S_TX_ready;
reg CPHA;
reg R_Edge, F_Edge;
reg [15:0] pdata_predicted;


	function new (string name = "predictor", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		from_input_monitor_penable = new("from_input_monitor_penable", this);
		from_input_monitor_pdata = new("from_input_monitor_pdata", this);
		from_spcr_decoder_cpha = new("from_spcr_decoder_cpha", this);
		from_output_monitor_TX_ready = new("from_output_monitor_TX_ready", this);
		from_spcr_decoder_RX_cntr = new("from_spcr_decoder_RX_cntr", this);
		from_sclk_predictor_sclk_leading_edge = new("from_sclk_predictor_sclk_leading_edge", this);
		from_sclk_predictor_sclk_trailing_edge = new("from_sclk_predictor_sclk_trailing_edge", this);
		from_output_monitor_O_Data_Ready = new("from_output_monitor_O_Data_Ready", this);
		to_checker_pdata_predicted = new("to_checker_pdata_predicted", this);
	endfunction : build_phase
	
	task run_phase(uvm_phase phase);
	i_valid = 1'b0;
	i_valid_d = 1'b0;
	pdata_d = 16'bx;
	pdata_dd = 16'bx;
	O_Data_Ready = 1'b0;
	TX_cntr = 5'bx;
	S_TX_cntr = 5'bx;
	S_TX_ready = 1'b0;
	CPHA = 1'b0;
	R_Edge = 1'b0;
	F_Edge = 1'b0;
	pdata_predicted = 16'b0;
		forever begin
			from_input_monitor_penable.get(i_valid_d);
			from_spcr_decoder_cpha.get(CPHA);
			from_output_monitor_O_Data_Ready.get(O_Data_Ready);
			from_spcr_decoder_RX_cntr.get(S_TX_cntr);
			from_input_monitor_pdata.get(pdata_dd);
			from_sclk_predictor_sclk_leading_edge.get(R_Edge);
			from_sclk_predictor_sclk_trailing_edge.get(F_Edge);
			from_output_monitor_TX_ready.get(S_TX_ready);
			i_valid = i_valid_d; //one cycle of delay
			if(i_valid_d == 1'b1) begin
				pdata_d = pdata_dd;
			end
			if(O_Data_Ready == 1'b1) begin
				pdata_predicted = 16'b0; 
				TX_cntr = S_TX_cntr; 
			end
			else if(S_TX_ready & ~CPHA) begin 
				pdata_predicted[TX_cntr] = pdata_d[TX_cntr];
				TX_cntr = TX_cntr - 1;
			end
			if((R_Edge & CPHA) | (F_Edge & ~CPHA)) begin 
				if(TX_cntr <= S_TX_cntr) begin 
					pdata_predicted[TX_cntr] = pdata_d[TX_cntr];
					TX_cntr = TX_cntr - 1;
				end
			end
			else if(TX_cntr == 31) begin 
				to_checker_pdata_predicted.write(pdata_predicted);
			end
		end
	endtask : run_phase

endclass : predictor

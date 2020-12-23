////////////////////////////////////////////////////////////
// Module : spi_driver.svh        
// Project : Fall 2020 project            
// Task : Creates the SPI driver class
// Author : Project group-1 (EE273)         
////////////////////////////////////////////////////////////

class spi_driver extends uvm_driver #(itm);
`uvm_component_utils(spi_driver)

	virtual spi_interface v_if;

	function new (string name = "spi_driver", uvm_component parent = null);
	 	super.new(name, parent);
	endfunction : new
	 
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	 	if(!uvm_config_db #(virtual spi_interface)::get(this, "", "spi_inf", v_if)) 
	 		begin
	 		`uvm_fatal(get_type_name(), "Did not get the handle to virtual interface spi_interface")
	 		end
	endfunction : build_phase
	 
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction : connect_phase
	
	virtual task run_phase(uvm_phase phase);
		forever begin
			itm trx;
			seq_item_port.get_next_item(trx);
			@(posedge v_if.pclk) begin 
				v_if.penable <= trx.penable;
				v_if.SPCR <= trx.SPCR;
				v_if.pdata <= trx.pdata;
			end
			seq_item_port.item_done();
		end	
	endtask : run_phase
endclass : spi_driver


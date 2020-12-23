/////////////////////////////////////////////
// Module : spi_test.svh        
// Project : Fall 2020 project            
// Task : Creates the SPI test class 
// Author : Project group-1 (EE273)         
/////////////////////////////////////////////

class spi_test extends uvm_test;
`uvm_component_utils(spi_test)

spi_environment env;
spi_sequence seq;

virtual spi_interface v_if;

	function new (string name = "spi_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = spi_environment::type_id::create("env", this);
		seq = spi_sequence::type_id::create("seq", this);
		if(!uvm_config_db #(virtual spi_interface)::get(this, "", "spi_inf", v_if)) 
			begin
				`uvm_fatal(get_type_name(), "Did not get the handle to virtual interface spi_interface")
			end
	endfunction : build_phase
	
	task run_phase(uvm_phase phase);	
		phase.raise_objection(this);
		seq.start(env.agnt.seqr);
		#3200;
		phase.drop_objection(this);
	endtask : run_phase

endclass : spi_test

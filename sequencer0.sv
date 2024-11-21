class sequencer0 extends uvm_sequencer#(seq_item);
	`uvm_component_utils(sequencer0)
	
		//constructor
		function new(string name = "sequencer0", uvm_component parent = null);
			super.new(name, parent);
		endfunction : new
		
		//build_phase
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			//`uvm_info("SEQUENCER","BUILD PHASE",UVM_LOW);
		endfunction : build_phase
		
	endclass : sequencer0
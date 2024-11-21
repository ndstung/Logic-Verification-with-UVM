class test0 extends uvm_test;
	`uvm_component_utils(test0)
	
		//constructor
		function new(string name = "test0",uvm_component parent = null);
			super.new(name,parent);
		endfunction : new
		
		// instantiate environment, virtual interface, sequence
		environment0 en0;
		virtual interface0 inf0;
		sequence0 seq0;

		//build_phase
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			`uvm_info("TEST","BUILD PHASE",UVM_LOW);
			en0 = environment0::type_id::create("en0",this);
            
			if (!uvm_config_db#(virtual interface0)::get(this, "*", "interface0", inf0))
			begin
				`uvm_fatal("SB", "Could not get virtual interface")
			end

		endfunction : build_phase
	
		function void end_of_elaboration_phase(uvm_phase phase);
			uvm_top.print_topology();
		endfunction : end_of_elaboration_phase
				
		// task run phase
		virtual task run_phase(uvm_phase phase);
		
			phase.raise_objection(this);
			seq0=sequence0::type_id::create("seq0");
			seq0.start(en0.seqr0);
			#1;
			phase.drop_objection(this);
	
		endtask : run_phase
	
endclass : test0
	
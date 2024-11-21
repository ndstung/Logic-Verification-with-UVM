class agent0 extends uvm_agent;
	`uvm_component_utils(agent0)	

		//constructor
		function new(string name = "agent1",uvm_component parent = null);
			super.new(name,parent);
		endfunction : new
		
		// instantiate
		sequencer0 seqr0;
		driver0 drv0;
		encoder0 en0;
		//ifft ift;
		//fft ft;
		//decoder1 de1;
		//monitor0 mon0;
		
		//build_phase
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			`uvm_info("AGENT","BUILD PHASE",UVM_LOW);
			seqr0 = sequencer0::type_id::create("seqr0",this);
			drv0 = driver0::type_id::create("drv0",this);
			en0 = encoder0::type_id::create("en0",this);
			//ift0 = ifft::type_id::create("ift",this);
			//ft0 = fft::type_id::create("ft",this);
			//de0 = decoder0::type_id::create("de0",this);
			//mon0 = monitor0::type_id::create("mon0",this);
			
		endfunction : build_phase
		
		// connect phase
		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);

		endfunction : connect_phase
		
	endclass : agent0
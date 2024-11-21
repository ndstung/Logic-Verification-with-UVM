class environment0 extends uvm_env;
	`uvm_component_utils(environment0)
	
		//constructor
		function new(string name = "environment1",uvm_component parent = null);
			super.new(name,parent);
		endfunction : new
		
		// instantiate
		sequencer0 seqr0;
		driver0 drv0;
		encoder0 en0;
		ifft0 ift0;
		fft0 ft0;
		decoder0 de0;
		monitor0 mon0;
		scoreboard0 sb0;
			
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//`uvm_info("ENVIRONMENT","BUILD PHASE",UVM_LOW);
		seqr0 = sequencer0::type_id::create("seqr0",this);
		drv0 = driver0::type_id::create("drv0",this);
		en0 = encoder0::type_id::create("en0",this);
		ift0 = ifft0::type_id::create("ift0",this);
		ft0 = fft0::type_id::create("ft0",this);
		de0 = decoder0::type_id::create("de0",this);
		sb0 = scoreboard0::type_id::create("sb0",this);
		mon0 = monitor0::type_id::create("mon0",this);
		
	endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);

			drv0.seq_item_port.connect(seqr0.seq_item_export);
            drv0.drv_write_port.connect(en0.en_get_port.analysis_export);
			en0.en_write_port.connect(ift0.ifft_get_port.analysis_export);
			ift0.ifft_write_port2.connect(drv0.drv_get_port.analysis_export);
			ift0.ifft_write_port1.connect(ft0.fft_get_port.analysis_export);
			ft0.fft_write_port.connect(de0.de_get_port.analysis_export);
			de0.de_write_port.connect(sb0.reference_port.analysis_export);
			drv0.drv_write_to_mon_port.connect(mon0.monitor_get_port.analysis_export);
			mon0.monitor_write_port.connect(sb0.dut_value_port.analysis_export);


			//mon0.analysis_port6.connect(sb1.analysis_port6.analysis_export);

		endfunction : connect_phase
	endclass : environment0
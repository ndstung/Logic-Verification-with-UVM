class sequence0 extends uvm_sequence#(seq_item);
	`uvm_object_utils(sequence0)
	
	seq_item item;

		//constructor
		function new(string name = "sequence0");
			super.new(name);
		endfunction : new
		
		// task body
		virtual task body();
			item = new();
			//`uvm_info("SEQUENCE0","BODY",UVM_LOW)
			
			repeat (50000) begin
				start_item(item);
				item.randomize();
				
				// fixed values generate
				//item.randomize();
				
				finish_item(item);
			end	
			// repeat (1) begin
			// 	start_item(item);
			// 	item.tcase = 48'h5555_5555_5555;
				
			// 	// fixed values generate
			// 	//item.randomize();
				
			// 	finish_item(item);
			// end	

			// repeat (1) begin
			// 	start_item(item);
			// 	item.tcase = 48'haaaa_aaaa_aaaa;
				
			// 	// fixed values generate
			// 	//item.randomize();
				
			// 	finish_item(item);
			// end	

			// repeat (1) begin
			// 	start_item(item);
			// 	item.tcase = 48'hffff_ffff_ffff;
				
			// 	// fixed values generate
			// 	//item.randomize();
				
			// 	finish_item(item);
			// end	
		endtask : body
	endclass : sequence0
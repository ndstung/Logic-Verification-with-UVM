class driver0 extends uvm_driver#(seq_item);
	`uvm_component_utils(driver0)
		
		uvm_analysis_port #(seq_item) drv_write_port;
        uvm_tlm_analysis_fifo #(seq_item) drv_get_port;
		uvm_analysis_port #(seq_item) drv_write_to_mon_port;
        

		//constructor
		function new(string name = "driver0", uvm_component parent = null);
			super.new(name, parent);
		endfunction : new
		
		reg signed [16:0] fixed_point_re [128];
		reg signed [16:0] fixed_point_im [128];

		/*//struct {re, im} for 128 fixed_point numbers output
		typedef struct {
			real re;
			real im;
			} complex128;
		
		complex128 fixed_point [128]; */

		// virtual interface
		virtual interface0 inf0;

		// instantiate
		seq_item itm;

		//build_phase
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			//`uvm_info("DRIVER","BUILD PHASE",UVM_LOW);
			
            drv_write_port = new("drv_write_port",this);
            drv_get_port = new("drv_get_port",this);
			drv_write_to_mon_port = new("drv_write_to_mon_port", this);

			if (!uvm_config_db#(virtual interface0)::get(this, "*", "interface0", inf0))
			begin
				`uvm_fatal("SB", "Could not get virtual interface")
			end

		endfunction : build_phase
		
		// Task run phase
		virtual task run_phase(uvm_phase phase);
			super.run_phase(phase);
			//`uvm_info("DRIVER","RUN PHASE",UVM_LOW)

			inf0.Pushin=0;
			inf0.FirstData=0;

			//phase.raise_objection(this);
			forever begin
				itm = new();

				seq_item_port.get_next_item(itm);
				
                //Begining of Process
				// Sending 48bits message to encoder
				drv_write_port.write(itm);
				
				//`uvm_info("DRIVER send DATA",$sformatf("tcase =%h",itm.tcase),UVM_LOW);
				#1;

                
				//Driver get 128 fixed points number from IFFT
				drv_get_port.get(itm);
                //$display("-----------------------------------------------------------");
                //for (int i = 0; i < 128 ;i++) begin
                //   $display("Index - %d - Real =",i,itm.fixed_re[i]);
                //end

			itm.FirstData = 0'b1;  // Ensuring FirstData is high at start
            itm.Pushin = 0'b1;  
			//$display("Pushin = %b, FirstData = %b",itm.Pushin,itm.FirstData);
			for (int i = 0; i < 128 ; i++) begin
            @(posedge (inf0.Clk));
            #1;

            // FirstData should be high only on the first index
            //inf0.FirstData = (i == 0) ? 1'b1 : 1'b0;
                //if (i < 128) begin
					itm.Pushin = 1;
                    inf0.Pushin = itm.Pushin;
                    //$display("Index - %d - Pushin =%b",i,inf0.Pushin);
                    inf0.FirstData = itm.FirstData;
                    //$display("FirstData =%b",inf0.FirstData);
                    inf0.DinR = itm.fixed_re[i];
                    inf0.DinI = itm.fixed_im[i];

					//$display("Index %d - FirstData = %d",i,inf0.FirstData);
                	//$display("DinR to InterFace =%d",inf0.DinR);

                    itm.FirstData = i==0;
                    //itm.Pushin = 1'b0;
                    inf0.FirstData = itm.FirstData;
                    //inf0.Pushin = itm.Pushin;
					//$display("Index -%d - DinR to InterFace =%d",i,inf0.DinR);


                    //Write to the analysis port after updating the interface
			end
			//#3;
			//$display("Push Out = %b",inf0.PushOut);
			#1215;
			//$display("Push Out = %b",inf0.PushOut);
			//itm.PushOut = inf0.PushOut;

			@(posedge(inf0.Clk)) #1;
			inf0.Pushin=0;
			inf0.FirstData=0;

			//drv_write_to_mon_port.write(itm);
			
			seq_item_port.item_done();	

			end

			//phase.drop_objection(this);
		endtask : run_phase
	endclass : driver0
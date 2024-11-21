class monitor0 extends uvm_monitor;
    `uvm_component_utils(monitor0)

    // analysis port
    uvm_tlm_analysis_fifo #(seq_item) monitor_get_port; //monitor port get item from driver
    uvm_analysis_port#(seq_item) monitor_write_port;
    
    //constructor
	function new(string name = "monitor0", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

    //instantiate
    virtual interface0 inf0;
    seq_item itm_dut;

    //build_phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//`uvm_info("MONITOR","BUILD PHASE",UVM_LOW);

        //ports 
		monitor_get_port =  new("monitor_get_port",this);
        monitor_write_port = new("monitor_write_port", this);

        // interface0
        if (!uvm_config_db#(virtual interface0)::get(this, "", "interface0", inf0)) begin
            `uvm_error("MONITOR", "Failed to get virtual interface0");
        end
    endfunction : build_phase

    // Task run phase
	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		//`uvm_info("MONITOR","RUN PHASE", UVM_MEDIUM);
        itm_dut = seq_item::type_id::create("itm_dut",this);


        //phase.raise_objection(this);

        forever begin
            // Initialization
            //itm_dut.FirstData = 1'b1;  // Ensuring FirstData is high at start
            //itm_dut.Pushin = 1'b1;     // Assuming you want to push from the beginning
            //for (int i = 0; i < 128 ; i++) begin
            //monitor_get_port.get(itm);
            //$display("PushOut = %b",itm_dut.PushOut);

            @(posedge inf0.Clk);

            if (inf0.PushOut == 1) begin
                itm_dut.PushOut = inf0.PushOut;
                //$display("PushOut from DUT (in MONITOR): %b", itm_dut.PushOut);
                itm_dut.DataOut= inf0.DataOut;
                //$display("Output from DUT (in MONITOR): %h", itm_dut.DataOut);

                //itm_dut.PushOut = 0;
                monitor_write_port.write(itm_dut);
            end


        end
        //phase.drop_objection(this);
        // Final write to the analysis port to ensure all data is sent

        //`uvm_info("MONITOR","END OF RUN PHASE",UVM_LOW);
    endtask : run_phase

endclass : monitor0
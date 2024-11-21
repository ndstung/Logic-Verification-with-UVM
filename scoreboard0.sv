class scoreboard0 extends uvm_scoreboard;
    `uvm_component_utils(scoreboard0)

    uvm_tlm_analysis_fifo #(seq_item) reference_port; // store 48 bits from decoder1
    uvm_tlm_analysis_fifo #(seq_item) dut_value_port; // 48 bits output from DUT




    seq_item itm, itm_dut;

    virtual interface0 inf0;

    //constructor
    function new(string name="scoreboard0",uvm_component parent=null); //create constructor
		super.new(name,parent);

		reference_port =  new("reference_port",this);
        dut_value_port =  new("dut_value_port",this);
        itm = new();
        itm_dut = new();

	endfunction : new

    //build phase
    function void build_phase(uvm_phase phase);     
		//`uvm_info("SCOREBOARD","BUILD PHASE",UVM_LOW);		


        if (!uvm_config_db#(virtual interface0)::get(this, "*", "interface0", inf0))
		begin
			`uvm_fatal("SB", "Could not get virtual interface")
		end
	endfunction : build_phase


    task run_phase(uvm_phase phase); 	
        if (inf0 == null) begin
            `uvm_error("SB", "Virtual interface not initialized.");
            return;
        end


        forever begin
            reference_port.get(itm);
            dut_value_port.get(itm_dut);
           // @(posedge inf0.Clk); // Wait for positive edge of clock
            //#1;
            

            //$display("Output from DECODER (in SCOREBOARD): %h", itm.bit_out);
            //$display("--------------------------------------");
            //$display("--------------------------------------");
            //$display("PushOut",itm.PushOut);
            //$display("DATAOUT from MONITOR (in ScoreBoard) = %h",itm_dut.DataOut);
            //$display("--------------------------------------");

    ///////////////////////////////////////////////////////////////////////////////////////
    // MAIN task to compare 48bit between DUT and DECODER

            if (itm.bit_out != itm_dut.DataOut) begin
                `uvm_error("ERROR", $sformatf("OUT FROM DUT = %h, OUT FROM DECODER = %h", itm_dut.DataOut, itm.bit_out))
            end else begin
                `uvm_info("Same 48bit", "OUT FROM DUT = OUT FROM DECODER", UVM_LOW)

            end
    ///////////////////////////////////////////////////////////////////////////////////////    
            
            
        end
        //phase.drop_objection(this); // Ensure to drop the objection once done
    endtask : run_phase
endclass : scoreboard0
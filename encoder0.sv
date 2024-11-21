class encoder0 extends uvm_component;
`uvm_component_utils(encoder0)

    uvm_tlm_analysis_fifo #(seq_item) en_get_port; //encoder port connects to driver
    uvm_analysis_port #(seq_item) en_write_port; //encoder port connects to ifft

    reg [1:0] current_bits; // Temporary variable to hold the current 2-bit value
    int fbin = 4;           // Starting frequency bin
    real amp[3:0];          // Initialize the amplitude array 

    //struct {re, im} for 128 complex numbers output
    typedef struct {
        real re;
        real im;
        } complex128;

    //using complex128 structure type
    complex128 cp[128];
    
    //constructor
    function new(string name = "encoder1",uvm_component parent = null);
        super.new(name,parent);

    // (analogous to `amp=[0.0, 0.333, 0.666, 1.0]`)
        amp[0] = 0.0;
        amp[1] = 0.333;
        amp[2] = 0.666;
        amp[3] = 1.0;
    endfunction : new
    
    // instantiate
    seq_item itm;
    
    //build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //`uvm_info("ENCODER","BUILD PHASE",UVM_LOW);
    
        en_get_port = new("en_get_port",this);
        en_write_port = new("en_write_port",this);

    endfunction : build_phase

    // Task run phase
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        //`uvm_info("ENCODER","RUN PHASE",UVM_LOW)

        forever begin
            itm = new();
            
            // encoder receive 48 bits values from driver
            en_get_port.get(itm);
            
            //`uvm_info("ENCODER receive DATA",$sformatf("tcase =%h",itm.tcase),UVM_LOW)
            #1;

            //Function initialize and configure frequencies
            configure_frequencies(itm);

            // write(item) sending 128 complex number (frequency domain) to IFFT
            en_write_port.write(itm);
            //$display("--------------------------------------------------------------");
            //`uvm_info("ENCODER","128 complex numbers (frequency domain) sent to IFFT",UVM_LOW)
            #1;
            
        end
    endtask : run_phase

    // Method to initialize and configure frequencies
    virtual function void configure_frequencies(seq_item itm);
        int fbin = 4;
        int current_bits;
        bit [47:0] tcase = itm.tcase;
        // Initialize the complex numbers to zeros
        for (int i = 0 ; i < 128 ; i++) begin
            itm.encoder_cp[i].re = 0.0;
            itm.encoder_cp[i].im = 0.0;
        end

        // Loop to set the frequencies
        while (fbin < 52) begin
            current_bits = tcase[1:0]; // Get the lowest 2 bits
            itm.encoder_cp[fbin].re = amp[current_bits];          // Set amplitude based on the extracted bits
            itm.encoder_cp[128 - fbin].re = amp[current_bits];    // Mirror on the negative side

            tcase = tcase >> 2;       // Shift right by 2 bits to process the next pair of bits
            fbin = fbin + 2;          // Increment frequency bin
        end

        itm.encoder_cp[55].re = 1.0;       // Special case handling
        itm.encoder_cp[128-55].re = 1.0;   // Mirrored value
    endfunction
    
endclass : encoder0
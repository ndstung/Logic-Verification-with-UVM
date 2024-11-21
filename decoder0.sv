class decoder0 extends uvm_component;
    `uvm_component_utils(decoder0)

    uvm_tlm_analysis_fifo #(seq_item) de_get_port; //get 128 complex number (frequency domain) from fft
    uvm_analysis_port #(seq_item) de_write_port; //send 48 bits to scoreboard
    

    // Input data with 128 complex numbers (frequency domain)
    typedef struct {
        real re;
        real im;
        } complex128;
    
    complex128 cp_fre[128]; // 128 complex number (frequency domain) in ifft
    real [47:0] res;        // 48 bits output in decoder
    
    real tpoints[4] = '{0.0, 0.333, 0.666, 1.0};
    real full_scale;
    real fspoints[4];
    real decision_points[3];

    // Instantiate
    seq_item itm;

    //constructor
    function new(string name = "decoder1",uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    //build_phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//`uvm_info("DECODER","BUILD PHASE",UVM_LOW);
        de_get_port = new("de_get_port",this);
        de_write_port = new("de_write_port",this);
    endfunction : build_phase

    // Task run phase
	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		//`uvm_info("DECODER","RUN PHASE",UVM_LOW)

        itm = new();
        
        forever begin
            de_get_port.get(itm);
            
            // Assign 128 complex number (frequency domain) 
            // from seq_item
            for (int i = 0; i < 128; i++) begin
                cp_fre[i].re = itm.fft_cp[i].re;
                cp_fre[i].im = itm.fft_cp[i].im;
            end

            //$display("----------------------------------------------------------");
            //$display("INPUT from FFT to DECODER");
            //$display(cp_fre);
            //$display("----------------------------------------------------------");
            
            //task convert 128 complex number (frequency domain) to 48 bits
            bdecoder(cp_fre,res);

            //$display("----------------------------------------------------------");
            //$display("48 bits in DECODER:");
            //$display("%0h",res);
            //$display("----------------------------------------------------------");

            //put 48 bits array to seq_item
            itm.bit_out = res;



            //send 48 bits to scoreboard
            de_write_port.write(itm);
            //$display("48 bits send to SCOREBOARD: %h",itm.bit_out);

            //$display("48 OUTPUT IN DECODER = %h", itm.bit_out);

            //`uvm_info("DECODER","END RUN PHASE",UVM_LOW)
        end
    endtask

    // slices the spectrum data back to bits
    // Uses Freq bin 55 or 57 (Which ever is larger) as the full scale guide tone
    // Uses the square of values to avoid the square root
    task bdecoder(input complex128 spectrum[128], output logic [47:0] result);
        real tpoints[4] = '{0.0, 0.333, 0.666, 1.0};
        real full_scale;
        real decision_points[3];
    
        // Determine full scale based on spectrum values at indices 55 and 57
        full_scale = max(asq(spectrum[55].re), asq(spectrum[57].re));
    
        // Define decision points based on full scale
        decision_points[0] = asq(0.166666 * full_scale);
        decision_points[1] = asq((0.166666 + 0.333333) * full_scale);
        decision_points[2] = asq((0.166666 + 0.666666) * full_scale);
    
        result = 0;
        for (int x = 4; x <= 52; x += 2) begin  
            logic [95:0] bv = 3;
            real fsq ;
            fsq = asq(spectrum[x].re); 
            //$display(spectrum[x]);
            for (int dx = 0; dx < 3; dx++) begin
                if (fsq < decision_points[dx]) begin
                    // $display(fsq); 
                    bv = dx;
                    break;
                end
                //$display(x);   
            end
            // Calculate bit value and shift left according to index position
            bv = bv << (x - 4);
            result = result | bv;
        end
    endtask : bdecoder

    // Helper function to square a value
    function real asq(real val);
        asq = val * val;
    endfunction

     // Function to find maximum of two real values
    function real max(real a, real b);
        if (a > b) begin
            return a;
        end else begin
            return b;
        end
    endfunction

endclass : decoder0
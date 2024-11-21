class fft0 extends uvm_component;
    `uvm_component_utils(fft0)

    // uvm_blocking_*_port
    uvm_tlm_analysis_fifo #(seq_item) fft_get_port; // get 128 complex number (time domain) from ifft
    uvm_analysis_port #(seq_item) fft_write_port; // send 128 complex number (frequency) domain to decoder

    typedef struct {
        real re;
        real im;
        } complex128;

    //using complex128 structure type
    complex128 cp_time[128];    // Array to hold input of IFFT data in frequency domain
    complex128 cp_fre[128];     // Array to hold output complex numbers in frequency domain
    //complex128 cj[128];		// Array to hold conjungate input of IFFT data in frequency domain
    complex128 rv[128];		    // Array to hold reverse input 
    complex128 tw[64];          // Array to hold 64 twiddles (n/2)

    //constructor
	function new(string name = "driver1", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new
    
    //instantiate
    seq_item itm;
    
    //build_phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//`uvm_info("FFT","BUILD PHASE",UVM_LOW);

        //ports 
        fft_get_port = new("fft_get_port",this);
        fft_write_port = new("fft_write_port",this);
    endfunction : build_phase

    // Task run phase
	virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        //`uvm_info("FFT","RUN PHASE",UVM_LOW)
        itm = new();

        generate_twiddle_factors();  // Initialize fft twiddle factors

        forever begin
            //get 128 complex number(time domain) from ifft
            fft_get_port.get(itm);

            // Assign 128 complex number (time domain) 
            // from seq_item
            for (int i = 0; i < 128; i++) begin
                cp_time[i].re = itm.ifft_cp[i].re;
                cp_time[i].im = itm.ifft_cp[i].im;
            end
            // $display("----------------------------------------------------------");
            // $display(cp_time);
            // $display("----------------------------------------------------------");

            // Handle INPUT from ENCODER into OUTPUT for DRIVER
            bit_reversed_data(cp_time,rv);
            perform_fft(rv,cp_fre);
            
            // $display("----------------------------------------------------------");
            // $display(cp_fre);
            // $display("----------------------------------------------------------");
      
            // Copy complex128 array into the sequence item frequency domain
            for (int i = 0; i < 128; i++) begin
                itm.fft_cp[i].re = cp_fre[i].re;
                itm.fft_cp[i].im = cp_fre[i].im;
                // $display("---------------------------------------------------------------------------");
                // $display("fft_cp[%d] %.10f",i, itm.fft_cp[i].re);
            end

            // sending 128 complex number (frequency domain) to decoder
            fft_write_port.write(itm);

            //`uvm_info("FFT","END RUN PHASE",UVM_LOW)
        end
    endtask : run_phase

    // Main IFFT task
    task perform_fft(input complex128 reverse[128], output complex128 out_complex_time[128]);
        complex128 a, b, v, t;
        int ix, lvl, bs, twix, spread = 2;
        int i1, i2;
        // IFFT main loop
        
        for (lvl = 0; lvl < 7; lvl++) begin  // 7 levels for 128 points (2^7 = 128)
            bs = 0;
            while (bs < 128) begin
                for (ix = bs; ix < (bs + spread / 2);ix++) begin
                    twix = (ix % spread) * (128 / spread);                                             
                    //$display(ix);
                    t.re = tw[twix].re;  // Accessing twiddle factor
                    t.im = tw[twix].im;
                   
                    // $display("real: %.15f - imag: %.15f ",t.re,t.im);
                    // Fetching the indices for butterfly
                    i1 = ix;
                    i2 = ix + spread / 2;

                
                    v.re = reverse[i2].re * t.re - reverse[i2].im * t.im;
                    v.im = reverse[i2].re * t.im + reverse[i2].im * t.re;

                    // Direct complex addition and subtraction
                    a.re = reverse[i1].re + v.re;
                    a.im = reverse[i1].im + v.im;
                    
                    //$display(a);
                    b.re = reverse[i1].re - v.re;
                    b.im = reverse[i1].im - v.im;

                    // Storing the computed values back to the output array
                    reverse[i1].re = a.re;
                    reverse[i1].im = a.im;
                    reverse[i2].re = b.re;
                    reverse[i2].im = b.im;
                end
                bs += spread;
            end
            spread *= 2;
        end

        for (int i = 0; i < 128; i++) begin
            out_complex_time[i].re = (reverse[i].re < 1e-13) ? 0 : reverse[i].re;
            out_complex_time[i].im = 0.0;
            //$display("out_complex_time = %p",out_complex_time[i].re);
        end

    endtask

    // SystemVerilog task to calculate the complex conjugate
    task complex_conjugate(input complex128 in_complex[128], output complex128 out_conjugate[128]);
        for (int i = 0; i < 128; i++) begin
            out_conjugate[i].re = in_complex[i].re;  // Real part stays the same
            out_conjugate[i].im = -in_complex[i].im; // Imaginary part negated
        end
    endtask
    

    // Task for bit reversal (same for ifft and fft)
    task bit_reversed_data(input complex128 in_conjugate[128], output complex128 out_reverse[128]);
        integer ix, wx, rx, qq;
        const integer BITS = 7;  // Assuming we're dealing with 128 points, requiring 7 bits

        for (ix = 0; ix < 128; ix++) begin
            wx = ix;
            rx = 0;
            for (qq = 0; qq < BITS; qq++) begin
                rx = rx * 2;
                if (wx & 1 !=0) begin
                    rx = rx | 1;
                end
                wx = wx >> 1;
            end
            out_reverse[ix] = in_conjugate[rx];

        end
    endtask

    // Task to calculate twiddle factors
    task generate_twiddle_factors();
        integer k;
        real angle;
        for (k = 0; k < 64; k++) begin
            angle = (-2) * 3.141592653589793238462643 * k / 128;  // 2*pi*k/n
            tw[k].re = $cos(angle);  // Cosine for the real part
            tw[k].im = $sin(angle);  // Sine for the imaginary part
            
        end
    endtask
        
endclass : fft0
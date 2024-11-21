class seq_item extends uvm_sequence_item;
`uvm_object_utils(seq_item)

	reg Pushin;              // Data is present on the input
	reg FirstData;           // The first data in an FFT block
	reg signed [16:0] DinR;  // Real part of input
	reg signed [16:0] DinI;  // Imaginary part of input
	reg PushOut;             // Output data is ready
	reg [47:0] DataOut;


	typedef struct {
		real re;
		real im;
		} complex128;
	
	complex128 encoder_cp[128]; // 128 complex numbers (frequency domain) which send to ifft


    //128 fixed_point numbers - output from IFFT
	reg signed [16:0] fixed_re[128];
    reg signed [16:0] fixed_im[128];

    complex128 ifft_cp[128];    // 128 complex numbers (time domain) which send to fft 
    
    complex128 fft_cp[128];     // 128 complex numbers (frequency domain) which send to decoder

	reg [47:0] bit_out;			// Output data from decoder
	
	// Output from encoder

	// Output from IFFT

	// Output from FFT




	rand reg [47:0] tcase; // DataOut for testing
	
	//constructor
	function new(string name = "seq_item");
		super.new(name);
	endfunction : new
	
	/*constraint valid_data {
        // Define any specific constraints on tcase_DataOut if necessary
        					tcase_DataOut = 48'haaaa_aaaa_aaaa;
							tcase_DataOut = 48'hffff_ffff_ffff;
		
    }*/
	
endclass : seq_item
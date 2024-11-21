package project273; //project273 package

    import uvm_pkg::*; //necessary to include this package in user's package
    
    //include all sv files
    `include "seq_item0.sv"

    `include "sequence0.sv"
    `include "sequencer0.sv"

    `include "driver0.sv"
    `include "monitor0.sv"
    `include "encoder0.sv"
    `include "ifft0.sv"
    `include "fft0.sv"
    `include "decoder0.sv"
    `include "scoreboard0.sv"
    `include "agent0.sv"
    `include "environment0.sv"
    `include "test0.sv"
endpackage : project273
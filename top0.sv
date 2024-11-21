
//simple testbench
`timescale 1ns/1ns
import uvm_pkg::*;
`include "package0.sv"

`include "interface0.sv"

module top0();

	reg Clk, Reset;

	interface0 inf0(.Clk(Clk),.Reset(Reset));


	initial begin
		Clk=0;
		Reset=1;
		#10;
		Reset = 0;
		repeat(100000000) begin
			#5 Clk=1;
			#5 Clk=0;
		end
		//$display("\n\n\nRan out of clocks\n\n\n");
		$finish;
	end

	initial begin
		uvm_config_db #(virtual interface0)::set(null, "*", "interface0" , inf0);
		run_test("test0");
	end

	ofdmdec dut(.Clk(inf0.Clk),.Reset(inf0.Reset),.Pushin(inf0.Pushin),.FirstData(inf0.FirstData),.DinR(inf0.DinR),.DinI(inf0.DinI),.PushOut(inf0.PushOut),.DataOut(inf0.DataOut));

	initial begin
		$dumpfile("fun.vcd");
		$dumpvars(9,top0);
	end
  
endmodule : top0
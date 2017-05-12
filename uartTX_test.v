`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:23:47 03/09/2017
// Design Name:   uartTX
// Module Name:   C:/Users/bill/FPGA/myUART/uartTX_test.v
// Project Name:  myUART
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: uartTX
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module uartTX_test;

	// Inputs
	reg clk50m;
	reg reset_n;
	reg [7:0] txdata;
	reg dataok;

	// Outputs
	//wire [1:0] cstatus;
	//wire [1:0] nstatus;
	wire txd;

	// Instantiate the Unit Under Test (UUT)
	uartTX uut (
		.clk50m(clk50m), 
		.reset_n(reset_n), 
		.txdata(txdata), 
		.dataok(dataok), 

		.txd(txd)
	);

	initial begin
		// Initialize Inputs
		clk50m = 0;
		reset_n = 0;
		txdata = 0;
		
		dataok = 0;

		// Wait 100 ns for global reset to finish
		#10000;
		
		reset_n = 1;
		
		#1000;
		
		txdata = 8'h48;
		dataok = 1;

		
      #100000;  
		dataok = 0;
		
		// Add stimulus here
		
		#1000000;
		
		txdata = 8'h49;
		dataok = 1;

		
		#100000;  
		dataok = 0;
		
		
		#2000000;
		
		$stop;

	end
	
	
	//50MHz clock
   always #10 clk50m = ~clk50m; 
      
endmodule


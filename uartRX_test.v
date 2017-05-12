`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2017 10:57:19 AM
// Design Name: 
// Module Name: myUART_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uartRX_test;
    
    reg clk50m;
    reg reset_n;
	 reg clk_uart;
    reg rxd;

    
    wire   [7:0]   rxdata;
    wire          dataok;

	 
	 reg	[7:0]		data;
    
	 /*
	 input           clk50m,
	 input			  clk_uart,
    input           reset_n,
	 
    input          rxd, // uart rx data in
	 
	 output   [7:0]   rxdata,
    output          dataok
	 */
    uartRX inst_uartRX(
    
        .clk50m     (clk50m),
		  .clk_uart		(clk_uart),
        .reset_n    (reset_n),
        .rxd        (rxd),

        .rxdata     (rxdata),
        .dataok     (dataok)

    );
    
    parameter BIT_TIME = 51000;
    
        initial begin
    		// Initialize Inputs
    		clk50m = 1'b0;
    		reset_n = 1'b0;
			clk_uart = 1'b0;
			data = 8'h00;
    		rxd = 1'b1;
			

    		// Wait 100 ns for global reset to finish
    		#10000;
 
    		reset_n = 'b1;
    		#10000;

			data = 8'h48;
    		sendData(data[7:0]);	
			
			repeat(2) begin
			#BIT_TIME;
    	   end
			
			data = 8'h49;
			sendData(data[7:0]);

			rxd = 1'b1;  // idle
			#BIT_TIME; 
			
			repeat(5) begin
			#BIT_TIME;
    	   end
			
			$stop;
    		
    	end	
    
	  //50MHz clock
	  always #10 clk50m = ~clk50m; 
	  //clock for UART
	  always #1627 clk_uart = ~clk_uart; 
		
		
		task sendData;
			input [7:0] data;
			
			begin
			
			   rxd = 1'b1; //idle
				#BIT_TIME;
				
				rxd = 1'b0;  //start
				#BIT_TIME;
			
				rxd = data[0];  // bit 0
				#BIT_TIME;
			
				rxd = data[1];  // bit 1
				#BIT_TIME;
				
				rxd = data[2];  // bit 2
				#BIT_TIME;
				
				 rxd = data[3];  // bit 3
				#BIT_TIME;       
					 
				rxd = data[4];  // bit 4
				#BIT_TIME;    
						  
				rxd = data[5];  // bit 5
				#BIT_TIME     
						 
				rxd = data[6];  // bit 6
				#BIT_TIME;
				
				rxd = data[7];  // bit 7
				#BIT_TIME;
				
				
				rxd = 1'b1;  // stop
				#BIT_TIME;
			end
			
		endtask
        
endmodule

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


module myUART_test;
    
    reg clk50m;
    reg reset_n;
	 reg rxd;
    
    //wire clkout;
	 wire txd;
	 
	 /*
	 input clk50m,
    input reset_n,
    input rxd,
    
    output clkout,
    output txd
	 
	 */
	 
	 reg	[7:0]		data;
    
    myUART inst_myUART(
    
        .clk50m   (clk50m),
        .reset_n  (reset_n),
		  .rxd		(rxd),
        
        //.clkout     (clkout),
		  .txd			(txd)
   
    );
	 
	 parameter BIT_TIME = 102000;
    
        initial begin
    		// Initialize Inputs
    		clk50m = 1'b0;
    		reset_n = 1'b0;
			rxd = 1'b1;
			data = 8'h00;

    		// Wait 100 ns for global reset to finish
    		#10000;
 
    		reset_n = 'b1;
    		#10000;
			
			data = 8'h48;
    		sendData(data[7:0]);	
			
			data = 8'h49;
			sendData(data[7:0]);
			
			
			data = 8'h20;
			sendData(data[7:0]);

			rxd = 1'b1;  // idle
			#BIT_TIME;   
    		
			repeat(1) begin
			#BIT_TIME;
			#BIT_TIME;
			#BIT_TIME;
			#BIT_TIME;
			#BIT_TIME;
			#BIT_TIME;
			#BIT_TIME;
			#BIT_TIME;
			#BIT_TIME;
			#BIT_TIME;
			#BIT_TIME;
			
			end
			
    		$stop;
    		
    	end	
    
        //33MHz clock
        always #10 clk50m = ~clk50m; 

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

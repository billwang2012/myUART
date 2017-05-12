`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2017 09:50:51 AM
// Design Name: 
// Module Name: myUART
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


module myUART(
    input clk50m,
    input reset_n,
    input rxd,
    
    //output clkout,
    output txd
    
    );
    
    wire [7:0]      txdata, rxdata;
	 wire				  txdata_ok, rxdata_ok;

	 wire				clk_uart;
	 
   
	
	 uartClkDiv	inst_uartClkDiv(
			.clk50m		(clk50m),
			.reset_n    (reset_n),
			.clk_uart	(clk_uart)
		);
		
	 //`define TXONLY;
	 
	 uartCtrl inst_uartCtrl(
			//.clk50m		(clk50m),
			.clk_uart	(clk_uart),
			.reset_n		(reset_n),
			
			//`ifdef TXONLY
			//.rxdata		(8'h00),//input
			//.rxdata_ok	(1'b0),//input
			//`else
			.rxdata		(rxdata),//input
			.rxdata_ok	(rxdata_ok),//input
			//`endif
	
			.txdata		(txdata),//output
			.dataok		(txdata_ok)//output
	 
	 );

	 uartRX inst_uartRX(
        .clk50m     (clk50m),
		  .clk_uart		(clk_uart),		  
        .reset_n    (reset_n),
        .rxdata     (rxdata), //output to uartCtrl
        .dataok  		(rxdata_ok),//output to uartCtrl
		  
        .rxd        (rxd) //input
		); 


    uartTX inst_uartTX(
        .clk50m     (clk50m),
		  .clk_uart		(clk_uart),		  
        .reset_n    (reset_n),
        .txdata     (txdata), //input to uartCtrl
		  .dataok 		(txdata_ok), //input to uartCtrl
		  
        .txd        (txd) //output
    );
    
   
     
endmodule

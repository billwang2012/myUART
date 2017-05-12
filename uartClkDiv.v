`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:34:56 03/15/2017 
// Design Name: 
// Module Name:    uartClkDiv 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module uartClkDiv(

	input clk50m,
	input reset_n,
	output clk_uart

    );
	 
    parameter BAUDRATE = 9600;
    parameter CNTMAX = 50000000/(BAUDRATE*16*2) ; // 50MHz/(16*9600*2)
	 
	 reg clk_uart_reg;
    reg [7:0] cnt_clk;
	 
    // clk_uart = 16*BAUDRATE
    always@(posedge clk50m or negedge reset_n) begin
        if(~reset_n) begin
            cnt_clk <= 8'h00;
            clk_uart_reg <= 1'b0;
            
        end
        
        else if (cnt_clk == CNTMAX-1) begin
            cnt_clk <= 8'h00;
            clk_uart_reg <= ~clk_uart_reg;
        end
        
        else
            cnt_clk <= cnt_clk + 8'h01;
    
    end
	 
	 assign clk_uart = clk_uart_reg;
	 
endmodule

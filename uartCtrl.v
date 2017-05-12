`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:51:14 03/15/2017 
// Design Name: 
// Module Name:    uartCtrl 
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
module uartCtrl(
	
	//input clk50m,
	input clk_uart,
	input reset_n,
	
	input [7:0] rxdata,
	input rxdata_ok,
	
	output [7:0] txdata,
	output dataok

    );

    reg  [7:0] cnt;
	 reg	[3:0] index;
	 reg	[7:0]	txdata_reg; 
	 reg			dataok_reg;
    //ROM: Hello FPGA  
    wire [7:0] helloFPGA [11:0];
    
    //helloFPGA = "Hello FPGA\n" ;
    //assign helloFPGA = "Hello FPGA\n"; //cannot assign to memory helloFPGA directly
    
    //assign helloFPGA one by one
    assign helloFPGA[0] = "H";
    assign helloFPGA[1] = "e";
    assign helloFPGA[2] = "l";
    assign helloFPGA[3] = "l";
    assign helloFPGA[4] = "o";
    assign helloFPGA[5] = " ";
    assign helloFPGA[6] = "F";
    assign helloFPGA[7] = "P";
    assign helloFPGA[8] = "G";
    assign helloFPGA[9] = "A";
    assign helloFPGA[10] = "\r"; //8'h0d return
    assign helloFPGA[11] = "\n"; //8'h0a new line
	
	
    always@(posedge clk_uart or negedge reset_n) begin
        if(~reset_n) begin
            txdata_reg <= 8'h00;
				dataok_reg <= 1'b0;
          end
        
        else if( cnt < 8'd16) begin //idle
            txdata_reg <= (index ==4'hF)? 8'h00 : helloFPGA[index];
				dataok_reg <= 1'b1;
        end
		  
        else if( cnt >= 8'd16) begin //keep data, release dataok
            txdata_reg <= txdata_reg;
				dataok_reg <= 1'b0;
        end		


    end 
    
    // cnt 
    always@(posedge clk_uart or negedge reset_n) begin
        if(~reset_n || cnt == 8'd176) begin
            cnt <= 8'h00;
          end
        
        else begin
            cnt <= cnt + 8'h01;
         end

        end
	 
		// index
	 always@(posedge clk_uart or negedge reset_n) begin
	  if(~reset_n || index == 4'd12) begin
			index <= 4'hF;
		 end
	  
	  else if(cnt == 8'd0) begin
			index <= index + 4'h01;
		end

	  end
	//`define TXONLY
	//`ifdef TXONLY
	  //assign txdata = txdata_reg;
	  //assign dataok = dataok_reg;
	 //`else
	  assign txdata = rxdata;
	  assign dataok = rxdata_ok;
	 
	 //`endif

endmodule

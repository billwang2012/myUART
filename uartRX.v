`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2017 02:38:03 PM
// Design Name: 
// Module Name: uartRX
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


module uartRX(
    input           clk50m,
	 input			  clk_uart,
    input           reset_n,
	 
    input          rxd, // uart rx data in
	 
	 output   [7:0]   rxdata,
    output          dataok
       
    );
    
    reg [7:0]   rxdata_reg;
	 reg [7:0]   rxdata_fix;
    
    reg [7:0] count_bit;
    reg [7:0] count_data;
    reg [2:0] current_status, next_status;
    
    reg rxd_d1, rxd_d2, rxd_d3;
    wire rxd_negedge;
	 reg rx_ongoing;
    
    reg bit_done;
     
     //parameter PARITY_STYLE = 0; // 0 = None parity check, 1 = Even, 2 = Odd, 3 = Mark, 4 = Space
     //parameter STOP_BITS = 0; //0 = 1 bit, 1 = 1.5 bits, 2 = 2 bits
    
    parameter IDLE = 3'b000;     // idle
    parameter START= 3'b001;    // start
    parameter DATA= 3'b010;     // data sending
	 parameter PARITY= 3'b100;      // Parity check
    parameter STOP= 3'b011;      // stop
	 parameter STOP2= 3'b111;      // stop2
    

    // rxd_negedge, falling edge of rxd = start begin
    always@(posedge clk50m) begin
        if(~reset_n) begin
            rxd_d1 <= 1'b1; 
            rxd_d2 <= 1'b1;
            rxd_d3 <= 1'b1;       
        end
        
        else begin
            rxd_d1 <= rxd; 
            rxd_d2 <= rxd_d1; 
            rxd_d3 <= rxd_d2; 
        end
            
    end
    
    assign rxd_negedge = !rxd && !rxd_d1 && rxd_d2 && rxd_d3;
    
	 // rx_ongoing
	 always@(posedge clk50m or negedge reset_n) begin
	 
		if(~reset_n) begin
			rx_ongoing <= 1'b0;
        end
            
        else if(rxd_negedge && current_status != STOP2 )
			rx_ongoing <= 1'b1;
		  else if(current_status == STOP2)
		   rx_ongoing <= 1'b0;
	 
	 end


    // bitcount @ clk_uart -- count_bit 
    always@(posedge clk_uart or negedge reset_n) begin
    
        if(~reset_n || rxd_negedge) begin
          count_bit <= 8'h00;
        end
        
        else if(count_bit == 8'h0f) begin
          count_bit <= 8'h00;
        end
        
        else 
			count_bit <= rx_ongoing?(count_bit +1'b1):8'h00;
        
    
    end	
    
    // bitcount @ clk_uart -- count_data
    always@(posedge clk_uart or negedge reset_n) begin
    
        if(~reset_n) begin
          count_data <=  8'h00;
        end
        
        else if(count_bit == 8'h0f && current_status == DATA)
          count_data <= count_data + 1'b1; 
          
        else if(current_status == START )
          count_data <= 8'h00;

    end
    
    // main state machine -- current_status
    always@(posedge clk50m or negedge reset_n) begin
        if(~reset_n) current_status <= IDLE;
        
        else
            current_status <= next_status;
    end
    
    // main state machine -- next_status transition
    always@(posedge clk_uart or negedge reset_n) begin
    
        if(~reset_n) begin
            next_status = IDLE;
        end
            
        else begin
        
            case(current_status)
               IDLE: begin
                    if(rx_ongoing) next_status =  START;
                
                end
                
               
               START: begin
                    if(count_bit == 8'h0f ) begin
                        next_status =  DATA;
                    end
                end
                
               DATA: begin    
                    if(count_data == 8'h9) next_status =  STOP;
                end             
    
                STOP: begin
                    if(count_bit == 8'h0f) begin
                        next_status =  STOP2;
                    end
                    
                 end
					  
                STOP2: begin
                        next_status =  IDLE;
                 end
                 
                default:
                     next_status =  IDLE;     
                    
            endcase   
        
        end //end else     
            
    end //end always
    
    
    // main state machine -- output control
    always@(posedge clk_uart or negedge reset_n) begin
    
        if(~reset_n) begin
            bit_done <= 1'b0;
            rxdata_reg <= 8'h00;
				rxdata_fix <= 8'h00;
        end
            
        else begin
        
            case(current_status)
               IDLE: begin
                    if(count_bit < 8'h0f) bit_done <= 1'b0; // idle 
						  rxdata_reg <= 8'h00;
                end
                
               
               START: begin
                    if(count_bit < 8'h0f) bit_done <= 1'b0; // start
						  rxdata_reg <= 8'h00;
                end
               
               DATA: begin
							bit_done <= 1'b0;
                    if(count_data != 8'h08 && count_bit == 8'h08)
                        rxdata_reg[7:0] <= {rxd,rxdata_reg[7:1]};          
    
                end             
    
                STOP: begin
						  rxdata_fix <= rxdata_reg;
                    if(count_bit < 8'h0f) bit_done <= 1'b1; // stop
                 end
					  
                STOP2: begin
						  rxdata_fix <= rxdata_reg;
                    bit_done <= 1'b1; // stop2
                 end
                 
                default: begin
							rxdata_reg <= 8'h00;
                     bit_done <=  1'b0;						
						end
                    
            endcase   
        
        end //end else     
            
    end //end always
	 
    assign rxdata = rxdata_fix; //[7:0]
    assign dataok = bit_done;

endmodule


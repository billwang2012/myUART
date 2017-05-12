`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Brocade
// Engineer: Bill Wang
// 
// Create Date: 03/02/2017 03:59:28 PM
// Design Name: myUART
// Module Name: uartTX
// Project Name: myUART
// Target Devices: Spartan-6
// Tool Versions: PlanAhead
// Description: send 8-bit data to UART_TX
// 
// Dependencies: 
// 
// Revision:0.01
// Revision 0.01 - File Created
// Additional Comments: for FPGA study
// 
//////////////////////////////////////////////////////////////////////////////////


module uartTX(
    input           clk50m,
	 input			  clk_uart,
    input           reset_n,
    input   [7:0]   txdata,
    input			  dataok,
   
    output          txd
       
    );
    
    reg txd_reg;
  
    reg [3:0] cnt_bit;
    reg [7:0] cnt_data;
    reg [2:0] current_status, next_status;
	 
	 // tx_ongoing
	 reg tx_ongoing;
	 //reg dataok_d1,dataok_d2,dataok_d3,tx_ongoing;
	 //wire dataok_posedge;
    

     
    //parameter PARITY_STYLE = 0; // 0 = None parity check, 1 = Even, 2 = Odd, 3 = Mark, 4 = Space
    //parameter STOP_BITS = 0; //0 = 1 bit, 1 = 1.5 bits, 2 = 2 bits
    
    
    parameter IDLE = 3'b111;     // idle
    parameter IDLE1 = 3'b000;     // idle1
    parameter START= 3'b001;    // start
    parameter DATA= 3'b010;     // data sending
    parameter STOP= 3'b011;      // stop bit1
    //parameter PARITY= 3'b100;      // parity check
	 
   
	 always@(posedge clk50m) begin
		if(~reset_n) begin
			tx_ongoing <= 1'b0;
		end

		else if(current_status == IDLE) 
			tx_ongoing <= 1'b0;
		else 
			tx_ongoing <= 1'b1;
	 end
    

    
    // bitcnt @ clk_uart -- cnt_bit, one bit = 16 (8'h0f) clock cycle
    always@(posedge clk_uart or negedge reset_n) begin
    
        if(~reset_n) begin
          cnt_bit <= 4'h0;
        end
        
        else if(cnt_bit == 4'hf) begin
          cnt_bit <= 4'h0;
        end
        
        else if(tx_ongoing) cnt_bit <= cnt_bit + 4'h1;
        
    
    end	
    
    
    
    // bitcnt @ clk_uart -- cnt_data, during DATA period, we have 8-bit data to send
    always@(posedge clk_uart or negedge reset_n) begin
    
        if(~reset_n) begin
          cnt_data <=  8'h00;
        end
        
        else if(cnt_bit == 4'hf && current_status == DATA)
          cnt_data <= cnt_data + 8'h01; 
          
        else if(current_status == START )
          cnt_data <= 8'h00;

    end
    
    // main state machine -segement 1- current_status
    always@(posedge clk50m or negedge reset_n) begin
        if(~reset_n) current_status <= IDLE;
        
        else
            current_status <= next_status;
    end
    
    // main state machine -segement 2- next_status transition
    always@(posedge clk_uart or negedge reset_n) begin
    
        if(~reset_n) begin
            next_status <= IDLE;
        end
            
        else begin
        
            case(current_status)
                IDLE: begin
                    if(dataok) next_status <=  IDLE1;
                end

                IDLE1: begin
                    if(cnt_bit == 4'hf) next_status <=  START;
                end                
               
                START: begin
                    if(cnt_bit == 4'hf ) begin
                        next_status <=  DATA; //send one bit 0 for START, then transition to DATA
                    end
                end
                
                DATA: begin    
                    if(cnt_data == 8'h8) next_status <=  STOP; //send 8-bit data, then STOP
                end             
    
                STOP: begin
                    if(cnt_bit == 4'hf) begin
                       next_status <=  IDLE;
                    end
                 end
                 
                default:
                    next_status <=  IDLE;     
                    
            endcase   
        
        end //end else     
            
    end //end always
    
    
    // main state machine -segement 3- output control
    always@(posedge clk_uart or negedge reset_n) begin
    
        if(~reset_n) begin
            txd_reg <= 1'b1;
        end
            
        else begin
        
            case(current_status)
                IDLE: begin
                    txd_reg <= 1'b1; // idle: txd =1
                end
					 
                IDLE1: begin
                    if(cnt_bit < 4'hf) txd_reg <= 1'b1; // idle1: txd =1 make sure we have enough IDLE time
                end
					 
                START: begin
                    if(cnt_bit < 4'hf) txd_reg <= 1'b0; // start: txd =0;
                end
                
                DATA: begin
                    if(cnt_data != 8'h8 && cnt_bit == 4'h0) //data: txd = txdata[7~0]
                        txd_reg <= txdata[cnt_data];          
                end             
    
                STOP: begin
                    if(cnt_bit < 4'hf) txd_reg <= 1'b1; // stop: txd =1;
                 end
                 
                default:
                    txd_reg <=  1'b1;     
                    
            endcase   
        
        end //end else     
            
    end //end always

    assign txd = txd_reg;


endmodule

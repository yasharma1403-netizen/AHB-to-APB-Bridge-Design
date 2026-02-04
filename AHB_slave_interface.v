module AHB_slave_interface(input hclk, hresetn, hwrite, hreadyin,
                           input [31:0] hwdata, haddr, prdata,
                           input [1:0] htrans, hresp,
                           output reg  valid, hwrite_reg,
                           output reg[31:0] haddr1, haddr2, hwdata1, hwdata2,
                           output reg[2:0] temp_selx,
                           output [31:0] hrdata);

//pipelining the address and the data

always@(posedge hclk)
  begin 
   if(!hresetn)
     begin
       haddr1<=0;             
       haddr2<=0;
     end
   else
     begin
       haddr1<=haddr;
       haddr2<=haddr1;
     end 
  end

always@(posedge hclk)
  begin 
   if(!hresetn)
     begin
       hwdata1<=0;             
       hwdata2<=0;
     end
   else
     begin
       hwdata1<=hwdata;
       hwdata2<=hwdata1;
     end 
  end

always@(posedge hclk)
  begin 
   if(!hresetn)
     begin
       hwrite_reg<=0;             
     end
   else
     begin
       hwrite_reg<=hwrite;
     end 
  end

//checking if the conditions are valid are or not

always@(*)
 begin
  valid=1'b0;
  if(hreadyin && haddr>=32'h8000_0000 && haddr<=32'h8c00_0000 && htrans==2'b10 || htrans==2'b11)
   begin
    valid=1;
   end
  else
   begin
    valid=0;
   end
 end

//assigning the value to temp_selx

always@(*)
 begin
  temp_selx=3'b000;
  if(haddr>=32'h8000_0000 && haddr<=32'h8400_0000)
   begin
    temp_selx=3'b001;
   end
  else if(haddr>=32'h8400_0000 && haddr<=32'h8800_0000)
   begin
    temp_selx=3'b010;
   end
  else if(haddr>=32'h8800_0000 && haddr<=32'h8c00_0000)
   begin
    temp_selx=3'b100;
   end
  else
   begin
    temp_selx=3'b000; 
   end
 end

  
  assign hrdata=prdata;
  //assign hresp=2'b0;
  
 endmodule
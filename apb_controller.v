module APB_Controller(
input valid, hwrite_reg, hwrite, hresetn, hreadyin, hclk,
input [31:0] haddr, haddr1, haddr2, hwdata, hwdata1, hwdata2, prdata,
input [2:0] temp_selx,
output reg pwrite, penable, hr_readyout,
output reg[31:0] paddr, pwdata,
output reg[2:0] psel);

reg penable_temp, pwrite_temp, hr_readyout_temp;
reg[2:0] psel_temp;
reg[31:0] pwdata_temp, paddr_temp;

parameter ST_IDLE=3'b000,
    ST_WWAIT=3'b001,
    ST_WRITEP=3'b010,
    ST_WRITE=3'b011,
    ST_WENABLE=3'b100,
    ST_WENABLEP=3'b101,
    ST_READ=3'b110,
    ST_RENABLE=3'b111;

reg[2:0] present, next;

//present state logic

always@(posedge hclk)
 begin 
  if(!hresetn)
   begin
    present <= ST_IDLE;
   end
  else
   begin
     present <= next;
   end
 end

//next state logic

always@(*)
 
 begin
  next = ST_IDLE;
  case(present)
     ST_IDLE: begin
               if(valid==1 && hwrite==1)
                next = ST_WWAIT;
               else if(valid==1 && hwrite==0)
                next = ST_READ;
               else
                next = ST_IDLE;
               end
     ST_WWAIT: begin
                if(valid==1)
                 next=ST_WRITEP;
                else
                 next=ST_WRITE;
               end
     ST_WRITEP: begin
                 next=ST_WENABLEP;
                end
     ST_WRITE: begin
                if(valid==1)
                 next=ST_WENABLEP;
                else
                 next=ST_WENABLE;
			   end
     ST_WENABLE: begin
                   if(valid==1 && hwrite==0)
                    next=ST_READ;
                   else if(valid==1 && hwrite==1)
                    next=ST_WWAIT;
                   else
                    next=ST_IDLE;
				 end
     ST_WENABLEP: begin
                   if(valid==1 && hwrite_reg==1)
                    next=ST_WRITEP;
                   else if(valid==0 && hwrite_reg==1)
                    next=ST_WRITE;
                   else 
                    next=ST_READ;
				  end
     ST_READ:  begin
	          next=ST_RENABLE;
			  end
     ST_RENABLE: 
	            begin
                  if(valid && !hwrite)
                   next=ST_READ;
                  else if(valid && hwrite)
                   next=ST_WWAIT;
                  else if(!valid)
                   next=ST_IDLE;
                end
               endcase
    end 

//temporary logic

always@(*)

    begin
     case(present)
      ST_IDLE:
                if(valid && !hwrite)
                 begin
                   paddr_temp=haddr;
                   pwrite_temp=hwrite;
                   psel_temp=temp_selx;
                   penable_temp=0;
                   hr_readyout_temp=0;
                 end

                else if(valid && hwrite)
                 begin
                   psel_temp=0;
                   penable_temp=0;
                   hr_readyout_temp=1;
                 end

                else
                 begin
                   psel_temp=0;
                   penable_temp=0;
                   hr_readyout_temp=1; 
                 end

      ST_READ: 
             begin
              penable_temp=1;
              hr_readyout_temp=1;
             end
 
      ST_RENABLE: if(valid && !hwrite)
                 begin
                   paddr_temp=haddr;
                   pwrite_temp=hwrite;
                   psel_temp=temp_selx;
                  hr_readyout_temp=0;
                  penable_temp=0;
                 end

                else if(valid && hwrite)
                 begin
                   psel_temp=0;
                   penable_temp=0;
                   hr_readyout_temp=1;
                 end

      ST_WWAIT:
              if(valid)
               begin
                hr_readyout_temp=0;
                penable_temp=0;
                paddr_temp=haddr1;
                pwdata_temp=hwdata;
				pwrite_temp=hwrite;
                psel_temp=temp_selx;
			   end
			  
			  else
			   begin
			    paddr_temp=haddr;
				pwdata_temp=hwdata;
				pwrite_temp=hwrite;
				hr_readyout_temp=1'b0;
			   end
			   
      ST_WRITE:
	         begin
			  penable_temp=1;
			  hr_readyout_temp=1;
			 end
			 
	  ST_WRITEP:
	          begin
			    paddr_temp=haddr1;
				pwdata_temp=hwdata;
				penable_temp=1;
				hr_readyout_temp=0;
              end
                 

      ST_WENABLEP:
	           begin
			    paddr_temp=haddr1;
				pwdata_temp=hwdata;
				pwrite_temp=hwrite;
				psel_temp=temp_selx;
				penable_temp=0;
				hr_readyout_temp=0;
               end
     endcase
	end
	
//output logic

always@(posedge hclk)
 begin
  if(!hresetn)
   begin
    paddr<=0;
	pwdata<=0;
	pwrite<=0;
	penable<=0;
	psel<=0;
	hr_readyout<=0;
   end
   
  else
   begin
    paddr<=paddr_temp;
	pwdata<=pwdata_temp;
	pwrite<=pwrite_temp;
	penable<=penable_temp;
	psel<=psel_temp;
	hr_readyout<=hr_readyout_temp;
   end
 end

endmodule
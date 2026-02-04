module AHB_Master(input hclk, hresetn, hr_readyout,
                  input [31:0] hrdata,
				  output reg hwrite,hreadyin,
				  output reg [31:0] haddr, hwdata,
				  output reg [1:0]htrans);
				  reg [2:0] hburst;  //single,4,8,16,...
				  reg [2:0] hsize;   //size 8,16,...

integer i,j;

task single_write();
  begin
  @(posedge hclk)
     #1;
	 begin
	    hwrite=1;
		hreadyin=1;
		htrans=2'd2;
		hsize=0;
		hburst=0;
		haddr=32'h8000_0001;
	end
	
  @(posedge hclk)
	    #1;
	begin
	    htrans=2'd0;
		hwdata=8'h80;
	end
  end
endtask

task single_read();
 begin
  @(posedge hclk)
    begin
	 hwrite=0;
	 htrans=2'd2;
	 hreadyin=1;
	 hburst=0;
	 hsize=0;
	 haddr=32'h8000_0001;
	end
  @(posedge hclk)
   #1;
    begin
	 htrans=2'd0;
	end
 end
endtask

task burst_write();
 begin
  @(posedge hclk)
   #1;  
   begin
    hwrite=1'b1;
	htrans=2'd2;
	hburst=3'd3;
	hsize=0;
	hreadyin=1;
	haddr=32'h8000_0001;
   end
   
  @(posedge hclk)
   #1;
   begin
    haddr=haddr+1'b1;
    hwdata={$random}%256;
    htrans=2'd3;
   end

 for(i=0;i<2;i=i+1)
  begin
  @(posedge hclk);
    #1
    haddr=haddr+1;  
	hwdata={$random}%256;
	htrans=2'd3;
  end
 
   @(posedge hclk);
    #1;
	begin
	 htrans=2'd0;
     hwdata={$random}%256;
    end	
 end
endtask
endmodule
	
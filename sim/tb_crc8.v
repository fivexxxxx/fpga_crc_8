`timescale 1ns/1ns
//仿真验证--由AI完成的激励文件，稍微修改。
//输入四个数据03 00 01 02，计算校验位为21，
//一起输出加校验位的5个数据03 00 01 02 21。
//
module tb_crc8();

reg                 clk					; 
reg                 rst					;
reg                 crc_en				;
reg 	[7:0]       dina				;
wire             	crc_vld				;
wire 	[7:0]    	crc_dout			;

crc8 crc8_inst(
    .clk            (clk        )		,
    .rst            (rst        )		,
    .crc_en         (crc_en     )		,    
    .dina           (dina       )		,
    .crc_vld        (crc_vld    )		,
    .crc_dout       (crc_dout   )		
);

initial begin 
    clk = 1'b0;
    forever #10 clk = ~clk;        //设置时钟周期为20ns
end    
//#10由AI生成的#20修改，要不仿真结果异常，其他没有改动
initial begin
    rst = 1'b1; crc_en = 1'b0; dina = 8'h00;
    #100 rst = 1'b0;            			//复位100ns
    #10  crc_en = 1'b1; dina = 8'h03;    	//输入数据03,并使能crc_en
    #10  crc_en = 1'b0;          			//20ns后crc_en拉低
    #10  crc_en = 1'b1; dina = 8'h00;    	//输入数据00,并使能crc_en          
    #10  crc_en = 1'b0;          
    #10  crc_en = 1'b1; dina = 8'h01;  		//输入数据01,并使能crc_en
    #10  crc_en = 1'b0;          
    #10  crc_en = 1'b1; dina = 8'h02;    	//输入数据02,并使能crc_en          
    #10  crc_en = 1'b0;          
end 

endmodule
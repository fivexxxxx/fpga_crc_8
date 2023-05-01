module crc8(
	input 				clk				,
	input 				rst				,
	input 				crc_en			,
	input 		[7:0] 	dina			,
	output reg 			crc_vld			,
	output reg 	[7:0]	crc_dout		
);		
wire [7:0] 				d				;
reg  [7:0] 				c				;
reg  [7:0] 				newcrc			;
wire 					end_vld			;
reg 					dly				;

always @(posedge clk ) begin
  dly<=crc_en;// 打一拍用来产生校验位标志end_vld
end
assign  d = dina;
assign end_vld = dly&(!crc_en);//产生校验位标志 end_vld

always@(*)begin//组合逻辑
    newcrc[0] = d[7] ^ d[6] ^ d[0] ^ c[0] ^ c[6] ^ c[7]					;
    newcrc[1] = d[6] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[6]					;
    newcrc[2] = d[6] ^ d[2] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[2] ^ c[6]	;
    newcrc[3] = d[7] ^ d[3] ^ d[2] ^ d[1] ^ c[1] ^ c[2] ^ c[3] ^ c[7]	;
    newcrc[4] = d[4] ^ d[3] ^ d[2] ^ c[2] ^ c[3] ^ c[4]					;
    newcrc[5] = d[5] ^ d[4] ^ d[3] ^ c[3] ^ c[4] ^ c[5]					;
    newcrc[6] = d[6] ^ d[5] ^ d[4] ^ c[4] ^ c[5] ^ c[6]					;
    newcrc[7] = d[7] ^ d[6] ^ d[5] ^ c[5] ^ c[6] ^ c[7]					;
end

always@(posedge clk)begin
	if(rst)begin
		c<='d0;//初始化寄存器为0
	end
	else if(crc_en)begin
			c<=newcrc;//时序逻辑打拍寄存
		end
	else if(end_vld)begin
			c<=c;//校验位寄存
		end
	else begin
		c<='d0;//初始化寄存器为0
	end
end
always @(posedge clk ) begin
	if (rst) begin
		crc_vld<=1'b0;
	end
	else  begin
		crc_vld<=end_vld|crc_en;//产生输出数据的标志信号
	end
end
always @(posedge clk) begin
	if (rst) begin
		crc_dout<='d0;  
	end
	else if (end_vld) begin
		crc_dout<=c;//添加校验位
	end
	else begin
		crc_dout<=dina;//被校验的数据
	end
end
endmodule
//仿真验证，输入四个数据03 00 01 02，计算校验位为21，一起输出加校验位的5个数据03 00 01 02 21。
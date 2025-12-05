module tb_locksystem();
reg clk,rst_btn;
reg [3:0] entered_pwd;
wire led_locked, led_unlocked, led_alert;
top_module1 uut (.clk(clk),.rst_btn(rst_btn),.entered_pwd(entered_pwd),.led_locked(led_locked),.led_unlocked(led_unlocked),.led_alert(led_alert));
always #5 clk=~clk;
initial begin
clk=0;rst_btn=1;

end
initial begin
#10 rst_btn=0;

#20 entered_pwd = 1000;
#20 entered_pwd = 1001;
#20 entered_pwd = 1100;
end
initial begin
#20 rst_btn=1;
end
initial begin
#10 rst_btn=0;
end
initial begin
#20 entered_pwd= 1010;
end
endmodule

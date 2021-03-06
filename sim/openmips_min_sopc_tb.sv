`timescale 1ns/1ps
import project_types::*;

module openmips_min_sopc_tb();

logic CLOCK_50;
reset_status_t rst;

initial begin
    CLOCK_50 = 1'b0;
    forever
        # 10
          CLOCK_50 = ~CLOCK_50;
end

initial begin
    rst = RST_ENABLE;
    #195 rst = RST_DISABLE;
    #1000 $stop;
end

openmips_min_sopc openmips_min_sopc0(
                      .clk(CLOCK_50),
                      .rst(rst)
                  );

endmodule

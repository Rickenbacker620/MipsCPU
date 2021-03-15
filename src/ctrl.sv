import project_types::*;

module ctrl (
    input logic rst,
    input logic stallreq_from_id,
    input logic stallreq_from_ex,

    output logic[5:0] stall
);

always_comb begin
    if (rst == RST_ENABLE) begin
        stall = 6'b000000;
    end
    else if (stallreq_from_ex == 1'b1) begin
        stall = 6'b001111;
    end
    else if (stallreq_from_id == 1'b1) begin
        stall = 6'b000111;
    end
    else begin
        stall = 6'b000000;
    end
end

endmodule
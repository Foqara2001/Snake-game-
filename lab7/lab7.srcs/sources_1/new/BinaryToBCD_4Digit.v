module BinaryToBCD_4Digit(
    input [15:0] binary,
    output reg [3:0] thousands,
    output reg [3:0] hundreds,
    output reg [3:0] tens,
    output reg [3:0] ones
);
    integer i;
    reg [35:0] shift;

    always @(*) begin
        shift = 0;
        shift[15:0] = binary;
        for (i = 0; i < 16; i = i + 1) begin
            if (shift[19:16] >= 5) shift[19:16] = shift[19:16] + 3;
            if (shift[23:20] >= 5) shift[23:20] = shift[23:20] + 3;
            if (shift[27:24] >= 5) shift[27:24] = shift[27:24] + 3;
            if (shift[31:28] >= 5) shift[31:28] = shift[31:28] + 3;
            shift = shift << 1;
        end
        thousands = shift[31:28];
        hundreds  = shift[27:24];
        tens      = shift[23:20];
        ones      = shift[19:16];
    end
endmodule

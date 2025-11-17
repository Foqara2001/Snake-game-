`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tel Aviv University
// Engineer: Ahmad Foqara / Mohammad Foqara
// 
// Design Name: Snake Game Score Counter
// Module Name: ScoreCounter
// Description: BCD score counter using Lim_Inc to increment 4-digit decimal score.
//              Ideal for use with Seg_7_Display module.
// Target Device: Basys3
//////////////////////////////////////////////////////////////////////////////////

module ScoreCounter(
    input clk,
    input reset,           // Active-high reset
    input inc_score,       // Pulse HIGH when snake eats food
    output [6:0] seg,      // 7-segment segments
    output [3:0] an,       // 7-segment anodes
    output dp              // Decimal point
);

    // BCD digit registers
    reg [3:0] ones = 0;
    reg [3:0] tens = 0;
    reg [3:0] hundreds = 0;
    reg [3:0] thousands = 0;

    // Lim_Inc outputs
    wire [3:0] ones_sum, tens_sum, hundreds_sum, thousands_sum;
    wire co_ones, co_tens, co_hundreds, co_thousands;

    // Chain 4 Lim_Inc modules for BCD counting
    Lim_Inc #(.L(10)) L0 (.a(ones),     .ci(inc_score),    .sum(ones_sum),     .co(co_ones));
    Lim_Inc #(.L(10)) L1 (.a(tens),     .ci(co_ones),      .sum(tens_sum),     .co(co_tens));
    Lim_Inc #(.L(10)) L2 (.a(hundreds), .ci(co_tens),      .sum(hundreds_sum), .co(co_hundreds));
    Lim_Inc #(.L(10)) L3 (.a(thousands),.ci(co_hundreds),  .sum(thousands_sum),.co(co_thousands));

    // Score counting logic
    always @(posedge clk) begin
        if (reset) begin
            ones      <= 0;
            tens      <= 0;
            hundreds  <= 0;
            thousands <= 0;
        end else if (inc_score) begin
            ones      <= ones_sum;
            tens      <= tens_sum;
            hundreds  <= hundreds_sum;
            thousands <= thousands_sum;
        end
    end

    // Combine BCD digits for display
    wire [15:0] score_bcd = {thousands, hundreds, tens, ones};

    // Display score on 7-segment
    Seg_7_Display seg_disp (
        .x(score_bcd),
        .clk(clk),
        .clr(reset),
        .a_to_g(seg),
        .an(an),
        .dp(dp)
    );

endmodule

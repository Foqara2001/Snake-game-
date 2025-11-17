`timescale 1ns / 1ps

module tb_ScoreCounter_7step;

    // Inputs
    reg clk;
    reg reset;
    reg inc_score;

    // Outputs
    wire [6:0] seg;
    wire [3:0] an;
    wire dp;

    // UUT
    ScoreCounter uut (
        .clk(clk),
        .reset(reset),
        .inc_score(inc_score),
        .seg(seg),
        .an(an),
        .dp(dp)
    );

    // Clock: 100 MHz
    initial clk = 0;
    always #5 clk = ~clk;

    // Segment to digit decoder (common cathode)
    function [3:0] seg_to_digit(input [6:0] s);
        case (s)
            7'b1000000: seg_to_digit = 0;
            7'b1111001: seg_to_digit = 1;
            7'b0100100: seg_to_digit = 2;
            7'b0110000: seg_to_digit = 3;
            7'b0011001: seg_to_digit = 4;
            7'b0010010: seg_to_digit = 5;
            7'b0000010: seg_to_digit = 6;
            7'b1111000: seg_to_digit = 7;
            7'b0000000: seg_to_digit = 8;
            7'b0010000: seg_to_digit = 9;
            default:    seg_to_digit = 4'b1111;
        endcase
    endfunction

    reg [3:0] ones_digit = 0;

    always @(posedge clk) begin
        if (an == 4'b1110) begin
            ones_digit <= seg_to_digit(seg);
            $display("[Time %0t] Score = %0d", $time, seg_to_digit(seg));
        end
    end

    // Stimulus: 7 pulses
    initial begin
        $display("Starting short ScoreCounter test...");

        // Reset
        reset = 1;
        inc_score = 0;
        #20;
        reset = 0;

        // Send 7 score pulses
        repeat (7) begin
            inc_score = 1;
            #10;
            inc_score = 0;
            #30;
        end

        #100;
        $display("Finished test for 7 score increments.");
        $finish;
    end

endmodule

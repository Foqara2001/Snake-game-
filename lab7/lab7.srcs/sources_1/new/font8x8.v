module font8x8 (
    input  [7:0] char,
    input  [2:0] row,
    output reg [7:0] row_data
);
    always @(*) begin
        case (char)
            "G": case (row) 0: row_data = 8'b00111100;
                              1: row_data = 8'b01100110;
                              2: row_data = 8'b01100000;
                              3: row_data = 8'b01101110;
                              4: row_data = 8'b01100110;
                              5: row_data = 8'b01100110;
                              6: row_data = 8'b00111100;
                              7: row_data = 8'b00000000; endcase
            "A": case (row) 0: row_data = 8'b00011000;
                              1: row_data = 8'b00111100;
                              2: row_data = 8'b01100110;
                              3: row_data = 8'b01111110;
                              4: row_data = 8'b01100110;
                              5: row_data = 8'b01100110;
                              6: row_data = 8'b01100110;
                              7: row_data = 8'b00000000; endcase
            "M": case (row) 0: row_data = 8'b01100110;
                              1: row_data = 8'b01111110;
                              2: row_data = 8'b01111110;
                              3: row_data = 8'b01100110;
                              4: row_data = 8'b01100110;
                              5: row_data = 8'b01100110;
                              6: row_data = 8'b01100110;
                              7: row_data = 8'b00000000; endcase
            "E": case (row) 0: row_data = 8'b01111110;
                              1: row_data = 8'b01100000;
                              2: row_data = 8'b01111100;
                              3: row_data = 8'b01100000;
                              4: row_data = 8'b01100000;
                              5: row_data = 8'b01100000;
                              6: row_data = 8'b01111110;
                              7: row_data = 8'b00000000; endcase
            "O": case (row) 0: row_data = 8'b00111100;
                              1: row_data = 8'b01100110;
                              2: row_data = 8'b01100110;
                              3: row_data = 8'b01100110;
                              4: row_data = 8'b01100110;
                              5: row_data = 8'b01100110;
                              6: row_data = 8'b00111100;
                              7: row_data = 8'b00000000; endcase
            "V": case (row) 0: row_data = 8'b01100110;
                              1: row_data = 8'b01100110;
                              2: row_data = 8'b01100110;
                              3: row_data = 8'b01100110;
                              4: row_data = 8'b01100110;
                              5: row_data = 8'b00111100;
                              6: row_data = 8'b00011000;
                              7: row_data = 8'b00000000; endcase
            "R": case (row) 0: row_data = 8'b01111100;
                              1: row_data = 8'b01100110;
                              2: row_data = 8'b01100110;
                              3: row_data = 8'b01111100;
                              4: row_data = 8'b01101100;
                              5: row_data = 8'b01100110;
                              6: row_data = 8'b01100110;
                              7: row_data = 8'b00000000; endcase
            " ": case (row) default: row_data = 8'b00000000; endcase
            default: row_data = 8'b00000000;
        endcase
    end
endmodule

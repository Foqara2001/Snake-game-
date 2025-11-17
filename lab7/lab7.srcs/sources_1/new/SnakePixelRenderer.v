module SnakePixelRenderer #(
    parameter MAX_SNAKE_LENGTH = 100
)(
    input pixel_clk,
    input [7:0] snake_length,
    input [11*MAX_SNAKE_LENGTH-1:0] snake_x_flat,
    input [11*MAX_SNAKE_LENGTH-1:0] snake_y_flat,
    input [10:0] XCoord,
    input [10:0] YCoord,
    input [10:0] food_x,
    input [10:0] food_y,
    input food_active,
    input game_over,
    output reg [11:0] pixel_color
);

    integer i;
    reg [10:0] x_part, y_part;
    reg is_body_pixel;
    reg is_head_pixel;
    reg is_food_pixel;

    // === Game Over Text Setup ===
    reg [7:0] game_over_str [0:8];
    initial begin
        game_over_str[0] = "G";
        game_over_str[1] = "A";
        game_over_str[2] = "M";
        game_over_str[3] = "E";
        game_over_str[4] = " ";
        game_over_str[5] = "O";
        game_over_str[6] = "V";
        game_over_str[7] = "E";
        game_over_str[8] = "R";
    end

    wire [2:0] font_row = YCoord[2:0];
    wire [2:0] font_col = 7 - XCoord[2:0];
    wire [3:0] char_index = (XCoord - 280) >> 3;

    reg [7:0] current_char;
    wire [7:0] font_byte;

    font8x8 font_inst (
        .char(current_char),
        .row(font_row),
        .row_data(font_byte)
    );

    always @(posedge pixel_clk) begin
        if (game_over) begin

            current_char = game_over_str[char_index];
            if (font_byte[font_col])
                pixel_color <= 12'hF00; // Red "GAME OVER" text
            else
                pixel_color <= 12'h000; // Black background

        end else begin
            is_body_pixel = 0;
            is_head_pixel = 0;

            for (i = 0; i < snake_length; i = i + 1) begin
                x_part = snake_x_flat >> (11 * i);
                y_part = snake_y_flat >> (11 * i);
                if (x_part[10:0] == XCoord && y_part[10:0] == YCoord) begin
                    if (i == 0)
                        is_head_pixel = 1;
                    else
                        is_body_pixel = 1;
                end
            end

            is_food_pixel = (food_active && food_x == XCoord && food_y == YCoord);

            if (is_head_pixel)
                pixel_color <= 12'hFF0; // Yellow head
            else if (is_body_pixel)
                pixel_color <= 12'h0F0; // Green body
            else if (is_food_pixel)
                pixel_color <= 12'hF00; // Red food
            else
                pixel_color <= 12'h000; // Black
        end
    end
endmodule

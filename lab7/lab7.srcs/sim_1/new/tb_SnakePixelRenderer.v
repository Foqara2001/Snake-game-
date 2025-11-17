`timescale 1ns / 1ps

module tb_SnakePixelRenderer;

    parameter MAX_SNAKE_LENGTH = 100;

    // Inputs
    reg pixel_clk;
    reg [7:0] snake_length;
    reg [11*MAX_SNAKE_LENGTH-1:0] snake_x_flat;
    reg [11*MAX_SNAKE_LENGTH-1:0] snake_y_flat;
    reg [10:0] XCoord;
    reg [10:0] YCoord;
    reg [10:0] food_x;
    reg [10:0] food_y;
    reg food_active;

    // Output
    wire [11:0] pixel_color;

    // Instantiate the Unit Under Test (UUT)
    SnakePixelRenderer #(
        .MAX_SNAKE_LENGTH(MAX_SNAKE_LENGTH)
    ) uut (
        .pixel_clk(pixel_clk),
        .snake_length(snake_length),
        .snake_x_flat(snake_x_flat),
        .snake_y_flat(snake_y_flat),
        .XCoord(XCoord),
        .YCoord(YCoord),
        .food_x(food_x),
        .food_y(food_y),
        .food_active(food_active),
        .pixel_color(pixel_color)
    );

    // Clock generation
    initial pixel_clk = 0;
    always #5 pixel_clk = ~pixel_clk;

    initial begin
        // Initialize snake with 3 segments: (10,10), (11,10), (12,10)
        snake_length = 3;
        snake_x_flat = 0;
        snake_y_flat = 0;

        snake_x_flat[10:0]   = 11'd10;
        snake_x_flat[21:11]  = 11'd11;
        snake_x_flat[32:22]  = 11'd12;

        snake_y_flat[10:0]   = 11'd10;
        snake_y_flat[21:11]  = 11'd10;
        snake_y_flat[32:22]  = 11'd10;

        food_x = 11'd15;
        food_y = 11'd15;
        food_active = 1;

        // Wait for a few clock cycles and test body pixel
        XCoord = 11'd11; // Second snake segment
        YCoord = 11'd10;
        #10;

        // Test food pixel
        XCoord = 11'd15;
        YCoord = 11'd15;
        #10;

        // Test empty pixel
        XCoord = 11'd20;
        YCoord = 11'd20;
        #10;

        $display("Pixel rendering test completed.");
        $finish;
    end

endmodule

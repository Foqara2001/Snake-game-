// SnakeGameTop.v
`timescale 1ns / 1ps

module SnakeGameTop(
    input clk,
    input reset,
    input PS2Clk,
    input PS2Data,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output Hsync,
    output Vsync,
    output [6:0] seg,
    output [3:0] an,
    output dp
);

    parameter GRID_WIDTH = 100;
    parameter GRID_HEIGHT = 75;
    parameter SNAKE_INIT_LENGTH = 3;
    parameter INITIAL_SPEED = 10000000;
    parameter MAX_SNAKE_LENGTH = 100;

    wire [10:0] XCoord, YCoord;
    wire [11:0] pixel_color;
    wire [7:0] scancode;
    wire keyPressed;
    wire pixel_clk;

    wire [11*MAX_SNAKE_LENGTH-1:0] snake_x_flat;
    wire [11*MAX_SNAKE_LENGTH-1:0] snake_y_flat;
    wire [10:0] food_x;
    wire [10:0] food_y;
    wire food_active;
    wire food_eaten;
    wire [7:0] snake_length;
    wire game_over;
    wire border_collision;
    wire [1:0] direction;

    VGA_Interface vga(
        .clk(clk),
        .rstn(~reset),
        .pixel_color(pixel_color),
        .vgaRed(vgaRed),
        .vgaGreen(vgaGreen),
        .vgaBlue(vgaBlue),
        .Hsync(Hsync),
        .Vsync(Vsync),
        .XCoord(XCoord),
        .YCoord(YCoord),
        .pixel_clk(pixel_clk)
    );

    Ps2_interface ps2(
        .PS2Clk(PS2Clk),
        .rstn(~reset),
        .PS2Data(PS2Data),
        .scancode(scancode),
        .keypressed(keyPressed)
    );

    SnakeGameLogic #(
        .GRID_WIDTH(GRID_WIDTH),
        .GRID_HEIGHT(GRID_HEIGHT),
        .SNAKE_INIT_LENGTH(SNAKE_INIT_LENGTH),
        .INITIAL_SPEED(INITIAL_SPEED),
        .MAX_SNAKE_LENGTH(MAX_SNAKE_LENGTH)
    ) game_logic (
        .clk(clk),
        .reset(reset),
        .scancode(scancode),
        .keyPressed(keyPressed),
        .snake_x_flat(snake_x_flat),
        .snake_y_flat(snake_y_flat),
        .food_x(food_x),
        .food_y(food_y),
        .food_active(food_active),
        .food_eaten(food_eaten),
        .snake_length(snake_length),
        .game_over(game_over)
       
    );

    SnakePixelRenderer #(
        .MAX_SNAKE_LENGTH(MAX_SNAKE_LENGTH)
    ) renderer (
        .pixel_clk(pixel_clk),
        .snake_length(snake_length),
        .snake_x_flat(snake_x_flat),
        .snake_y_flat(snake_y_flat),
        .XCoord(XCoord),
        .YCoord(YCoord),
        .food_x(food_x),
        .food_y(food_y),
        .food_active(food_active),
        .pixel_color(pixel_color),
        .game_over(game_over)
        
    );

    wire score_pulse = food_eaten && food_active;

    ScoreCounter score_unit (
        .clk(clk),
        .reset(reset),
        .inc_score(score_pulse),
        .seg(seg),
        .an(an),
        .dp(0)
    );

endmodule

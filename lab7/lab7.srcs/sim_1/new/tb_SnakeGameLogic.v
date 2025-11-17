`timescale 1ns / 1ps

module tb_SnakeGameLogic;

    parameter GRID_WIDTH = 100;
    parameter GRID_HEIGHT = 75;
    parameter SNAKE_INIT_LENGTH = 3;
    parameter INITIAL_SPEED = 10; // much lower for faster sim
    parameter MAX_SNAKE_LENGTH = 100;

    // Inputs
    reg clk;
    reg reset;
    reg [7:0] scancode;
    reg keyPressed;

    // Outputs
    wire [11*MAX_SNAKE_LENGTH-1:0] snake_x_flat;
    wire [11*MAX_SNAKE_LENGTH-1:0] snake_y_flat;
    wire [10:0] food_x;
    wire [10:0] food_y;
    wire food_active;
    wire food_eaten;
    wire border_collision;
    wire [7:0] snake_length;
    wire game_over;
    wire [1:0] direction;

    // Instantiate the Unit Under Test (UUT)
    SnakeGameLogic #(
        .GRID_WIDTH(GRID_WIDTH),
        .GRID_HEIGHT(GRID_HEIGHT),
        .SNAKE_INIT_LENGTH(SNAKE_INIT_LENGTH),
        .INITIAL_SPEED(INITIAL_SPEED), // ? fast movement
        .MAX_SNAKE_LENGTH(MAX_SNAKE_LENGTH)
    ) uut (
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
        .border_collision(border_collision),
        .snake_length(snake_length),
        .game_over(game_over),
        .direction(direction)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Task to simulate key press
    task press_key(input [7:0] code);
    begin
        scancode = code;
        keyPressed = 1;
        #10;
        keyPressed = 0;
        #10;
    end
    endtask

    initial begin
        // Initialize
        reset = 1;
        scancode = 8'h00;
        keyPressed = 0;
        #50;
        reset = 0;

        // Start the game with Right arrow key (0x74)
        press_key(8'h74); // Right
        #50;

        // Wait for the snake to start moving and food to spawn
        repeat (50) #10;

        // Change direction: Down
        press_key(8'h72);
        repeat (30) #10;

        // Change direction: Left
        press_key(8'h6B);
        repeat (30) #10;

        // Change direction: Up
        press_key(8'h75);
        repeat (30) #10;

        // Wait to observe food_eaten and snake growth
        repeat (200) #10;

        $display("Simulation finished. Snake Length: %0d, Game Over: %0b", snake_length, game_over);
        $finish;
    end

endmodule

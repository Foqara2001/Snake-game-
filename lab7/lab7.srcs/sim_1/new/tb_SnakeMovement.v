`timescale 1ns / 1ps

module tb_SnakeMovement;

    parameter GRID_WIDTH = 100;
    parameter GRID_HEIGHT = 75;
    parameter MAX_SNAKE_LENGTH = 100;
    parameter SNAKE_INIT_LENGTH = 3;

    // Inputs
    reg clk;
    reg reset;
    reg [1:0] direction;
    reg [7:0] snake_length;
    reg enable_move;
    reg [10:0] food_x;
    reg [10:0] food_y;
    reg food_active;

    // Outputs
    wire food_eaten;
    wire border_collision;
    wire [11*MAX_SNAKE_LENGTH-1:0] snake_x_flat;
    wire [11*MAX_SNAKE_LENGTH-1:0] snake_y_flat;

    // Instantiate the Unit Under Test (UUT)
    SnakeMovement #(
        .GRID_WIDTH(GRID_WIDTH),
        .GRID_HEIGHT(GRID_HEIGHT),
        .MAX_SNAKE_LENGTH(MAX_SNAKE_LENGTH),
        .SNAKE_INIT_LENGTH(SNAKE_INIT_LENGTH)
    ) uut (
        .clk(clk),
        .reset(reset),
        .direction(direction),
        .snake_length(snake_length),
        .enable_move(enable_move),
        .food_x(food_x),
        .food_y(food_y),
        .food_active(food_active),
        .food_eaten(food_eaten),
        .border_collision(border_collision),
        .snake_x_flat(snake_x_flat),
        .snake_y_flat(snake_y_flat)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Snake movement task
    task move_snake(input [1:0] dir, input [10:0] fx, input [10:0] fy, input f_active);
    begin
        direction = dir;
        food_x = fx;
        food_y = fy;
        food_active = f_active;
        enable_move = 1;
        #10;
        enable_move = 0;
        #10;
        if (food_eaten) begin
            snake_length = snake_length + 1;
        end
    end
    endtask

    initial begin
        $display("Starting SnakeMovement testbench...");

        // Initial values
        reset = 1;
        direction = 2'b00;
        snake_length = SNAKE_INIT_LENGTH;
        enable_move = 0;
        food_x = 0;
        food_y = 0;
        food_active = 0;

        #20 reset = 0;

        // === First apple ===
        food_x = (GRID_WIDTH / 2) + 1;
        food_y = GRID_HEIGHT / 2;
        food_active = 1;
        move_snake(2'b00, food_x, food_y, 1);

        // === Second apple ===
        food_x = food_x + 1;
        food_y = food_y;
        move_snake(2'b00, food_x, food_y, 1);

        // === Third apple ===
        food_x = food_x + 1;
        food_y = food_y;
        move_snake(2'b00, food_x, food_y, 1);

        // === Move forward without eating ===
        food_active = 0;
        repeat (3) move_snake(2'b00, 0, 0, 0);

        // === Fourth apple ===
        food_x = food_x + 1;
        food_y = food_y;
        food_active = 1;
        move_snake(2'b00, food_x, food_y, 1);

        // === Final moves ===
        food_active = 0;
        repeat (5) move_snake(2'b00, 0, 0, 0);

        $display("Testbench finished.");
        $finish;
    end

endmodule

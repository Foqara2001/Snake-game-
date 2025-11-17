module SnakeMovement #(
    parameter GRID_WIDTH = 100,
    parameter GRID_HEIGHT = 75,
    parameter MAX_SNAKE_LENGTH = 100,
    parameter SNAKE_INIT_LENGTH = 3
)(
    input clk,
    input reset,
    input [1:0] direction,
    input [7:0] snake_length,
    input enable_move,
    input [10:0] food_x,
    input [10:0] food_y,
    input food_active,
    output reg food_eaten,
    output reg border_collision,
    output reg [11*MAX_SNAKE_LENGTH-1:0] snake_x_flat,
    output reg [11*MAX_SNAKE_LENGTH-1:0] snake_y_flat
);

    integer i;
    reg [7:0] snake_length_d;

    always @(posedge clk)
        snake_length_d <= snake_length;

    function [10:0] get_x(input integer idx);
        get_x = snake_x_flat[11*idx +: 11];
    endfunction

    function [10:0] get_y(input integer idx);
        get_y = snake_y_flat[11*idx +: 11];
    endfunction

    reg [10:0] head_x, head_y;
    reg [10:0] new_head_x, new_head_y;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < MAX_SNAKE_LENGTH; i = i + 1) begin
                snake_x_flat[11*i +: 11] <= GRID_WIDTH / 2 + i;
                snake_y_flat[11*i +: 11] <= GRID_HEIGHT / 2;
            end
            food_eaten <= 0;
            border_collision <= 0;

        end else if (enable_move) begin
            // Current head position
            head_x = get_x(0);
            head_y = get_y(0);

            // Compute next head position
            case (direction)
                2'b00: begin new_head_x = head_x + 1; new_head_y = head_y;     end // Right
                2'b01: begin new_head_x = head_x;     new_head_y = head_y - 1; end // Up
                2'b10: begin new_head_x = head_x - 1; new_head_y = head_y;     end // Left
                2'b11: begin new_head_x = head_x;     new_head_y = head_y + 1; end // Down
                default: begin new_head_x = head_x; new_head_y = head_y; end
            endcase

            // Check if food was eaten
            food_eaten <= (food_active && new_head_x == food_x && new_head_y == food_y);

            // Move the body (shift)
            for (i = MAX_SNAKE_LENGTH - 1; i > 0; i = i - 1) begin
                if (i < snake_length_d) begin
                    snake_x_flat[11*i +: 11] <= get_x(i - 1);
                    snake_y_flat[11*i +: 11] <= get_y(i - 1);
                end else if (i == snake_length_d && food_eaten) begin
                    // Initialize new tail with previous last segment
                    snake_x_flat[11*i +: 11] <= get_x(i - 1);
                    snake_y_flat[11*i +: 11] <= get_y(i - 1);
                end else begin
                    snake_x_flat[11*i +: 11] <= 11'd0;
                    snake_y_flat[11*i +: 11] <= 11'd0;
                end
            end

            // Update head
            snake_x_flat[10:0] <= new_head_x;
            snake_y_flat[10:0] <= new_head_y;

            // Check border collision
            border_collision <= (new_head_x >= GRID_WIDTH || new_head_y >= GRID_HEIGHT);
        end
    end
endmodule

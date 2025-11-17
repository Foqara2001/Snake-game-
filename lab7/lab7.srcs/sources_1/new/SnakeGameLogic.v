module SnakeGameLogic #(
    parameter GRID_WIDTH = 100,
    parameter GRID_HEIGHT = 75,
    parameter SNAKE_INIT_LENGTH = 3,
    parameter INITIAL_SPEED = 10000000,
    parameter MAX_SNAKE_LENGTH = 100
)(
    input clk,
    input reset,
    input [7:0] scancode,
    input keyPressed,
    output [11*MAX_SNAKE_LENGTH-1:0] snake_x_flat,
    output [11*MAX_SNAKE_LENGTH-1:0] snake_y_flat,
    output reg [10:0] food_x,
    output reg [10:0] food_y,
    output reg food_active,
    output food_eaten,
    
    output reg [7:0] snake_length,
    output reg game_over
   
);


    reg [1:0] next_direction;
    reg [31:0] move_counter = 0;
    reg [31:0] move_speed = INITIAL_SPEED;
    reg start_game = 0;
    reg [3:0] moves_since_start = 0;
    reg grow_flag = 0;
    reg [15:0] rand_seed = 16'hABCD;
    wire border_collision ;
    reg [1:0] direction;

    // Pulse generation for enable_move
    reg enable_move_raw;
    reg enable_move_d;
    wire enable_move_pulse;

    always @(posedge clk)
        enable_move_d <= enable_move_raw;

    assign enable_move_pulse = enable_move_raw && !enable_move_d;

    // Movement module
    SnakeMovement #(
        .GRID_WIDTH(GRID_WIDTH),
        .GRID_HEIGHT(GRID_HEIGHT),
        .MAX_SNAKE_LENGTH(MAX_SNAKE_LENGTH),
        .SNAKE_INIT_LENGTH(SNAKE_INIT_LENGTH)
    ) movement (
        .clk(clk),
        .reset(reset),
        .direction(direction),
        .snake_length(snake_length),
        .enable_move(enable_move_pulse),  // use pulse here
        .food_x(food_x),
        .food_y(food_y),
        .food_active(food_active),
        .food_eaten(food_eaten),
        .border_collision(border_collision),
        .snake_x_flat(snake_x_flat),
        .snake_y_flat(snake_y_flat)
    );

    integer i;
    reg [10:0] head_x, head_y, body_x, body_y;
    reg self_collision;

    always @(posedge clk) begin
        if (reset) begin
            direction <= 2'b10;
            snake_length <= SNAKE_INIT_LENGTH;
            food_active <= 0;
            move_counter <= 0;
            grow_flag <= 0;
            moves_since_start <= 0;
            game_over <= 0;
            start_game <= 0;
        end else if (!game_over) begin
            // Direction control
            case (scancode)
                8'h75: if (direction != 2'b11) begin next_direction <= 2'b01; start_game <= 1; end // Up
                8'h73: if (direction != 2'b01) begin next_direction <= 2'b11; start_game <= 1; end // Down
                8'h6B: if (direction != 2'b00) begin next_direction <= 2'b10; start_game <= 1; end // Left
                8'h74: if (direction != 2'b10) begin next_direction <= 2'b00; start_game <= 1; end // Right
            endcase

            // Movement timing
            enable_move_raw <= (start_game && move_counter >= move_speed);

            if (enable_move_pulse) begin
                direction <= next_direction;
                move_counter <= 0;
                moves_since_start <= moves_since_start + 1;

                // Spawn food
                if (!food_active) begin
                    food_x <= rand_seed[7:0] % (GRID_WIDTH - 4) + 2;
                    food_y <= rand_seed[15:8] % (GRID_HEIGHT - 4) + 2;
                    food_active <= 1;
                end

                // Grow snake
                if (grow_flag) begin
                    grow_flag <= 0;
                    if (snake_length < MAX_SNAKE_LENGTH)
                        snake_length <= snake_length + 1;
                end
            end else begin
                move_counter <= move_counter + 1;
            end

            // Self-collision check
            self_collision = 0;
            head_x = snake_x_flat[10:0];
            head_y = snake_y_flat[10:0];

            if (moves_since_start >= 2) begin
                for (i = 1; i < snake_length && i < MAX_SNAKE_LENGTH; i = i + 1) begin
                    body_x = snake_x_flat[11*i +: 11];
                    body_y = snake_y_flat[11*i +: 11];
                    if (head_x == body_x && head_y == body_y)
                        self_collision = 1; 
                end
            end

            if (self_collision || border_collision)
                game_over <= 1;

            if (food_eaten && food_active) begin
                grow_flag <= 1;
                food_active <= 0;
            end
        end
    end

    // Pseudo-random generator
    always @(posedge clk)
        rand_seed <= {rand_seed[14:0], rand_seed[15] ^ rand_seed[13]};

endmodule

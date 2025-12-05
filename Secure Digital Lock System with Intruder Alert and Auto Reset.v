module comparator(
    input [3:0] entered,
    input [3:0] preset,
    output match
);
    assign match = (entered == preset);
endmodule
module counter(
    input clk,
    input rst_btn,               // Physical push button
    input wrong_attempt,
    output reg [1:0] count,
    output reg alert_trigger
);
    always @(posedge clk or posedge rst_btn) begin
        if (rst_btn) begin
            count <= 0;
            alert_trigger <= 0;
        end else if (wrong_attempt && count < 3) begin
            count <= count + 1;
            if (count == 2)        // 0,1,2 ? 3rd wrong attempt
                alert_trigger <= 1;
        end
    end
endmodule
module fsm_controller(
    input clk,
    input rst_btn,                // Physical push-button reset
    input match,
    input alert_trigger,
    output reg [1:0] state,
    output reg led_locked,
    output reg led_unlocked,
    output reg led_alert
);
    parameter LOCKED = 2'b00, UNLOCKED = 2'b01, ALERT = 2'b11;

    always @(posedge clk or posedge rst_btn) begin
        if (rst_btn)
            state <= LOCKED;
        else begin
            case (state)
                LOCKED: begin
                    if (match)
                        state <= UNLOCKED;
                    else if (alert_trigger)
                        state <= ALERT;
                end
                UNLOCKED: begin
                    state <= UNLOCKED; // stays here until reset
                end
                ALERT: begin
                    state <= ALERT;    // stays here until reset
                end
            endcase
        end
    end

    always @(*) begin
        led_locked   = (state == LOCKED);
        led_unlocked = (state == UNLOCKED);
        led_alert    = (state == ALERT);
    end
endmodule
module top_module1(
    input clk,
    input rst_btn,                 // Physical push button for reset
    input [3:0] entered_pwd,
    output led_locked,
    output led_unlocked,
    output led_alert
);
    wire match;
    wire [1:0] state;
    wire [1:0] wrong_count;
    wire alert_trigger;
    wire wrong_attempt;

    assign wrong_attempt = ~match && (state == 2'b00);  // only count when locked

    comparator cmp (
        .entered(entered_pwd),
        .preset(4'b1010),
        .match(match)
    );

    counter cnt (
        .clk(clk),
        .rst_btn(rst_btn),
        .wrong_attempt(wrong_attempt),
        .count(wrong_count),
        .alert_trigger(alert_trigger)
    );

    fsm_controller fsm (
        .clk(clk),
        .rst_btn(rst_btn),
        .match(match),
        .alert_trigger(alert_trigger),
        .state(state),
        .led_locked(led_locked),
        .led_unlocked(led_unlocked),
        .led_alert(led_alert)
    );
endmodule



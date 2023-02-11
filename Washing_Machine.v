`timescale 1ns / 1ps
module Washing_Machine #(
    parameter DRAIN_CYCLE = 30
) (
    input            clk,
    input            rst_n,
    input      [1:0] SELECTOR,
    input            START,
    input            WATER_LEVEL_SENSOR,
    input            TEMP_SENSOR,
    output reg       DOOR_LOCK,
    output reg       WATER_VALVE,
    output reg       DETERGENT_HATCH,
    output reg       WATER_HEATER,
    output reg       DRUM_MOTOR,
    output reg       WATER_PUMP,
    output reg [2:0] CURRENT_STATE
);
    localparam IDLE           = 3'd0;
    localparam WATER_FILLING  = 3'd1;
    localparam WATER_HEATING  = 3'd2;
    localparam WASHING        = 3'd3;
    localparam WATER_DRAINING = 3'd4;

    localparam NO_DETERGENT_NO_HEATING = 2'b00;
    localparam NO_DETERGENT_HEATING    = 2'b01;
    localparam DETERGENT_NO_HEATING    = 2'b10;
    localparam DETERGENT_HEATING       = 2'b11;

    reg [5:0] WASH_CYCLE;
    always @(SELECTOR) begin
        case (SELECTOR)
            NO_DETERGENT_NO_HEATING: WASH_CYCLE = 10;
            NO_DETERGENT_HEATING:    WASH_CYCLE = 20;
            DETERGENT_NO_HEATING:    WASH_CYCLE = 30;
            DETERGENT_HEATING:       WASH_CYCLE = 40;
            default:                 WASH_CYCLE = 30;
        endcase
    end

    reg [2:0] NEXT_STATE;
    reg [5:0] washing_cycle;
    reg [5:0] draining_cycle;
    always @(*) begin
        case (CURRENT_STATE)
            IDLE: begin
                if (START) NEXT_STATE = WATER_FILLING;
                else NEXT_STATE = IDLE;
            end

            WATER_FILLING: begin
                if (WATER_LEVEL_SENSOR && SELECTOR[0]) NEXT_STATE = WATER_HEATING;
                else if (WATER_LEVEL_SENSOR && !SELECTOR[0]) NEXT_STATE = WASHING;
                else NEXT_STATE = WATER_FILLING;
            end

            WATER_HEATING: begin
                if (TEMP_SENSOR) NEXT_STATE = WASHING;
                else NEXT_STATE = WATER_HEATING;
            end

            WASHING: begin
                if (washing_cycle == 0) NEXT_STATE = WATER_DRAINING;
                else NEXT_STATE = WASHING;
            end

            WATER_DRAINING: begin
                if (draining_cycle == 0) NEXT_STATE = IDLE;
                else NEXT_STATE = WATER_DRAINING;
            end

            default: NEXT_STATE = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (!rst_n) CURRENT_STATE <= IDLE;
        else CURRENT_STATE <= NEXT_STATE;
    end

    always @(*) begin
        case (CURRENT_STATE)
            IDLE: begin
                DOOR_LOCK = 0;
                DETERGENT_HATCH = 0;
                WATER_PUMP = 0;
                WATER_HEATER = 0;
                DRUM_MOTOR = 0;
                WATER_VALVE = 0;
            end

            WATER_FILLING: begin
                DOOR_LOCK = 1;
                DETERGENT_HATCH = SELECTOR[1];
                WATER_PUMP = 0;
                WATER_HEATER = 0;
                DRUM_MOTOR = 0;
                WATER_VALVE = 1;
            end

            WATER_HEATING: begin
                DOOR_LOCK = 1;
                DETERGENT_HATCH = 0;
                WATER_PUMP = 0;
                WATER_HEATER = 1;
                DRUM_MOTOR = 0;
                WATER_VALVE = 0;
            end

            WASHING: begin
                DOOR_LOCK = 1;
                DETERGENT_HATCH = 0;
                WATER_PUMP = 0;
                WATER_HEATER = 0;
                DRUM_MOTOR = 1;
                WATER_VALVE = 0;
            end

            WATER_DRAINING: begin
                DOOR_LOCK = 1;
                DETERGENT_HATCH = 0;
                WATER_PUMP = 1;
                WATER_HEATER = 0;
                DRUM_MOTOR = 0;
                WATER_VALVE = 0;
            end

            default: begin
                DOOR_LOCK = 0;
                DETERGENT_HATCH = 0;
                WATER_PUMP = 0;
                WATER_HEATER = 0;
                DRUM_MOTOR = 0;
                WATER_VALVE = 0;
            end
        endcase
    end

    always @(posedge clk) begin
        case (CURRENT_STATE)
            IDLE: begin
                washing_cycle <= WASH_CYCLE;
                draining_cycle <= DRAIN_CYCLE;
            end

            WASHING: washing_cycle <= washing_cycle - 1;

            WATER_DRAINING: draining_cycle <= draining_cycle - 1;

            //default: 
        endcase
    end
endmodule
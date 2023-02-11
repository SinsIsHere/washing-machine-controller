`timescale 1ns / 1ps
module testbench;
    reg            clk;
    reg            rst_n;
    reg      [1:0] SELECTOR;
    reg            START;
    reg            WATER_LEVEL_SENSOR;
    reg            TEMP_SENSOR;
    wire           DOOR_LOCK;
    wire           WATER_VALVE;
    wire           DETERGENT_HATCH;
    wire           WATER_HEATER;
    wire           DRUM_MOTOR;
    wire           WATER_PUMP;
    wire     [2:0] CURRENT_STATE;

    Washing_Machine DUT (
        .clk               (clk),
        .rst_n             (rst_n),
        .SELECTOR          (SELECTOR),
        .START             (START),
        .WATER_LEVEL_SENSOR(WATER_LEVEL_SENSOR),
        .TEMP_SENSOR       (TEMP_SENSOR),
        .DOOR_LOCK         (DOOR_LOCK),
        .WATER_VALVE       (WATER_VALVE),
        .DETERGENT_HATCH   (DETERGENT_HATCH),
        .WATER_HEATER      (WATER_HEATER),
        .DRUM_MOTOR        (DRUM_MOTOR),
        .WATER_PUMP        (WATER_PUMP),
        .CURRENT_STATE     (CURRENT_STATE)
    );

    always #1 clk = ~clk;

    initial begin
        clk = 0; rst_n = 0; SELECTOR = 11; START = 0; WATER_LEVEL_SENSOR = 0; TEMP_SENSOR = 0;

        #2 rst_n = 1;
        #2 START = 1;
        #2 START = 0;

        #60 WATER_LEVEL_SENSOR = 1;
        #2 WATER_LEVEL_SENSOR = 0;

        #60 TEMP_SENSOR = 1;
        #2 TEMP_SENSOR = 0;

        #200 $finish;
    end
endmodule
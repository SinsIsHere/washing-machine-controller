# Washing Machine Controller

This is a small project for my Logic Design course, I wrote a washing machine controller module following closely to how a real controller would operate. Written in Verilog, simulated and synthesized using Xilinx Vivado.

System operation:
- The user selects a wash program(e.g. ‘Wool’, ‘Cotton’) on the selector dial.

- The user presses the ‘Start’ button.

- The door lock is engaged.

- The water valve is opened to allow water into thewashdrum.

- If the wash program involves detergent, the detergent hatch is opened. When the detergent has been released, the detergent hatch is closed.

- When the ‘full water level’ is sensed, the water valve is closed.

- If the wash program involves warmwater, thewater heaterisswitched on. When the water reaches the correct temperature,thewater heater is switched off.

- The washer motor is turned on to rotate the drum. The motor then goes through a series of movements, both clockwise and counter-clockwise(at various speed) to wash the clothes. The preciseset of movements carried out depends on the wash program the user has selected). At the end of the wash cycle, the motor is stopped.

- The pump is switched on to drain the drum. When the drum is empty, the pump is swithed off.

The main module is in **Washing_Machine.v**.

The simulation result can be found in the file **simulation.png**.
![simulation](https://user-images.githubusercontent.com/92133811/218250432-a9afdb0a-ac5f-4ed7-a1a5-b21c2b217a6c.png)

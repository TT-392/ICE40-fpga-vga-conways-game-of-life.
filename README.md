# ICE40-fpga-vga-conways-game-of-life.
A 300 cells version of Conways Game of Life created to run on a vga monitor on the ICEStick fpga dev board.

This is one of my first fpga projects so I don't know everything about verilog and fpga programming. Feel free point out shitty code.

This project is written to be run on the ICEStick and therefore on an ice40hx1k fpga which only has 1280 logic elements. Therefore The code currently only uses 895 of them.

There still needs to be some work done to make the edges work correctly.

## building
To build the project, make sure you have the icestorm toolchain installed and run `make`, or run `make upload` to make and upload to the fpga.


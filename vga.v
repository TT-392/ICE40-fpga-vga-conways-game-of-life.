module vga(
    input wire pclk, // clock after pll
    output wire r,
    output wire g,
    output wire b,
    output wire Hsync,
    output wire Vsync,
    output wire D1,
);

wire clk; 

/////////////////////////
//// Configurate PLL ////
/////////////////////////
SB_PLL40_CORE #(.FEEDBACK_PATH("SIMPLE"),
    .PLLOUT_SELECT("GENCLK"),
    .DIVR(4'b001),
    .DIVF(7'b1000010),
    .DIVQ(3'b100),
    .FILTER_RANGE(3'b01),
) uut (
.REFERENCECLK(pclk),
.PLLOUTCORE(clk),
.LOCK(D5),
.RESETB(1'b1),
.BYPASS(1'b0)
);

// init registers
reg [9:0] Hcounter;
reg [9:0] Vcounter;
reg [9:0] Hpixels;
reg [9:0] Vpixels;
// the storage register contains all 300 squares
//reg [300:0] storage = 'h000000000000000000000000000000000000000070000000000000000000000000000000000; // blink
reg [300:0] storage = 'h000000000000000000000000000000000f00011000010001200000000000000000000000000; // spaceship
reg [22:0] storage_new; // stores previous states
reg [10:0] clock_div;   // counter which counts in display range
reg [40:0] human_clock; // clock for the blinky led
reg [20:0] frame_counter = 0; // a counter that goes up 1 every frame


always @(posedge Vsync) begin
    frame_counter <= frame_counter + 1;
end

integer i; // int used for for loops

always @(posedge clk) begin
    human_clock <= human_clock + 1; // clock used for reliable clock division
    //////////////////////////////////////
    //// manage Hcounter and Vcounter ////
    //////////////////////////////////////
    if (Hcounter < 799) begin
        Hcounter <= Hcounter + 1;
    end
    else begin
        Hcounter <= 0;
        clock_div <= 0;
        if (Vcounter < 520) begin
            Vcounter <= Vcounter + 1;
        end
        else begin
            Vcounter <= 0;
        end
    end

    // manage clock_div counter which only counts while in display range
    if (Vcounter >= 30 & Vcounter < 511 & Hcounter >= 144 & Hcounter < 784) begin
        clock_div <= clock_div + 1;
    end

    
    // ┏━╸┏━┓┏┓╻╻ ╻┏━┓╻ ╻ // 
    // ┃  ┃ ┃┃┗┫┃╻┃┣━┫┗┳┛ //
    // ┗━╸┗━┛╹ ╹┗┻┛╹ ╹ ╹  //
    if (frame_counter % 16 == 0) begin // every 16 frames
        if (Vcounter == 0) begin // in the first line
            if (Hcounter < 600) begin // the first 600 pixels (clock cycles)
                if (Hcounter % 2) begin // all even pixels
                    // shift all the cells
                    storage[0] <= storage[299];
                    for (i = 1; i < 300; i = i + 1) begin
                        storage[i] <= storage[i - 1];
                    end

                    // shift old cells into storage_new register
                    storage_new[0] <= storage[299];
                    for (i = 1; i < 22; i = i + 1) begin
                        storage_new[i] <= storage_new[i-1];
                    end
                end
                if (!(Hcounter % 2)) begin // all uneven pixels pixels
                    // actually do the conway stuff
                    if (frame_counter > 320) begin // some time for the monitor to init
                       storage[0] <= ((storage_new[1] + storage_new[19]
                       + storage_new[20] + storage_new[21] + storage[279]
                       + storage[280] + storage[281] + storage[299])
                       | storage[0]) == 3; // conway formula, see future readme for info
                    end
                end
            end
        end
    end
end



assign Vsync = (Vcounter < 2) ? 0 : 1;  // Vsync pulse
assign Hsync = (Hcounter < 96) ? 0 : 1; // Hsync pulse

assign D1 = human_clock[24]; // blinky led

////////////////////////
//// draw to screen ////
////////////////////////
assign r = ((Vcounter == 31 & Hcounter == 144) | (Vcounter == 510 & Hcounter == 783)) ? 1 : 0; // auto adjust alignment dots

reg [8:0] counter; 
always @(negedge clock_div[4]) begin // every 32 pixels
    if (Hcounter > 780) begin
        counter <= ((Vcounter - 30) / 32) * 20;
    end
    else begin
        counter <= counter + 1;
    end
end

assign g = (Vcounter >= 31 & Vcounter < 511 & Hcounter >= 144 & Hcounter < 784 & (storage[counter]))? 1 : 0; // draw blocks


endmodule

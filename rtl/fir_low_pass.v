`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.03.2025 19:28:52
// Design Name: 
// Module Name: fir_low_pass
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module fir_filter_128 (
    input wire clk,                    // Clock signal
    input wire rst,                    // Reset signal
    input wire signed [15:0] xin,       // 16-bit input sample
    output reg signed [40:0] y_out      // 16-bit filtered output
);

    // Number of Taps
    parameter N = 128;
    
    // Shift Register (stores past input samples)
    reg signed [15:0] shift_reg [0:N-1];

    // Filter Coefficients (Replace with actual values)
    reg signed [15:0] coeffs [0:N-1];
    
    reg signed [40:0] multi [0:N-1];
    
    reg signed [40:0] sumreg [0:(N-1)/2];

    // Internal sum variable
    reg signed [40:0] sum;

    integer i;

    // Initialize coefficients (Replace with real filter coefficients)
    initial begin
        coeffs[0] = 28;    coeffs[1] = 224;   coeffs[2] = 47;    coeffs[3] = 30;
        coeffs[4] = -31;   coeffs[5] = -87;   coeffs[6] = -118;  coeffs[7] = -104;
        coeffs[8] = -43;   coeffs[9] = 46;    coeffs[10] = 132;  coeffs[11] = 176;
        coeffs[12] = 153;  coeffs[13] = 63;   coeffs[14] = -67;  coeffs[15] = -190;
        coeffs[16] = -251; coeffs[17] = -217; coeffs[18] = -88;  coeffs[19] = 95;
        coeffs[20] = 265;  coeffs[21] = 349;  coeffs[22] = 300;  coeffs[23] = 122;
        coeffs[24] = -130; coeffs[25] = -361; coeffs[26] = -474; coeffs[27] = -407;
        coeffs[28] = -165; coeffs[29] = 175;  coeffs[30] = 486;  coeffs[31] = 637;
        coeffs[32] = 546;  coeffs[33] = 221;  coeffs[34] = -234; coeffs[35] = -652;
        coeffs[36] = -855; coeffs[37] = -733; coeffs[38] = -297; coeffs[39] = 316;
        coeffs[40] = 880;  coeffs[41] = 1157; coeffs[42] = 997;  coeffs[43] = 406;
        coeffs[44] = -434; coeffs[45] = -1216;coeffs[46] = -1612;coeffs[47] = -1402;
        coeffs[48] = -577; coeffs[49] = 625;  coeffs[50] = 1776; coeffs[51] = 2396;
        coeffs[52] = 2126; coeffs[53] = 897;  coeffs[54] = -999; coeffs[55] = -2945;
        coeffs[56] = -4152;coeffs[57] = -3897;coeffs[58] = -1767;coeffs[59] = 2168;
        coeffs[60] = 7322; coeffs[61] = 12701;coeffs[62] = 17152;coeffs[63] = 19670;
        coeffs[64] = 19670;coeffs[65] = 17152;coeffs[66] = 12701;coeffs[67] = 7322;
        coeffs[68] = 2168; coeffs[69] = -1767;coeffs[70] = -3897;coeffs[71] = -4152;
        coeffs[72] = -2945;coeffs[73] = -999; coeffs[74] = 897;  coeffs[75] = 2126;
        coeffs[76] = 2396; coeffs[77] = 1776; coeffs[78] = 625;  coeffs[79] = -577;
        coeffs[80] = -1402;coeffs[81] = -1612;coeffs[82] = -1216;coeffs[83] = -434;
        coeffs[84] = 406;  coeffs[85] = 997;  coeffs[86] = 1157; coeffs[87] = 880;
        coeffs[88] = 316;  coeffs[89] = -297; coeffs[90] = -733; coeffs[91] = -855;
        coeffs[92] = -652; coeffs[93] = -234; coeffs[94] = 221;  coeffs[95] = 546;
        coeffs[96] = 637;  coeffs[97] = 486;  coeffs[98] = 175;  coeffs[99] = -165;
        coeffs[100] = -407;coeffs[101] = -474;coeffs[102] = -361;coeffs[103] = -130;
        coeffs[104] = 122; coeffs[105] = 300; coeffs[106] = 349;  coeffs[107] = 265;
        coeffs[108] = 95;  coeffs[109] = -88; coeffs[110] = -217; coeffs[111] = -251;
        coeffs[112] = -190;coeffs[113] = -67; coeffs[114] = 63;   coeffs[115] = 153;
        coeffs[116] = 176; coeffs[117] = 132; coeffs[118] = 46;   coeffs[119] = -43;
        coeffs[120] = -104;coeffs[121] = -118;coeffs[122] = -87;  coeffs[123] = -31;
        coeffs[124] = 30;  coeffs[125] = 47;  coeffs[126] = 224;  coeffs[127] = 28;
    end

    // FIR Filter Processing
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y_out <= 0;
            for (i = 0; i < N; i = i + 1) begin
                shift_reg[i] <= 0;
            end
        end else begin
            // Shift the shift register right
            for (i = N-1; i > 0; i = i - 1) begin
                shift_reg[i] <= shift_reg[i-1];
            end
            shift_reg[0] <= xin;  // Insert new input

            // Compute convolution sum
            sum = 0;
            for (i = 0; i < N; i = i + 1) begin
                multi[i] = (shift_reg[i] * coeffs[i]);
            end
            
            //stage 1
            for (i = 0; i < N/2; i = i + 1) begin
                sumreg[i] = multi[2*i] + multi[2*i+1];
            end
            
            //stage 2
            for (i = 0; i < N/4; i = i + 1) begin
                sumreg[i] = sumreg[2*i] + sumreg[2*i+1];
            end
            
            //stage 3
            for (i = 0; i < N/8; i = i + 1) begin
                sumreg[i] = sumreg[2*i] + sumreg[2*i+1];
            end
            
            //stage 4
            for (i = 0; i < N/16; i = i + 1) begin
                sumreg[i] = sumreg[2*i] + sumreg[2*i+1];
            end
            
            //stage 5
            for (i = 0; i < N/32; i = i + 1) begin
                sumreg[i] = sumreg[2*i] + sumreg[2*i+1];
            end
            
            //stage 6
            for (i = 0; i < N/64; i = i + 1) begin
                sumreg[i] = sumreg[2*i] + sumreg[2*i+1];
            end

            //stage 7
            for (i = 0; i < N/128; i = i + 1) begin
                sumreg[i] = sumreg[2*i] + sumreg[2*i+1];
            end
            // Assign output (Reduce bit-width from 32-bit to 16-bit)
            y_out <= sumreg[0];
        end
    end

endmodule


`timescale 1ns/1ps
`default_nettype none
module shift_left_logical(in, shamt, out);

parameter N = 32; // only used as a constant! Don't feel like you need to a shifter for arbitrary N.

input wire [N-1:0] in;            // the input number that will be shifted left. Fill in the remainder with zeros.
input wire [$clog2(N)-1:0] shamt; // the amount to shift by (think of it as a decimal number from 0 to 31). 
output logic [N-1:0] out;

mux32 #(.N(1)) MUX_0 (
.in00(in[00]), .in01(in[01]), .in02(in[02]), .in03(in[03]), .in04(in[04]), .in05(in[05]), .in06(in[06]), .in07(in[07]), .in08(in[08]), .in09(in[09]), .in10(in[10]), .in11(in[11]), .in12(in[12]), .in13(in[13]), .in14(in[14]), .in15(in[15]), .in16(in[16]), .in17(in[17]), .in18(in[18]), .in19(in[19]), .in20(in[20]), .in21(in[21]), .in22(in[22]), .in23(in[23]), .in24(in[24]), .in25(in[25]), .in26(in[26]), .in27(in[27]), .in28(in[28]), .in29(in[29]), .in30(in[30]), .in31(in[31]), .select(shamt), .out(out[N-1])
);
mux32 #(.N(1)) MUX_1 (
.in00(in[01]), .in01(in[02]), .in02(in[03]), .in03(in[04]), .in04(in[05]), .in05(in[06]), .in06(in[07]), .in07(in[08]), .in08(in[09]), .in09(in[10]), .in10(in[11]), .in11(in[12]), .in12(in[13]), .in13(in[14]), .in14(in[15]), .in15(in[16]), .in16(in[17]), .in17(in[18]), .in18(in[19]), .in19(in[20]), .in20(in[21]), .in21(in[22]), .in22(in[23]), .in23(in[24]), .in24(in[25]), .in25(in[26]), .in26(in[27]), .in27(in[28]), .in28(in[29]), .in29(in[30]), .in30(in[31]), .in31(1'd0), .select(shamt), .out(out[N-2])
);
mux32 #(.N(1)) MUX_2 (
.in00(in[02]), .in01(in[03]), .in02(in[04]), .in03(in[05]), .in04(in[06]), .in05(in[07]), .in06(in[08]), .in07(in[09]), .in08(in[10]), .in09(in[11]), .in10(in[12]), .in11(in[13]), .in12(in[14]), .in13(in[15]), .in14(in[16]), .in15(in[17]), .in16(in[18]), .in17(in[19]), .in18(in[20]), .in19(in[21]), .in20(in[22]), .in21(in[23]), .in22(in[24]), .in23(in[25]), .in24(in[26]), .in25(in[27]), .in26(in[28]), .in27(in[29]), .in28(in[30]), .in29(in[31]), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-3])
);
mux32 #(.N(1)) MUX_3 (
.in00(in[03]), .in01(in[04]), .in02(in[05]), .in03(in[06]), .in04(in[07]), .in05(in[08]), .in06(in[09]), .in07(in[10]), .in08(in[11]), .in09(in[12]), .in10(in[13]), .in11(in[14]), .in12(in[15]), .in13(in[16]), .in14(in[17]), .in15(in[18]), .in16(in[19]), .in17(in[20]), .in18(in[21]), .in19(in[22]), .in20(in[23]), .in21(in[24]), .in22(in[25]), .in23(in[26]), .in24(in[27]), .in25(in[28]), .in26(in[29]), .in27(in[30]), .in28(in[31]), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-4])
);
mux32 #(.N(1)) MUX_4 (
.in00(in[04]), .in01(in[05]), .in02(in[06]), .in03(in[07]), .in04(in[08]), .in05(in[09]), .in06(in[10]), .in07(in[11]), .in08(in[12]), .in09(in[13]), .in10(in[14]), .in11(in[15]), .in12(in[16]), .in13(in[17]), .in14(in[18]), .in15(in[19]), .in16(in[20]), .in17(in[21]), .in18(in[22]), .in19(in[23]), .in20(in[24]), .in21(in[25]), .in22(in[26]), .in23(in[27]), .in24(in[28]), .in25(in[29]), .in26(in[30]), .in27(in[31]), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-5])
);
mux32 #(.N(1)) MUX_5 (
.in00(in[05]), .in01(in[06]), .in02(in[07]), .in03(in[08]), .in04(in[09]), .in05(in[10]), .in06(in[11]), .in07(in[12]), .in08(in[13]), .in09(in[14]), .in10(in[15]), .in11(in[16]), .in12(in[17]), .in13(in[18]), .in14(in[19]), .in15(in[20]), .in16(in[21]), .in17(in[22]), .in18(in[23]), .in19(in[24]), .in20(in[25]), .in21(in[26]), .in22(in[27]), .in23(in[28]), .in24(in[29]), .in25(in[30]), .in26(in[31]), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-6])
);
mux32 #(.N(1)) MUX_6 (
.in00(in[06]), .in01(in[07]), .in02(in[08]), .in03(in[09]), .in04(in[10]), .in05(in[11]), .in06(in[12]), .in07(in[13]), .in08(in[14]), .in09(in[15]), .in10(in[16]), .in11(in[17]), .in12(in[18]), .in13(in[19]), .in14(in[20]), .in15(in[21]), .in16(in[22]), .in17(in[23]), .in18(in[24]), .in19(in[25]), .in20(in[26]), .in21(in[27]), .in22(in[28]), .in23(in[29]), .in24(in[30]), .in25(in[31]), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-7])
);
mux32 #(.N(1)) MUX_7 (
.in00(in[07]), .in01(in[08]), .in02(in[09]), .in03(in[10]), .in04(in[11]), .in05(in[12]), .in06(in[13]), .in07(in[14]), .in08(in[15]), .in09(in[16]), .in10(in[17]), .in11(in[18]), .in12(in[19]), .in13(in[20]), .in14(in[21]), .in15(in[22]), .in16(in[23]), .in17(in[24]), .in18(in[25]), .in19(in[26]), .in20(in[27]), .in21(in[28]), .in22(in[29]), .in23(in[30]), .in24(in[31]), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-8])
);
mux32 #(.N(1)) MUX_8 (
.in00(in[08]), .in01(in[09]), .in02(in[10]), .in03(in[11]), .in04(in[12]), .in05(in[13]), .in06(in[14]), .in07(in[15]), .in08(in[16]), .in09(in[17]), .in10(in[18]), .in11(in[19]), .in12(in[20]), .in13(in[21]), .in14(in[22]), .in15(in[23]), .in16(in[24]), .in17(in[25]), .in18(in[26]), .in19(in[27]), .in20(in[28]), .in21(in[29]), .in22(in[30]), .in23(in[31]), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-9])
);
mux32 #(.N(1)) MUX_9 (
.in00(in[09]), .in01(in[10]), .in02(in[11]), .in03(in[12]), .in04(in[13]), .in05(in[14]), .in06(in[15]), .in07(in[16]), .in08(in[17]), .in09(in[18]), .in10(in[19]), .in11(in[20]), .in12(in[21]), .in13(in[22]), .in14(in[23]), .in15(in[24]), .in16(in[25]), .in17(in[26]), .in18(in[27]), .in19(in[28]), .in20(in[29]), .in21(in[30]), .in22(in[31]), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-10])
);
mux32 #(.N(1)) MUX_10 (
.in00(in[10]), .in01(in[11]), .in02(in[12]), .in03(in[13]), .in04(in[14]), .in05(in[15]), .in06(in[16]), .in07(in[17]), .in08(in[18]), .in09(in[19]), .in10(in[20]), .in11(in[21]), .in12(in[22]), .in13(in[23]), .in14(in[24]), .in15(in[25]), .in16(in[26]), .in17(in[27]), .in18(in[28]), .in19(in[29]), .in20(in[30]), .in21(in[31]), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-11])
);
mux32 #(.N(1)) MUX_11 (
.in00(in[11]), .in01(in[12]), .in02(in[13]), .in03(in[14]), .in04(in[15]), .in05(in[16]), .in06(in[17]), .in07(in[18]), .in08(in[19]), .in09(in[20]), .in10(in[21]), .in11(in[22]), .in12(in[23]), .in13(in[24]), .in14(in[25]), .in15(in[26]), .in16(in[27]), .in17(in[28]), .in18(in[29]), .in19(in[30]), .in20(in[31]), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-12])
);
mux32 #(.N(1)) MUX_12 (
.in00(in[12]), .in01(in[13]), .in02(in[14]), .in03(in[15]), .in04(in[16]), .in05(in[17]), .in06(in[18]), .in07(in[19]), .in08(in[20]), .in09(in[21]), .in10(in[22]), .in11(in[23]), .in12(in[24]), .in13(in[25]), .in14(in[26]), .in15(in[27]), .in16(in[28]), .in17(in[29]), .in18(in[30]), .in19(in[31]), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-13])
);
mux32 #(.N(1)) MUX_13 (
.in00(in[13]), .in01(in[14]), .in02(in[15]), .in03(in[16]), .in04(in[17]), .in05(in[18]), .in06(in[19]), .in07(in[20]), .in08(in[21]), .in09(in[22]), .in10(in[23]), .in11(in[24]), .in12(in[25]), .in13(in[26]), .in14(in[27]), .in15(in[28]), .in16(in[29]), .in17(in[30]), .in18(in[31]), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-14])
);
mux32 #(.N(1)) MUX_14 (
.in00(in[14]), .in01(in[15]), .in02(in[16]), .in03(in[17]), .in04(in[18]), .in05(in[19]), .in06(in[20]), .in07(in[21]), .in08(in[22]), .in09(in[23]), .in10(in[24]), .in11(in[25]), .in12(in[26]), .in13(in[27]), .in14(in[28]), .in15(in[29]), .in16(in[30]), .in17(in[31]), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-15])
);
mux32 #(.N(1)) MUX_15 (
.in00(in[15]), .in01(in[16]), .in02(in[17]), .in03(in[18]), .in04(in[19]), .in05(in[20]), .in06(in[21]), .in07(in[22]), .in08(in[23]), .in09(in[24]), .in10(in[25]), .in11(in[26]), .in12(in[27]), .in13(in[28]), .in14(in[29]), .in15(in[30]), .in16(in[31]), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-16])
);
mux32 #(.N(1)) MUX_16 (
.in00(in[16]), .in01(in[17]), .in02(in[18]), .in03(in[19]), .in04(in[20]), .in05(in[21]), .in06(in[22]), .in07(in[23]), .in08(in[24]), .in09(in[25]), .in10(in[26]), .in11(in[27]), .in12(in[28]), .in13(in[29]), .in14(in[30]), .in15(in[31]), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-17])
);
mux32 #(.N(1)) MUX_17 (
.in00(in[17]), .in01(in[18]), .in02(in[19]), .in03(in[20]), .in04(in[21]), .in05(in[22]), .in06(in[23]), .in07(in[24]), .in08(in[25]), .in09(in[26]), .in10(in[27]), .in11(in[28]), .in12(in[29]), .in13(in[30]), .in14(in[31]), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-18])
);
mux32 #(.N(1)) MUX_18 (
.in00(in[18]), .in01(in[19]), .in02(in[20]), .in03(in[21]), .in04(in[22]), .in05(in[23]), .in06(in[24]), .in07(in[25]), .in08(in[26]), .in09(in[27]), .in10(in[28]), .in11(in[29]), .in12(in[30]), .in13(in[31]), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-19])
);
mux32 #(.N(1)) MUX_19 (
.in00(in[19]), .in01(in[20]), .in02(in[21]), .in03(in[22]), .in04(in[23]), .in05(in[24]), .in06(in[25]), .in07(in[26]), .in08(in[27]), .in09(in[28]), .in10(in[29]), .in11(in[30]), .in12(in[31]), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-20])
);
mux32 #(.N(1)) MUX_20 (
.in00(in[20]), .in01(in[21]), .in02(in[22]), .in03(in[23]), .in04(in[24]), .in05(in[25]), .in06(in[26]), .in07(in[27]), .in08(in[28]), .in09(in[29]), .in10(in[30]), .in11(in[31]), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-21])
);
mux32 #(.N(1)) MUX_21 (
.in00(in[21]), .in01(in[22]), .in02(in[23]), .in03(in[24]), .in04(in[25]), .in05(in[26]), .in06(in[27]), .in07(in[28]), .in08(in[29]), .in09(in[30]), .in10(in[31]), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-22])
);
mux32 #(.N(1)) MUX_22 (
.in00(in[22]), .in01(in[23]), .in02(in[24]), .in03(in[25]), .in04(in[26]), .in05(in[27]), .in06(in[28]), .in07(in[29]), .in08(in[30]), .in09(in[31]), .in10(1'd0), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-23])
);
mux32 #(.N(1)) MUX_23 (
.in00(in[23]), .in01(in[24]), .in02(in[25]), .in03(in[26]), .in04(in[27]), .in05(in[28]), .in06(in[29]), .in07(in[30]), .in08(in[31]), .in09(1'd0), .in10(1'd0), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-24])
);
mux32 #(.N(1)) MUX_24 (
.in00(in[24]), .in01(in[25]), .in02(in[26]), .in03(in[27]), .in04(in[28]), .in05(in[29]), .in06(in[30]), .in07(in[31]), .in08(1'd0), .in09(1'd0), .in10(1'd0), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-25])
);
mux32 #(.N(1)) MUX_25 (
.in00(in[25]), .in01(in[26]), .in02(in[27]), .in03(in[28]), .in04(in[29]), .in05(in[30]), .in06(in[31]), .in07(1'd0), .in08(1'd0), .in09(1'd0), .in10(1'd0), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-26])
);
mux32 #(.N(1)) MUX_26 (
.in00(in[26]), .in01(in[27]), .in02(in[28]), .in03(in[29]), .in04(in[30]), .in05(in[31]), .in06(1'd0), .in07(1'd0), .in08(1'd0), .in09(1'd0), .in10(1'd0), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-27])
);
mux32 #(.N(1)) MUX_27 (
.in00(in[27]), .in01(in[28]), .in02(in[29]), .in03(in[30]), .in04(in[31]), .in05(1'd0), .in06(1'd0), .in07(1'd0), .in08(1'd0), .in09(1'd0), .in10(1'd0), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-28])
);
mux32 #(.N(1)) MUX_28 (
.in00(in[28]), .in01(in[29]), .in02(in[30]), .in03(in[31]), .in04(1'd0), .in05(1'd0), .in06(1'd0), .in07(1'd0), .in08(1'd0), .in09(1'd0), .in10(1'd0), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-29])
);
mux32 #(.N(1)) MUX_29 (
.in00(in[29]), .in01(in[30]), .in02(in[31]), .in03(1'd0), .in04(1'd0), .in05(1'd0), .in06(1'd0), .in07(1'd0), .in08(1'd0), .in09(1'd0), .in10(1'd0), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-30])
);
mux32 #(.N(1)) MUX_30 (
.in00(in[30]), .in01(in[31]), .in02(1'd0), .in03(1'd0), .in04(1'd0), .in05(1'd0), .in06(1'd0), .in07(1'd0), .in08(1'd0), .in09(1'd0), .in10(1'd0), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-31])
);
mux32 #(.N(1)) MUX_31 (
.in00(in[31]), .in01(1'd0), .in02(1'd0), .in03(1'd0), .in04(1'd0), .in05(1'd0), .in06(1'd0), .in07(1'd0), .in08(1'd0), .in09(1'd0), .in10(1'd0), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-32])
);


endmodule

`timescale 1ns/1ps
`default_nettype none
module shift_left_logical(in, shamt, out);

parameter N = 32; // only used as a constant! Don't feel like you need to a shifter for arbitrary N.

input wire [N-1:0] in;            // the input number that will be shifted left. Fill in the remainder with zeros.
input wire [$clog2(N)-1:0] shamt; // the amount to shift by (think of it as a decimal number from 0 to 31). 
output logic [N-1:0] out;

mux32 #(.N(1)) MUX_0 (
.in00(in[31]), .in01(in[30]), .in02(in[29]), .in03(in[28]), .in04(in[27]), .in05(in[26]), .in06(in[25]), .in07(in[24]), .in08(in[23]), .in09(in[22]), .in10(in[21]), .in11(in[20]), .in12(in[19]), .in13(in[18]), .in14(in[17]), .in15(in[16]), .in16(in[15]), .in17(in[14]), .in18(in[13]), .in19(in[12]), .in20(in[11]), .in21(in[10]), .in22(in[09]), .in23(in[08]), .in24(in[07]), .in25(in[06]), .in26(in[05]), .in27(in[04]), .in28(in[03]), .in29(in[02]), .in30(in[01]), .in31(in[00]), .select(shamt), .out(out[N-1])
);
mux32 #(.N(1)) MUX_1 (
.in00(in[30]), .in01(in[29]), .in02(in[28]), .in03(in[27]), .in04(in[26]), .in05(in[25]), .in06(in[24]), .in07(in[23]), .in08(in[22]), .in09(in[21]), .in10(in[20]), .in11(in[19]), .in12(in[18]), .in13(in[17]), .in14(in[16]), .in15(in[15]), .in16(in[14]), .in17(in[13]), .in18(in[12]), .in19(in[11]), .in20(in[10]), .in21(in[09]), .in22(in[08]), .in23(in[07]), .in24(in[06]), .in25(in[05]), .in26(in[04]), .in27(in[03]), .in28(in[02]), .in29(in[01]), .in30(in[00]), .in31(1'd0), .select(shamt), .out(out[N-2])
);
mux32 #(.N(1)) MUX_2 (
.in00(in[29]), .in01(in[28]), .in02(in[27]), .in03(in[26]), .in04(in[25]), .in05(in[24]), .in06(in[23]), .in07(in[22]), .in08(in[21]), .in09(in[20]), .in10(in[19]), .in11(in[18]), .in12(in[17]), .in13(in[16]), .in14(in[15]), .in15(in[14]), .in16(in[13]), .in17(in[12]), .in18(in[11]), .in19(in[10]), .in20(in[09]), .in21(in[08]), .in22(in[07]), .in23(in[06]), .in24(in[05]), .in25(in[04]), .in26(in[03]), .in27(in[02]), .in28(in[01]), .in29(in[00]), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-3])
);
mux32 #(.N(1)) MUX_3 (
.in00(in[28]), .in01(in[27]), .in02(in[26]), .in03(in[25]), .in04(in[24]), .in05(in[23]), .in06(in[22]), .in07(in[21]), .in08(in[20]), .in09(in[19]), .in10(in[18]), .in11(in[17]), .in12(in[16]), .in13(in[15]), .in14(in[14]), .in15(in[13]), .in16(in[12]), .in17(in[11]), .in18(in[10]), .in19(in[09]), .in20(in[08]), .in21(in[07]), .in22(in[06]), .in23(in[05]), .in24(in[04]), .in25(in[03]), .in26(in[02]), .in27(in[01]), .in28(in[00]), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-4])
);
mux32 #(.N(1)) MUX_4 (
.in00(in[27]), .in01(in[26]), .in02(in[25]), .in03(in[24]), .in04(in[23]), .in05(in[22]), .in06(in[21]), .in07(in[20]), .in08(in[19]), .in09(in[18]), .in10(in[17]), .in11(in[16]), .in12(in[15]), .in13(in[14]), .in14(in[13]), .in15(in[12]), .in16(in[11]), .in17(in[10]), .in18(in[09]), .in19(in[08]), .in20(in[07]), .in21(in[06]), .in22(in[05]), .in23(in[04]), .in24(in[03]), .in25(in[02]), .in26(in[01]), .in27(in[00]), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-5])
);
mux32 #(.N(1)) MUX_5 (
.in00(in[26]), .in01(in[25]), .in02(in[24]), .in03(in[23]), .in04(in[22]), .in05(in[21]), .in06(in[20]), .in07(in[19]), .in08(in[18]), .in09(in[17]), .in10(in[16]), .in11(in[15]), .in12(in[14]), .in13(in[13]), .in14(in[12]), .in15(in[11]), .in16(in[10]), .in17(in[09]), .in18(in[08]), .in19(in[07]), .in20(in[06]), .in21(in[05]), .in22(in[04]), .in23(in[03]), .in24(in[02]), .in25(in[01]), .in26(in[00]), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-6])
);
mux32 #(.N(1)) MUX_6 (
.in00(in[25]), .in01(in[24]), .in02(in[23]), .in03(in[22]), .in04(in[21]), .in05(in[20]), .in06(in[19]), .in07(in[18]), .in08(in[17]), .in09(in[16]), .in10(in[15]), .in11(in[14]), .in12(in[13]), .in13(in[12]), .in14(in[11]), .in15(in[10]), .in16(in[09]), .in17(in[08]), .in18(in[07]), .in19(in[06]), .in20(in[05]), .in21(in[04]), .in22(in[03]), .in23(in[02]), .in24(in[01]), .in25(in[00]), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-7])
);
mux32 #(.N(1)) MUX_7 (
.in00(in[24]), .in01(in[23]), .in02(in[22]), .in03(in[21]), .in04(in[20]), .in05(in[19]), .in06(in[18]), .in07(in[17]), .in08(in[16]), .in09(in[15]), .in10(in[14]), .in11(in[13]), .in12(in[12]), .in13(in[11]), .in14(in[10]), .in15(in[09]), .in16(in[08]), .in17(in[07]), .in18(in[06]), .in19(in[05]), .in20(in[04]), .in21(in[03]), .in22(in[02]), .in23(in[01]), .in24(in[00]), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-8])
);
mux32 #(.N(1)) MUX_8 (
.in00(in[23]), .in01(in[22]), .in02(in[21]), .in03(in[20]), .in04(in[19]), .in05(in[18]), .in06(in[17]), .in07(in[16]), .in08(in[15]), .in09(in[14]), .in10(in[13]), .in11(in[12]), .in12(in[11]), .in13(in[10]), .in14(in[09]), .in15(in[08]), .in16(in[07]), .in17(in[06]), .in18(in[05]), .in19(in[04]), .in20(in[03]), .in21(in[02]), .in22(in[01]), .in23(in[00]), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-9])
);
mux32 #(.N(1)) MUX_9 (
.in00(in[22]), .in01(in[21]), .in02(in[20]), .in03(in[19]), .in04(in[18]), .in05(in[17]), .in06(in[16]), .in07(in[15]), .in08(in[14]), .in09(in[13]), .in10(in[12]), .in11(in[11]), .in12(in[10]), .in13(in[09]), .in14(in[08]), .in15(in[07]), .in16(in[06]), .in17(in[05]), .in18(in[04]), .in19(in[03]), .in20(in[02]), .in21(in[01]), .in22(in[00]), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-10])
);
mux32 #(.N(1)) MUX_10 (
.in00(in[21]), .in01(in[20]), .in02(in[19]), .in03(in[18]), .in04(in[17]), .in05(in[16]), .in06(in[15]), .in07(in[14]), .in08(in[13]), .in09(in[12]), .in10(in[11]), .in11(in[10]), .in12(in[09]), .in13(in[08]), .in14(in[07]), .in15(in[06]), .in16(in[05]), .in17(in[04]), .in18(in[03]), .in19(in[02]), .in20(in[01]), .in21(in[00]), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-11])
);
mux32 #(.N(1)) MUX_11 (
.in00(in[20]), .in01(in[19]), .in02(in[18]), .in03(in[17]), .in04(in[16]), .in05(in[15]), .in06(in[14]), .in07(in[13]), .in08(in[12]), .in09(in[11]), .in10(in[10]), .in11(in[09]), .in12(in[08]), .in13(in[07]), .in14(in[06]), .in15(in[05]), .in16(in[04]), .in17(in[03]), .in18(in[02]), .in19(in[01]), .in20(in[00]), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-12])
);
mux32 #(.N(1)) MUX_12 (
.in00(in[19]), .in01(in[18]), .in02(in[17]), .in03(in[16]), .in04(in[15]), .in05(in[14]), .in06(in[13]), .in07(in[12]), .in08(in[11]), .in09(in[10]), .in10(in[09]), .in11(in[08]), .in12(in[07]), .in13(in[06]), .in14(in[05]), .in15(in[04]), .in16(in[03]), .in17(in[02]), .in18(in[01]), .in19(in[00]), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-13])
);
mux32 #(.N(1)) MUX_13 (
.in00(in[18]), .in01(in[17]), .in02(in[16]), .in03(in[15]), .in04(in[14]), .in05(in[13]), .in06(in[12]), .in07(in[11]), .in08(in[10]), .in09(in[09]), .in10(in[08]), .in11(in[07]), .in12(in[06]), .in13(in[05]), .in14(in[04]), .in15(in[03]), .in16(in[02]), .in17(in[01]), .in18(in[00]), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-14])
);
mux32 #(.N(1)) MUX_14 (
.in00(in[17]), .in01(in[16]), .in02(in[15]), .in03(in[14]), .in04(in[13]), .in05(in[12]), .in06(in[11]), .in07(in[10]), .in08(in[09]), .in09(in[08]), .in10(in[07]), .in11(in[06]), .in12(in[05]), .in13(in[04]), .in14(in[03]), .in15(in[02]), .in16(in[01]), .in17(in[00]), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-15])
);
mux32 #(.N(1)) MUX_15 (
.in00(in[16]), .in01(in[15]), .in02(in[14]), .in03(in[13]), .in04(in[12]), .in05(in[11]), .in06(in[10]), .in07(in[09]), .in08(in[08]), .in09(in[07]), .in10(in[06]), .in11(in[05]), .in12(in[04]), .in13(in[03]), .in14(in[02]), .in15(in[01]), .in16(in[00]), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-16])
);
mux32 #(.N(1)) MUX_16 (
.in00(in[15]), .in01(in[14]), .in02(in[13]), .in03(in[12]), .in04(in[11]), .in05(in[10]), .in06(in[09]), .in07(in[08]), .in08(in[07]), .in09(in[06]), .in10(in[05]), .in11(in[04]), .in12(in[03]), .in13(in[02]), .in14(in[01]), .in15(in[00]), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-17])
);
mux32 #(.N(1)) MUX_17 (
.in00(in[14]), .in01(in[13]), .in02(in[12]), .in03(in[11]), .in04(in[10]), .in05(in[09]), .in06(in[08]), .in07(in[07]), .in08(in[06]), .in09(in[05]), .in10(in[04]), .in11(in[03]), .in12(in[02]), .in13(in[01]), .in14(in[00]), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-18])
);
mux32 #(.N(1)) MUX_18 (
.in00(in[13]), .in01(in[12]), .in02(in[11]), .in03(in[10]), .in04(in[09]), .in05(in[08]), .in06(in[07]), .in07(in[06]), .in08(in[05]), .in09(in[04]), .in10(in[03]), .in11(in[02]), .in12(in[01]), .in13(in[00]), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-19])
);
mux32 #(.N(1)) MUX_19 (
.in00(in[12]), .in01(in[11]), .in02(in[10]), .in03(in[09]), .in04(in[08]), .in05(in[07]), .in06(in[06]), .in07(in[05]), .in08(in[04]), .in09(in[03]), .in10(in[02]), .in11(in[01]), .in12(in[00]), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-20])
);
mux32 #(.N(1)) MUX_20 (
.in00(in[11]), .in01(in[10]), .in02(in[09]), .in03(in[08]), .in04(in[07]), .in05(in[06]), .in06(in[05]), .in07(in[04]), .in08(in[03]), .in09(in[02]), .in10(in[01]), .in11(in[00]), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-21])
);
mux32 #(.N(1)) MUX_21 (
.in00(in[10]), .in01(in[09]), .in02(in[08]), .in03(in[07]), .in04(in[06]), .in05(in[05]), .in06(in[04]), .in07(in[03]), .in08(in[02]), .in09(in[01]), .in10(in[00]), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-22])
);
mux32 #(.N(1)) MUX_22 (
.in00(in[09]), .in01(in[08]), .in02(in[07]), .in03(in[06]), .in04(in[05]), .in05(in[04]), .in06(in[03]), .in07(in[02]), .in08(in[01]), .in09(in[00]), .in10(1'd0), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-23])
);
mux32 #(.N(1)) MUX_23 (
.in00(in[08]), .in01(in[07]), .in02(in[06]), .in03(in[05]), .in04(in[04]), .in05(in[03]), .in06(in[02]), .in07(in[01]), .in08(in[00]), .in09(1'd0), .in10(1'd0), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-24])
);
mux32 #(.N(1)) MUX_24 (
.in00(in[07]), .in01(in[06]), .in02(in[05]), .in03(in[04]), .in04(in[03]), .in05(in[02]), .in06(in[01]), .in07(in[00]), .in08(1'd0), .in09(1'd0), .in10(1'd0), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-25])
);
mux32 #(.N(1)) MUX_25 (
.in00(in[06]), .in01(in[05]), .in02(in[04]), .in03(in[03]), .in04(in[02]), .in05(in[01]), .in06(in[00]), .in07(1'd0), .in08(1'd0), .in09(1'd0), .in10(1'd0), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-26])
);
mux32 #(.N(1)) MUX_26 (
.in00(in[05]), .in01(in[04]), .in02(in[03]), .in03(in[02]), .in04(in[01]), .in05(in[00]), .in06(1'd0), .in07(1'd0), .in08(1'd0), .in09(1'd0), .in10(1'd0), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-27])
);
mux32 #(.N(1)) MUX_27 (
.in00(in[04]), .in01(in[03]), .in02(in[02]), .in03(in[01]), .in04(in[00]), .in05(1'd0), .in06(1'd0), .in07(1'd0), .in08(1'd0), .in09(1'd0), .in10(1'd0), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-28])
);
mux32 #(.N(1)) MUX_28 (
.in00(in[03]), .in01(in[02]), .in02(in[01]), .in03(in[00]), .in04(1'd0), .in05(1'd0), .in06(1'd0), .in07(1'd0), .in08(1'd0), .in09(1'd0), .in10(1'd0), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-29])
);
mux32 #(.N(1)) MUX_29 (
.in00(in[02]), .in01(in[01]), .in02(in[00]), .in03(1'd0), .in04(1'd0), .in05(1'd0), .in06(1'd0), .in07(1'd0), .in08(1'd0), .in09(1'd0), .in10(1'd0), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-30])
);
mux32 #(.N(1)) MUX_30 (
.in00(in[01]), .in01(in[00]), .in02(1'd0), .in03(1'd0), .in04(1'd0), .in05(1'd0), .in06(1'd0), .in07(1'd0), .in08(1'd0), .in09(1'd0), .in10(1'd0), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-31])
);
mux32 #(.N(1)) MUX_31 (
.in00(in[00]), .in01(1'd0), .in02(1'd0), .in03(1'd0), .in04(1'd0), .in05(1'd0), .in06(1'd0), .in07(1'd0), .in08(1'd0), .in09(1'd0), .in10(1'd0), .in11(1'd0), .in12(1'd0), .in13(1'd0), .in14(1'd0), .in15(1'd0), .in16(1'd0), .in17(1'd0), .in18(1'd0), .in19(1'd0), .in20(1'd0), .in21(1'd0), .in22(1'd0), .in23(1'd0), .in24(1'd0), .in25(1'd0), .in26(1'd0), .in27(1'd0), .in28(1'd0), .in29(1'd0), .in30(1'd0), .in31(1'd0), .select(shamt), .out(out[N-32])
);

endmodule

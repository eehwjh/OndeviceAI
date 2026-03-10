`timescale 1ns / 1ps

module data_mem (
    input        clk,
    input        rst,
    input        dwe,
    input [31:0] daddr,
    input [31:0] dwdata,
    output [31:0] drdata
);

//    logic [7:0] dmem[0:31];
//
//    always_ff @( posedge clk) begin
//            if (dwe) begin
//                dmem[dwaddr+0] <= dwdata[7:0];
//                dmem[dwaddr+1] <= dwdata [15:8];
//                dmem[dwaddr+2] <= dwdata [23:16];
//                dmem[dwaddr+3] <= dwdata [31:24];
//            end
//        end
//
//    assign drdata = {dmem[dwaddr], dmem[dwaddr+1], dmem[dwaddr+2], dmem[dwaddr+3]};

// word address
    logic [31:0] dmem[0:31];
    always_ff @( posedge clk ) begin
        if (dwe) begin
           dmem[daddr[31:2]] <= dwdata; 
        end
    end

    assign drdata = dmem[daddr[31:2]];


endmodule


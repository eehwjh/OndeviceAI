`timescale 1ns / 1ps

interface fifo_interface(
    input clk,
    input rst
);
    logic push;
    logic pop;
    logic [7:0] wdata;
    logic [7:0] rdata;
    logic full;
    logic empty;
endinterface //fifo_interface

class transaction;

    rand bit push;
    rand bit pop;
    rand logic [7:0] wdata;
    
    function void display(string name);
    endfunction
endclass //transaction
















module tb_fifo ();
    localparam WIDTH = 8;
    localparam DEPTH = 4;

    fifo_interface fifo_if(clk, rst);

    fifo #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .clk(),
        .rst(),
        .push(),
        .pop(),
        .wdata(),
        .rdata(),
        .full(),
        .empty()
    );
endmodule

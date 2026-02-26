`timescale 1ns / 1ps

module fifo #(
    parameter WIDTH = 8,
    DEPTH = 4
) (
    input                    clk,
    input                    rst,
    input                    push,
    input                    pop,
    input  logic [WIDTH-1:0] wdata,
    output logic [WIDTH-1:0] rdata,
    output                   full,
    output                   empty
);
    wire [$clog2(DEPTH)-1:0] w_wptr, w_rptr;

    register_file #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) U_REG_FILE (
        .clk(clk),
        .we(push & (~full)),
        .waddr(w_wptr),
        .raddr(w_rptr),
        .wdata(wdata),
        .rdata(rdata)
);

    control_unit #(
        .DEPTH(DEPTH)
    ) U_CONTRL_UNIT (
        .clk(clk),
        .rst(rst),
        .push(push),
        .pop(pop),
        .wptr(w_wptr),
        .rptr(w_rptr),
        .full(full),
        .empty(empty)
);


endmodule


module register_file #(
    parameter WIDTH = 8,
    DEPTH = 4
) (
    input clk,
    input we,
    input logic [$clog2(DEPTH)-1:0] waddr,
    input logic [$clog2(DEPTH)-1:0] raddr,
    input logic [WIDTH-1:0] wdata,
    output logic [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] register[0:DEPTH-1];

    always_ff @(posedge clk) begin : blockName
        if (we) begin
            register[waddr] <= wdata;
        end
    end

    assign rdata = register[raddr];
endmodule

module control_unit #(
    parameter DEPTH = 4
) (
    input clk,
    input rst,
    input push,
    input pop,
    output logic [$clog2(DEPTH)-1:0] wptr,
    output logic [$clog2(DEPTH)-1:0] rptr,
    output logic full,
    output logic empty
);
    logic wptr_reg, wptr_next, rptr_reg, rptr_next;

    assign wptr = wptr_reg;
    assign rptr = rptr_reg;

    always_ff @(posedge clk, posedge rst) begin : blockName
        if (rst) begin
            wptr_reg <= 0;
            rptr_reg <= 0;
            full <= 1'b0;
            empty <= 1'b1;
        end else begin
            wptr_reg <= wptr_next;
            rptr_reg <= rptr_next;
        end
    end

    always @(*) begin
        wptr_next = wptr_reg;
        rptr_next = rptr_reg;
        case ({
            push, pop
        })
            2'b10: begin
                if (!full) begin
                    wptr_next = wptr_reg + 1;
                    empty = 1'b0;
                    if (wptr_next == rptr_reg) begin
                        full = 1'b1;
                    end
                end
            end
            2'b01: begin
                if (!empty) begin
                    rptr_next = rptr_reg + 1;
                    full = 1'b0;
                    if (rptr_next == wptr_reg) begin
                        full = 1'b1;
                    end
                end
            end
            2'b11: begin
                if (empty != 1'b1 && full != 1'b1) begin
                    wptr_next = wptr_reg + 1;
                    rptr_next = rptr_reg + 1;
                end else if (full) begin
                    rptr_next = rptr_reg + 1;
                    full = 1'b0;
                end else if (empty) begin
                    wptr_next = wptr_reg + 1;
                    empty = 1'b0;
                end
            end
        endcase
    end

endmodule

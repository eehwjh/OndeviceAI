`timescale 1ns / 1ps

interface adder_interface;
    logic [31:0] a;
    logic [31:0] b;
    logic [31:0] s;
    logic        c;
    logic        mode;
endinterface //adder_interface

class transaction;
    
    rand bit [31:0] a; // use rand to generate a value randomly
    rand bit [31:0] b;
    bit        mode;


endclass //transaction

class generator;
    
    // variable declare , data type transaction
    transaction tr;
    virtual adder_interface adder_interf_gen;

    function new(virtual adder_interface adder_interf_ext); // 인터페이스 생성하기 위한 외부와 연결할 때 다리 역할, adder_interf_ext
        this.adder_interf_gen = adder_interf_ext;
        tr               = new();
        
    endfunction

    task run();
        tr.randomize();
        tr.mode = 0;
        adder_interf_gen.a = tr.a;
        adder_interf_gen.b = tr.b;
        adder_interf_gen.mode = tr.mode;

        //drive
        #10;        
    endtask //


endclass //className

module tb_adder_sv ();

    adder_interface adder_interf();
    // class generator를 선언
    // gen: generator 객체를 관리하기위한 handler
    generator   gen;

 adder dut (
    .a(adder_interf.a),
    .b(adder_interf.b),
    .mode(adder_interf.mode),
    .s(adder_interf.s),
    .c(adder_interf.c)
    );

    initial begin
        // class generator 를 생성;
        // generator class의 function new가 실행됨
        // new 생성자
        gen = new(adder_interf);
        gen.run();
        $stop;
    end


endmodule

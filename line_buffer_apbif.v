////////////////////////////////////////////////////////////////////////////////////
// Copyright: HJIMI
//
// File Name: line_buffer_apbif.v
//
// Author   : gen_apbif.pl
//
// Abstract : Translation Block for APB Interface
//
////////////////////////////////////////////////////////////////////////////////////

module line_buffer_apbif (
    ///< output signals
    output [31:0]    prdata,
    output           apbif_wr,
    output           apbif_rd,
    output [31:0]    apbif_wdata,
    output [31:0]    apbif_addr,

    ///< input signals
    input            psel,
    input  [31:0]    paddr,
    input  [31:0]    pwdata,
    input            pwrite,
    input            penable,
    input  [31:0]    apbif_rdata,
    input            pclk,
    input            presetn
);


wire           apbif_wr    = penable & psel & pwrite;
wire           apbif_rd    = ~penable & psel & ~pwrite;
wire [31:0]    apbif_wdata = pwdata;
wire [31:0]    apbif_addr  = paddr;

reg  [31:0]    prdata;
always@(posedge pclk or negedge presetn) begin
    if(!presetn) begin
        prdata <= 32'h0;
    end
    else if(apbif_rd) begin
        prdata <= apbif_rdata;
    end
end

endmodule

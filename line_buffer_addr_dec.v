////////////////////////////////////////////////////////////////////////////////////
// Copyright: HJIMI
//
// File Name: line_buffer_addr_dec.v
//
// Author   : gen_addr_dec.pl
//
// Abstract : Address Decoder Block for APB Interface
//
////////////////////////////////////////////////////////////////////////////////////

module line_buffer_addr_dec (
    ///< apb interface signals
    input  [31:0]    apbif_addr,
    output [31:0]    apbif_rdata,

    ///< output signals
    output          ctrl_ff_sel,
    output          real_depth_ff_sel,
    output          line_wr_ff_sel,
    output          ram_base_ff_sel,
    output          ram_base_offset_ff_sel,
    output          actived_chnl_ff_sel,
    output          actived_chnl_bits_ff_sel,
    output          inactived_chnl_bits_ff_sel,
    output          ro_test_ff_sel,

    ///< input signals
    input [ 5:0]   ctrl_ff,
    input [15:0]   real_depth_ff,
    input [15:0]   line_wr_ff,
    input [31:0]   ram_base_ff,
    input [31:0]   ram_base_offset_ff,
    input [15:0]   actived_chnl_ff,
    input [31:0]   actived_chnl_bits_ff,
    input [15:0]   inactived_chnl_bits_ff,
    input [23:0]   ro_test_ff
);

wire    ctrl_ff_sel = (apbif_addr[15:0] == 16'h10);
wire    real_depth_ff_sel = (apbif_addr[15:0] == 16'h14);
wire    line_wr_ff_sel = (apbif_addr[15:0] == 16'h18);
wire    ram_base_ff_sel = (apbif_addr[15:0] == 16'h1c);
wire    ram_base_offset_ff_sel = (apbif_addr[15:0] == 16'h20);
wire    actived_chnl_ff_sel = (apbif_addr[15:0] == 16'h24);
wire    actived_chnl_bits_ff_sel = (apbif_addr[15:0] == 16'h28);
wire    inactived_chnl_bits_ff_sel = (apbif_addr[15:0] == 16'h2c);
wire    ro_test_ff_sel = (apbif_addr[15:0] == 16'h30);

wire [31:0]    ctrl_ff_32 = {26'h0,ctrl_ff};
wire [31:0]    real_depth_ff_32 = {16'h0,real_depth_ff};
wire [31:0]    line_wr_ff_32 = {16'h0,line_wr_ff};
wire [31:0]    ram_base_ff_32 = ram_base_ff;
wire [31:0]    ram_base_offset_ff_32 = ram_base_offset_ff;
wire [31:0]    actived_chnl_ff_32 = {16'h0,actived_chnl_ff};
wire [31:0]    actived_chnl_bits_ff_32 = actived_chnl_bits_ff;
wire [31:0]    inactived_chnl_bits_ff_32 = {16'h0,inactived_chnl_bits_ff};
wire [31:0]    ro_test_ff_32 = {8'h0,ro_test_ff};

wire [31:0]    apbif_rdata = 
                             {32{ctrl_ff_sel}} & ctrl_ff_32 |
                             {32{real_depth_ff_sel}} & real_depth_ff_32 |
                             {32{line_wr_ff_sel}} & line_wr_ff_32 |
                             {32{ram_base_ff_sel}} & ram_base_ff_32 |
                             {32{ram_base_offset_ff_sel}} & ram_base_offset_ff_32 |
                             {32{actived_chnl_ff_sel}} & actived_chnl_ff_32 |
                             {32{actived_chnl_bits_ff_sel}} & actived_chnl_bits_ff_32 |
                             {32{inactived_chnl_bits_ff_sel}} & inactived_chnl_bits_ff_32 |
                             {32{ro_test_ff_sel}} & ro_test_ff_32 |
                             32'h0;
endmodule

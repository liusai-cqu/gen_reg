////////////////////////////////////////////////////////////////////////////////////
// Copyright: HJIMI
//
// File Name: line_buffer_reg.v
//
// Author   : gen_reg.pl
//
// Abstract : Register Block for APB Interface
//
////////////////////////////////////////////////////////////////////////////////////

module line_buffer_reg (
    ///< apb interface signals
    input           pclk,
    input           presetn,
    input           apbif_wr,
    input [31:0]    apbif_wdata,

    ///< input signals
    input           ctrl_ff_sel,
    input           real_depth_ff_sel,
    input           line_wr_ff_sel,
    input           ram_base_ff_sel,
    input           ram_base_offset_ff_sel,
    input           actived_chnl_ff_sel,
    input           actived_chnl_bits_ff_sel,
    input           inactived_chnl_bits_ff_sel,
    input           ro_test_ff_sel,
    input  [ 3:0]   ro_test_sts0,
    input  [ 2:0]   ro_test_sts1,
    input  [ 4:0]   ro_test_sts2,

    ///< output signals
    output [ 5:0]   ctrl_ff,
    output [15:0]   real_depth_ff,
    output [15:0]   line_wr_ff,
    output [31:0]   ram_base_ff,
    output [31:0]   ram_base_offset_ff,
    output [15:0]   actived_chnl_ff,
    output [31:0]   actived_chnl_bits_ff,
    output [15:0]   inactived_chnl_bits_ff,
    output [23:0]   ro_test_ff
);


///< ========== Register ctrl_ff begin ==========
reg            cfg_input_enable;
always @(posedge pclk or negedge presetn) begin
    if(!presetn) begin
        cfg_input_enable <= 1'h0;
    end
    if(ctrl_ff_sel & apbif_wr) begin
        cfg_input_enable <= apbif_wdata[0:0];
    end
end

reg            cfg_fe_offset_lock;
always @(posedge pclk or negedge presetn) begin
    if(!presetn) begin
        cfg_fe_offset_lock <= 1'h0;
    end
    if(ctrl_ff_sel & apbif_wr) begin
        cfg_fe_offset_lock <= apbif_wdata[1:1];
    end
end

reg [1:0]    cfg_tmplt_pack_mode;
always @(posedge pclk or negedge presetn) begin
    if(!presetn) begin
        cfg_tmplt_pack_mode <= 2'h0;
    end
    if(ctrl_ff_sel & apbif_wr) begin
        cfg_tmplt_pack_mode <= apbif_wdata[5:4];
    end
end

assign ctrl_ff = {cfg_tmplt_pack_mode,2'b0,cfg_fe_offset_lock,cfg_input_enable};
///< ========== Register ctrl_ff end ==========


///< ========== Register real_depth_ff begin ==========
reg [15:0]    cfg_real_depth;
always @(posedge pclk or negedge presetn) begin
    if(!presetn) begin
        cfg_real_depth <= 16'h0;
    end
    if(real_depth_ff_sel & apbif_wr) begin
        cfg_real_depth <= apbif_wdata[15:0];
    end
end

assign real_depth_ff = {cfg_real_depth};
///< ========== Register real_depth_ff end ==========


///< ========== Register line_wr_ff begin ==========
reg [7:0]    cfg_line_wr_strb;
always @(posedge pclk or negedge presetn) begin
    if(!presetn) begin
        cfg_line_wr_strb <= 8'h0;
    end
    if(line_wr_ff_sel & apbif_wr) begin
        cfg_line_wr_strb <= apbif_wdata[7:0];
    end
end

reg [7:0]    cfg_line_wr_msk;
always @(posedge pclk or negedge presetn) begin
    if(!presetn) begin
        cfg_line_wr_msk <= 8'h0;
    end
    if(line_wr_ff_sel & apbif_wr) begin
        cfg_line_wr_msk <= apbif_wdata[15:8];
    end
end

assign line_wr_ff = {cfg_line_wr_msk,cfg_line_wr_strb};
///< ========== Register line_wr_ff end ==========


///< ========== Register ram_base_ff begin ==========
reg [31:0]    cfg_ram_base;
always @(posedge pclk or negedge presetn) begin
    if(!presetn) begin
        cfg_ram_base <= 32'h0;
    end
    if(ram_base_ff_sel & apbif_wr) begin
        cfg_ram_base <= apbif_wdata[31:0];
    end
end

assign ram_base_ff = {cfg_ram_base};
///< ========== Register ram_base_ff end ==========


///< ========== Register ram_base_offset_ff begin ==========
reg [31:0]    cfg_ram_base_offset;
always @(posedge pclk or negedge presetn) begin
    if(!presetn) begin
        cfg_ram_base_offset <= 32'h0;
    end
    if(ram_base_offset_ff_sel & apbif_wr) begin
        cfg_ram_base_offset <= apbif_wdata[31:0];
    end
end

assign ram_base_offset_ff = {cfg_ram_base_offset};
///< ========== Register ram_base_offset_ff end ==========


///< ========== Register actived_chnl_ff begin ==========
reg [15:0]    cfg_actived_chnl;
always @(posedge pclk or negedge presetn) begin
    if(!presetn) begin
        cfg_actived_chnl <= 16'h0;
    end
    if(actived_chnl_ff_sel & apbif_wr) begin
        cfg_actived_chnl <= apbif_wdata[15:0];
    end
end

assign actived_chnl_ff = {cfg_actived_chnl};
///< ========== Register actived_chnl_ff end ==========


///< ========== Register actived_chnl_bits_ff begin ==========
reg [31:0]    cfg_actived_chnl_bits;
always @(posedge pclk or negedge presetn) begin
    if(!presetn) begin
        cfg_actived_chnl_bits <= 32'h0;
    end
    if(actived_chnl_bits_ff_sel & apbif_wr) begin
        cfg_actived_chnl_bits <= apbif_wdata[31:0];
    end
end

assign actived_chnl_bits_ff = {cfg_actived_chnl_bits};
///< ========== Register actived_chnl_bits_ff end ==========


///< ========== Register inactived_chnl_bits_ff begin ==========
reg [15:0]    cfg_inactived_ram_bits;
always @(posedge pclk or negedge presetn) begin
    if(!presetn) begin
        cfg_inactived_ram_bits <= 16'h0;
    end
    if(inactived_chnl_bits_ff_sel & apbif_wr) begin
        cfg_inactived_ram_bits <= apbif_wdata[15:0];
    end
end

assign inactived_chnl_bits_ff = {cfg_inactived_ram_bits};
///< ========== Register inactived_chnl_bits_ff end ==========


///< ========== Register ro_test_ff begin ==========
reg [7:0]    cfg_in_ro_test;
always @(posedge pclk or negedge presetn) begin
    if(!presetn) begin
        cfg_in_ro_test <= 8'h0;
    end
    if(ro_test_ff_sel & apbif_wr) begin
        cfg_in_ro_test <= apbif_wdata[23:16];
    end
end

assign ro_test_ff = {cfg_in_ro_test,3'b0,ro_test_sts2,1'b0,ro_test_sts1,ro_test_sts0};
///< ========== Register ro_test_ff end ==========


endmodule

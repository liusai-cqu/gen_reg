////////////////////////////////////////////////////////////////////////////////////
// Copyright: HJIMI
//
// File Name: line_buffer_apb.v
//
// Author   : gen_apb.pl
//
// Abstract : TOP Level Block for APB Interface
//
////////////////////////////////////////////////////////////////////////////////////

module line_buffer_apb(
    ///< apb interface signals
    input            pclk,
    input            presetn,
    input            psel,
    input            pwrite,
    input            penable,
    input  [31:0]    pwdata,
    input  [31:0]    paddr,
    output [31:0]    prdata,

    ///< input & output signals
    input  [ 3:0]   ro_test_sts0,
    input  [ 2:0]   ro_test_sts1,
    input  [ 4:0]   ro_test_sts2,
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

wire           apbif_wr;
wire           apbif_rd;
wire [31:0]    apbif_wdata;
wire [31:0]    apbif_addr;
wire [31:0]    apbif_rdata;
wire           ctrl_ff_sel;
wire           real_depth_ff_sel;
wire           line_wr_ff_sel;
wire           ram_base_ff_sel;
wire           ram_base_offset_ff_sel;
wire           actived_chnl_ff_sel;
wire           actived_chnl_bits_ff_sel;
wire           inactived_chnl_bits_ff_sel;
wire           ro_test_ff_sel;

line_buffer_apbif U_LINE_BUFFER_APBIF (
    .prdata                        (prdata                        ),
    .apbif_wr                      (apbif_wr                      ),
    .apbif_rd                      (apbif_rd                      ),
    .apbif_wdata                   (apbif_wdata                   ),
    .apbif_addr                    (apbif_addr                    ),
    .psel                          (psel                          ),
    .paddr                         (paddr                         ),
    .pwdata                        (pwdata                        ),
    .pwrite                        (pwrite                        ),
    .penable                       (penable                       ),
    .apbif_rdata                   (apbif_rdata                   ),
    .pclk                          (pclk                          ),
    .presetn                       (presetn                       )
);

line_buffer_reg U_LINE_BUFFER_REG (
    .pclk                          (pclk                          ),
    .presetn                       (presetn                       ),
    .apbif_wr                      (apbif_wr                      ),
    .apbif_wdata                   (apbif_wdata                   ),
    .ctrl_ff_sel                   (ctrl_ff_sel                   ),
    .real_depth_ff_sel             (real_depth_ff_sel             ),
    .line_wr_ff_sel                (line_wr_ff_sel                ),
    .ram_base_ff_sel               (ram_base_ff_sel               ),
    .ram_base_offset_ff_sel        (ram_base_offset_ff_sel        ),
    .actived_chnl_ff_sel           (actived_chnl_ff_sel           ),
    .actived_chnl_bits_ff_sel      (actived_chnl_bits_ff_sel      ),
    .inactived_chnl_bits_ff_sel    (inactived_chnl_bits_ff_sel    ),
    .ro_test_ff_sel                (ro_test_ff_sel                ),
    .ro_test_sts0                  (ro_test_sts0                  ),
    .ro_test_sts1                  (ro_test_sts1                  ),
    .ro_test_sts2                  (ro_test_sts2                  ),
    .ctrl_ff                       (ctrl_ff                       ),
    .real_depth_ff                 (real_depth_ff                 ),
    .line_wr_ff                    (line_wr_ff                    ),
    .ram_base_ff                   (ram_base_ff                   ),
    .ram_base_offset_ff            (ram_base_offset_ff            ),
    .actived_chnl_ff               (actived_chnl_ff               ),
    .actived_chnl_bits_ff          (actived_chnl_bits_ff          ),
    .inactived_chnl_bits_ff        (inactived_chnl_bits_ff        ),
    .ro_test_ff                    (ro_test_ff                    )
);

line_buffer_addr_dec U_LINE_BUFFER_ADDR_DEC (
    .apbif_addr                    (apbif_addr                    ),
    .apbif_rdata                   (apbif_rdata                   ),
    .ctrl_ff_sel                   (ctrl_ff_sel                   ),
    .real_depth_ff_sel             (real_depth_ff_sel             ),
    .line_wr_ff_sel                (line_wr_ff_sel                ),
    .ram_base_ff_sel               (ram_base_ff_sel               ),
    .ram_base_offset_ff_sel        (ram_base_offset_ff_sel        ),
    .actived_chnl_ff_sel           (actived_chnl_ff_sel           ),
    .actived_chnl_bits_ff_sel      (actived_chnl_bits_ff_sel      ),
    .inactived_chnl_bits_ff_sel    (inactived_chnl_bits_ff_sel    ),
    .ro_test_ff_sel                (ro_test_ff_sel                ),
    .ctrl_ff                       (ctrl_ff                       ),
    .real_depth_ff                 (real_depth_ff                 ),
    .line_wr_ff                    (line_wr_ff                    ),
    .ram_base_ff                   (ram_base_ff                   ),
    .ram_base_offset_ff            (ram_base_offset_ff            ),
    .actived_chnl_ff               (actived_chnl_ff               ),
    .actived_chnl_bits_ff          (actived_chnl_bits_ff          ),
    .inactived_chnl_bits_ff        (inactived_chnl_bits_ff        ),
    .ro_test_ff                    (ro_test_ff                    )
);

endmodule

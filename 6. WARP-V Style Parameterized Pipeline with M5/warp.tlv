\m4_TLV_version 1d: tl-x.org
\SV
   m4_makerchip_module
\TLV
   m4_define(['M4_PIPE_DEPTH'], 4)
   m4_define(['M4_WIDTH'], 16)
   
   |pipe
      @1
         $reset = *reset;
         $in[M4_WIDTH-1:0] = *cyc_cnt[M4_WIDTH-1:0];
         $val[M4_WIDTH-1:0] = $reset ? {M4_WIDTH{1'b0}} : $in;
      @2
         $stage2[M4_WIDTH-1:0] = $val + 16'd2;
      @3
         $stage3[M4_WIDTH-1:0] = $stage2 + 16'd3;
      @M4_PIPE_DEPTH
         $out[M4_WIDTH-1:0] = $stage3 + 16'd1;
   
   *passed = *cyc_cnt > 60;
   *failed = 1'b0;
\SV
   endmodule

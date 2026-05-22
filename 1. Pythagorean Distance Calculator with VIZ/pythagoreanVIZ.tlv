\m4_TLV_version 1d: tl-x.org
\SV
   m4_makerchip_module
\TLV
   |calc
      @1
         $reset = *reset;
         $x[7:0] = *cyc_cnt[7:0];
         $y[7:0] = *cyc_cnt[7:0] + 8'd30;
      @2
         $x_sq[15:0] = $x * $x;
         $y_sq[15:0] = $y * $y;
      @3
         $sum_sq[16:0] = {1'b0, $x_sq} + {1'b0, $y_sq};
      @4
         $dist[8:0] = $sum_sq[16:8];
   
   *passed = *cyc_cnt > 60;
   *failed = 1'b0;
\SV
   endmodule

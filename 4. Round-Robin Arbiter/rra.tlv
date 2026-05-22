\m4_TLV_version 1d: tl-x.org
\SV
   m4_makerchip_module
\TLV
   |arb
      @1
         $reset = *reset;
         
         $req[3:0] = $reset   ? 4'b0 :
                     (*cyc_cnt[1:0] == 2'b00) ? 4'b0001 :
                     (*cyc_cnt[1:0] == 2'b01) ? 4'b0110 :
                     (*cyc_cnt[1:0] == 2'b10) ? 4'b1111 :
                                                 4'b1010 ;
         
         $priority[1:0] = $reset    ? 2'b0 :
                          $granted  ? >>1$priority + 1 :
                                      >>1$priority;
         
         $p0[1:0] = $priority;
         $p1[1:0] = $priority + 2'b01;
         $p2[1:0] = $priority + 2'b10;
         $p3[1:0] = $priority + 2'b11;
         
         $grant[3:0] =
            $req[$p0] ? (4'b0001 << $p0) :
            $req[$p1] ? (4'b0001 << $p1) :
            $req[$p2] ? (4'b0001 << $p2) :
            $req[$p3] ? (4'b0001 << $p3) :
                         4'b0000;
         
         $granted = |{$grant};
   
   *passed = *cyc_cnt > 60;
   *failed = 1'b0;
\SV
   endmodule

\m4_TLV_version 1d: tl-x.org
\SV
   m4_makerchip_module
\TLV
   |lfsr
      @1
         $reset = *reset;
         
         $feedback = >>1$lfsr[7] ^ >>1$lfsr[5] ^
                     >>1$lfsr[4] ^ >>1$lfsr[3];
         
         // Use cyc_cnt > 2 to ensure reset has cleared before seeding
         $lfsr[7:0] = ($reset || *cyc_cnt < 3) ? 8'hAC :
                      {>>1$lfsr[6:0], $feedback};
         
         $out = $lfsr[0];
   
   *passed = *cyc_cnt > 100;
   *failed = ($lfsr == 8'b0) && (*cyc_cnt > 5);
\SV
   endmodule

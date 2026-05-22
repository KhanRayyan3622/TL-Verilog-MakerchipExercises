\m4_TLV_version 1d: tl-x.org
\SV
   m4_makerchip_module
\TLV
   
   |crc
      @1
         $reset    = *reset;
         $data_in  = $rand1[0];   // 1 bit input
         $valid    = !$reset && $rand2[0];
         
      ?$valid
         @1
            $xor_bit = $data_in ^ >>1$crc[7];
            
            $crc[7:0] = $reset ? 8'hFF :
               {>>1$crc[6:0], 1'b0}
               ^ ($xor_bit ? 8'h07 : 8'h00);
            
            $crc_valid = ($crc == 8'h00);
   
   *passed = *cyc_cnt > 120;
   *failed = 1'b0;
\SV
   endmodule

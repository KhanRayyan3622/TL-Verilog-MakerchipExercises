\m4_TLV_version 1d: tl-x.org
\SV
   m4_makerchip_module
\TLV
   // CRC-8 using polynomial x^8 + x^2 + x + 1
   // Processes one bit per cycle
   
   |crc
      @1
         $reset    = *reset;
         $data_in  = $rand1[0];   // 1 bit input
         $valid    = !$reset && $rand2[0];
         
      ?$valid
         @1
            // CRC shift register with polynomial feedback
            $xor_bit = $data_in ^ >>1$crc[7];
            
            $crc[7:0] = $reset ? 8'hFF :   // init to all ones
               {>>1$crc[6:0], 1'b0}        // shift left
               ^ ($xor_bit ? 8'h07 : 8'h00); // XOR polynomial if feedback=1
            
            $crc_valid = ($crc == 8'h00);  // zero remainder = no errors
   
   *passed = *cyc_cnt > 120;
   *failed = 1'b0;
\SV
   endmodule

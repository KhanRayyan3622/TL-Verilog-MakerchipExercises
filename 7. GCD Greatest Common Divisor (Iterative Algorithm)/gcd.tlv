\m4_TLV_version 1d: tl-x.org
\SV
   m4_makerchip_module
\TLV
   |gcd
      @1
         $reset = *reset;
         
         $done = (>>1$b == 32'b0) && !$reset && (*cyc_cnt > 2);
         $load = $reset || >>1$done;
         
         // Generate varied inputs using cycle counter
         $new_a[31:0] = {28'b0, *cyc_cnt[3:0] | 4'b0001};
         $new_b[31:0] = {28'b0, ~*cyc_cnt[3:0] | 4'b0001};
         
         $a[31:0] = $load              ? $new_a       :
                    (>>1$a > >>1$b)    ? >>1$a - >>1$b :
                                         >>1$a;
         
         $b[31:0] = $load              ? $new_b        :
                    (>>1$a > >>1$b)    ? >>1$b         :
                                         >>1$b - >>1$a;
         
         $gcd_out[31:0] = $done ? >>1$a : >>1$gcd_out;
   
   *passed = *cyc_cnt > 200;
   *failed = 1'b0;
\SV
   endmodule
